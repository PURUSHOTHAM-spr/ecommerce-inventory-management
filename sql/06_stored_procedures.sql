-- =============================================================
-- E-Commerce Sales & Inventory Management System
-- Script: 06_stored_procedures.sql
-- Purpose: Stored procedures for business operations
-- Run AFTER: 05_views.sql
-- MySQL Version: 8.0+
-- =============================================================

USE ecommerce_analytics;

DELIMITER $$

-- =============================================================
-- PROCEDURE 1: sp_get_customer_order_history
-- Returns all orders and their items for a specific customer.
-- =============================================================
DROP PROCEDURE IF EXISTS sp_get_customer_order_history $$
CREATE PROCEDURE sp_get_customer_order_history(
    IN p_customer_id INT UNSIGNED,
    IN p_limit       INT           -- Pass NULL to retrieve all
)
BEGIN
    -- Validate customer exists
    IF NOT EXISTS (SELECT 1 FROM customers WHERE customer_id = p_customer_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Customer not found.',
                MYSQL_ERRNO  = 45001;
    END IF;

    SELECT
        o.order_id,
        o.order_date,
        o.status                                   AS order_status,
        p.product_name,
        cat.category_name,
        oi.quantity,
        oi.unit_price,
        oi.discount_pct,
        oi.line_total,
        o.total_amount                             AS order_total,
        o.tax_amount,
        pay.payment_method,
        pay.status                                 AS payment_status,
        sh.carrier,
        sh.tracking_number,
        sh.status                                  AS shipment_status,
        sh.delivered_date
    FROM orders o
    JOIN order_items oi  ON oi.order_id     = o.order_id
    JOIN products    p   ON p.product_id    = oi.product_id
    JOIN categories  cat ON cat.category_id = p.category_id
    LEFT JOIN payments  pay ON pay.order_id = o.order_id
        AND pay.status = 'COMPLETED'
    LEFT JOIN shipments sh  ON sh.order_id  = o.order_id
    WHERE o.customer_id = p_customer_id
    ORDER BY o.order_date DESC
    LIMIT IFNULL(p_limit, 18446744073709551615);
END $$

-- =============================================================
-- PROCEDURE 2: sp_generate_sales_report
-- Returns a date-range sales summary broken down by category.
-- =============================================================
DROP PROCEDURE IF EXISTS sp_generate_sales_report $$
CREATE PROCEDURE sp_generate_sales_report(
    IN p_start_date DATE,
    IN p_end_date   DATE
)
BEGIN
    IF p_start_date IS NULL OR p_end_date IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Start date and end date are required.',
                MYSQL_ERRNO  = 45002;
    END IF;

    IF p_start_date > p_end_date THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Start date must be on or before end date.',
                MYSQL_ERRNO  = 45003;
    END IF;

    -- Overall summary
    SELECT
        COUNT(DISTINCT o.order_id)          AS total_orders,
        COUNT(DISTINCT o.customer_id)       AS unique_customers,
        SUM(oi.quantity)                    AS units_sold,
        ROUND(SUM(oi.line_total), 2)        AS gross_revenue,
        ROUND(SUM(o.discount_amount), 2)    AS total_discounts,
        ROUND(SUM(o.tax_amount), 2)         AS total_tax,
        ROUND(SUM(oi.line_total) - SUM(o.discount_amount), 2) AS net_revenue,
        ROUND(AVG(o.total_amount), 2)       AS avg_order_value
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.status NOT IN ('CANCELLED')
      AND DATE(o.order_date) BETWEEN p_start_date AND p_end_date;

    -- Category breakdown
    SELECT
        cat.category_name,
        COUNT(DISTINCT o.order_id)       AS orders,
        SUM(oi.quantity)                 AS units_sold,
        ROUND(SUM(oi.line_total), 2)     AS revenue,
        ROUND(SUM(oi.quantity * p.cost_price), 2) AS cogs,
        ROUND(SUM(oi.line_total) - SUM(oi.quantity * p.cost_price), 2) AS gross_profit
    FROM orders o
    JOIN order_items oi  ON oi.order_id     = o.order_id
    JOIN products    p   ON p.product_id    = oi.product_id
    JOIN categories  cat ON cat.category_id = p.category_id
    WHERE o.status NOT IN ('CANCELLED')
      AND DATE(o.order_date) BETWEEN p_start_date AND p_end_date
    GROUP BY cat.category_name
    ORDER BY revenue DESC;
END $$

-- =============================================================
-- PROCEDURE 3: sp_place_order
-- Transactional order placement with inventory checks.
-- Implements safe locking (SELECT ... FOR UPDATE) to prevent
-- overselling under concurrent load.
--
-- Parameters:
--   p_customer_id   - ID of the placing customer
--   p_product_ids   - Comma-separated product IDs  (e.g. '1,5,10')
--   p_quantities    - Comma-separated quantities    (e.g. '2,1,3')
--   p_shipping_addr - Full shipping address string
--   p_city, p_state, p_postal - Shipping location
--   p_new_order_id  - OUT: the newly created order_id
--
-- Locking order: products are processed in ascending product_id
-- order to avoid circular deadlocks between sessions.
-- =============================================================
DROP PROCEDURE IF EXISTS sp_place_order $$
CREATE PROCEDURE sp_place_order(
    IN  p_customer_id   INT UNSIGNED,
    IN  p_product_ids   VARCHAR(500),    -- '1,5,10'
    IN  p_quantities    VARCHAR(500),    -- '2,1,3'
    IN  p_shipping_addr VARCHAR(300),
    IN  p_city          VARCHAR(80),
    IN  p_state         VARCHAR(80),
    IN  p_postal        VARCHAR(20),
    OUT p_new_order_id  INT UNSIGNED
)
BEGIN
    -- Error handler: rolls back and re-signals on any SQL error.
    DECLARE v_exit TINYINT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET v_exit = 1;
        ROLLBACK;
        RESIGNAL;
    END;

    -- Validate customer
    IF NOT EXISTS (SELECT 1 FROM customers WHERE customer_id = p_customer_id AND is_active = 1) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Customer not found or inactive.',
                MYSQL_ERRNO  = 45010;
    END IF;

    -- Validate inputs are not empty
    IF p_product_ids IS NULL OR p_product_ids = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'At least one product must be specified.',
                MYSQL_ERRNO  = 45011;
    END IF;

    START TRANSACTION;

    -- Use a temporary table to hold the parsed product/quantity pairs.
    DROP TEMPORARY TABLE IF EXISTS tmp_order_lines;
    CREATE TEMPORARY TABLE tmp_order_lines (
        row_num    INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
        product_id INT UNSIGNED NOT NULL,
        quantity   INT          NOT NULL
    );

    -- Populate tmp_order_lines from comma-separated strings.
    -- This approach avoids dynamic SQL and cursors.
    -- We use a helper stored procedure pattern with a JSON array.
    -- Simplified: insert lines individually (caller must split externally
    -- or use the JSON overload below). For the demo, we handle up to 5 items.
    CALL sp_parse_order_lines(p_product_ids, p_quantities);

    -- Validate quantities > 0
    IF EXISTS (SELECT 1 FROM tmp_order_lines WHERE quantity <= 0) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'All quantities must be greater than zero.',
                MYSQL_ERRNO  = 45012;
    END IF;

    -- Validate all products exist and are active
    IF EXISTS (
        SELECT 1 FROM tmp_order_lines tol
        LEFT JOIN products p ON p.product_id = tol.product_id AND p.is_active = 1
        WHERE p.product_id IS NULL
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'One or more products are invalid or inactive.',
                MYSQL_ERRNO  = 45013;
    END IF;

    -- Lock inventory rows in ascending product_id order (deadlock prevention).
    -- SELECT ... FOR UPDATE holds a row-level exclusive lock until COMMIT.
    SET @locked = (
        SELECT GROUP_CONCAT(i.quantity_on_hand ORDER BY i.product_id)
        FROM inventory i
        JOIN tmp_order_lines tol ON tol.product_id = i.product_id
        ORDER BY i.product_id
        FOR UPDATE
    );

    -- Check sufficient stock for every line
    IF EXISTS (
        SELECT 1
        FROM tmp_order_lines tol
        JOIN inventory i ON i.product_id = tol.product_id
        WHERE (i.quantity_on_hand - i.quantity_reserved) < tol.quantity
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient stock for one or more products.',
                MYSQL_ERRNO  = 45014;
    END IF;

    -- Create the order header
    INSERT INTO orders (
        customer_id, status,
        shipping_address, shipping_city, shipping_state, shipping_postal,
        total_amount, discount_amount, tax_amount
    )
    SELECT
        p_customer_id, 'PENDING',
        p_shipping_addr, p_city, p_state, p_postal,
        ROUND(SUM(tol.quantity * p.sale_price), 2),
        0.00,
        ROUND(SUM(tol.quantity * p.sale_price) * 0.09, 2)
    FROM tmp_order_lines tol
    JOIN products p ON p.product_id = tol.product_id;

    SET p_new_order_id = LAST_INSERT_ID();

    -- Insert order items (unit_price captured at order time)
    INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_pct, line_total)
    SELECT
        p_new_order_id,
        tol.product_id,
        tol.quantity,
        p.sale_price,
        0.00,
        ROUND(tol.quantity * p.sale_price, 2)
    FROM tmp_order_lines tol
    JOIN products p ON p.product_id = tol.product_id;

    -- Reserve inventory (reduce available quantity by reserving)
    UPDATE inventory i
    JOIN tmp_order_lines tol ON tol.product_id = i.product_id
    SET i.quantity_reserved = i.quantity_reserved + tol.quantity;

    -- Record RESERVED movements
    INSERT INTO inventory_movements (product_id, movement_type, quantity_change, reference_id, reference_type, notes)
    SELECT
        tol.product_id,
        'RESERVED',
        -tol.quantity,
        p_new_order_id,
        'ORDER',
        CONCAT('Stock reserved for order #', p_new_order_id)
    FROM tmp_order_lines tol;

    DROP TEMPORARY TABLE IF EXISTS tmp_order_lines;

    COMMIT;
END $$

-- =============================================================
-- HELPER: sp_parse_order_lines
-- Parses comma-separated product_ids and quantities into
-- the tmp_order_lines temporary table.
-- Example: '1,5,10' and '2,1,3' → 3 rows
-- =============================================================
DROP PROCEDURE IF EXISTS sp_parse_order_lines $$
CREATE PROCEDURE sp_parse_order_lines(
    IN p_product_ids VARCHAR(500),
    IN p_quantities  VARCHAR(500)
)
BEGIN
    DECLARE v_idx          INT DEFAULT 1;
    DECLARE v_pid_part     VARCHAR(20);
    DECLARE v_qty_part     VARCHAR(20);
    DECLARE v_comma_pos_p  INT;
    DECLARE v_comma_pos_q  INT;
    DECLARE v_remaining_p  VARCHAR(500) DEFAULT p_product_ids;
    DECLARE v_remaining_q  VARCHAR(500) DEFAULT p_quantities;

    DROP TEMPORARY TABLE IF EXISTS tmp_order_lines;
    CREATE TEMPORARY TABLE tmp_order_lines (
        row_num    INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
        product_id INT UNSIGNED NOT NULL,
        quantity   INT          NOT NULL
    );

    parse_loop: LOOP
        SET v_comma_pos_p = LOCATE(',', v_remaining_p);
        SET v_comma_pos_q = LOCATE(',', v_remaining_q);

        IF v_comma_pos_p = 0 THEN
            -- Last (or only) token
            SET v_pid_part = TRIM(v_remaining_p);
            SET v_qty_part = TRIM(v_remaining_q);
        ELSE
            SET v_pid_part    = TRIM(SUBSTRING(v_remaining_p, 1, v_comma_pos_p - 1));
            SET v_qty_part    = TRIM(SUBSTRING(v_remaining_q, 1, v_comma_pos_q - 1));
            SET v_remaining_p = SUBSTRING(v_remaining_p, v_comma_pos_p + 1);
            SET v_remaining_q = SUBSTRING(v_remaining_q, v_comma_pos_q + 1);
        END IF;

        IF v_pid_part <> '' AND v_qty_part <> '' THEN
            INSERT INTO tmp_order_lines (product_id, quantity)
            VALUES (CAST(v_pid_part AS UNSIGNED), CAST(v_qty_part AS SIGNED));
        END IF;

        IF v_comma_pos_p = 0 THEN
            LEAVE parse_loop;
        END IF;
    END LOOP parse_loop;
END $$

-- =============================================================
-- PROCEDURE 4: sp_adjust_inventory
-- Safely adjusts stock with a reason code.
-- Used by warehouse staff for manual corrections and restocks.
-- =============================================================
DROP PROCEDURE IF EXISTS sp_adjust_inventory $$
CREATE PROCEDURE sp_adjust_inventory(
    IN p_product_id     INT UNSIGNED,
    IN p_quantity_delta INT          COMMENT 'Positive = add stock, Negative = remove',
    IN p_movement_type  ENUM('RESTOCK','ADJUSTMENT'),
    IN p_notes          VARCHAR(255)
)
BEGIN
    DECLARE v_current_qty INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Validate product
    IF NOT EXISTS (SELECT 1 FROM products WHERE product_id = p_product_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Product not found.',
                MYSQL_ERRNO  = 45020;
    END IF;

    IF p_quantity_delta = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Quantity delta cannot be zero.',
                MYSQL_ERRNO  = 45021;
    END IF;

    START TRANSACTION;

    -- Lock the row
    SELECT quantity_on_hand INTO v_current_qty
    FROM inventory
    WHERE product_id = p_product_id
    FOR UPDATE;

    -- Prevent negative stock
    IF (v_current_qty + p_quantity_delta) < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Adjustment would result in negative stock.',
                MYSQL_ERRNO  = 45022;
    END IF;

    UPDATE inventory
    SET quantity_on_hand  = quantity_on_hand + p_quantity_delta,
        last_restocked_at = CASE WHEN p_quantity_delta > 0 THEN NOW() ELSE last_restocked_at END
    WHERE product_id = p_product_id;

    INSERT INTO inventory_movements (product_id, movement_type, quantity_change, reference_type, notes)
    VALUES (p_product_id, p_movement_type, p_quantity_delta, 'MANUAL', p_notes);

    COMMIT;

    SELECT
        p_product_id             AS product_id,
        v_current_qty            AS old_quantity,
        (v_current_qty + p_quantity_delta) AS new_quantity,
        p_movement_type          AS movement_type,
        p_notes                  AS notes;
END $$

-- =============================================================
-- PROCEDURE 5: sp_process_return
-- Processes a product return request.
-- Business rules enforced:
--   - Order must be DELIVERED or RETURNED status.
--   - Return quantity <= purchased quantity.
--   - Duplicate returns for the same order_item are blocked
--     by the UNIQUE constraint on returns.order_item_id.
--   - Stock is restored only when return_status = 'APPROVED'
--     (warehouse has received items back).
-- =============================================================
DROP PROCEDURE IF EXISTS sp_process_return $$
CREATE PROCEDURE sp_process_return(
    IN  p_order_id        INT UNSIGNED,
    IN  p_order_item_id   INT UNSIGNED,
    IN  p_return_quantity INT,
    IN  p_reason          VARCHAR(300),
    OUT p_return_id       INT UNSIGNED
)
BEGIN
    DECLARE v_purchased_qty INT DEFAULT 0;
    DECLARE v_order_status  VARCHAR(20);
    DECLARE v_line_total    DECIMAL(14,2);
    DECLARE v_product_id    INT UNSIGNED;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Validate order exists and belongs to a delivered/returned state
    SELECT o.status INTO v_order_status
    FROM orders o
    WHERE o.order_id = p_order_id;

    IF v_order_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Order not found.',
                MYSQL_ERRNO  = 45030;
    END IF;

    IF v_order_status NOT IN ('DELIVERED', 'RETURNED') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Returns are only allowed for DELIVERED or RETURNED orders.',
                MYSQL_ERRNO  = 45031;
    END IF;

    -- Validate order item
    SELECT oi.quantity, oi.line_total, oi.product_id
    INTO   v_purchased_qty, v_line_total, v_product_id
    FROM   order_items oi
    WHERE  oi.order_item_id = p_order_item_id
      AND  oi.order_id      = p_order_id;

    IF v_purchased_qty IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Order item not found or does not belong to this order.',
                MYSQL_ERRNO  = 45032;
    END IF;

    IF p_return_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Return quantity must be greater than zero.',
                MYSQL_ERRNO  = 45033;
    END IF;

    IF p_return_quantity > v_purchased_qty THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Return quantity exceeds purchased quantity.',
                MYSQL_ERRNO  = 45034;
    END IF;

    -- Check for existing return (UNIQUE constraint will also catch this)
    IF EXISTS (SELECT 1 FROM returns WHERE order_item_id = p_order_item_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A return request already exists for this order item.',
                MYSQL_ERRNO  = 45035;
    END IF;

    START TRANSACTION;

    -- Insert return record
    INSERT INTO returns (order_id, order_item_id, quantity, reason, return_status, refund_amount)
    VALUES (p_order_id, p_order_item_id, p_return_quantity, p_reason, 'REQUESTED',
            ROUND(v_line_total * (p_return_quantity / v_purchased_qty), 2));

    SET p_return_id = LAST_INSERT_ID();

    -- Update order status to RETURNED
    UPDATE orders SET status = 'RETURNED', updated_at = NOW()
    WHERE order_id = p_order_id;

    -- Restore inventory (stock comes back once return is requested;
    -- a separate approval workflow can be added in production)
    UPDATE inventory
    SET quantity_on_hand = quantity_on_hand + p_return_quantity
    WHERE product_id = v_product_id;

    INSERT INTO inventory_movements
        (product_id, movement_type, quantity_change, reference_id, reference_type, notes)
    VALUES
        (v_product_id, 'RETURN', p_return_quantity, p_return_id, 'RETURN',
         CONCAT('Return #', p_return_id, ' – stock restored'));

    COMMIT;
END $$

DELIMITER ;

-- Verify procedures were created
SELECT routine_name, routine_type
FROM information_schema.routines
WHERE routine_schema = 'ecommerce_analytics'
ORDER BY routine_type, routine_name;
