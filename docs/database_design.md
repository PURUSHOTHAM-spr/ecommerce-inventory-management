# Database Design – E-Commerce Sales & Inventory Management System

## Overview

The `ecommerce_analytics` database is designed for a single-warehouse Indian e-commerce platform. It handles the complete order lifecycle: product cataloguing, supplier management, inventory tracking, order placement, payment processing, shipping, and returns.

The schema is normalised to approximately **Third Normal Form (3NF)**. All non-key attributes depend only on the primary key, not on other non-key attributes.

---

## Design Decisions

### Why InnoDB?
All tables use the InnoDB storage engine because it provides:
- **ACID transactions** — critical for order placement and inventory deduction
- **Row-level locking** — supports concurrent orders without table-wide locks
- **Foreign key enforcement** — referential integrity at the database level
- **MVCC (Multi-Version Concurrency Control)** — readers do not block writers

### Why DECIMAL for money?
`DECIMAL(12,2)` and `DECIMAL(14,2)` are used for all monetary columns. The `FLOAT` and `DOUBLE` types use binary floating-point arithmetic and cannot represent decimal fractions like 0.10 exactly, which leads to rounding errors in financial calculations.

### Historical Price Preservation
`order_items.unit_price` captures the selling price at the moment of purchase. This means future changes to `products.sale_price` do not alter historical revenue figures — a critical requirement for accurate reporting.

### Inventory Reservation Pattern
When an order is placed (`PENDING`), the quantity is **reserved** (`quantity_reserved` incremented) but not yet deducted from `quantity_on_hand`. When the order is **CONFIRMED**, the reservation is converted to an actual sale deduction. If the order is **CANCELLED**, the reservation is released. This prevents overselling while keeping available stock visible.

---

## Tables and Relationships

### 1. `customers`
Stores customer master data including contact details and location.

| Column | Type | Notes |
|--------|------|-------|
| customer_id | INT UNSIGNED PK | Auto-increment |
| email | VARCHAR(120) | UNIQUE — prevents duplicate accounts |
| city, state, country | VARCHAR | Used for geographic analytics |
| is_active | TINYINT(1) | Soft delete flag |

**Relationships:** One customer → many orders.

---

### 2. `categories`
Hierarchical product taxonomy supporting up to two levels via a self-referencing FK.

| Column | Type | Notes |
|--------|------|-------|
| category_id | INT UNSIGNED PK | |
| parent_category_id | INT UNSIGNED FK | Self-reference; NULL = top-level |

**Relationships:** One category → many products. One parent category → many child categories.

---

### 3. `products`
Master product catalogue. Contains current pricing only; historical prices live in `order_items`.

| Column | Type | Notes |
|--------|------|-------|
| product_id | INT UNSIGNED PK | |
| sku | VARCHAR(60) UNIQUE | Stock-Keeping Unit |
| cost_price | DECIMAL(12,2) | Supplier cost — used for margin calculations |
| sale_price | DECIMAL(12,2) | Current listed price |

**CHECK constraints:** `cost_price >= 0`, `sale_price >= 0`  
**Relationships:** One category → many products. One product → one inventory row. One product → many order_items.

---

### 4. `suppliers`
Companies supplying products. Decoupled from products via `product_suppliers`.

**Relationships:** One supplier → many product_supplier links.

---

### 5. `product_suppliers` (Junction Table)
Resolves the **many-to-many** relationship between products and suppliers.

| Column | Type | Notes |
|--------|------|-------|
| product_id + supplier_id | UNIQUE | Each pair appears once |
| is_primary_supplier | TINYINT(1) | Marks the default supplier |
| lead_time_days | SMALLINT | Replenishment lead time |
| unit_cost | DECIMAL(12,2) | Supplier-specific cost |

---

### 6. `inventory`
Current stock levels — **one row per product** (single-warehouse model).

| Column | Type | Notes |
|--------|------|-------|
| product_id | UNIQUE FK | One inventory record per product |
| quantity_on_hand | INT | Total physical units in stock |
| quantity_reserved | INT | Units earmarked for pending orders |
| reorder_level | INT | Trigger threshold for restocking alerts |

**Available quantity** = `quantity_on_hand − quantity_reserved`

---

### 7. `inventory_movements`
Immutable audit log of every stock change. Never delete from this table.

| Movement Type | Description |
|---------------|-------------|
| SALE | Stock deducted when order confirmed |
| RETURN | Stock restored from a product return |
| RESTOCK | New stock added from supplier |
| ADJUSTMENT | Manual correction by warehouse staff |
| RESERVED | Stock earmarked for a pending order |
| UNRESERVED | Reservation released (order cancelled) |

---

### 8. `orders`
Order header — one row per customer order.

| Status | Meaning |
|--------|---------|
| PENDING | Order placed; awaiting payment confirmation |
| CONFIRMED | Payment confirmed; preparing to ship |
| SHIPPED | Handed to carrier |
| DELIVERED | Delivered at destination |
| CANCELLED | Cancelled before shipping |
| RETURNED | Items returned after delivery |

---

### 9. `order_items`
Line items within an order. Stores `unit_price` at time of purchase.

**UNIQUE constraint:** `(order_id, product_id)` — prevents the same product appearing twice in one order.

**line_total formula:** `quantity × unit_price × (1 − discount_pct / 100)`

---

### 10. `payments`
Payment records linked to orders. Multiple payment attempts per order are supported (e.g., first attempt FAILED, second COMPLETED).

| Status | Meaning |
|--------|---------|
| PENDING | Gateway initiated |
| COMPLETED | Successfully settled |
| FAILED | Declined or gateway error |
| REFUNDED | Money returned to customer |

> **Important:** A FAILED payment does NOT mean the order was paid. Order status and payment status are independent.

---

### 11. `shipments`
Shipping and delivery tracking per order.

| Column | Notes |
|--------|-------|
| shipped_date | Date item left the warehouse |
| estimated_date | Carrier-promised delivery date |
| delivered_date | Actual delivery date (NULL until delivered) |

**Delivery performance** = `DATEDIFF(delivered_date, shipped_date)`

---

### 12. `returns`
Customer return requests. The UNIQUE constraint on `order_item_id` prevents duplicate return requests for the same line item.

| Status | Meaning |
|--------|---------|
| REQUESTED | Customer submitted a return |
| APPROVED | Support approved |
| REJECTED | Support rejected |
| RECEIVED | Items back in warehouse |
| REFUNDED | Refund issued |

---

## Normalisation

| Form | Status | Notes |
|------|--------|-------|
| 1NF | ✅ | All columns are atomic; no repeating groups |
| 2NF | ✅ | No partial dependencies (all non-PKs depend on full PK) |
| 3NF | ✅ | No transitive dependencies between non-key attributes |
| BCNF | Approximate | `product_suppliers` has a composite key; BCNF holds |

**Intentional denormalisation:**
- `orders.total_amount` — pre-computed sum stored for query performance. Kept consistent by the trigger `trg_oi_before_insert`.
- `orders.shipping_*` columns — shipping address is copied at order time to preserve the address even if the customer later updates their profile.

---

## Entity Relationship Summary

```
customers ──< orders ──< order_items >── products >── categories
                  |              |
                  |         inventory_movements
                  |
           payments  shipments  returns
                              (order_items)

suppliers ──< product_suppliers >── products
                                        |
                                    inventory
                                        |
                               inventory_movements
```

---

## Constraints Summary

| Table | Constraint Type | Column(s) |
|-------|----------------|-----------|
| customers | UNIQUE | email |
| products | UNIQUE | sku |
| products | CHECK | cost_price >= 0, sale_price >= 0 |
| suppliers | UNIQUE | email |
| product_suppliers | UNIQUE | (product_id, supplier_id) |
| inventory | UNIQUE | product_id |
| inventory | CHECK | qty_on_hand >= 0, qty_reserved >= 0 |
| order_items | UNIQUE | (order_id, product_id) |
| order_items | CHECK | quantity > 0, unit_price >= 0, discount_pct 0–100 |
| payments | CHECK | amount > 0 |
| returns | UNIQUE | order_item_id |
| returns | CHECK | quantity > 0 |

---

## Indexes Created (03_indexes.sql)

| Index Name | Table | Columns | Purpose |
|------------|-------|---------|---------|
| idx_customers_city | customers | city | City-level sales reports |
| idx_customers_name | customers | last_name, first_name | Name lookup |
| idx_products_category | products | category_id | Category filtering |
| idx_products_category_active | products | category_id, is_active | Active product filtering |
| idx_orders_customer | orders | customer_id | Order history lookup |
| idx_orders_customer_status | orders | customer_id, status | Order history with status filter |
| idx_orders_order_date | orders | order_date | Date-range reports |
| idx_orders_status_date | orders | status, order_date | Dashboard queries |
| idx_oi_product | order_items | product_id | Product revenue reports |
| idx_oi_product_order | order_items | product_id, order_id | Bidirectional join support |
| idx_payments_status_date | payments | status, payment_date | Payment reporting |
| idx_im_product_type | inventory_movements | product_id, movement_type | Movement audit queries |
| idx_im_created_at | inventory_movements | created_at | Time-series movement scans |

---

## Scalability Notes

This schema supports a single warehouse. To extend to **multi-warehouse**:
1. Add a `warehouses` table.
2. Change `inventory` to `(product_id, warehouse_id)` as composite PK.
3. Update procedures and triggers accordingly.

To support **product variants** (size, colour):
1. Add a `product_variants` table with a FK to `products`.
2. Move `sku`, `cost_price`, and `sale_price` to the variant level.
