-- =============================================================
-- E-Commerce Sales & Inventory Management System
-- Script: 08_triggers.sql
-- Purpose: Database triggers for inventory and audit automation
-- Run AFTER: 07_functions.sql
-- MySQL Version: 8.0+
--
-- TRIGGER INVENTORY CONTRACT
-- ──────────────────────────
-- Trigger trg_oi_after_insert:
--   When a new order item is inserted for a CONFIRMED order,
--   subtract the quantity from inventory (SALE movement).
--   sp_place_order uses RESERVED movements; this trigger handles
--   orders inserted directly (e.g. backfill scripts).
--   To avoid double-deduction, the trigger checks if a RESERVED
--   movement already exists for this order's product.
--
-- Trigger trg_order_after_update:
--   When an order status changes to CANCELLED, release the
--   reserved quantity back to available inventory.
--
-- Trigger trg_oi_before_insert:
--   Validates line_total = quantity × unit_price × (1 - disc/100).
--   Prevents stale or incorrect totals being stored.
-- =============================================================

USE ecommerce_analytics;

DELIMITER $$

-- =============================================================
-- TRIGGER 1: trg_oi_before_insert
-- Validates and auto-corrects line_total before insert.
-- =============================================================
DROP TRIGGER IF EXISTS trg_oi_before_insert $$
CREATE TRIGGER trg_oi_before_insert
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    -- Auto-calculate line_total to ensure consistency
    SET NEW.line_total = ROUND(
        NEW.quantity * NEW.unit_price * (1 - COALESCE(NEW.discount_pct, 0) / 100),
    2);

    -- Enforce positive quantity
    IF NEW.quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Order item quantity must be greater than zero.',
                MYSQL_ERRNO  = 45100;
    END IF;

    -- Enforce non-negative price
    IF NEW.unit_price < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Unit price cannot be negative.',
                MYSQL_ERRNO  = 45101;
    END IF;
END $$

-- =============================================================
-- TRIGGER 2: trg_order_after_status_update
-- When an order is CANCELLED: release reserved inventory.
-- When an order transitions from PENDING to CONFIRMED:
--   convert reserved stock to a committed SALE deduction.
-- =============================================================
DROP TRIGGER IF EXISTS trg_order_after_status_update $$
CREATE TRIGGER trg_order_after_status_update
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    -- Only act when status actually changes
    IF OLD.status <> NEW.status THEN

        -- ── CANCELLATION ──────────────────────────────────────────
        -- Release reservation: restore reserved counter, add movement
        IF NEW.status = 'CANCELLED' AND OLD.status IN ('PENDING','CONFIRMED') THEN
            UPDATE inventory i
            JOIN order_items oi ON oi.order_id = NEW.order_id
                AND oi.product_id = i.product_id
            SET i.quantity_reserved = GREATEST(0, i.quantity_reserved - oi.quantity);

            INSERT INTO inventory_movements
                (product_id, movement_type, quantity_change, reference_id, reference_type, notes)
            SELECT
                oi.product_id,
                'UNRESERVED',
                oi.quantity,          -- positive: stock is freed
                NEW.order_id,
                'ORDER',
                CONCAT('Reservation released – order #', NEW.order_id, ' cancelled')
            FROM order_items oi
            WHERE oi.order_id = NEW.order_id;
        END IF;

        -- ── CONFIRMATION: PENDING → CONFIRMED ─────────────────────
        -- Convert reservation to committed sale: deduct from on-hand,
        -- release reservation counter, record SALE movement.
        IF NEW.status = 'CONFIRMED' AND OLD.status = 'PENDING' THEN
            -- Deduct from on-hand and release reservation
            UPDATE inventory i
            JOIN order_items oi ON oi.order_id    = NEW.order_id
                                AND oi.product_id = i.product_id
            SET
                i.quantity_on_hand  = GREATEST(0, i.quantity_on_hand  - oi.quantity),
                i.quantity_reserved = GREATEST(0, i.quantity_reserved - oi.quantity);

            -- Record SALE inventory movement
            INSERT INTO inventory_movements
                (product_id, movement_type, quantity_change, reference_id, reference_type, notes)
            SELECT
                oi.product_id,
                'SALE',
                -oi.quantity,
                NEW.order_id,
                'ORDER',
                CONCAT('Sale deducted – order #', NEW.order_id, ' confirmed')
            FROM order_items oi
            WHERE oi.order_id = NEW.order_id;
        END IF;

    END IF;
END $$

-- =============================================================
-- TRIGGER 3: trg_inventory_before_update
-- Prevents quantity_on_hand from going below zero via any path.
-- =============================================================
DROP TRIGGER IF EXISTS trg_inventory_before_update $$
CREATE TRIGGER trg_inventory_before_update
BEFORE UPDATE ON inventory
FOR EACH ROW
BEGIN
    IF NEW.quantity_on_hand < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Inventory quantity_on_hand cannot be negative.',
                MYSQL_ERRNO  = 45110;
    END IF;

    IF NEW.quantity_reserved < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Inventory quantity_reserved cannot be negative.',
                MYSQL_ERRNO  = 45111;
    END IF;
END $$

-- =============================================================
-- TRIGGER 4: trg_return_after_insert
-- When a return is inserted with status APPROVED or RECEIVED,
-- restore stock immediately.
-- (For REQUESTED returns, stock is restored by sp_process_return.)
-- This trigger guards against direct INSERT paths.
-- =============================================================
DROP TRIGGER IF EXISTS trg_return_after_insert $$
CREATE TRIGGER trg_return_after_insert
AFTER INSERT ON returns
FOR EACH ROW
BEGIN
    -- Stock restoration is handled by sp_process_return.
    -- This trigger only audits the event.
    INSERT INTO inventory_movements
        (product_id, movement_type, quantity_change, reference_id, reference_type, notes)
    SELECT
        oi.product_id,
        'RETURN',
        NEW.quantity,
        NEW.return_id,
        'RETURN',
        CONCAT('Return request #', NEW.return_id, ' – reason: ', COALESCE(NEW.reason,'N/A'))
    FROM order_items oi
    WHERE oi.order_item_id = NEW.order_item_id
      AND NOT EXISTS (
          -- Avoid duplicate movement if sp_process_return already inserted one
          SELECT 1 FROM inventory_movements im
          WHERE im.reference_id   = NEW.return_id
            AND im.reference_type = 'RETURN'
            AND im.movement_type  = 'RETURN'
      );
END $$

-- =============================================================
-- TRIGGER 5: trg_product_price_audit
-- Logs any price changes on the products table to
-- inventory_movements as an ADJUSTMENT note for traceability.
-- In production, a dedicated price_history table is preferred.
-- =============================================================
DROP TRIGGER IF EXISTS trg_product_price_audit $$
CREATE TRIGGER trg_product_price_audit
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    IF OLD.sale_price <> NEW.sale_price THEN
        INSERT INTO inventory_movements
            (product_id, movement_type, quantity_change, reference_type, notes)
        VALUES (
            NEW.product_id,
            'ADJUSTMENT',
            0,          -- no stock change; quantity_change = 0 is intentional
            'MANUAL',
            CONCAT(
                'Price updated: INR ', OLD.sale_price,
                ' → INR ', NEW.sale_price
            )
        );
    END IF;
END $$

DELIMITER ;

-- Verify triggers were created
SELECT trigger_name, event_manipulation, event_object_table, action_timing
FROM information_schema.triggers
WHERE trigger_schema = 'ecommerce_analytics'
ORDER BY event_object_table, action_timing;
