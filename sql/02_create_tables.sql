-- =============================================================
-- E-Commerce Sales & Inventory Management System
-- Script: 02_create_tables.sql
-- Purpose: Create all 12 tables with constraints and relationships
-- Run AFTER: 01_create_database.sql
-- MySQL Version: 8.0+
-- =============================================================

USE ecommerce_analytics;

-- -------------------------------------------------------------
-- TABLE 1: customers
-- Stores customer profile and contact information.
-- One customer can place many orders (one-to-many with orders).
-- -------------------------------------------------------------
CREATE TABLE customers (
    customer_id    INT            UNSIGNED NOT NULL AUTO_INCREMENT,
    first_name     VARCHAR(60)    NOT NULL,
    last_name      VARCHAR(60)    NOT NULL,
    email          VARCHAR(120)   NOT NULL,
    phone          VARCHAR(20)    NULL,
    address_line1  VARCHAR(150)   NOT NULL,
    address_line2  VARCHAR(150)   NULL,
    city           VARCHAR(80)    NOT NULL,
    state          VARCHAR(80)    NOT NULL,
    postal_code    VARCHAR(20)    NOT NULL,
    country        VARCHAR(60)    NOT NULL DEFAULT 'India',
    created_at     DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active      TINYINT(1)     NOT NULL DEFAULT 1,
    CONSTRAINT pk_customers PRIMARY KEY (customer_id),
    CONSTRAINT uq_customers_email UNIQUE (email)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Customer master data';

-- -------------------------------------------------------------
-- TABLE 2: categories
-- Product taxonomy (Electronics, Clothing, etc.).
-- One category can contain many products.
-- Supports two-level hierarchy via parent_category_id.
-- -------------------------------------------------------------
CREATE TABLE categories (
    category_id        INT          UNSIGNED NOT NULL AUTO_INCREMENT,
    category_name      VARCHAR(100) NOT NULL,
    parent_category_id INT          UNSIGNED NULL,
    description        TEXT         NULL,
    created_at         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_categories PRIMARY KEY (category_id),
    CONSTRAINT uq_categories_name UNIQUE (category_name),
    CONSTRAINT fk_categories_parent
        FOREIGN KEY (parent_category_id)
        REFERENCES categories (category_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Product category hierarchy';

-- -------------------------------------------------------------
-- TABLE 3: products
-- Master product catalog with pricing.
-- cost_price is used for gross profit estimation.
-- sale_price is the current listed price; historical prices
--   are preserved via order_items.unit_price.
-- -------------------------------------------------------------
CREATE TABLE products (
    product_id    INT            UNSIGNED NOT NULL AUTO_INCREMENT,
    category_id   INT            UNSIGNED NOT NULL,
    product_name  VARCHAR(200)   NOT NULL,
    sku           VARCHAR(60)    NOT NULL,
    description   TEXT           NULL,
    cost_price    DECIMAL(12,2)  NOT NULL COMMENT 'Supplier cost (purchase price)',
    sale_price    DECIMAL(12,2)  NOT NULL COMMENT 'Current listed selling price',
    is_active     TINYINT(1)     NOT NULL DEFAULT 1,
    created_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_products PRIMARY KEY (product_id),
    CONSTRAINT uq_products_sku UNIQUE (sku),
    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
        REFERENCES categories (category_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_products_cost_price  CHECK (cost_price  >= 0),
    CONSTRAINT chk_products_sale_price  CHECK (sale_price  >= 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Product master catalog';

-- -------------------------------------------------------------
-- TABLE 4: suppliers
-- Companies that supply products to the store.
-- -------------------------------------------------------------
CREATE TABLE suppliers (
    supplier_id   INT          UNSIGNED NOT NULL AUTO_INCREMENT,
    supplier_name VARCHAR(150) NOT NULL,
    contact_name  VARCHAR(120) NULL,
    email         VARCHAR(120) NULL,
    phone         VARCHAR(20)  NULL,
    address       VARCHAR(200) NULL,
    city          VARCHAR(80)  NULL,
    country       VARCHAR(60)  NOT NULL DEFAULT 'India',
    is_active     TINYINT(1)   NOT NULL DEFAULT 1,
    created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_suppliers PRIMARY KEY (supplier_id),
    CONSTRAINT uq_suppliers_email UNIQUE (email)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Supplier master data';

-- -------------------------------------------------------------
-- TABLE 5: product_suppliers (junction / bridge table)
-- Many-to-many: a product can have multiple suppliers,
-- a supplier can supply multiple products.
-- is_primary_supplier identifies the default supplier.
-- -------------------------------------------------------------
CREATE TABLE product_suppliers (
    product_supplier_id INT            UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id          INT            UNSIGNED NOT NULL,
    supplier_id         INT            UNSIGNED NOT NULL,
    supplier_sku        VARCHAR(60)    NULL COMMENT 'Supplier-side part number',
    unit_cost           DECIMAL(12,2)  NOT NULL COMMENT 'Cost from this supplier',
    lead_time_days      SMALLINT       UNSIGNED NOT NULL DEFAULT 7,
    is_primary_supplier TINYINT(1)     NOT NULL DEFAULT 0,
    created_at          DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_product_suppliers PRIMARY KEY (product_supplier_id),
    CONSTRAINT uq_product_supplier UNIQUE (product_id, supplier_id),
    CONSTRAINT fk_ps_product
        FOREIGN KEY (product_id)
        REFERENCES products (product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_ps_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers (supplier_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_ps_unit_cost CHECK (unit_cost >= 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Product-to-supplier many-to-many relationship';

-- -------------------------------------------------------------
-- TABLE 6: inventory
-- Current stock levels per product and warehouse location.
-- One row per product (single-warehouse model; extend
-- with a warehouses table if multi-warehouse is needed).
-- -------------------------------------------------------------
CREATE TABLE inventory (
    inventory_id       INT       UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id         INT       UNSIGNED NOT NULL,
    quantity_on_hand   INT       NOT NULL DEFAULT 0 COMMENT 'Current stock',
    quantity_reserved  INT       NOT NULL DEFAULT 0 COMMENT 'Reserved for pending orders',
    reorder_level      INT       NOT NULL DEFAULT 10 COMMENT 'Alert threshold',
    reorder_quantity   INT       NOT NULL DEFAULT 50 COMMENT 'Suggested replenishment qty',
    last_restocked_at  DATETIME  NULL,
    updated_at         DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_inventory PRIMARY KEY (inventory_id),
    CONSTRAINT uq_inventory_product UNIQUE (product_id),
    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id)
        REFERENCES products (product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT chk_inventory_qty_hand     CHECK (quantity_on_hand  >= 0),
    CONSTRAINT chk_inventory_qty_reserved CHECK (quantity_reserved >= 0),
    CONSTRAINT chk_inventory_reorder_lvl  CHECK (reorder_level     >= 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Current inventory levels per product';

-- -------------------------------------------------------------
-- TABLE 7: inventory_movements
-- Audit trail for every stock change.
-- movement_type values:
--   SALE          - stock reduced by a fulfilled order
--   RETURN        - stock restored by a product return
--   RESTOCK       - stock added by a purchase/restock
--   ADJUSTMENT    - manual stock correction
--   RESERVED      - stock earmarked for a pending order
--   UNRESERVED    - reservation released (cancel or reject)
-- -------------------------------------------------------------
CREATE TABLE inventory_movements (
    movement_id    BIGINT       UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id     INT          UNSIGNED NOT NULL,
    movement_type  ENUM('SALE','RETURN','RESTOCK','ADJUSTMENT','RESERVED','UNRESERVED')
                               NOT NULL,
    quantity_change INT         NOT NULL COMMENT 'Positive = in, Negative = out',
    reference_id   INT          UNSIGNED NULL COMMENT 'order_id, return_id, etc.',
    reference_type VARCHAR(40)  NULL COMMENT 'ORDER, RETURN, RESTOCK, MANUAL',
    notes          VARCHAR(255) NULL,
    created_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_inventory_movements PRIMARY KEY (movement_id),
    CONSTRAINT fk_im_product
        FOREIGN KEY (product_id)
        REFERENCES products (product_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Complete audit log of all inventory changes';

-- -------------------------------------------------------------
-- TABLE 8: orders
-- Order header. One order belongs to one customer.
-- status values:
--   PENDING    - placed, awaiting payment confirmation
--   CONFIRMED  - payment confirmed, preparing to ship
--   SHIPPED    - handed to carrier
--   DELIVERED  - confirmed delivered
--   CANCELLED  - cancelled before shipping
--   RETURNED   - items returned after delivery
-- -------------------------------------------------------------
CREATE TABLE orders (
    order_id          INT            UNSIGNED NOT NULL AUTO_INCREMENT,
    customer_id       INT            UNSIGNED NOT NULL,
    order_date        DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status            ENUM('PENDING','CONFIRMED','SHIPPED','DELIVERED','CANCELLED','RETURNED')
                                     NOT NULL DEFAULT 'PENDING',
    shipping_address  VARCHAR(300)   NOT NULL,
    shipping_city     VARCHAR(80)    NOT NULL,
    shipping_state    VARCHAR(80)    NOT NULL,
    shipping_postal   VARCHAR(20)    NOT NULL,
    shipping_country  VARCHAR(60)    NOT NULL DEFAULT 'India',
    total_amount      DECIMAL(14,2)  NOT NULL DEFAULT 0.00
                       COMMENT 'Sum of order_items line totals',
    discount_amount   DECIMAL(12,2)  NOT NULL DEFAULT 0.00,
    tax_amount        DECIMAL(12,2)  NOT NULL DEFAULT 0.00,
    notes             VARCHAR(500)   NULL,
    created_at        DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_orders PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_orders_total    CHECK (total_amount    >= 0),
    CONSTRAINT chk_orders_discount CHECK (discount_amount >= 0),
    CONSTRAINT chk_orders_tax      CHECK (tax_amount      >= 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Order header (one row per customer order)';

-- -------------------------------------------------------------
-- TABLE 9: order_items
-- Line items within an order. unit_price captures the price
-- at time of purchase so future price changes do not alter
-- historical revenue figures.
-- -------------------------------------------------------------
CREATE TABLE order_items (
    order_item_id  INT           UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id       INT           UNSIGNED NOT NULL,
    product_id     INT           UNSIGNED NOT NULL,
    quantity       INT           NOT NULL,
    unit_price     DECIMAL(12,2) NOT NULL COMMENT 'Price at time of purchase',
    discount_pct   DECIMAL(5,2)  NOT NULL DEFAULT 0.00
                    COMMENT 'Line-level discount percentage (0-100)',
    line_total     DECIMAL(14,2) NOT NULL
                    COMMENT 'quantity * unit_price * (1 - discount_pct/100)',
    CONSTRAINT pk_order_items PRIMARY KEY (order_item_id),
    CONSTRAINT uq_order_product UNIQUE (order_id, product_id),
    CONSTRAINT fk_oi_order
        FOREIGN KEY (order_id)
        REFERENCES orders (order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_oi_product
        FOREIGN KEY (product_id)
        REFERENCES products (product_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_oi_quantity     CHECK (quantity     > 0),
    CONSTRAINT chk_oi_unit_price   CHECK (unit_price   >= 0),
    CONSTRAINT chk_oi_discount_pct CHECK (discount_pct BETWEEN 0 AND 100),
    CONSTRAINT chk_oi_line_total   CHECK (line_total   >= 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Individual line items within an order';

-- -------------------------------------------------------------
-- TABLE 10: payments
-- Payment records linked to an order.
-- An order may have multiple payment attempts.
-- status values:
--   PENDING   - initiated, awaiting gateway confirmation
--   COMPLETED - successfully settled
--   FAILED    - declined or error
--   REFUNDED  - money returned to customer
-- -------------------------------------------------------------
CREATE TABLE payments (
    payment_id      INT            UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id        INT            UNSIGNED NOT NULL,
    payment_date    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount          DECIMAL(14,2)  NOT NULL,
    payment_method  ENUM('CREDIT_CARD','DEBIT_CARD','NET_BANKING',
                         'UPI','WALLET','COD','EMI')
                                   NOT NULL,
    status          ENUM('PENDING','COMPLETED','FAILED','REFUNDED')
                                   NOT NULL DEFAULT 'PENDING',
    transaction_ref VARCHAR(120)   NULL COMMENT 'Gateway transaction reference',
    notes           VARCHAR(255)   NULL,
    created_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_payments PRIMARY KEY (payment_id),
    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id)
        REFERENCES orders (order_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_payments_amount CHECK (amount > 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Payment transactions for orders';

-- -------------------------------------------------------------
-- TABLE 11: shipments
-- Shipping/delivery tracking per order.
-- One order can have multiple shipments (e.g., partial ship).
-- status values:
--   PENDING    - awaiting dispatch
--   DISPATCHED - handed to carrier
--   IN_TRANSIT - en route
--   DELIVERED  - confirmed at destination
--   RETURNED   - carrier returned to sender
-- -------------------------------------------------------------
CREATE TABLE shipments (
    shipment_id      INT          UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id         INT          UNSIGNED NOT NULL,
    shipped_date     DATE         NULL,
    estimated_date   DATE         NULL,
    delivered_date   DATE         NULL,
    carrier          VARCHAR(80)  NULL,
    tracking_number  VARCHAR(100) NULL,
    status           ENUM('PENDING','DISPATCHED','IN_TRANSIT','DELIVERED','RETURNED')
                                  NOT NULL DEFAULT 'PENDING',
    created_at       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_shipments PRIMARY KEY (shipment_id),
    CONSTRAINT fk_shipments_order
        FOREIGN KEY (order_id)
        REFERENCES orders (order_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Shipment and delivery tracking';

-- -------------------------------------------------------------
-- TABLE 12: returns
-- Product return requests after delivery.
-- return_status values:
--   REQUESTED  - customer initiated
--   APPROVED   - approved by support
--   REJECTED   - rejected by support
--   RECEIVED   - items received back in warehouse
--   REFUNDED   - refund issued to customer
-- A unique constraint on (order_item_id) prevents duplicate
-- return requests for the same line item.
-- -------------------------------------------------------------
CREATE TABLE returns (
    return_id      INT            UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id       INT            UNSIGNED NOT NULL,
    order_item_id  INT            UNSIGNED NOT NULL,
    quantity       INT            NOT NULL COMMENT 'Items being returned',
    reason         VARCHAR(300)   NULL,
    return_status  ENUM('REQUESTED','APPROVED','REJECTED','RECEIVED','REFUNDED')
                                  NOT NULL DEFAULT 'REQUESTED',
    refund_amount  DECIMAL(12,2)  NULL,
    requested_at   DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved_at    DATETIME       NULL,
    CONSTRAINT pk_returns PRIMARY KEY (return_id),
    CONSTRAINT uq_returns_order_item UNIQUE (order_item_id)
        COMMENT 'One active return request per order line item',
    CONSTRAINT fk_returns_order
        FOREIGN KEY (order_id)
        REFERENCES orders (order_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_returns_order_item
        FOREIGN KEY (order_item_id)
        REFERENCES order_items (order_item_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_returns_quantity CHECK (quantity > 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Product return requests and refund tracking';

-- Verify all tables were created
SELECT
    table_name,
    engine,
    table_rows,
    table_comment
FROM information_schema.tables
WHERE table_schema = 'ecommerce_analytics'
ORDER BY table_name;
