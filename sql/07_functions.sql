-- =============================================================
-- E-Commerce Sales & Inventory Management System
-- Script: 07_functions.sql
-- Purpose: Deterministic scalar functions for business logic
-- Run AFTER: 06_stored_procedures.sql
-- MySQL Version: 8.0+
-- =============================================================

USE ecommerce_analytics;

DELIMITER $$

-- =============================================================
-- FUNCTION 1: fn_line_total
-- Calculates the net line total for an order item.
-- Formula: quantity × unit_price × (1 - discount_pct / 100)
-- Pure calculation; no table access needed.
-- =============================================================
DROP FUNCTION IF EXISTS fn_line_total $$
CREATE FUNCTION fn_line_total(
    p_quantity    INT,
    p_unit_price  DECIMAL(12,2),
    p_discount_pct DECIMAL(5,2)
)
RETURNS DECIMAL(14,2)
DETERMINISTIC
NO SQL
BEGIN
    IF p_quantity <= 0 THEN
        RETURN 0.00;
    END IF;
    IF p_unit_price < 0 THEN
        RETURN 0.00;
    END IF;
    RETURN ROUND(
        p_quantity * p_unit_price * (1 - COALESCE(p_discount_pct, 0) / 100),
    2);
END $$

-- =============================================================
-- FUNCTION 2: fn_gross_margin_pct
-- Returns gross margin percentage for a product.
-- Formula: (sale_price - cost_price) / sale_price × 100
-- Returns NULL if sale_price is zero (avoids division by zero).
-- =============================================================
DROP FUNCTION IF EXISTS fn_gross_margin_pct $$
CREATE FUNCTION fn_gross_margin_pct(
    p_sale_price DECIMAL(12,2),
    p_cost_price DECIMAL(12,2)
)
RETURNS DECIMAL(6,2)
DETERMINISTIC
NO SQL
BEGIN
    IF p_sale_price IS NULL OR p_sale_price = 0 THEN
        RETURN NULL;
    END IF;
    RETURN ROUND((p_sale_price - p_cost_price) / p_sale_price * 100, 2);
END $$

-- =============================================================
-- FUNCTION 3: fn_order_total_with_tax
-- Applies GST (18%) to a subtotal.
-- Useful for quick tax-inclusive price calculation.
-- =============================================================
DROP FUNCTION IF EXISTS fn_order_total_with_tax $$
CREATE FUNCTION fn_order_total_with_tax(
    p_subtotal   DECIMAL(14,2),
    p_tax_rate   DECIMAL(5,2)     -- e.g. 18.00 for 18%
)
RETURNS DECIMAL(14,2)
DETERMINISTIC
NO SQL
BEGIN
    IF p_subtotal IS NULL OR p_subtotal < 0 THEN
        RETURN 0.00;
    END IF;
    RETURN ROUND(p_subtotal * (1 + COALESCE(p_tax_rate, 0) / 100), 2);
END $$

-- =============================================================
-- FUNCTION 4: fn_days_to_delivery
-- Calculates the number of calendar days between order date
-- and shipment delivered_date. Returns NULL if not delivered.
-- =============================================================
DROP FUNCTION IF EXISTS fn_days_to_delivery $$
CREATE FUNCTION fn_days_to_delivery(
    p_order_date    DATETIME,
    p_delivered_date DATE
)
RETURNS SMALLINT
DETERMINISTIC
NO SQL
BEGIN
    IF p_delivered_date IS NULL THEN
        RETURN NULL;
    END IF;
    RETURN DATEDIFF(p_delivered_date, DATE(p_order_date));
END $$

-- =============================================================
-- FUNCTION 5: fn_customer_segment
-- Classifies a customer by lifetime spending into segments.
-- Segments: VIP (>50000), LOYAL (>20000), REGULAR (>5000), NEW
-- =============================================================
DROP FUNCTION IF EXISTS fn_customer_segment $$
CREATE FUNCTION fn_customer_segment(
    p_lifetime_spending DECIMAL(14,2)
)
RETURNS VARCHAR(10)
DETERMINISTIC
NO SQL
BEGIN
    RETURN CASE
        WHEN p_lifetime_spending IS NULL THEN 'NEW'
        WHEN p_lifetime_spending >= 50000 THEN 'VIP'
        WHEN p_lifetime_spending >= 20000 THEN 'LOYAL'
        WHEN p_lifetime_spending >=  5000 THEN 'REGULAR'
        ELSE 'NEW'
    END;
END $$

DELIMITER ;

-- =============================================================
-- Quick smoke test for all functions
-- =============================================================
SELECT
    fn_line_total(2, 2499.00, 10.00)                AS line_total_test,      -- 4498.20
    fn_gross_margin_pct(2499.00, 1200.00)            AS margin_pct_test,      -- 52.02
    fn_order_total_with_tax(5000.00, 18.00)          AS total_with_tax_test,  -- 5900.00
    fn_days_to_delivery('2024-01-05', '2024-01-10')  AS delivery_days_test,   -- 5
    fn_customer_segment(75000.00)                    AS segment_vip,          -- VIP
    fn_customer_segment(25000.00)                    AS segment_loyal,        -- LOYAL
    fn_customer_segment(1000.00)                     AS segment_new;          -- NEW

-- Verify functions in schema
SELECT routine_name, routine_type, data_type AS return_type
FROM information_schema.routines
WHERE routine_schema = 'ecommerce_analytics'
  AND routine_type   = 'FUNCTION'
ORDER BY routine_name;
