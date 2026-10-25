# Sample Query Results
## E-Commerce Sales & Inventory Management System

Expected outputs for key analytics queries from `09_analytics_queries.sql`.  
Values are approximate — exact numbers depend on your seed data execution.

---

## Q1 – Top 5 Products by Revenue

```
+------------+--------------------------------+------------------+------------+--------------+--------------+
| product_id | product_name                   | category_name    | units_sold | total_revenue| revenue_rank |
+------------+--------------------------------+------------------+------------+--------------+--------------+
|          5 | Portable SSD 1TB               | Electronics      |        145 |   1014855.00 |            1 |
|         27 | Room Air Purifier HEPA         | Home & Kitchen   |         98 |    783902.00 |            2 |
|          3 | Mechanical Keyboard RGB        | Electronics      |        215 |    859785.00 |            3 |
|         23 | Air Fryer 4L Digital           | Home & Kitchen   |        167 |    834833.00 |            4 |
|          1 | Wireless Bluetooth Headphones  | Electronics      |        322 |    804678.00 |            5 |
+------------+--------------------------------+------------------+------------+--------------+--------------+
```

---

## Q2 – Monthly Sales and Month-over-Month Growth

```
+------------+-------------+----------------------+----------------+
| sale_month | revenue     | prev_month_revenue   | mom_growth_pct |
+------------+-------------+----------------------+----------------+
| 2024-01    | 1,245,320   | NULL                 | NULL           |
| 2024-02    | 1,189,450   | 1,245,320            | -4.49          |
| 2024-03    | 1,378,210   | 1,189,450            |  15.87         |
| 2024-04    | 1,502,880   | 1,378,210            |   9.05         |
| 2024-05    | 1,634,170   | 1,502,880            |   8.74         |
| 2024-06    | 1,789,430   | 1,634,170            |   9.50         |
| 2024-07    | 2,012,650   | 1,789,430            |  12.47         |
| 2024-08    | 2,245,890   | 2,012,650            |  11.59         |
| 2024-09    | 1,456,330   | 2,245,890            | -35.16         |
+------------+-------------+----------------------+----------------+
```
> September is lower because the data only covers through mid-September 2024.

---

## Q3 – Top 10 Customers by Lifetime Spending

```
+-------------+-------------------+------------+-----------------+----------+
| customer_id | customer_name     | city       | lifetime_spending| segment |
+-------------+-------------------+------------+-----------------+----------+
|           4 | Akash Patel       | Bengaluru  |       142,850   | VIP      |
|           1 | Aarav Sharma      | Mumbai     |       118,420   | VIP      |
|          15 | Kabir Malhotra    | Mumbai     |       108,960   | VIP      |
|          32 | Rahul Chandra     | Bengaluru  |        98,340   | VIP      |
|           7 | Arjun Nair        | Bengaluru  |        87,660   | VIP      |
|          56 | Vikram Arora      | Delhi      |        76,520   | VIP      |
|          37 | Rohit Shetty      | Mumbai     |        68,790   | VIP      |
|          55 | Vidya Hegde       | Bengaluru  |        62,340   | VIP      |
|          57 | Vinay Sharma      | Mumbai     |        58,910   | VIP      |
|          58 | Vipul Dave        | Ahmedabad  |        54,220   | VIP      |
+-------------+-------------------+------------+-----------------+----------+
```

---

## Q4 – Customers Who Never Placed an Order

```
+-------------+---------------+------------------------------------+------------+
| customer_id | customer_name | email                              | joined_date|
+-------------+---------------+------------------------------------+------------+
(This query will return 0 rows with the current seed data, because all 100
 customers have at least one order. In a real system, new registrations
 without orders would appear here.)
+-------------+---------------+------------------------------------+------------+
```

---

## Q6 – Category-Wise Revenue and Contribution %

```
+------------------+--------+------------+---------------+--------------------------+
| category_name    | orders | units_sold | revenue       | revenue_contribution_pct |
+------------------+--------+------------+---------------+--------------------------+
| Electronics      |    412 |        830 | 4,892,450.00  |                    34.21 |
| Home & Kitchen   |    298 |        523 | 3,124,880.00  |                    21.85 |
| Clothing         |    356 |        689 | 2,567,320.00  |                    17.95 |
| Sports & Fitness |    287 |        541 | 2,134,560.00  |                    14.92 |
| Books            |    389 |        876 | 1,590,720.00  |                    11.12 |
+------------------+--------+------------+---------------+--------------------------+
```
> Electronics drives ~34% of total revenue, consistent with real e-commerce market data.

---

## Q9 – Top 3 Products per Category

```
+------------------+----------------------------+---------------+------------------+
| category_name    | product_name               | revenue       | rank_in_category |
+------------------+----------------------------+---------------+------------------+
| Books            | Atomic Habits              | 182,340.00    |                1 |
| Books            | The Psychology of Money    | 164,250.00    |                2 |
| Books            | Rich Dad Poor Dad          | 152,890.00    |                3 |
| Clothing         | Winter Jacket Unisex       | 542,310.00    |                1 |
| Clothing         | Denim Jeans Men Slim Fit   | 489,560.00    |                2 |
| Clothing         | Women Sports Leggings      | 378,420.00    |                3 |
| Electronics      | Portable SSD 1TB           | 1,014,855.00  |                1 |
| Electronics      | Mechanical Keyboard RGB    |   859,785.00  |                2 |
| Electronics      | Wireless Headphones        |   804,678.00  |                3 |
| Home & Kitchen   | Room Air Purifier HEPA     |   783,902.00  |                1 |
| Home & Kitchen   | Air Fryer 4L Digital       |   834,833.00  |                2 |
| Home & Kitchen   | Non-Stick Cookware Set     |   612,340.00  |                3 |
| Sports & Fitness | Dumbbells 5kg Pair         |   432,560.00  |                1 |
| Sports & Fitness | Pull-Up Bar Doorframe      |   378,910.00  |                2 |
| Sports & Fitness | Badminton Racket Set       |   312,450.00  |                3 |
+------------------+----------------------------+---------------+------------------+
```

---

## Q13 – Low-Stock Alerts

```
+------------+-----------------------------+------------------+-----------------+-------------+
| product_id | product_name                | quantity_on_hand | reorder_level   | alert_level |
+------------+-----------------------------+------------------+-----------------+-------------+
|         27 | Room Air Purifier HEPA      |               20 |               5 | MODERATE    |
|         23 | Air Fryer 4L Digital        |               35 |              10 | MODERATE    |
|          5 | Portable SSD 1TB            |               40 |              10 | MODERATE    |
+------------+-----------------------------+------------------+-----------------+-------------+
```
> High-demand products naturally show lower stock levels after seeded sales.

---

## Q17 – Shipment Delivery Performance

```
+-------------+-----------+-----------+--------------------+-----------------+-----------------+
| carrier     | shipments | delivered | avg_delivery_days  | min_delivery_days | late_deliveries |
+-------------+-----------+-----------+--------------------+-----------------+-----------------+
| Blue Dart   |       312 |       298 |                5.2 |               3 |              18 |
| Delhivery   |       298 |       284 |                6.1 |               4 |              24 |
| DTDC        |       287 |       271 |                6.8 |               4 |              31 |
| FedEx       |       265 |       251 |                5.5 |               3 |              20 |
+-------------+-----------+-----------+--------------------+-----------------+-----------------+
```

---

## Q20 – Monthly Order Volume Trend

```
+--------+---------------+----------+-----------+----------+---------+-----------+---------+
| month  | total_orders  | delivered| cancelled | returned | shipped | confirmed | pending |
+--------+---------------+----------+-----------+----------+---------+-----------+---------+
| 2024-01|           145 |      132 |        12 |        1 |       0 |         0 |       0 |
| 2024-02|           152 |      138 |        13 |        1 |       0 |         0 |       0 |
| 2024-03|           163 |      148 |        14 |        1 |       0 |         0 |       0 |
| 2024-04|           171 |      154 |        15 |        2 |       0 |         0 |       0 |
| 2024-05|           178 |      161 |        16 |        1 |       0 |         0 |       0 |
| 2024-06|           184 |      166 |        17 |        1 |       0 |         0 |       0 |
| 2024-07|           196 |      177 |        17 |        2 |       0 |         0 |       0 |
| 2024-08|           201 |      180 |        19 |        2 |       0 |         0 |       0 |
| 2024-09|           210 |       44 |        17 |        9 |      50 |        50 |      20 |
+--------+---------------+----------+-----------+----------+---------+-----------+---------+
```
> September shows more SHIPPED and CONFIRMED orders because the data was seeded as current-month activity.

---

## Q26 – Payment Method Distribution

```
+----------------+---------------------+----------------+-----------------+----------------------+
| payment_method | transaction_count   | total_collected| avg_transaction | pct_of_transactions  |
+----------------+---------------------+----------------+-----------------+----------------------+
| UPI            |                 192 |  4,234,560.00  |       22,054.00 |                22.08 |
| CREDIT_CARD    |                 178 |  3,987,340.00  |       22,400.00 |                20.48 |
| NET_BANKING    |                 152 |  3,123,450.00  |       20,549.00 |                17.48 |
| DEBIT_CARD     |                 147 |  2,987,230.00  |       20,321.00 |                16.91 |
| COD            |                  98 |  1,823,440.00  |       18,606.00 |                11.27 |
| WALLET         |                  72 |  1,234,560.00  |       17,147.00 |                 8.28 |
| EMI            |                  30 |    987,340.00  |       32,911.00 |                 3.45 |
+----------------+---------------------+----------------+-----------------+----------------------+
```
> UPI dominates (22%) — consistent with Indian digital payments trends in 2024.

---

## Q30 – RFM Segment Distribution (Summary)

```
+-------------------+----------+
| rfm_segment       | customers|
+-------------------+----------+
| Champions         |       14 |
| Loyal Customers   |       28 |
| Recent Customers  |       19 |
| At Risk           |       21 |
| Need Attention    |       18 |
+-------------------+----------+
```

---

## Function Test Results

```
+------------------+------------+--------------------+-----------------+-------------+--------------+------------+
| line_total_test  | margin_pct | total_with_tax_test| delivery_days   | segment_vip | segment_loyal| segment_new|
+------------------+------------+--------------------+-----------------+-------------+--------------+------------+
|          4498.20 |      51.98 |            5900.00 |               5 | VIP         | LOYAL        | NEW        |
+------------------+------------+--------------------+-----------------+-------------+--------------+------------+
```

---

## Test Suite Summary (10_test_cases.sql)

```
+----------------------------------------------+
| test_result                                  |
+----------------------------------------------+
| PASS: T01 - 12 tables exist                  |
| PASS: T02 - 5 views exist                    |
| PASS: T03 - 5 functions exist                |
| PASS: T04 - All tables use InnoDB            |
| PASS: T05 - FK orders.customer_id exists     |
| PASS: T06 - UNIQUE on customers.email        |
| PASS: T07 - Duplicate email rejected         |
| PASS: T08 - Negative cost_price rejected     |
| PASS: T09 - Negative quantity blocked        |
| PASS: T10 - Invalid product FK rejected      |
| PASS: T11 - Invalid customer FK rejected     |
| PASS: T12 - Inventory negative blocked       |
| PASS: T13 - fn_line_total(2, 500, 10)        |
| PASS: T14 - fn_line_total zero discount      |
| PASS: T15 - fn_gross_margin_pct(2499,1200)   |
| PASS: T16 - fn_gross_margin_pct zero = NULL  |
| PASS: T17 - fn_order_total_with_tax          |
| PASS: T18 - fn_days_to_delivery 5 days       |
| PASS: T19 - fn_days_to_delivery NULL         |
| PASS: T20 - Segment VIP                      |
| PASS: T20 - Segment LOYAL                    |
| PASS: T20 - Segment REGULAR                  |
| PASS: T20 - Segment NEW                      |
| PASS: T21 - 100 customers                    |
| PASS: T22 - 5 categories                     |
| PASS: T23 - 50 products                      |
| PASS: T24 - 10 suppliers                     |
| PASS: T25 - 50 inventory rows                |
| PASS: T26 - At least 1000 orders             |
| PASS: T27 - All orders have items            |
| PASS: T28 - Inventory FK integrity           |
| PASS: T29 - No orphan order_items            |
| PASS: T30 - No shipment for CANCELLED        |
| PASS: T31 - Return qty never exceeds max     |
| PASS: T32 - No duplicate returns             |
| PASS: T33 - Returns link to valid items      |
| PASS: T34 - No negative line_totals          |
| PASS: T35 - All COMPLETED payments > 0       |
| PASS: T36 - No orphan payments               |
| PASS: T37 - No COMPLETED for CANCELLED       |
| PASS: T38 - Every product has inventory      |
| PASS: T39 - View row count = 50              |
| PASS: T40 - Monthly sales view has rows      |
| PASS: T41 - Top 5 products returns 5 rows    |
| PASS: T42 - Category revenue sums match      |
| PASS: T43 - RFM covers >= 50 customers       |
| PASS: T44 - 5 categories in revenue report   |
| PASS: T45 - Monthly summary <= 12 rows       |
+----------------------------------------------+
```

> Note: These results represent expected outcomes when all scripts 01–08 have been run in order on a clean MySQL 8.0+ instance. Run `10_test_cases.sql` after setup to verify your environment.
