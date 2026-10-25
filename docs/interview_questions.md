# Interview Questions & Answers
## E-Commerce Sales & Inventory Management System

Prepared for: SQL Developer / Database Developer / Data Analyst interviews  
Project: `ecommerce_analytics` MySQL 8.0+ database

---

## Section 1: Normalisation

**Q1. What is database normalisation and what forms did you apply in this project?**

Normalisation is the process of organising a relational database to reduce data redundancy and improve data integrity. In this project:

- **1NF** — All columns are atomic (no arrays or repeating groups). Each row is uniquely identifiable by its primary key.
- **2NF** — No partial dependencies. In `order_items`, `line_total` depends on the full composite key `(order_id, product_id)` not just `order_id` alone.
- **3NF** — No transitive dependencies. For example, customer address details live in `customers`, not duplicated in `orders`. The shipping address is intentionally copied to `orders` for historical accuracy — this is a documented, justified denormalisation.

---

**Q2. Where did you intentionally denormalise and why?**

Two places:
1. `orders.total_amount` — pre-computed sum of line totals. Avoids a JOIN+SUM on every dashboard query. Kept consistent by the `trg_oi_before_insert` trigger.
2. `orders.shipping_*` columns — the shipping address is copied at order time. If the customer later changes their address, historical orders still show the correct delivery address. This is a business requirement.

---

**Q3. What is the difference between 3NF and BCNF?**

In 3NF, every non-prime attribute must be non-transitively dependent on every candidate key. BCNF is stricter: every determinant must be a candidate key. BCNF eliminates anomalies that 3NF can still allow when a table has multiple overlapping candidate keys. In practice, BCNF decomposition can cause lossy joins, so 3NF is usually the target for production databases.

---

## Section 2: JOINs

**Q4. What is the difference between INNER JOIN and LEFT JOIN? Give an example from this project.**

- `INNER JOIN` returns only rows that have matching records in both tables.
- `LEFT JOIN` returns all rows from the left table and matching rows from the right; non-matching right-side rows become NULL.

Example: In Q4 of `09_analytics_queries.sql`, finding customers who never placed an order:
```sql
SELECT c.customer_id
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;
```
Using INNER JOIN here would return only customers who HAVE orders — the opposite of what we want.

---

**Q5. When would you use a self-join?**

When a table references itself. In this project, the `categories` table has a `parent_category_id` FK pointing back to `categories.category_id`. To display parent and child category names together:
```sql
SELECT child.category_name, parent.category_name AS parent_category
FROM categories child
LEFT JOIN categories parent ON parent.category_id = child.parent_category_id;
```

---

## Section 3: CTEs and Window Functions

**Q6. What is a CTE and when would you use it instead of a subquery?**

A CTE (Common Table Expression), written with `WITH`, creates a named temporary result set for the duration of the query. Use CTEs when:
- The same subquery is referenced more than once.
- You need to chain multiple transformation steps for readability.
- You want to use window functions and then filter on their results (you cannot filter on a window function result in the same SELECT).

Example from Q25 (rolling revenue):
```sql
WITH monthly_rev AS (
    SELECT DATE_FORMAT(order_date,'%Y-%m') AS month,
           SUM(line_total) AS revenue
    FROM orders o JOIN order_items oi ...
    GROUP BY month
)
SELECT month, revenue,
       AVG(revenue) OVER (ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_3m
FROM monthly_rev;
```

---

**Q7. Explain RANK, DENSE_RANK, and ROW_NUMBER and when each is appropriate.**

All three assign a sequential number within a window partition, but they differ in tie handling:

| Function | Tie handling | Gaps after tie |
|----------|-------------|----------------|
| `ROW_NUMBER()` | Arbitrary — each row gets a unique number | No gap |
| `RANK()` | Tied rows share the same rank | Gap after ties |
| `DENSE_RANK()` | Tied rows share the same rank | No gap |

Use `RANK` when you want SQL behaviour consistent with Olympic rankings (two silvers, no bronze). Use `DENSE_RANK` when gaps would confuse users (e.g. "second-highest revenue product" — if two products tie for first, `DENSE_RANK = 2` correctly identifies the next one). Use `ROW_NUMBER` when you simply need pagination or a unique sequential ID per partition.

---

**Q8. What is the LAG function and how did you use it in this project?**

`LAG(column, offset, default)` accesses a value from a previous row in the result set's ordering without a self-join. In Q2 (month-over-month growth):
```sql
LAG(revenue) OVER (ORDER BY sale_month) AS prev_month_revenue
```
This retrieves the previous month's revenue for each row, making growth rate calculation straightforward: `(current - previous) / previous * 100`.

---

**Q9. How does PARTITION BY differ from GROUP BY?**

`GROUP BY` collapses rows into one row per group — the detail is lost.  
`PARTITION BY` (used inside window functions) keeps all rows but computes the aggregate across the defined partition. The detail rows remain visible.

```sql
-- GROUP BY: one row per category
SELECT category_id, SUM(sale_price) FROM products GROUP BY category_id;

-- PARTITION BY: all rows kept, with category total on each row
SELECT product_name, sale_price,
       SUM(sale_price) OVER (PARTITION BY category_id) AS category_total
FROM products;
```

---

## Section 4: Indexes

**Q10. What types of indexes did you create and why?**

- **Single-column indexes** on FK columns (e.g., `idx_orders_customer`) to speed up JOIN lookups.
- **Composite indexes** (e.g., `idx_orders_status_date`) for common filter+sort patterns like `WHERE status = 'DELIVERED' AND order_date >= ...`.
- The primary key automatically creates a clustered index in InnoDB.
- UNIQUE constraints automatically create unique indexes.

---

**Q11. Why does column order matter in a composite index?**

MySQL can use a composite index only for queries that reference the **leftmost prefix** of the index columns. For `idx_orders_status_date (status, order_date)`:
- `WHERE status = 'X'` ✅ uses the index (leftmost prefix)
- `WHERE status = 'X' AND order_date > Y` ✅ uses both columns
- `WHERE order_date > Y` ❌ cannot use this index (skips the leftmost column)

Put the column used in equality conditions first, then range conditions.

---

**Q12. What is a covering index? Give an example.**

A covering index is one that contains all the columns needed to satisfy a query, so the engine never needs to access the actual table rows. This is shown in `11_performance_testing.sql` DEMO 4:

```sql
-- idx_orders_customer_status covers (customer_id, status)
SELECT customer_id, status, COUNT(*) FROM orders
WHERE customer_id = 4 GROUP BY customer_id, status;
-- Extra: "Using index" in EXPLAIN = no heap access
```

---

**Q13. What are the trade-offs of having too many indexes?**

- Slower `INSERT`, `UPDATE`, and `DELETE` — every index must be updated on write.
- More disk space consumed.
- MySQL's query optimiser has more choices to evaluate, potentially choosing a suboptimal plan.
- Rule: only index columns that are actually used in WHERE, JOIN ON, ORDER BY, or GROUP BY clauses in frequent queries.

---

## Section 5: ACID and Transactions

**Q14. What does ACID stand for and how does this project implement it?**

| Property | Meaning | Implementation |
|----------|---------|----------------|
| **Atomicity** | All operations in a transaction succeed or none do | `sp_place_order` uses `START TRANSACTION … COMMIT` with a `ROLLBACK` on error |
| **Consistency** | Database moves from one valid state to another | CHECK constraints, FK constraints, triggers enforce rules at all times |
| **Isolation** | Concurrent transactions do not interfere | InnoDB row-level locking; `SELECT FOR UPDATE` prevents dirty reads in order placement |
| **Durability** | Committed data survives crashes | InnoDB writes to the redo log before confirming a commit |

---

**Q15. Explain what SELECT FOR UPDATE does and why it is used in sp_place_order.**

`SELECT … FOR UPDATE` acquires an exclusive row-level lock on the selected rows for the duration of the transaction. In `sp_place_order`:
1. We lock the inventory rows for the products in the order.
2. We check whether sufficient stock exists.
3. We update the inventory.
4. We commit.

Without `FOR UPDATE`, two concurrent sessions could both read `quantity_on_hand = 5`, both decide there is enough stock for a quantity of 5, and both proceed — resulting in -5 on-hand stock (overselling). The lock prevents the second session from reading until the first has committed.

---

**Q16. What is a deadlock and how does this project reduce the risk?**

A deadlock occurs when two transactions each hold a lock the other needs, and both wait forever. Example: Session A locks product 1 then wants product 5; Session B locks product 5 then wants product 1.

This project reduces deadlock risk by always locking inventory rows in **ascending `product_id` order**. If all sessions acquire locks in the same order, circular wait chains cannot form. MySQL also automatically detects deadlocks and rolls back the younger transaction (error 1213). The recommended application-level response is to retry the transaction.

---

## Section 6: Stored Procedures and Triggers

**Q17. What is the difference between a stored procedure and a function in MySQL?**

| Aspect | Stored Procedure | Function |
|--------|-----------------|----------|
| Return value | Zero or more result sets; OUT params | Returns exactly one scalar value |
| Called with | `CALL proc_name()` | Used in expressions: `SELECT fn()` |
| Transactions | Can contain `START TRANSACTION` | Cannot contain transaction control statements |
| Side effects | Can modify data | Must be `DETERMINISTIC` or declared otherwise |
| Use case | Business workflows | Reusable calculations |

In this project, `sp_place_order` is a procedure (multi-step workflow), while `fn_line_total` is a function (pure calculation used in SELECT).

---

**Q18. Explain the triggers created in this project and how they avoid double-counting.**

Five triggers were created:

1. `trg_oi_before_insert` — recalculates `line_total` before any INSERT on `order_items`. Ensures the stored value always matches the formula.
2. `trg_order_after_status_update` — when an order changes from PENDING→CONFIRMED, deducts stock; when CANCELLED, releases the reservation.
3. `trg_inventory_before_update` — prevents negative `quantity_on_hand` or `quantity_reserved`.
4. `trg_return_after_insert` — audits return creation in `inventory_movements`, but only if `sp_process_return` has not already inserted the movement (checked via `NOT EXISTS`).
5. `trg_product_price_audit` — records price changes in `inventory_movements` with `quantity_change = 0` for traceability.

Double-counting is prevented by: (a) the trigger checking `NOT EXISTS` before inserting a movement, and (b) the procedure and trigger having clearly separated responsibilities (procedure handles stock restoration; trigger handles audit only).

---

## Section 7: Query Optimisation

**Q19. How do you use EXPLAIN to diagnose a slow query?**

```sql
EXPLAIN SELECT ... FROM orders WHERE status = 'DELIVERED';
```

Key columns to check:
- `type`: `ALL` means full table scan (bad); `ref` or `range` means index is used (good).
- `key`: which index was chosen. `NULL` means no index used.
- `rows`: estimated rows examined. Lower is better.
- `Extra`: `Using filesort` or `Using temporary` indicate expensive operations.

`EXPLAIN ANALYZE` (MySQL 8.0.18+) runs the query and shows actual vs estimated rows plus execution time in milliseconds.

---

**Q20. Why should you avoid using functions on indexed columns in WHERE clauses?**

Wrapping an indexed column in a function prevents the optimiser from using the index:
```sql
-- BAD: YEAR() prevents index usage on order_date
WHERE YEAR(order_date) = 2024

-- GOOD: range predicate allows index range scan
WHERE order_date >= '2024-01-01' AND order_date < '2025-01-01'
```
The function result is not stored in the index, so MySQL must evaluate the function for every row (full scan).

---

## Section 8: Project-Specific Design Decisions

**Q21. Why is unit_price stored in order_items rather than looked up from products.sale_price?**

If we only stored the `product_id` and looked up the price at query time, any price change in `products.sale_price` would retroactively alter all historical revenue figures. By capturing `unit_price` at the moment of purchase, historical revenue reports remain accurate regardless of future price changes.

---

**Q22. How does the inventory reservation system work?**

When `sp_place_order` runs:
1. It locks inventory rows with `SELECT FOR UPDATE`.
2. It checks `quantity_on_hand − quantity_reserved >= requested_quantity`.
3. It increments `quantity_reserved` (not decrement `quantity_on_hand` yet).
4. It records a `RESERVED` movement.

When the order is confirmed:
- The trigger decrements both `quantity_on_hand` and `quantity_reserved`.
- It records a `SALE` movement.

When the order is cancelled:
- The trigger decrements `quantity_reserved` only.
- It records an `UNRESERVED` movement.

This ensures `quantity_on_hand − quantity_reserved` always reflects the truly available stock.

---

**Q23. How would you handle a situation where a product goes out of stock while an order is being processed?**

The `sp_place_order` procedure uses `SELECT FOR UPDATE` to lock the inventory row before checking stock. If another session has already locked the row and reduces stock below the required amount, the second session will wait until the first commits, then re-check the stock. Since the check happens after the lock is acquired, it always sees the latest committed quantity. If stock is insufficient, error 45014 is raised and the transaction rolls back cleanly.

---

**Q24. What is the purpose of the inventory_movements table?**

It is an immutable audit log of every stock change. Each row records: what product changed, what type of movement it was, by how much, and which order/return caused it. This table serves multiple purposes:
- **Compliance** — full traceability of all stock changes.
- **Reconciliation** — SUM of all movements should equal current `quantity_on_hand`.
- **Reporting** — stock movement trends, return rates, restock frequency.
- **Debugging** — if stock appears wrong, the movement history explains every change.

---

**Q25. How would you scale this schema to handle millions of orders?**

Several strategies:
1. **Partitioning `orders` by range on `order_date`** — keeps working set small for recent data queries.
2. **Partitioning `inventory_movements` by range on `created_at`** — this table grows unboundedly.
3. **Read replicas** — route analytics queries to read replicas; write transactions stay on primary.
4. **Archiving** — move orders older than N years to an `orders_archive` table.
5. **Connection pooling** — use PgBouncer-equivalent (ProxySQL) to manage MySQL connections efficiently.
6. **Caching** — cache dashboard aggregates (e.g., total revenue today) in Redis with TTL.
7. **Summary tables** — pre-compute daily/monthly revenue aggregates in a separate table, refreshed by a scheduled job.
