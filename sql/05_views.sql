-- =============================================================
-- E-Commerce Sales & Inventory Management System
-- Script: 05_views.sql
-- Purpose: Create useful reporting views
-- Run AFTER: 04_seed_data.sql
-- MySQL Version: 8.0+
-- =============================================================

USE ecommerce_analytics;

-- =============================================================
-- VIEW 1: vw_product_inventory_status
-- Shows current stock levels, low-stock alerts, and
-- available quantity (on_hand minus reserved).
-- =============================================================
DROP VIEW IF EXISTS vw_product_inventory_status;
CREATE VIEW vw_product_inventory_status AS
SELECT
    p.product_id,
    p.sku,
    p.product_name,
    c.category_name,
    i.quantity_on_hand,
    i.quantity_reserved,
    (i.quantity_on_hand - i.quantity_reserved) AS quantity_available,
    i.reorder_level,
    i.reorder_quantity,
    i.last_restocked_at,
    CASE
        WHEN i.quantity_on_hand = 0
            THEN 'OUT_OF_STOCK'
        WHEN i.quantity_on_hand <= i.reorder_level
            THEN 'LOW_STOCK'
        WHEN i.quantity_on_hand <= (i.reorder_level * 2)
            THEN 'MODERATE'
        ELSE 'WELL_STOCKED'
    END AS stock_status,
    p.sale_price,
    p.cost_price,
    ROUND(p.sale_price - p.cost_price, 2) AS gross_margin_per_unit,
    ROUND((p.sale_price - p.cost_price) / NULLIF(p.sale_price, 0) * 100, 2) AS margin_pct
FROM products p
JOIN categories c ON c.category_id = p.category_id
JOIN inventory  i ON i.product_id  = p.product_id
WHERE p.is_active = 1;

-- =============================================================
-- VIEW 2: vw_order_details
-- Denormalised view joining orders, items, customers, products.
-- Useful for order fulfilment dashboards and reports.
-- =============================================================
DROP VIEW IF EXISTS vw_order_details;
CREATE VIEW vw_order_details AS
SELECT
    o.order_id,
    o.order_date,
    o.status                                               AS order_status,
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name)                AS customer_name,
    c.email,
    c.city                                                 AS customer_city,
    c.state                                                AS customer_state,
    oi.order_item_id,
    p.product_id,
    p.product_name,
    cat.category_name,
    oi.quantity,
    oi.unit_price,
    oi.discount_pct,
    oi.line_total,
    o.total_amount                                         AS order_total,
    o.discount_amount                                      AS order_discount,
    o.tax_amount,
    o.shipping_city,
    o.shipping_state,
    pay.payment_method,
    pay.status                                             AS payment_status,
    sh.carrier,
    sh.status                                              AS shipment_status,
    sh.shipped_date,
    sh.delivered_date
FROM orders o
JOIN customers  c   ON c.customer_id   = o.customer_id
JOIN order_items oi ON oi.order_id     = o.order_id
JOIN products   p   ON p.product_id    = oi.product_id
JOIN categories cat ON cat.category_id = p.category_id
LEFT JOIN payments pay ON pay.order_id = o.order_id
    AND pay.status NOT IN ('FAILED')       -- most recent successful payment
LEFT JOIN shipments sh  ON sh.order_id = o.order_id;

-- =============================================================
-- VIEW 3: vw_monthly_sales_summary
-- Aggregates revenue, orders, and units sold per month.
-- Excludes CANCELLED orders (no revenue recognised).
-- =============================================================
DROP VIEW IF EXISTS vw_monthly_sales_summary;
CREATE VIEW vw_monthly_sales_summary AS
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m')   AS sale_month,
    YEAR(o.order_date)                   AS sale_year,
    MONTH(o.order_date)                  AS month_num,
    COUNT(DISTINCT o.order_id)           AS total_orders,
    COUNT(DISTINCT o.customer_id)        AS unique_customers,
    SUM(oi.quantity)                     AS units_sold,
    ROUND(SUM(oi.line_total), 2)         AS gross_revenue,
    ROUND(SUM(o.discount_amount), 2)     AS total_discounts,
    ROUND(SUM(o.tax_amount), 2)          AS total_tax,
    ROUND(SUM(oi.line_total) - SUM(o.discount_amount), 2) AS net_revenue,
    ROUND(SUM(oi.line_total) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS avg_order_value
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status NOT IN ('CANCELLED')
GROUP BY sale_month, sale_year, month_num;

-- =============================================================
-- VIEW 4: vw_customer_spending_summary
-- Lifetime value metrics per customer.
-- =============================================================
DROP VIEW IF EXISTS vw_customer_spending_summary;
CREATE VIEW vw_customer_spending_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name)  AS customer_name,
    c.email,
    c.city,
    c.state,
    COUNT(DISTINCT o.order_id)              AS total_orders,
    SUM(oi.line_total)                      AS lifetime_revenue,
    ROUND(SUM(oi.line_total) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS avg_order_value,
    MIN(o.order_date)                       AS first_order_date,
    MAX(o.order_date)                       AS last_order_date,
    DATEDIFF(MAX(o.order_date), MIN(o.order_date)) AS customer_tenure_days,
    SUM(CASE WHEN o.status = 'CANCELLED' THEN 1 ELSE 0 END) AS cancelled_orders,
    SUM(CASE WHEN o.status = 'RETURNED'  THEN 1 ELSE 0 END) AS returned_orders,
    -- RFM components
    DATEDIFF(CURDATE(), MAX(o.order_date))  AS days_since_last_order
FROM customers c
LEFT JOIN orders o      ON o.customer_id = c.customer_id
                        AND o.status NOT IN ('CANCELLED')
LEFT JOIN order_items oi ON oi.order_id  = o.order_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.city, c.state;

-- =============================================================
-- VIEW 5: vw_product_profitability
-- Estimated gross profit per product based on cost vs revenue.
-- Note: cost_price is the product master cost; actual supplier
-- costs may vary (see product_suppliers.unit_cost).
-- =============================================================
DROP VIEW IF EXISTS vw_product_profitability;
CREATE VIEW vw_product_profitability AS
SELECT
    p.product_id,
    p.sku,
    p.product_name,
    c.category_name,
    p.cost_price,
    p.sale_price,
    COUNT(DISTINCT oi.order_id)            AS orders_containing_product,
    SUM(oi.quantity)                       AS units_sold,
    ROUND(SUM(oi.line_total), 2)           AS total_revenue,
    ROUND(SUM(oi.quantity * p.cost_price), 2) AS estimated_cogs,
    ROUND(SUM(oi.line_total) - SUM(oi.quantity * p.cost_price), 2) AS estimated_gross_profit,
    ROUND(
        (SUM(oi.line_total) - SUM(oi.quantity * p.cost_price))
        / NULLIF(SUM(oi.line_total), 0) * 100,
    2) AS gross_margin_pct,
    i.quantity_on_hand                     AS current_stock
FROM products p
JOIN categories  c  ON c.category_id = p.category_id
LEFT JOIN order_items oi ON oi.product_id = p.product_id
LEFT JOIN orders o      ON o.order_id     = oi.order_id
                        AND o.status NOT IN ('CANCELLED')
LEFT JOIN inventory i   ON i.product_id   = p.product_id
GROUP BY p.product_id, p.sku, p.product_name, c.category_name,
         p.cost_price, p.sale_price, i.quantity_on_hand;

-- Verify views were created
SELECT table_name AS view_name
FROM information_schema.views
WHERE table_schema = 'ecommerce_analytics'
ORDER BY table_name;
