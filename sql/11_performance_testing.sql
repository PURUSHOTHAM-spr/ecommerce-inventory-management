-- =============================================================
-- E-Commerce Sales & Inventory Management System
-- Script: 11_performance_testing.sql
-- Purpose: Index strategy, EXPLAIN plans, and query optimisation
-- Run AFTER: 04_seed_data.sql
-- MySQL Version: 8.0+
--
-- HOW TO READ EXPLAIN OUTPUT
-- ──────────────────────────────────────────────────────────────
-- type column (best → worst):
--   system > const > eq_ref > ref > range > index > ALL
-- key  : which index was chosen (NULL = full table scan)
-- rows : estimated rows examined (lower = better)
-- Extra: 'Using index'          = covering index (very fast)
--        'Using filesort'       = needs sort pass (expensive)
--        'Using temporary'      = temp table (expensive)
--        'Using where'          = filter after index scan
-- =============================================================

USE ecommerce_analytics;

-- ─────────────────────────────────────────────────────────────
-- SECTION 1: Full Table Scan vs Index Scan Comparison
-- ─────────────────────────────────────────────────────────────

-- Demo 1A: Without index – full scan on orders.status
-- (Run BEFORE 03_indexes.sql to see the difference; we simulate
--  by temporarily ignoring the index with IGNORE INDEX.)
SELECT 'DEMO 1A – Forced table scan (ignore index)' AS demo;
EXPLAIN
SELECT order_id, customer_id, status, order_date
FROM   orders IGNORE INDEX (idx_orders_status_date)
WHERE  status = 'DELIVERED'
  AND  order_date >= '2024-06-01';

-- Demo 1B: With composite index idx_orders_status_date
SELECT 'DEMO 1B – With composite index on (status, order_date)' AS demo;
EXPLAIN
SELECT order_id, customer_id, status, order_date
FROM   orders
WHERE  status = 'DELIVERED'
  AND  order_date >= '2024-06-01';

-- Insight: With the composite index, the engine skips straight to
-- status='DELIVERED' rows and scans only those within the date range.
-- Full scan reads ALL rows; index scan reads only the matching subset.

-- ─────────────────────────────────────────────────────────────
-- SECTION 2: Index Column Order Matters
-- ─────────────────────────────────────────────────────────────

-- The index idx_orders_status_date is (status, order_date).
-- MySQL can use it when filtering on:
--   (a) status alone
--   (b) status + order_date together
-- But NOT for order_date alone (leftmost prefix rule).

SELECT 'DEMO 2A – Prefix match: status only → uses index' AS demo;
EXPLAIN
SELECT COUNT(*) FROM orders WHERE status = 'SHIPPED';

SELECT 'DEMO 2B – No prefix match: date only → table scan' AS demo;
EXPLAIN
SELECT COUNT(*) FROM orders WHERE order_date >= '2024-06-01';

-- Lesson: Always put the highest-cardinality filter first in composite indexes
-- if you query on both columns, or put the equality column first
-- (status is low-cardinality but it narrows the scan enormously).

-- ─────────────────────────────────────────────────────────────
-- SECTION 3: JOIN Performance – FK Index Usage
-- ─────────────────────────────────────────────────────────────

SELECT 'DEMO 3 – JOIN using FK index on order_items.product_id' AS demo;
EXPLAIN
SELECT
    p.product_name,
    SUM(oi.quantity)         AS units_sold,
    SUM(oi.line_total)       AS revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders   o ON o.order_id   = oi.order_id
WHERE o.status = 'DELIVERED'
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC;

-- Expected: oi uses idx_oi_product for the JOIN; o uses idx_orders_status_date.
-- Without those indexes, both tables would be full-scanned and joined with
-- a nested-loop requiring up to O(n × m) row comparisons.

-- ─────────────────────────────────────────────────────────────
-- SECTION 4: Covering Index Example
-- ─────────────────────────────────────────────────────────────

-- The index idx_orders_customer_status on (customer_id, status)
-- covers queries that only need those two columns + order_id from PK.

SELECT 'DEMO 4 – Covering index: no heap access needed' AS demo;
EXPLAIN
SELECT customer_id, status, COUNT(*) AS order_count
FROM   orders
WHERE  customer_id = 4
GROUP  BY customer_id, status;

-- When Extra = 'Using index', the engine reads only from the index
-- B-tree and never touches the actual table rows – extremely fast.

-- ─────────────────────────────────────────────────────────────
-- SECTION 5: Sorting with and without an Index
-- ─────────────────────────────────────────────────────────────

SELECT 'DEMO 5A – Sort on indexed column: no filesort' AS demo;
EXPLAIN
SELECT customer_id, order_date, total_amount
FROM   orders
WHERE  customer_id = 15
ORDER  BY order_date DESC;

SELECT 'DEMO 5B – Sort on non-indexed column: filesort' AS demo;
EXPLAIN
SELECT customer_id, total_amount, notes
FROM   orders
WHERE  customer_id = 15
ORDER  BY total_amount DESC;

-- Lesson: Sorting on a column that is NOT part of an index forces
-- MySQL to buffer rows and sort them with a filesort pass.
-- For large result sets this is very expensive.

-- ─────────────────────────────────────────────────────────────
-- SECTION 6: Subquery vs JOIN Performance
-- ─────────────────────────────────────────────────────────────

-- Q: Find customers whose total spending > 10000
-- Method A: Correlated subquery (potentially slow)
SELECT 'DEMO 6A – Correlated subquery (avoid for large tables)' AS demo;
EXPLAIN
SELECT customer_id, first_name, last_name
FROM   customers c
WHERE  (
    SELECT SUM(oi.line_total)
    FROM   orders o
    JOIN   order_items oi ON oi.order_id = o.order_id
    WHERE  o.customer_id = c.customer_id
      AND  o.status NOT IN ('CANCELLED')
) > 10000;

-- Method B: JOIN + HAVING (typically faster – one pass)
SELECT 'DEMO 6B – JOIN + HAVING (preferred)' AS demo;
EXPLAIN
SELECT c.customer_id, c.first_name, c.last_name,
       SUM(oi.line_total) AS total_spent
FROM   customers c
JOIN   orders      o  ON o.customer_id = c.customer_id
JOIN   order_items oi ON oi.order_id   = o.order_id
WHERE  o.status NOT IN ('CANCELLED')
GROUP  BY c.customer_id, c.first_name, c.last_name
HAVING SUM(oi.line_total) > 10000;

-- ─────────────────────────────────────────────────────────────
-- SECTION 7: EXPLAIN ANALYZE (MySQL 8.0.18+)
-- Shows actual vs estimated row counts and execution time.
-- ─────────────────────────────────────────────────────────────

SELECT 'DEMO 7 – EXPLAIN ANALYZE on monthly revenue CTE' AS demo;
EXPLAIN ANALYZE
WITH monthly AS (
    SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS mth,
           SUM(oi.line_total)                 AS rev
    FROM   orders      o
    JOIN   order_items oi ON oi.order_id = o.order_id
    WHERE  o.status NOT IN ('CANCELLED')
    GROUP  BY mth
)
SELECT mth, rev,
       LAG(rev) OVER (ORDER BY mth) AS prev_rev
FROM   monthly
ORDER  BY mth;

-- ─────────────────────────────────────────────────────────────
-- SECTION 8: Index Usage on inventory_movements
-- ─────────────────────────────────────────────────────────────

SELECT 'DEMO 8 – Range scan on inventory_movements.created_at' AS demo;
EXPLAIN
SELECT product_id, movement_type, quantity_change, created_at
FROM   inventory_movements
WHERE  created_at >= '2024-07-01'
  AND  created_at <  '2024-08-01'
ORDER  BY created_at;

-- idx_im_created_at supports the range predicate;
-- without it, all millions of movement rows would be full-scanned.

-- ─────────────────────────────────────────────────────────────
-- SECTION 9: SELECT * vs Explicit Columns (Column Pruning)
-- ─────────────────────────────────────────────────────────────

SELECT 'DEMO 9A – SELECT * (fetches all columns, no index coverage)' AS demo;
EXPLAIN SELECT * FROM orders WHERE customer_id = 7;

SELECT 'DEMO 9B – Explicit columns matching index prefix' AS demo;
EXPLAIN
SELECT order_id, customer_id, status
FROM   orders
WHERE  customer_id = 7;

-- Lesson: Selecting only indexed columns allows the engine to use
-- a covering index, which avoids reading the full row from disk.

-- ─────────────────────────────────────────────────────────────
-- SECTION 10: Trade-off Summary
-- ─────────────────────────────────────────────────────────────
SELECT
    'Index trade-offs'          AS topic,
    'Faster reads'              AS benefit,
    'Slower INSERT/UPDATE/DELETE + extra storage' AS cost
UNION ALL
SELECT 'Composite index column order', 'Leftmost prefix can be used alone',
       'Right-side columns only usable when left-side filtered'
UNION ALL
SELECT 'Covering index', 'Avoids heap access entirely',
       'Index must include all queried columns'
UNION ALL
SELECT 'Low-cardinality index (e.g. status)', 'Small range scans',
       'MySQL may ignore it for large DELIVERED result sets'
UNION ALL
SELECT 'Over-indexing', 'Faster SELECT', 'Write amplification; more lock contention';

-- ─────────────────────────────────────────────────────────────
-- SECTION 11: Slow Query Patterns to Avoid
-- ─────────────────────────────────────────────────────────────

-- Pattern to AVOID: Function on indexed column in WHERE clause
-- This disables index usage on order_date
SELECT 'BAD PATTERN – function on indexed column disables index' AS warning;
EXPLAIN
SELECT order_id FROM orders
WHERE  YEAR(order_date) = 2024 AND MONTH(order_date) = 6;

-- BETTER: Use a range predicate instead
SELECT 'GOOD PATTERN – range predicate preserves index' AS recommendation;
EXPLAIN
SELECT order_id FROM orders
WHERE  order_date >= '2024-06-01' AND order_date < '2024-07-01';

-- ─────────────────────────────────────────────────────────────
-- SECTION 12: Index Usage Stats (if Performance Schema enabled)
-- ─────────────────────────────────────────────────────────────
SELECT 'Checking if performance_schema is enabled ...' AS info;
SELECT @@performance_schema AS performance_schema_enabled;

-- If performance_schema = 1, uncomment to view index hit counts:
/*
SELECT
    object_schema,
    object_name         AS table_name,
    index_name,
    count_star          AS total_accesses,
    count_read          AS reads
FROM performance_schema.table_io_waits_summary_by_index_usage
WHERE object_schema = 'ecommerce_analytics'
  AND index_name    IS NOT NULL
ORDER BY count_star DESC
LIMIT 20;
*/
