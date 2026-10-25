# Business Rules – E-Commerce Sales & Inventory Management System

This document defines every business rule enforced by the database. Each rule lists where it is enforced and what happens when it is violated.

---

## 1. Customer Rules

| Rule | Enforcement | Violation Behaviour |
|------|-------------|---------------------|
| Email addresses must be unique | UNIQUE constraint on `customers.email` | INSERT/UPDATE fails with error 1062 |
| A customer must have first name, last name, address, city, state, and postal code | NOT NULL constraints | INSERT fails |
| Deactivated customers (`is_active = 0`) cannot place new orders | Checked in `sp_place_order` | Procedure raises error 45010 |

---

## 2. Product Rules

| Rule | Enforcement | Violation Behaviour |
|------|-------------|---------------------|
| Each product must belong to a valid category | FK `products.category_id → categories` | INSERT fails with FK error 1452 |
| SKU must be unique across all products | UNIQUE constraint on `products.sku` | INSERT fails with error 1062 |
| `cost_price` and `sale_price` cannot be negative | CHECK constraints | INSERT/UPDATE fails with error 3819 |
| Inactive products (`is_active = 0`) cannot be ordered | Checked in `sp_place_order` | Procedure raises error 45013 |
| Historical selling price is preserved | `order_items.unit_price` stored at order time | `products.sale_price` updates do not retroactively change past orders |
| Price changes are audit-logged | Trigger `trg_product_price_audit` | Movement record inserted with old/new price |

---

## 3. Inventory Rules

| Rule | Enforcement | Violation Behaviour |
|------|-------------|---------------------|
| `quantity_on_hand` cannot be negative | Trigger `trg_inventory_before_update` | UPDATE blocked with error 45110 |
| `quantity_reserved` cannot be negative | Trigger `trg_inventory_before_update` | UPDATE blocked with error 45111 |
| Every product must have exactly one inventory row | UNIQUE FK on `inventory.product_id` | Duplicate INSERT fails |
| Manual stock adjustments cannot result in negative stock | Checked in `sp_adjust_inventory` | Procedure raises error 45022 |
| Every stock change must be recorded in `inventory_movements` | Enforced by procedures and triggers | All inventory mutations go through authorised paths |
| Available quantity = on_hand − reserved | Calculated in `vw_product_inventory_status` | No direct column; derived at query time |

---

## 4. Order Rules

| Rule | Enforcement | Violation Behaviour |
|------|-------------|---------------------|
| An order must belong to an active customer | FK + check in `sp_place_order` | Error raised |
| Each order must have at least one order item | Application-level responsibility; tested in `10_test_cases.sql` | T27 fails if violated |
| A product cannot appear twice in the same order | UNIQUE constraint on `(order_id, product_id)` | INSERT fails with error 1062 |
| Order item quantities must be positive | CHECK constraint + trigger `trg_oi_before_insert` | INSERT blocked |
| `line_total` is always auto-calculated | Trigger `trg_oi_before_insert` recalculates before INSERT | Caller-supplied value is overwritten |
| `discount_pct` must be between 0 and 100 | CHECK constraint | INSERT/UPDATE fails |
| `total_amount`, `discount_amount`, `tax_amount` must be ≥ 0 | CHECK constraints | INSERT/UPDATE fails |
| Sufficient stock must exist before an order is confirmed | Checked in `sp_place_order` with `SELECT FOR UPDATE` | Error 45014 raised; transaction rolled back |
| Orders lock inventory rows in ascending `product_id` order | `sp_place_order` sorts by `product_id` before locking | Reduces circular deadlock probability |

---

## 5. Inventory Movement Rules

| Rule | Enforcement | Violation Behaviour |
|------|-------------|---------------------|
| When an order is PENDING, stock is **reserved** (not deducted) | `sp_place_order` updates `quantity_reserved` | Prevents overselling during checkout |
| When an order transitions to CONFIRMED, reservation converts to a SALE deduction | Trigger `trg_order_after_status_update` | `quantity_on_hand` decremented; `quantity_reserved` decremented |
| When an order is CANCELLED, reservation is released | Trigger `trg_order_after_status_update` | `quantity_reserved` decremented; UNRESERVED movement inserted |
| All inventory changes are recorded in `inventory_movements` | Procedures and triggers | Full audit trail maintained |

---

## 6. Payment Rules

| Rule | Enforcement | Violation Behaviour |
|------|-------------|---------------------|
| Payment amount must be positive | CHECK constraint | INSERT fails |
| A FAILED payment does not mean the order was paid | Order status and payment status are independent | Reporting queries check payment status separately |
| Refunds are recorded as REFUNDED payment status | Procedure/application sets status | Separate from order cancellation |
| CANCELLED orders must not have COMPLETED payments | Tested in T37 of `10_test_cases.sql` | Test fails if data violates this rule |

---

## 7. Shipment Rules

| Rule | Enforcement | Violation Behaviour |
|------|-------------|---------------------|
| Shipments can only be created for non-CANCELLED, non-PENDING orders | Data convention enforced in `04_seed_data.sql` and application | T30 test validates this |
| `delivered_date` is NULL until the shipment is actually delivered | NULL default; set by application on delivery confirmation | Analytics exclude NULL delivered_date for performance metrics |

---

## 8. Return Rules

| Rule | Enforcement | Violation Behaviour |
|------|-------------|---------------------|
| Returns are only allowed for DELIVERED or RETURNED orders | Checked in `sp_process_return` | Error 45031 raised |
| Return quantity cannot exceed the purchased quantity | Checked in `sp_process_return` | Error 45034 raised |
| Only one return request is allowed per order line item | UNIQUE constraint on `returns.order_item_id` | Duplicate INSERT fails with error 1062 |
| A rejected return does not restore stock | Stock only restored for non-REJECTED returns | Procedure enforces this logic |
| Returns update the parent order status to RETURNED | `sp_process_return` updates `orders.status` | Order status reflects return activity |

---

## 9. Revenue and Reporting Definitions

These definitions are used consistently across all analytics queries in `09_analytics_queries.sql`.

| Term | Definition |
|------|------------|
| **Revenue** | `SUM(order_items.line_total)` for all orders where `status NOT IN ('CANCELLED')` |
| **Net Revenue** | Revenue minus `orders.discount_amount` |
| **COGS** | `SUM(order_items.quantity × products.cost_price)` |
| **Gross Profit** | Revenue − COGS |
| **Gross Margin %** | `(Revenue − COGS) / Revenue × 100` |
| **Average Order Value** | `SUM(line_total) / COUNT(DISTINCT order_id)` for non-cancelled orders |
| **Active Order** | Status IN ('CONFIRMED', 'SHIPPED', 'DELIVERED') |
| **Cancelled Order** | Status = 'CANCELLED' — excluded from revenue |
| **Returned Order** | Status = 'RETURNED' — included in revenue; refund tracked separately in payments |
| **Units Sold** | `SUM(order_items.quantity)` for non-cancelled orders |
| **Customer Lifetime Value** | `SUM(order_items.line_total)` for all non-cancelled orders per customer |

---

## 10. State Machine Diagrams

### Order Status Transitions
```
PENDING ──────► CONFIRMED ──► SHIPPED ──► DELIVERED
   │                │                          │
   ▼                ▼                          ▼
CANCELLED       CANCELLED                  RETURNED
```

### Payment Status Transitions
```
PENDING ──► COMPLETED
   │
   ▼
FAILED

COMPLETED ──► REFUNDED
```

### Shipment Status Transitions
```
PENDING ──► DISPATCHED ──► IN_TRANSIT ──► DELIVERED
                                              │
                                              ▼
                                           RETURNED
```

### Return Status Transitions
```
REQUESTED ──► APPROVED ──► RECEIVED ──► REFUNDED
     │
     ▼
  REJECTED
```

---

## 11. Concurrency and Locking

- Orders are placed inside an explicit `START TRANSACTION … COMMIT` block.
- Inventory rows are locked with `SELECT … FOR UPDATE` before quantity checks.
- Products are processed in ascending `product_id` order within a transaction to avoid circular deadlocks between concurrent sessions ordering the same products.
- If a deadlock occurs (MySQL error 1213), the application should retry the transaction up to 3 times with an exponential back-off.

---

## 12. Known Limitations

1. **Single warehouse** — inventory is not split by location. Multi-warehouse requires schema extension.
2. **No product variants** — size/colour variants are not modelled. Extend with a `product_variants` table.
3. **One return per order item** — partial returns of the same item in multiple batches are not supported.
4. **No coupon/voucher system** — discounts are applied as a flat percentage at the line-item level.
5. **Tax model** — a flat 9% GST estimate is used. A real system needs GST type (CGST/SGST/IGST) based on shipping state.
