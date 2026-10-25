-- =============================================================
-- E-Commerce Sales & Inventory Management System
-- Script: 03_indexes.sql
-- Purpose: Create performance indexes (run AFTER tables are created)
-- Run AFTER: 02_create_tables.sql
-- MySQL Version: 8.0+
-- =============================================================

USE ecommerce_analytics;

-- =============================================================
-- INDEX STRATEGY
-- Guiding principles used here:
--   1. Index every FK column not already covered by a UNIQUE key.
--   2. Add composite indexes for the most common filter+sort
--      combinations seen in 09_analytics_queries.sql.
--   3. Column order in composite indexes follows selectivity:
--      high-cardinality columns first so the engine can narrow
--      the result set as early as possible.
--   4. Do NOT index low-cardinality columns alone (is_active,
--      status with a handful of values) unless combined with
--      a high-cardinality prefix.
-- =============================================================

-- -----------------------------------------------------------
-- customers table
-- -----------------------------------------------------------
-- email is already UNIQUE (index auto-created by MySQL).
-- Support full-name lookups and city-based sales reports.
CREATE INDEX idx_customers_city
    ON customers (city);

CREATE INDEX idx_customers_name
    ON customers (last_name, first_name);

-- -----------------------------------------------------------
-- categories table
-- -----------------------------------------------------------
-- parent_category_id is referenced in self-join hierarchy queries.
CREATE INDEX idx_categories_parent
    ON categories (parent_category_id);

-- -----------------------------------------------------------
-- products table
-- -----------------------------------------------------------
-- SKU uniqueness index auto-created; additional index for
-- category-based filtering and reporting.
CREATE INDEX idx_products_category
    ON products (category_id);

-- Support filtering active products within a category.
CREATE INDEX idx_products_category_active
    ON products (category_id, is_active);

-- -----------------------------------------------------------
-- product_suppliers table
-- -----------------------------------------------------------
-- supplier_id FK lookup when querying supplier performance.
CREATE INDEX idx_ps_supplier
    ON product_suppliers (supplier_id);

-- -----------------------------------------------------------
-- inventory table
-- -----------------------------------------------------------
-- The UNIQUE on product_id already covers FK lookups.
-- Index on quantity_on_hand for low-stock alert queries.
CREATE INDEX idx_inventory_qty
    ON inventory (quantity_on_hand, product_id);

-- -----------------------------------------------------------
-- inventory_movements table
-- -----------------------------------------------------------
-- Most queries filter by product_id and movement_type,
-- then order by created_at.
CREATE INDEX idx_im_product_type
    ON inventory_movements (product_id, movement_type);

-- Support time-series queries: date-range scans.
CREATE INDEX idx_im_created_at
    ON inventory_movements (created_at);

-- Support reference lookups (e.g., "movements for order 42").
CREATE INDEX idx_im_reference
    ON inventory_movements (reference_type, reference_id);

-- -----------------------------------------------------------
-- orders table
-- -----------------------------------------------------------
-- FK on customer_id; status used heavily in reports.
CREATE INDEX idx_orders_customer
    ON orders (customer_id);

-- Composite: customer + status supports order history lookups.
CREATE INDEX idx_orders_customer_status
    ON orders (customer_id, status);

-- Date range queries are the most frequent reporting pattern.
CREATE INDEX idx_orders_order_date
    ON orders (order_date);

-- Status + date: used by fulfilment dashboards.
CREATE INDEX idx_orders_status_date
    ON orders (status, order_date);

-- -----------------------------------------------------------
-- order_items table
-- -----------------------------------------------------------
-- FK on product_id for product-level revenue reports.
CREATE INDEX idx_oi_product
    ON order_items (product_id);

-- Composite: product + order supports joins in both directions.
CREATE INDEX idx_oi_product_order
    ON order_items (product_id, order_id);

-- -----------------------------------------------------------
-- payments table
-- -----------------------------------------------------------
-- FK on order_id; status + date for payment reports.
CREATE INDEX idx_payments_order
    ON payments (order_id);

CREATE INDEX idx_payments_status_date
    ON payments (status, payment_date);

-- Payment method breakdown queries.
CREATE INDEX idx_payments_method
    ON payments (payment_method);

-- -----------------------------------------------------------
-- shipments table
-- -----------------------------------------------------------
CREATE INDEX idx_shipments_order
    ON shipments (order_id);

CREATE INDEX idx_shipments_status
    ON shipments (status);

-- Delivery performance: compare shipped_date vs delivered_date.
CREATE INDEX idx_shipments_dates
    ON shipments (shipped_date, delivered_date);

-- -----------------------------------------------------------
-- returns table
-- -----------------------------------------------------------
-- order_item_id is already UNIQUE; add order_id FK index.
CREATE INDEX idx_returns_order
    ON returns (order_id);

CREATE INDEX idx_returns_status
    ON returns (return_status);

-- =============================================================
-- VERIFY: List all indexes on the schema
-- =============================================================
SELECT
    s.table_name,
    s.index_name,
    GROUP_CONCAT(s.column_name ORDER BY s.seq_in_index SEPARATOR ', ')
        AS indexed_columns,
    s.non_unique,
    s.index_type
FROM information_schema.statistics s
WHERE s.table_schema = 'ecommerce_analytics'
GROUP BY s.table_name, s.index_name, s.non_unique, s.index_type
ORDER BY s.table_name, s.index_name;
