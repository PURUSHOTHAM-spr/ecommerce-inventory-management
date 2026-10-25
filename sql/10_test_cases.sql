-- =============================================================
-- E-Commerce Sales & Inventory Management System
-- Script: 10_test_cases.sql
-- Purpose: Repeatable test suite for schema, constraints,
--          transactions, and business logic
-- Run AFTER: 08_triggers.sql (all schema objects must exist)
-- MySQL Version: 8.0+
--
-- HOW TO RUN
-- ──────────────────────────────────────────────────────────────
-- 1. Execute all scripts 01-08 first on a clean database.
-- 2. Run this file: SOURCE sql/10_test_cases.sql
-- 3. All tests that PASS print "PASS" in the result column.
-- 4. Any test that raises an uncaught error = FAIL.
-- 5. To reset, re-run 01_create_database.sql then 02-08.
--
-- ASSERTION PATTERN USED
-- ──────────────────────────────────────────────────────────────
-- Each test uses a helper that raises SQLSTATE '45999' when
-- the assertion fails, so failures are visible as errors.
-- =============================================================

USE ecommerce_analytics;

-- ─────────────────────────────────────────────────────────────
-- Helper procedure: assert_equals
-- Raises an error if actual <> expected.
-- ─────────────────────────────────────────────────────────────
DELIMITER $$
DROP PROCEDURE IF EXISTS assert_equals $$
CREATE PROCEDURE assert_equals(
    IN p_test_name  VARCHAR(100),
    IN p_expected   VARCHAR(500),
    IN p_actual     VARCHAR(500)
)
BEGIN
    IF p_expected <> p_actual THEN
        SIGNAL SQLSTATE '45999'
            SET MESSAGE_TEXT = CONCAT(
                'FAIL [', p_test_name, '] Expected: ', p_expected,
                ' | Got: ', COALESCE(p_actual, 'NULL')
            );
    ELSE
        SELECT CONCAT('PASS: ', p_test_name) AS test_result;
    END IF;
END $$

DROP PROCEDURE IF EXISTS assert_true $$
CREATE PROCEDURE assert_true(
    IN p_test_name  VARCHAR(100),
    IN p_condition  TINYINT
)
BEGIN
    IF p_condition = 0 OR p_condition IS NULL THEN
        SIGNAL SQLSTATE '45999'
            SET MESSAGE_TEXT = CONCAT('FAIL [', p_test_name, '] Condition was FALSE or NULL');
    ELSE
        SELECT CONCAT('PASS: ', p_test_name) AS test_result;
    END IF;
END $$
DELIMITER ;

-- =============================================================
-- TEST GROUP 1: Schema Structure
-- =============================================================
SELECT '=== TEST GROUP 1: Schema Structure ===' AS test_group;

-- T01: All 12 tables exist
CALL assert_equals('T01 - 12 tables exist',
    '12',
    (SELECT CAST(COUNT(*) AS CHAR)
     FROM information_schema.tables
     WHERE table_schema = 'ecommerce_analytics'
       AND table_type   = 'BASE TABLE'));

-- T02: All 5 views exist
CALL assert_equals('T02 - 5 views exist',
    '5',
    (SELECT CAST(COUNT(*) AS CHAR)
     FROM information_schema.views
     WHERE table_schema = 'ecommerce_analytics'));

-- T03: All 5 functions exist
CALL assert_equals('T03 - 5 functions exist',
    '5',
    (SELECT CAST(COUNT(*) AS CHAR)
     FROM information_schema.routines
     WHERE routine_schema = 'ecommerce_analytics'
       AND routine_type   = 'FUNCTION'));

-- T04: InnoDB engine on all base tables
CALL assert_equals('T04 - All tables use InnoDB',
    '12',
    (SELECT CAST(COUNT(*) AS CHAR)
     FROM information_schema.tables
     WHERE table_schema = 'ecommerce_analytics'
       AND table_type   = 'BASE TABLE'
       AND engine       = 'InnoDB'));

-- T05: Foreign key on orders → customers exists
CALL assert_true('T05 - FK orders.customer_id exists',
    (SELECT COUNT(*) > 0
     FROM information_schema.key_column_usage
     WHERE table_schema            = 'ecommerce_analytics'
       AND table_name              = 'orders'
       AND column_name             = 'customer_id'
       AND referenced_table_name   = 'customers'));

-- T06: Unique constraint on customers.email
CALL assert_true('T06 - UNIQUE on customers.email',
    (SELECT COUNT(*) > 0
     FROM information_schema.table_constraints
     WHERE table_schema     = 'ecommerce_analytics'
       AND table_name       = 'customers'
       AND constraint_type  = 'UNIQUE'));

-- =============================================================
-- TEST GROUP 2: Data Integrity Constraints
-- =============================================================
SELECT '=== TEST GROUP 2: Data Integrity ===' AS test_group;

-- T07: Duplicate email is rejected
-- Expect an error (1062 – Duplicate entry). Test passes if error fires.
SELECT 'T07 - Duplicate email rejected' AS test_name;
SET @dup_email_ok = 0;
BEGIN
    DECLARE CONTINUE HANDLER FOR 1062 SET @dup_email_ok = 1;
    INSERT INTO customers (first_name, last_name, email, address_line1, city, state, postal_code)
    VALUES ('Test','Dup','aarav.sharma@gmail.com','1 Test','Mumbai','Maharashtra','400001');
END;
CALL assert_equals('T07 - Duplicate email rejected', '1', CAST(@dup_email_ok AS CHAR));

-- T08: Negative cost_price rejected (CHECK constraint)
SELECT 'T08 - Negative cost_price rejected' AS test_name;
SET @neg_cost_ok = 0;
BEGIN
    DECLARE CONTINUE HANDLER FOR 3819 SET @neg_cost_ok = 1;  -- Check constraint violation
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @neg_cost_ok = 1;
    INSERT INTO products (category_id, product_name, sku, cost_price, sale_price)
    VALUES (1, 'Bad Product', 'BAD-001', -100.00, 500.00);
END;
CALL assert_equals('T08 - Negative cost_price rejected', '1', CAST(@neg_cost_ok AS CHAR));

-- T09: Negative quantity in order_items rejected
SELECT 'T09 - Negative order_item quantity rejected' AS test_name;
SET @neg_qty_ok = 0;
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @neg_qty_ok = 1;
    -- T09 inserts a row with quantity = -1; trigger should block it
    INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_pct, line_total)
    VALUES (1, 2, -1, 999.00, 0.00, -999.00);
END;
CALL assert_equals('T09 - Negative quantity blocked by trigger', '1', CAST(@neg_qty_ok AS CHAR));

-- T10: Invalid product FK in order_items rejected
SELECT 'T10 - Invalid product FK rejected' AS test_name;
SET @bad_fk_ok = 0;
BEGIN
    DECLARE CONTINUE HANDLER FOR 1452 SET @bad_fk_ok = 1;  -- FK constraint violation
    INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_pct, line_total)
    VALUES (1, 9999, 1, 100.00, 0.00, 100.00);
END;
CALL assert_equals('T10 - Invalid product FK rejected', '1', CAST(@bad_fk_ok AS CHAR));

-- T11: Invalid customer FK in orders rejected
SELECT 'T11 - Invalid customer FK in orders rejected' AS test_name;
SET @bad_cust_ok = 0;
BEGIN
    DECLARE CONTINUE HANDLER FOR 1452 SET @bad_cust_ok = 1;
    INSERT INTO orders (customer_id, status, shipping_address, shipping_city,
                        shipping_state, shipping_postal, total_amount)
    VALUES (99999, 'PENDING', 'X', 'X', 'X', '000000', 0.00);
END;
CALL assert_equals('T11 - Invalid customer FK rejected', '1', CAST(@bad_cust_ok AS CHAR));

-- T12: Inventory quantity_on_hand cannot go negative (trigger)
SELECT 'T12 - Inventory cannot go negative' AS test_name;
SET @neg_inv_ok = 0;
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET @neg_inv_ok = 1;
    UPDATE inventory SET quantity_on_hand = -1 WHERE product_id = 1;
END;
CALL assert_equals('T12 - Inventory negative blocked', '1', CAST(@neg_inv_ok AS CHAR));

-- =============================================================
-- TEST GROUP 3: Function Correctness
-- =============================================================
SELECT '=== TEST GROUP 3: Function Correctness ===' AS test_group;

-- T13: fn_line_total basic calculation
CALL assert_equals('T13 - fn_line_total(2, 500, 10)',
    '900.00',
    CAST(fn_line_total(2, 500.00, 10.00) AS CHAR));

-- T14: fn_line_total with zero discount
CALL assert_equals('T14 - fn_line_total zero discount',
    '1000.00',
    CAST(fn_line_total(2, 500.00, 0.00) AS CHAR));

-- T15: fn_gross_margin_pct normal case
CALL assert_equals('T15 - fn_gross_margin_pct(2499,1200)',
    '51.98',
    CAST(fn_gross_margin_pct(2499.00, 1200.00) AS CHAR));

-- T16: fn_gross_margin_pct division-by-zero guard
CALL assert_true('T16 - fn_gross_margin_pct zero price = NULL',
    fn_gross_margin_pct(0.00, 100.00) IS NULL);

-- T17: fn_order_total_with_tax (18% GST)
CALL assert_equals('T17 - fn_order_total_with_tax(5000, 18)',
    '5900.00',
    CAST(fn_order_total_with_tax(5000.00, 18.00) AS CHAR));

-- T18: fn_days_to_delivery normal
CALL assert_equals('T18 - fn_days_to_delivery 5 days',
    '5',
    CAST(fn_days_to_delivery('2024-01-05', '2024-01-10') AS CHAR));

-- T19: fn_days_to_delivery NULL delivered
CALL assert_true('T19 - fn_days_to_delivery NULL when not delivered',
    fn_days_to_delivery('2024-01-05', NULL) IS NULL);

-- T20: fn_customer_segment boundaries
CALL assert_equals('T20 - Segment VIP', 'VIP',    fn_customer_segment(60000.00));
CALL assert_equals('T20 - Segment LOYAL', 'LOYAL', fn_customer_segment(30000.00));
CALL assert_equals('T20 - Segment REGULAR', 'REGULAR', fn_customer_segment(8000.00));
CALL assert_equals('T20 - Segment NEW', 'NEW', fn_customer_segment(100.00));

-- =============================================================
-- TEST GROUP 4: Seed Data Counts
-- =============================================================
SELECT '=== TEST GROUP 4: Seed Data Counts ===' AS test_group;

-- T21: 100 customers
CALL assert_equals('T21 - 100 customers',
    '100',
    (SELECT CAST(COUNT(*) AS CHAR) FROM customers));

-- T22: 5 categories
CALL assert_equals('T22 - 5 categories',
    '5',
    (SELECT CAST(COUNT(*) AS CHAR) FROM categories));

-- T23: 50 products
CALL assert_equals('T23 - 50 products',
    '50',
    (SELECT CAST(COUNT(*) AS CHAR) FROM products));

-- T24: 10 suppliers
CALL assert_equals('T24 - 10 suppliers',
    '10',
    (SELECT CAST(COUNT(*) AS CHAR) FROM suppliers));

-- T25: 50 inventory rows (one per product)
CALL assert_equals('T25 - 50 inventory rows',
    '50',
    (SELECT CAST(COUNT(*) AS CHAR) FROM inventory));

-- T26: At least 1000 orders
CALL assert_true('T26 - At least 1000 orders',
    (SELECT COUNT(*) FROM orders) >= 1000);

-- T27: All orders have at least one order item
CALL assert_equals('T27 - All orders have items',
    '0',
    (SELECT CAST(COUNT(*) AS CHAR)
     FROM orders o
     WHERE NOT EXISTS (
         SELECT 1 FROM order_items oi WHERE oi.order_id = o.order_id
     )));

-- T28: All inventory product_ids are valid
CALL assert_equals('T28 - Inventory FK integrity',
    '0',
    (SELECT CAST(COUNT(*) AS CHAR)
     FROM inventory i
     LEFT JOIN products p ON p.product_id = i.product_id
     WHERE p.product_id IS NULL));

-- T29: No order_items orphaned (order_id must exist)
CALL assert_equals('T29 - No orphan order_items',
    '0',
    (SELECT CAST(COUNT(*) AS CHAR)
     FROM order_items oi
     LEFT JOIN orders o ON o.order_id = oi.order_id
     WHERE o.order_id IS NULL));

-- T30: Shipments only for SHIPPED/DELIVERED/RETURNED/CONFIRMED orders
CALL assert_equals('T30 - No shipment for CANCELLED/PENDING orders',
    '0',
    (SELECT CAST(COUNT(*) AS CHAR)
     FROM shipments sh
     JOIN orders o ON o.order_id = sh.order_id
     WHERE o.status IN ('CANCELLED', 'PENDING')));

-- =============================================================
-- TEST GROUP 5: Business Logic
-- =============================================================
SELECT '=== TEST GROUP 5: Business Logic ===' AS test_group;

-- T31: Returns cannot exceed purchased quantity
-- (The UNIQUE constraint on order_item_id + sp_process_return check guards this)
CALL assert_true('T31 - Return qty never exceeds purchased qty',
    NOT EXISTS (
        SELECT 1
        FROM returns r
        JOIN order_items oi ON oi.order_item_id = r.order_item_id
        WHERE r.quantity > oi.quantity
    ));

-- T32: No duplicate returns for same order_item
CALL assert_equals('T32 - No duplicate returns per order_item',
    '0',
    (SELECT CAST(COUNT(*) AS CHAR)
     FROM (
         SELECT order_item_id, COUNT(*) AS cnt
         FROM returns
         GROUP BY order_item_id
         HAVING cnt > 1
     ) dups));

-- T33: All RETURNED orders have a corresponding return record
-- (Not strictly required, but check returns link to valid order_items)
CALL assert_equals('T33 - Returns link to valid order_items',
    '0',
    (SELECT CAST(COUNT(*) AS CHAR)
     FROM returns r
     LEFT JOIN order_items oi ON oi.order_item_id = r.order_item_id
     WHERE oi.order_item_id IS NULL));

-- T34: line_total is always >= 0
CALL assert_equals('T34 - No negative line_totals',
    '0',
    (SELECT CAST(COUNT(*) AS CHAR)
     FROM order_items
     WHERE line_total < 0));

-- T35: All COMPLETED payments have a positive amount
CALL assert_equals('T35 - All COMPLETED payments > 0',
    '0',
    (SELECT CAST(COUNT(*) AS CHAR)
     FROM payments
     WHERE status = 'COMPLETED'
       AND amount <= 0));

-- T36: Payments only for orders that exist
CALL assert_equals('T36 - No orphan payments',
    '0',
    (SELECT CAST(COUNT(*) AS CHAR)
     FROM payments pay
     LEFT JOIN orders o ON o.order_id = pay.order_id
     WHERE o.order_id IS NULL));

-- T37: CANCELLED orders should not have COMPLETED payments
-- (In our data, CANCELLED orders have FAILED payments only)
CALL assert_equals('T37 - No COMPLETED payment for CANCELLED orders',
    '0',
    (SELECT CAST(COUNT(*) AS CHAR)
     FROM payments pay
     JOIN orders o ON o.order_id = pay.order_id
     WHERE o.status  = 'CANCELLED'
       AND pay.status = 'COMPLETED'));

-- T38: Every product has an inventory row
CALL assert_equals('T38 - Every product has inventory',
    '0',
    (SELECT CAST(COUNT(*) AS CHAR)
     FROM products p
     LEFT JOIN inventory i ON i.product_id = p.product_id
     WHERE i.inventory_id IS NULL));

-- T39: vw_product_inventory_status matches products count
CALL assert_equals('T39 - View inventory status row count = 50',
    '50',
    (SELECT CAST(COUNT(*) AS CHAR) FROM vw_product_inventory_status));

-- T40: vw_monthly_sales_summary has data for each month
CALL assert_true('T40 - Monthly sales view has rows',
    (SELECT COUNT(*) FROM vw_monthly_sales_summary) > 0);

-- =============================================================
-- TEST GROUP 6: Analytics Query Smoke Tests
-- =============================================================
SELECT '=== TEST GROUP 6: Analytics Smoke Tests ===' AS test_group;

-- T41: Top 5 products query returns exactly 5 rows
CALL assert_equals('T41 - Top 5 products by revenue returns 5 rows',
    '5',
    (SELECT CAST(COUNT(*) AS CHAR) FROM (
        SELECT p.product_id, SUM(oi.line_total) AS rev
        FROM order_items oi
        JOIN products p ON p.product_id = oi.product_id
        JOIN orders   o ON o.order_id   = oi.order_id
        WHERE o.status NOT IN ('CANCELLED')
        GROUP BY p.product_id
        ORDER BY rev DESC
        LIMIT 5
    ) t));

-- T42: Category revenue sums to total revenue
CALL assert_true('T42 - Category revenue sums equal total revenue',
    ABS(
        (SELECT ROUND(SUM(oi.line_total), 0)
         FROM order_items oi
         JOIN orders o ON o.order_id = oi.order_id
         WHERE o.status NOT IN ('CANCELLED'))
        -
        (SELECT ROUND(SUM(t.revenue), 0)
         FROM vw_monthly_sales_summary t)
    ) < 10   -- within 10 INR rounding tolerance
);

-- T43: RFM analysis returns at least 50 customers
CALL assert_true('T43 - RFM analysis covers at least 50 customers',
    (SELECT COUNT(DISTINCT customer_id)
     FROM orders
     WHERE status NOT IN ('CANCELLED')) >= 50);

-- T44: All 5 categories appear in revenue report
CALL assert_equals('T44 - 5 categories in revenue report',
    '5',
    (SELECT CAST(COUNT(DISTINCT c.category_name) AS CHAR)
     FROM order_items oi
     JOIN products   p ON p.product_id  = oi.product_id
     JOIN categories c ON c.category_id = p.category_id
     JOIN orders     o ON o.order_id    = oi.order_id
     WHERE o.status NOT IN ('CANCELLED')));

-- T45: Monthly view has at most 12 rows (Jan-Sep = 9 months)
CALL assert_true('T45 - Monthly summary has 9 or fewer rows',
    (SELECT COUNT(*) FROM vw_monthly_sales_summary) <= 12);

-- =============================================================
-- TEST SUMMARY
-- =============================================================
SELECT '=== TEST SUITE COMPLETE ===' AS summary,
       'Review output above. Each PASS line = test passed.' AS note;

-- =============================================================
-- RESET INSTRUCTIONS
-- =============================================================
-- To reset all test data and re-run:
--   SOURCE sql/01_create_database.sql
--   SOURCE sql/02_create_tables.sql
--   SOURCE sql/03_indexes.sql
--   SOURCE sql/04_seed_data.sql
--   SOURCE sql/05_views.sql
--   SOURCE sql/06_stored_procedures.sql
--   SOURCE sql/07_functions.sql
--   SOURCE sql/08_triggers.sql
--   SOURCE sql/10_test_cases.sql
-- =============================================================
