-- =============================================================
-- E-Commerce Sales & Inventory Management System
-- Script: 09_analytics_queries.sql
-- Purpose: 30+ business intelligence queries
-- Run AFTER: 04_seed_data.sql
-- MySQL Version: 8.0+
--
-- BUSINESS DEFINITIONS USED THROUGHOUT
-- ──────────────────────────────────────────────────────────────
-- Revenue     : SUM(order_items.line_total) for non-CANCELLED orders
-- Net Revenue : Revenue − order discounts
-- COGS        : SUM(quantity × products.cost_price)
-- Gross Profit: Revenue − COGS
-- Cancelled   : orders with status = 'CANCELLED'
-- Returned    : orders with status = 'RETURNED'
-- Active Order : status IN ('CONFIRMED','SHIPPED','DELIVERED')
-- =============================================================

USE ecommerce_analytics;

-- ─────────────────────────────────────────────────────────────
-- Q1: Top 5 Products by Revenue
-- ─────────────────────────────────────────────────────────────
-- Shows the five highest-grossing products.
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    SUM(oi.quantity)              AS units_sold,
    ROUND(SUM(oi.line_total), 2)  AS total_revenue,
    RANK() OVER (ORDER BY SUM(oi.line_total) DESC) AS revenue_rank
FROM order_items oi
JOIN products   p   ON p.product_id    = oi.product_id
JOIN categories c   ON c.category_id   = p.category_id
JOIN orders     o   ON o.order_id      = oi.order_id
WHERE o.status NOT IN ('CANCELLED')
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY total_revenue DESC
LIMIT 5;

-- ─────────────────────────────────────────────────────────────
-- Q2: Monthly Sales and Month-over-Month Growth
-- ─────────────────────────────────────────────────────────────
WITH monthly AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m')    AS sale_month,
        ROUND(SUM(oi.line_total), 2)          AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.status NOT IN ('CANCELLED')
    GROUP BY sale_month
)
SELECT
    sale_month,
    revenue,
    LAG(revenue) OVER (ORDER BY sale_month) AS prev_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY sale_month))
        / NULLIF(LAG(revenue) OVER (ORDER BY sale_month), 0) * 100,
    2) AS mom_growth_pct
FROM monthly
ORDER BY sale_month;

-- ─────────────────────────────────────────────────────────────
-- Q3: Top 10 Customers by Lifetime Spending
-- ─────────────────────────────────────────────────────────────
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name)  AS customer_name,
    c.city,
    c.state,
    COUNT(DISTINCT o.order_id)              AS total_orders,
    ROUND(SUM(oi.line_total), 2)            AS lifetime_spending,
    fn_customer_segment(SUM(oi.line_total)) AS segment
FROM customers c
JOIN orders      o  ON o.customer_id  = c.customer_id
JOIN order_items oi ON oi.order_id    = o.order_id
WHERE o.status NOT IN ('CANCELLED')
GROUP BY c.customer_id, c.first_name, c.last_name, c.city, c.state
ORDER BY lifetime_spending DESC
LIMIT 10;

-- ─────────────────────────────────────────────────────────────
-- Q4: Customers Who Never Placed an Order
-- ─────────────────────────────────────────────────────────────
-- Uses LEFT JOIN + IS NULL (often faster than NOT IN with NULLs).
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    c.city,
    c.created_at                           AS joined_date
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL
ORDER BY c.created_at DESC;

-- ─────────────────────────────────────────────────────────────
-- Q5: Average Order Value (Overall and by Month)
-- ─────────────────────────────────────────────────────────────
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m')      AS sale_month,
    COUNT(DISTINCT o.order_id)              AS total_orders,
    ROUND(SUM(oi.line_total), 2)            AS total_revenue,
    ROUND(AVG(o.total_amount), 2)           AS avg_order_value
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status NOT IN ('CANCELLED')
GROUP BY sale_month
ORDER BY sale_month;

-- ─────────────────────────────────────────────────────────────
-- Q6: Category-Wise Revenue and Contribution %
-- ─────────────────────────────────────────────────────────────
SELECT
    c.category_name,
    COUNT(DISTINCT o.order_id)               AS orders,
    SUM(oi.quantity)                         AS units_sold,
    ROUND(SUM(oi.line_total), 2)             AS revenue,
    ROUND(
        SUM(oi.line_total) * 100.0
        / SUM(SUM(oi.line_total)) OVER (),
    2)                                       AS revenue_contribution_pct
FROM order_items oi
JOIN products   p   ON p.product_id   = oi.product_id
JOIN categories c   ON c.category_id  = p.category_id
JOIN orders     o   ON o.order_id     = oi.order_id
WHERE o.status NOT IN ('CANCELLED')
GROUP BY c.category_name
ORDER BY revenue DESC;

-- ─────────────────────────────────────────────────────────────
-- Q7: Best-Selling Products by Quantity Sold
-- ─────────────────────────────────────────────────────────────
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    SUM(oi.quantity)             AS units_sold,
    ROUND(SUM(oi.line_total), 2) AS revenue
FROM order_items oi
JOIN products   p ON p.product_id   = oi.product_id
JOIN categories c ON c.category_id  = p.category_id
JOIN orders     o ON o.order_id     = oi.order_id
WHERE o.status NOT IN ('CANCELLED')
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY units_sold DESC
LIMIT 10;

-- ─────────────────────────────────────────────────────────────
-- Q8: Second-Highest Revenue-Generating Product
-- Using DENSE_RANK to handle ties correctly.
-- ─────────────────────────────────────────────────────────────
WITH ranked AS (
    SELECT
        p.product_id,
        p.product_name,
        ROUND(SUM(oi.line_total), 2)   AS revenue,
        DENSE_RANK() OVER (ORDER BY SUM(oi.line_total) DESC) AS rk
    FROM order_items oi
    JOIN products p ON p.product_id = oi.product_id
    JOIN orders   o ON o.order_id   = oi.order_id
    WHERE o.status NOT IN ('CANCELLED')
    GROUP BY p.product_id, p.product_name
)
SELECT product_id, product_name, revenue, rk AS revenue_rank
FROM   ranked
WHERE  rk = 2;

-- ─────────────────────────────────────────────────────────────
-- Q9: Top 3 Products per Category (Window Function)
-- ─────────────────────────────────────────────────────────────
WITH cat_product_revenue AS (
    SELECT
        c.category_name,
        p.product_name,
        ROUND(SUM(oi.line_total), 2) AS revenue,
        ROW_NUMBER() OVER (
            PARTITION BY c.category_id
            ORDER BY SUM(oi.line_total) DESC
        ) AS rn
    FROM order_items oi
    JOIN products   p ON p.product_id   = oi.product_id
    JOIN categories c ON c.category_id  = p.category_id
    JOIN orders     o ON o.order_id     = oi.order_id
    WHERE o.status NOT IN ('CANCELLED')
    GROUP BY c.category_id, c.category_name, p.product_id, p.product_name
)
SELECT category_name, product_name, revenue, rn AS rank_in_category
FROM   cat_product_revenue
WHERE  rn <= 3
ORDER BY category_name, rn;

-- ─────────────────────────────────────────────────────────────
-- Q10: Customer Lifetime Spending with Percentile Ranking
-- ─────────────────────────────────────────────────────────────
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name)  AS customer_name,
    ROUND(SUM(oi.line_total), 2)            AS lifetime_spending,
    RANK() OVER (ORDER BY SUM(oi.line_total) DESC)        AS spending_rank,
    PERCENT_RANK() OVER (ORDER BY SUM(oi.line_total))     AS percentile
FROM customers c
JOIN orders      o  ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id   = o.order_id
WHERE o.status NOT IN ('CANCELLED')
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY lifetime_spending DESC;

-- ─────────────────────────────────────────────────────────────
-- Q11: Repeat Customer Analysis
-- Customers with more than 1 delivered/confirmed order.
-- ─────────────────────────────────────────────────────────────
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT o.order_id)             AS order_count,
    MIN(o.order_date)                      AS first_order,
    MAX(o.order_date)                      AS latest_order,
    DATEDIFF(MAX(o.order_date), MIN(o.order_date)) AS days_active
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.status IN ('DELIVERED','CONFIRMED','SHIPPED')
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY order_count DESC;

-- ─────────────────────────────────────────────────────────────
-- Q12: Products with No Recent Sales (Last 60 Days)
-- ─────────────────────────────────────────────────────────────
SELECT
    p.product_id,
    p.sku,
    p.product_name,
    c.category_name,
    MAX(o.order_date)   AS last_sale_date,
    DATEDIFF(CURDATE(), MAX(o.order_date)) AS days_since_last_sale,
    i.quantity_on_hand
FROM products p
JOIN categories c ON c.category_id = p.category_id
JOIN inventory  i ON i.product_id  = p.product_id
LEFT JOIN order_items oi ON oi.product_id = p.product_id
LEFT JOIN orders      o  ON o.order_id    = oi.order_id
                         AND o.status NOT IN ('CANCELLED')
GROUP BY p.product_id, p.sku, p.product_name, c.category_name, i.quantity_on_hand
HAVING MAX(o.order_date) IS NULL
    OR DATEDIFF(CURDATE(), MAX(o.order_date)) > 60
ORDER BY days_since_last_sale DESC;

-- ─────────────────────────────────────────────────────────────
-- Q13: Low-Stock Alerts and Replenishment Analysis
-- ─────────────────────────────────────────────────────────────
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    i.quantity_on_hand,
    i.quantity_reserved,
    (i.quantity_on_hand - i.quantity_reserved) AS available,
    i.reorder_level,
    i.reorder_quantity,
    CASE
        WHEN i.quantity_on_hand = 0 THEN 'ORDER_NOW'
        WHEN i.quantity_on_hand <= i.reorder_level THEN 'LOW_STOCK'
        ELSE 'OK'
    END AS alert_level,
    -- Primary supplier details
    ps.supplier_id,
    s.supplier_name,
    ps.lead_time_days,
    ps.unit_cost,
    ROUND(i.reorder_quantity * ps.unit_cost, 2) AS estimated_reorder_cost
FROM inventory i
JOIN products        p  ON p.product_id   = i.product_id
JOIN categories      c  ON c.category_id  = p.category_id
LEFT JOIN product_suppliers ps ON ps.product_id = p.product_id
                               AND ps.is_primary_supplier = 1
LEFT JOIN suppliers  s  ON s.supplier_id  = ps.supplier_id
WHERE i.quantity_on_hand <= i.reorder_level
ORDER BY i.quantity_on_hand ASC;

-- ─────────────────────────────────────────────────────────────
-- Q14: Supplier Performance Analysis
-- Revenue contribution per supplier through their products.
-- ─────────────────────────────────────────────────────────────
SELECT
    s.supplier_id,
    s.supplier_name,
    s.city                                       AS supplier_city,
    COUNT(DISTINCT p.product_id)                 AS products_supplied,
    SUM(oi.quantity)                             AS total_units_sold,
    ROUND(SUM(oi.line_total), 2)                 AS total_revenue,
    ROUND(SUM(oi.quantity * ps.unit_cost), 2)    AS total_cogs,
    ROUND(SUM(oi.line_total) - SUM(oi.quantity * ps.unit_cost), 2) AS gross_profit
FROM suppliers s
JOIN product_suppliers ps ON ps.supplier_id   = s.supplier_id
                          AND ps.is_primary_supplier = 1
JOIN products          p  ON p.product_id     = ps.product_id
JOIN order_items       oi ON oi.product_id    = p.product_id
JOIN orders            o  ON o.order_id       = oi.order_id
WHERE o.status NOT IN ('CANCELLED')
GROUP BY s.supplier_id, s.supplier_name, s.city
ORDER BY total_revenue DESC;

-- ─────────────────────────────────────────────────────────────
-- Q15: Sales by City (Customer Shipping City)
-- ─────────────────────────────────────────────────────────────
SELECT
    o.shipping_city                   AS city,
    o.shipping_state                  AS state,
    COUNT(DISTINCT o.order_id)        AS total_orders,
    COUNT(DISTINCT o.customer_id)     AS unique_customers,
    ROUND(SUM(oi.line_total), 2)      AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status NOT IN ('CANCELLED')
GROUP BY o.shipping_city, o.shipping_state
ORDER BY revenue DESC
LIMIT 15;

-- ─────────────────────────────────────────────────────────────
-- Q16: Order and Payment Status Report
-- Cross-tab of order status vs payment status.
-- ─────────────────────────────────────────────────────────────
SELECT
    o.status                                  AS order_status,
    COUNT(DISTINCT o.order_id)                AS order_count,
    SUM(CASE WHEN pay.status = 'COMPLETED' THEN 1 ELSE 0 END) AS paid_count,
    SUM(CASE WHEN pay.status = 'FAILED'    THEN 1 ELSE 0 END) AS failed_count,
    SUM(CASE WHEN pay.status = 'REFUNDED'  THEN 1 ELSE 0 END) AS refunded_count,
    SUM(CASE WHEN pay.order_id IS NULL     THEN 1 ELSE 0 END) AS no_payment_attempt
FROM orders o
LEFT JOIN payments pay ON pay.order_id = o.order_id
GROUP BY o.status
ORDER BY order_count DESC;

-- ─────────────────────────────────────────────────────────────
-- Q17: Shipment Delivery Performance
-- Average, min, and max days to deliver.
-- ─────────────────────────────────────────────────────────────
SELECT
    sh.carrier,
    COUNT(sh.shipment_id)                                   AS shipments,
    SUM(CASE WHEN sh.status = 'DELIVERED' THEN 1 ELSE 0 END) AS delivered,
    ROUND(AVG(DATEDIFF(sh.delivered_date, sh.shipped_date)), 1) AS avg_delivery_days,
    MIN(DATEDIFF(sh.delivered_date, sh.shipped_date))          AS min_delivery_days,
    MAX(DATEDIFF(sh.delivered_date, sh.shipped_date))          AS max_delivery_days,
    SUM(CASE WHEN sh.delivered_date > sh.estimated_date THEN 1 ELSE 0 END) AS late_deliveries
FROM shipments sh
WHERE sh.status = 'DELIVERED'
  AND sh.delivered_date IS NOT NULL
  AND sh.shipped_date   IS NOT NULL
GROUP BY sh.carrier
ORDER BY avg_delivery_days;

-- ─────────────────────────────────────────────────────────────
-- Q18: Product and Category Return Rates
-- ─────────────────────────────────────────────────────────────
SELECT
    c.category_name,
    p.product_name,
    SUM(oi.quantity)                   AS units_sold,
    COALESCE(SUM(r.quantity), 0)       AS units_returned,
    ROUND(
        COALESCE(SUM(r.quantity), 0) * 100.0
        / NULLIF(SUM(oi.quantity), 0),
    2)                                 AS return_rate_pct
FROM order_items oi
JOIN products   p  ON p.product_id   = oi.product_id
JOIN categories c  ON c.category_id  = p.category_id
JOIN orders     o  ON o.order_id     = oi.order_id
LEFT JOIN returns r ON r.order_item_id = oi.order_item_id
WHERE o.status NOT IN ('CANCELLED')
GROUP BY c.category_name, p.product_id, p.product_name
ORDER BY return_rate_pct DESC, units_sold DESC
LIMIT 20;

-- ─────────────────────────────────────────────────────────────
-- Q19: Estimated Gross Profit by Product
-- ─────────────────────────────────────────────────────────────
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    ROUND(SUM(oi.line_total), 2)              AS revenue,
    ROUND(SUM(oi.quantity * p.cost_price), 2) AS cogs,
    ROUND(SUM(oi.line_total) - SUM(oi.quantity * p.cost_price), 2) AS gross_profit,
    ROUND(
        (SUM(oi.line_total) - SUM(oi.quantity * p.cost_price))
        / NULLIF(SUM(oi.line_total), 0) * 100,
    2) AS margin_pct
FROM order_items oi
JOIN products   p ON p.product_id   = oi.product_id
JOIN categories c ON c.category_id  = p.category_id
JOIN orders     o ON o.order_id     = oi.order_id
WHERE o.status NOT IN ('CANCELLED')
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY gross_profit DESC;

-- ─────────────────────────────────────────────────────────────
-- Q20: Monthly Order Volume Trend
-- ─────────────────────────────────────────────────────────────
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(order_id)                  AS total_orders,
    SUM(CASE WHEN status = 'DELIVERED'  THEN 1 ELSE 0 END) AS delivered,
    SUM(CASE WHEN status = 'CANCELLED'  THEN 1 ELSE 0 END) AS cancelled,
    SUM(CASE WHEN status = 'RETURNED'   THEN 1 ELSE 0 END) AS returned,
    SUM(CASE WHEN status = 'SHIPPED'    THEN 1 ELSE 0 END) AS shipped,
    SUM(CASE WHEN status = 'CONFIRMED'  THEN 1 ELSE 0 END) AS confirmed,
    SUM(CASE WHEN status = 'PENDING'    THEN 1 ELSE 0 END) AS pending
FROM orders
GROUP BY month
ORDER BY month;

-- ─────────────────────────────────────────────────────────────
-- Q21: Revenue Contribution by Category (Pie-Chart Data)
-- ─────────────────────────────────────────────────────────────
SELECT
    c.category_name,
    ROUND(SUM(oi.line_total), 2) AS revenue,
    ROUND(
        SUM(oi.line_total) * 100.0
        / SUM(SUM(oi.line_total)) OVER (),
    2) AS pct_of_total
FROM order_items oi
JOIN products   p ON p.product_id   = oi.product_id
JOIN categories c ON c.category_id  = p.category_id
JOIN orders     o ON o.order_id     = oi.order_id
WHERE o.status NOT IN ('CANCELLED')
GROUP BY c.category_name
ORDER BY revenue DESC;

-- ─────────────────────────────────────────────────────────────
-- Q22: Customers Purchasing in Consecutive Months
-- Uses LAG to detect month-on-month continuity.
-- ─────────────────────────────────────────────────────────────
WITH customer_months AS (
    SELECT
        o.customer_id,
        DATE_FORMAT(o.order_date, '%Y-%m')   AS order_month,
        DENSE_RANK() OVER (
            PARTITION BY o.customer_id
            ORDER BY DATE_FORMAT(o.order_date, '%Y-%m')
        ) AS month_rk
    FROM orders o
    WHERE o.status NOT IN ('CANCELLED')
    GROUP BY o.customer_id, order_month
),
consecutive_check AS (
    SELECT
        cm.customer_id,
        cm.order_month,
        cm.month_rk,
        LAG(cm.order_month) OVER (
            PARTITION BY cm.customer_id ORDER BY cm.month_rk
        ) AS prev_month,
        PERIOD_DIFF(
            REPLACE(cm.order_month, '-', ''),
            REPLACE(LAG(cm.order_month) OVER (
                PARTITION BY cm.customer_id ORDER BY cm.month_rk
            ), '-', '')
        ) AS month_gap
    FROM customer_months cm
)
SELECT
    cc.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(*) AS consecutive_month_pairs
FROM consecutive_check cc
JOIN customers c ON c.customer_id = cc.customer_id
WHERE cc.month_gap = 1  -- exactly 1 month gap = consecutive
GROUP BY cc.customer_id, c.first_name, c.last_name
HAVING COUNT(*) >= 2    -- at least 3 consecutive months
ORDER BY consecutive_month_pairs DESC;

-- ─────────────────────────────────────────────────────────────
-- Q23: Products Performing Above Their Category Average Revenue
-- ─────────────────────────────────────────────────────────────
WITH product_revenue AS (
    SELECT
        p.product_id,
        p.product_name,
        c.category_id,
        c.category_name,
        SUM(oi.line_total) AS product_revenue
    FROM order_items oi
    JOIN products   p ON p.product_id  = oi.product_id
    JOIN categories c ON c.category_id = p.category_id
    JOIN orders     o ON o.order_id    = oi.order_id
    WHERE o.status NOT IN ('CANCELLED')
    GROUP BY p.product_id, p.product_name, c.category_id, c.category_name
),
category_avg AS (
    SELECT
        category_id,
        AVG(product_revenue) AS avg_category_revenue
    FROM product_revenue
    GROUP BY category_id
)
SELECT
    pr.product_name,
    pr.category_name,
    ROUND(pr.product_revenue, 2)     AS product_revenue,
    ROUND(ca.avg_category_revenue, 2) AS category_avg_revenue,
    ROUND(pr.product_revenue - ca.avg_category_revenue, 2) AS above_avg_by
FROM product_revenue pr
JOIN category_avg ca ON ca.category_id = pr.category_id
WHERE pr.product_revenue > ca.avg_category_revenue
ORDER BY above_avg_by DESC;

-- ─────────────────────────────────────────────────────────────
-- Q24: Customer Ranking by Spending (RANK vs DENSE_RANK)
-- Demonstrates difference between RANK and DENSE_RANK.
-- ─────────────────────────────────────────────────────────────
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name)   AS customer_name,
    ROUND(SUM(oi.line_total), 2)             AS total_spent,
    RANK()       OVER (ORDER BY SUM(oi.line_total) DESC) AS rank_with_gaps,
    DENSE_RANK() OVER (ORDER BY SUM(oi.line_total) DESC) AS dense_rank_no_gaps,
    ROW_NUMBER() OVER (ORDER BY SUM(oi.line_total) DESC) AS row_num
FROM customers c
JOIN orders      o  ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id   = o.order_id
WHERE o.status NOT IN ('CANCELLED')
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 20;

-- ─────────────────────────────────────────────────────────────
-- Q25: Rolling 3-Month Revenue (Moving Average)
-- ─────────────────────────────────────────────────────────────
WITH monthly_rev AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m')  AS sale_month,
        ROUND(SUM(oi.line_total), 2)        AS monthly_revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.status NOT IN ('CANCELLED')
    GROUP BY sale_month
)
SELECT
    sale_month,
    monthly_revenue,
    ROUND(
        AVG(monthly_revenue) OVER (
            ORDER BY sale_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
    2) AS rolling_3m_avg
FROM monthly_rev
ORDER BY sale_month;

-- ─────────────────────────────────────────────────────────────
-- Q26: Payment Method Distribution
-- ─────────────────────────────────────────────────────────────
SELECT
    payment_method,
    COUNT(*)                     AS transaction_count,
    ROUND(SUM(amount), 2)        AS total_collected,
    ROUND(AVG(amount), 2)        AS avg_transaction,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_transactions
FROM payments
WHERE status = 'COMPLETED'
GROUP BY payment_method
ORDER BY total_collected DESC;

-- ─────────────────────────────────────────────────────────────
-- Q27: Cancellation Rate by Month
-- ─────────────────────────────────────────────────────────────
SELECT
    DATE_FORMAT(order_date, '%Y-%m')  AS month,
    COUNT(order_id)                   AS total_orders,
    SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END) AS cancellations,
    ROUND(
        SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END) * 100.0
        / COUNT(order_id),
    2) AS cancellation_rate_pct
FROM orders
GROUP BY month
ORDER BY month;

-- ─────────────────────────────────────────────────────────────
-- Q28: Inventory Value Report (Stock on Hand × Cost Price)
-- ─────────────────────────────────────────────────────────────
SELECT
    c.category_name,
    COUNT(p.product_id)                                AS products,
    SUM(i.quantity_on_hand)                            AS total_units,
    ROUND(SUM(i.quantity_on_hand * p.cost_price), 2)   AS inventory_cost_value,
    ROUND(SUM(i.quantity_on_hand * p.sale_price), 2)   AS inventory_retail_value,
    ROUND(
        SUM(i.quantity_on_hand * (p.sale_price - p.cost_price)), 2
    )                                                  AS potential_gross_profit
FROM inventory i
JOIN products   p ON p.product_id   = i.product_id
JOIN categories c ON c.category_id  = p.category_id
GROUP BY c.category_name
ORDER BY inventory_cost_value DESC;

-- ─────────────────────────────────────────────────────────────
-- Q29: Orders and Revenue per State (Geographic Analysis)
-- ─────────────────────────────────────────────────────────────
SELECT
    o.shipping_state                 AS state,
    COUNT(DISTINCT o.order_id)       AS orders,
    COUNT(DISTINCT o.customer_id)    AS customers,
    ROUND(SUM(oi.line_total), 2)     AS revenue,
    ROUND(AVG(o.total_amount), 2)    AS avg_order_value
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status NOT IN ('CANCELLED')
GROUP BY o.shipping_state
ORDER BY revenue DESC;

-- ─────────────────────────────────────────────────────────────
-- Q30: Full RFM Analysis (Recency, Frequency, Monetary)
-- Segments customers into quartiles.
-- ─────────────────────────────────────────────────────────────
WITH rfm_raw AS (
    SELECT
        o.customer_id,
        DATEDIFF(CURDATE(), MAX(o.order_date))       AS recency_days,
        COUNT(DISTINCT o.order_id)                   AS frequency,
        ROUND(SUM(oi.line_total), 2)                 AS monetary
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.status NOT IN ('CANCELLED')
    GROUP BY o.customer_id
),
rfm_scored AS (
    SELECT
        customer_id,
        recency_days,
        frequency,
        monetary,
        NTILE(4) OVER (ORDER BY recency_days ASC)  AS r_score, -- lower recency = better
        NTILE(4) OVER (ORDER BY frequency    ASC)  AS f_score,
        NTILE(4) OVER (ORDER BY monetary     ASC)  AS m_score
    FROM rfm_raw
)
SELECT
    rs.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    rs.recency_days,
    rs.frequency,
    rs.monetary,
    rs.r_score,
    rs.f_score,
    rs.m_score,
    (rs.r_score + rs.f_score + rs.m_score) AS rfm_total,
    CASE
        WHEN rs.r_score >= 3 AND rs.f_score >= 3 AND rs.m_score >= 3 THEN 'Champions'
        WHEN rs.r_score >= 3 AND rs.f_score >= 2                     THEN 'Loyal Customers'
        WHEN rs.r_score >= 3 AND rs.f_score  < 2                     THEN 'Recent Customers'
        WHEN rs.r_score <= 2 AND rs.f_score >= 3                     THEN 'At Risk'
        ELSE 'Need Attention'
    END AS rfm_segment
FROM rfm_scored rs
JOIN customers c ON c.customer_id = rs.customer_id
ORDER BY rfm_total DESC, monetary DESC;

-- ─────────────────────────────────────────────────────────────
-- Q31: Products Purchased Together (Market Basket – Top Pairs)
-- Finds the most frequently co-ordered product pairs.
-- ─────────────────────────────────────────────────────────────
SELECT
    pa.product_name  AS product_a,
    pb.product_name  AS product_b,
    COUNT(*)         AS times_ordered_together
FROM order_items oia
JOIN order_items oib ON oib.order_id   = oia.order_id
                     AND oib.product_id > oia.product_id   -- avoid duplicates
JOIN products    pa  ON pa.product_id  = oia.product_id
JOIN products    pb  ON pb.product_id  = oib.product_id
GROUP BY pa.product_name, pb.product_name
ORDER BY times_ordered_together DESC
LIMIT 10;

-- ─────────────────────────────────────────────────────────────
-- Q32: New vs Returning Customer Revenue Split
-- ─────────────────────────────────────────────────────────────
WITH first_orders AS (
    SELECT customer_id, MIN(order_id) AS first_order_id
    FROM orders
    WHERE status NOT IN ('CANCELLED')
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN fo.first_order_id = o.order_id THEN 'New Customer'
        ELSE 'Returning Customer'
    END AS customer_type,
    COUNT(DISTINCT o.order_id)       AS orders,
    ROUND(SUM(oi.line_total), 2)     AS revenue,
    ROUND(AVG(o.total_amount), 2)    AS avg_order_value
FROM orders o
JOIN order_items oi ON oi.order_id  = o.order_id
JOIN first_orders fo ON fo.customer_id = o.customer_id
WHERE o.status NOT IN ('CANCELLED')
GROUP BY customer_type;

-- ─────────────────────────────────────────────────────────────
-- Q33: Day-of-Week Sales Pattern
-- ─────────────────────────────────────────────────────────────
SELECT
    DAYNAME(o.order_date)            AS day_of_week,
    DAYOFWEEK(o.order_date)          AS day_num,
    COUNT(DISTINCT o.order_id)       AS orders,
    ROUND(SUM(oi.line_total), 2)     AS revenue,
    ROUND(AVG(o.total_amount), 2)    AS avg_order_value
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status NOT IN ('CANCELLED')
GROUP BY day_of_week, day_num
ORDER BY day_num;
