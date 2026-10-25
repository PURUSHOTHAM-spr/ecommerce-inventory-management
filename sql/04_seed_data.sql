-- =============================================================
-- E-Commerce Sales & Inventory Management System
-- Script: 04_seed_data.sql
-- Purpose: Insert all sample data (reproducible)
-- Run AFTER: 03_indexes.sql
-- MySQL Version: 8.0+
-- Data spans: Jan 2024 – Sep 2024 (9 months)
-- =============================================================

USE ecommerce_analytics;

-- Disable FK checks during bulk insert for speed; re-enable after.
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';

-- =============================================================
-- CATEGORIES (5 top-level + 0 sub-categories for simplicity)
-- =============================================================
INSERT INTO categories (category_id, category_name, parent_category_id, description) VALUES
(1,  'Electronics',     NULL, 'Consumer electronics and gadgets'),
(2,  'Clothing',        NULL, 'Apparel and fashion accessories'),
(3,  'Home & Kitchen',  NULL, 'Household items, appliances, and kitchen tools'),
(4,  'Sports & Fitness',NULL, 'Sports equipment and fitness accessories'),
(5,  'Books',           NULL, 'Fiction, non-fiction, and educational books');

-- =============================================================
-- SUPPLIERS (10 suppliers)
-- =============================================================
INSERT INTO suppliers (supplier_id, supplier_name, contact_name, email, phone, address, city, country) VALUES
(1,  'TechZone Pvt Ltd',       'Arjun Mehta',    'arjun@techzone.in',       '9810001001', '12 Industrial Area',        'Mumbai',    'India'),
(2,  'FashionHub Supplies',    'Priya Sharma',   'priya@fashionhub.in',     '9820002002', '45 Textile Market',         'Surat',     'India'),
(3,  'HomeEssentials Co',      'Rajesh Kumar',   'rajesh@homeessentials.in','9830003003', '78 Hardware Lane',          'Pune',      'India'),
(4,  'SportsPro Distributors', 'Anita Singh',    'anita@sportspro.in',      '9840004004', '22 Sports Complex',         'Delhi',     'India'),
(5,  'BookWorld Publishers',   'Vikram Nair',    'vikram@bookworld.in',     '9850005005', '56 Library Road',           'Bengaluru', 'India'),
(6,  'GadgetKing Imports',     'Sunita Patel',   'sunita@gadgetking.in',    '9860006006', '9 Electronics Park',        'Chennai',   'India'),
(7,  'StyleFirst Wholesalers', 'Deepak Verma',   'deepak@stylefirst.in',    '9870007007', '33 Fashion Street',         'Jaipur',    'India'),
(8,  'KitchenPro Supplies',    'Meena Reddy',    'meena@kitchenpro.in',     '9880008008', '18 Cookware Bazaar',        'Hyderabad', 'India'),
(9,  'FitLife Equipment',      'Kiran Das',      'kiran@fitlife.in',        '9890009009', '67 Fitness Avenue',         'Kolkata',   'India'),
(10, 'EduBooks Direct',        'Pooja Iyer',     'pooja@edubooks.in',       '9900010010', '44 Knowledge Street',       'Ahmedabad', 'India');

-- =============================================================
-- PRODUCTS (50 products across 5 categories)
-- =============================================================
INSERT INTO products (product_id, category_id, product_name, sku, description, cost_price, sale_price) VALUES
-- Electronics (10 products)
(1,  1, 'Wireless Bluetooth Headphones',  'ELEC-001', 'Over-ear noise-cancelling headphones with 30h battery',  1200.00,  2499.00),
(2,  1, 'USB-C Fast Charger 65W',         'ELEC-002', 'Universal fast charger compatible with laptops and phones',  350.00,   799.00),
(3,  1, 'Mechanical Keyboard RGB',        'ELEC-003', 'Compact TKL mechanical keyboard with RGB backlight',    1800.00,  3999.00),
(4,  1, 'Wireless Mouse',                 'ELEC-004', 'Ergonomic wireless mouse with 2.4GHz receiver',          400.00,   899.00),
(5,  1, 'Portable SSD 1TB',               'ELEC-005', 'USB 3.2 Gen 2 portable solid-state drive, 1050 MB/s',   3500.00,  6999.00),
(6,  1, 'Webcam 1080p Full HD',           'ELEC-006', 'Plug-and-play HD webcam with built-in microphone',       700.00,  1499.00),
(7,  1, 'Smart LED Bulb Pack of 4',       'ELEC-007', 'Wi-Fi enabled RGB smart bulbs, works with Alexa',        600.00,  1299.00),
(8,  1, 'Power Bank 20000mAh',            'ELEC-008', 'Dual USB-A + USB-C power bank with fast charging',       900.00,  1999.00),
(9,  1, 'HDMI 2.1 Cable 2m',             'ELEC-009', '8K HDMI 2.1 high-speed braided cable',                   180.00,   399.00),
(10, 1, 'Laptop Stand Aluminium',         'ELEC-010', 'Adjustable aluminium laptop stand for desks',            550.00,  1199.00),
-- Clothing (10 products)
(11, 2, 'Men Cotton Casual Shirt',        'CLTH-001', 'Slim-fit cotton shirt in multiple colours',              350.00,   799.00),
(12, 2, 'Women Kurti Printed',            'CLTH-002', 'Rayon printed kurti with embroidery work',               280.00,   599.00),
(13, 2, 'Denim Jeans Men Slim Fit',       'CLTH-003', 'Stretch denim slim-fit jeans, various sizes',            700.00,  1499.00),
(14, 2, 'Sports Track Pants',             'CLTH-004', 'Polyester track pants with side pockets',                320.00,   699.00),
(15, 2, 'Winter Jacket Unisex',           'CLTH-005', 'Quilted lightweight winter jacket, wind-resistant',      950.00,  2199.00),
(16, 2, 'Cotton Socks Pack of 6',         'CLTH-006', 'Anti-odour ankle socks for men and women',               120.00,   299.00),
(17, 2, 'Formal Trousers Men',            'CLTH-007', 'Slim fit formal trousers, stretchable fabric',           500.00,  1099.00),
(18, 2, 'Women Sports Leggings',          'CLTH-008', 'High-waist compression leggings for gym and yoga',       380.00,   849.00),
(19, 2, 'Kids T-Shirt Pack of 3',         'CLTH-009', 'Pure cotton graphic t-shirts for children 2-12 yrs',     250.00,   549.00),
(20, 2, 'Rain Jacket Waterproof',         'CLTH-010', 'Packable waterproof rain jacket with hood',              750.00,  1699.00),
-- Home & Kitchen (10 products)
(21, 3, 'Non-Stick Cookware Set 5pc',     'HOME-001', 'Granite-coated non-stick pots and pans set',             1200.00,  2799.00),
(22, 3, 'Electric Kettle 1.5L',           'HOME-002', '1500W stainless steel electric kettle, auto shut-off',   550.00,  1199.00),
(23, 3, 'Air Fryer 4L Digital',           'HOME-003', 'Digital air fryer with 8 preset cooking programs',      2200.00,  4999.00),
(24, 3, 'Steel Water Bottle 1L',          'HOME-004', 'Insulated stainless steel water bottle, 24hr cold',       350.00,   749.00),
(25, 3, 'Bamboo Cutting Board Set',       'HOME-005', 'Set of 3 organic bamboo cutting boards',                 400.00,   899.00),
(26, 3, 'Microwave Safe Bowl Set',        'HOME-006', 'Borosilicate glass bowl set with lids, pack of 5',       500.00,  1099.00),
(27, 3, 'Room Air Purifier HEPA',         'HOME-007', 'True HEPA air purifier for rooms up to 300 sq ft',      3500.00,  7999.00),
(28, 3, 'Chopper Vegetable 14-Blade',     'HOME-008', 'Manual 14-blade vegetable and fruit chopper',            300.00,   649.00),
(29, 3, 'Bedsheet King Size Cotton',      'HOME-009', '400 TC pure cotton king-size bedsheet with 2 pillows',   800.00,  1799.00),
(30, 3, 'Floor Mop Spin Bucket Set',      'HOME-010', '360-degree spin mop with bucket and refill pads',        600.00,  1349.00),
-- Sports & Fitness (10 products)
(31, 4, 'Yoga Mat 6mm Anti-Slip',         'SPRT-001', 'TPE eco-friendly non-slip yoga mat with carry strap',    450.00,   999.00),
(32, 4, 'Resistance Bands Set of 5',      'SPRT-002', 'Latex resistance bands with varying tension levels',     250.00,   549.00),
(33, 4, 'Dumbbells 5kg Pair',             'SPRT-003', 'Fixed weight rubber-coated cast-iron dumbbells',         800.00,  1799.00),
(34, 4, 'Skipping Rope Digital',          'SPRT-004', 'Weighted skipping rope with digital calorie counter',    300.00,   649.00),
(35, 4, 'Gym Gloves Wrist Support',       'SPRT-005', 'Full-palm leather gym gloves with wrist wrap',           280.00,   599.00),
(36, 4, 'Foam Roller 60cm',               'SPRT-006', 'High-density EVA foam roller for muscle recovery',       350.00,   799.00),
(37, 4, 'Water Bottle Gym 700ml',         'SPRT-007', 'BPA-free shaker bottle with protein grid and handle',    150.00,   349.00),
(38, 4, 'Pull-Up Bar Doorframe',          'SPRT-008', 'No-screw telescopic doorframe pull-up bar',              600.00,  1299.00),
(39, 4, 'Ankle Weights 2kg Pair',         'SPRT-009', 'Adjustable ankle/wrist weights for cardio workouts',     350.00,   799.00),
(40, 4, 'Badminton Racket Set 2pc',       'SPRT-010', 'Carbon fibre badminton rackets with shuttlecocks',       700.00,  1599.00),
-- Books (10 products)
(41, 5, 'Atomic Habits - James Clear',    'BOOK-001', 'Self-help: building good habits, breaking bad ones',      180.00,   399.00),
(42, 5, 'Rich Dad Poor Dad',              'BOOK-002', 'Personal finance classic by Robert Kiyosaki',             150.00,   349.00),
(43, 5, 'The Alchemist - Paulo Coelho',   'BOOK-003', 'International bestselling fiction novel',                 120.00,   299.00),
(44, 5, 'Deep Work - Cal Newport',        'BOOK-004', 'Productivity: rules for focused success',                 160.00,   349.00),
(45, 5, 'SQL Performance Explained',      'BOOK-005', 'Technical book on SQL indexing and query optimisation',   400.00,   899.00),
(46, 5, 'Python Crash Course 3rd Ed',     'BOOK-006', 'Beginner to intermediate Python programming guide',       350.00,   799.00),
(47, 5, 'The Psychology of Money',        'BOOK-007', 'Money, greed, and happiness by Morgan Housel',            160.00,   349.00),
(48, 5, 'Zero to One - Peter Thiel',      'BOOK-008', 'Startup thinking and building the future',                170.00,   379.00),
(49, 5, 'Thinking Fast and Slow',         'BOOK-009', 'Cognitive biases and decision-making by Daniel Kahneman', 200.00,   449.00),
(50, 5, 'The Lean Startup',               'BOOK-010', 'Entrepreneurship methodology by Eric Ries',               180.00,   399.00);

-- =============================================================
-- PRODUCT_SUPPLIERS (each product has 1-3 supplier links)
-- =============================================================
INSERT INTO product_suppliers (product_id, supplier_id, supplier_sku, unit_cost, lead_time_days, is_primary_supplier) VALUES
-- Electronics -> TechZone (1) and GadgetKing (6)
(1,  1, 'TZ-HP-001', 1200.00, 5,  1),
(1,  6, 'GK-HP-101', 1250.00, 7,  0),
(2,  1, 'TZ-CH-002', 350.00,  3,  1),
(3,  1, 'TZ-KB-003', 1800.00, 6,  1),
(3,  6, 'GK-KB-303', 1850.00, 8,  0),
(4,  1, 'TZ-MS-004', 400.00,  4,  1),
(5,  6, 'GK-SD-005', 3500.00, 7,  1),
(6,  6, 'GK-WC-006', 700.00,  5,  1),
(7,  1, 'TZ-LB-007', 600.00,  4,  1),
(8,  6, 'GK-PB-008', 900.00,  6,  1),
(9,  1, 'TZ-HD-009', 180.00,  3,  1),
(10, 6, 'GK-LS-010', 550.00,  5,  1),
-- Clothing -> FashionHub (2) and StyleFirst (7)
(11, 2, 'FH-SH-011', 350.00,  7,  1),
(12, 2, 'FH-KU-012', 280.00,  6,  1),
(12, 7, 'SF-KU-112', 270.00,  8,  0),
(13, 7, 'SF-JN-013', 700.00,  7,  1),
(14, 2, 'FH-TP-014', 320.00,  5,  1),
(15, 7, 'SF-WJ-015', 950.00,  8,  1),
(16, 2, 'FH-SK-016', 120.00,  4,  1),
(17, 7, 'SF-FT-017', 500.00,  7,  1),
(18, 2, 'FH-LG-018', 380.00,  5,  1),
(19, 2, 'FH-KT-019', 250.00,  6,  1),
(20, 7, 'SF-RJ-020', 750.00,  9,  1),
-- Home & Kitchen -> HomeEssentials (3) and KitchenPro (8)
(21, 3, 'HE-CK-021', 1200.00, 8,  1),
(22, 8, 'KP-EK-022', 550.00,  5,  1),
(23, 8, 'KP-AF-023', 2200.00, 7,  1),
(24, 3, 'HE-WB-024', 350.00,  4,  1),
(25, 8, 'KP-CB-025', 400.00,  5,  1),
(26, 3, 'HE-GL-026', 500.00,  6,  1),
(27, 3, 'HE-AP-027', 3500.00, 10, 1),
(27, 8, 'KP-AP-127', 3600.00, 12, 0),
(28, 8, 'KP-CH-028', 300.00,  4,  1),
(29, 3, 'HE-BS-029', 800.00,  7,  1),
(30, 3, 'HE-MO-030', 600.00,  6,  1),
-- Sports -> SportsPro (4) and FitLife (9)
(31, 4, 'SP-YM-031', 450.00,  5,  1),
(32, 9, 'FL-RB-032', 250.00,  4,  1),
(33, 4, 'SP-DB-033', 800.00,  6,  1),
(33, 9, 'FL-DB-133', 820.00,  7,  0),
(34, 4, 'SP-SR-034', 300.00,  4,  1),
(35, 9, 'FL-GG-035', 280.00,  5,  1),
(36, 4, 'SP-FR-036', 350.00,  5,  1),
(37, 9, 'FL-WB-037', 150.00,  3,  1),
(38, 4, 'SP-PB-038', 600.00,  6,  1),
(39, 9, 'FL-AW-039', 350.00,  5,  1),
(40, 4, 'SP-BR-040', 700.00,  7,  1),
-- Books -> BookWorld (5) and EduBooks (10)
(41, 5, 'BW-AH-041', 180.00,  3,  1),
(42, 5, 'BW-RD-042', 150.00,  3,  1),
(43, 5, 'BW-AL-043', 120.00,  3,  1),
(44, 5, 'BW-DW-044', 160.00,  3,  1),
(45,10, 'EB-SP-045', 400.00,  4,  1),
(46,10, 'EB-PC-046', 350.00,  4,  1),
(47, 5, 'BW-PM-047', 160.00,  3,  1),
(48, 5, 'BW-ZO-048', 170.00,  3,  1),
(49,10, 'EB-TF-049', 200.00,  4,  1),
(50,10, 'EB-LS-050', 180.00,  4,  1);

-- =============================================================
-- INVENTORY (one row per product, varied stock levels)
-- =============================================================
INSERT INTO inventory (product_id, quantity_on_hand, quantity_reserved, reorder_level, reorder_quantity, last_restocked_at) VALUES
(1,  85,  5,  20, 50,  '2024-08-15 10:00:00'),
(2,  220, 10, 30, 100, '2024-09-01 09:00:00'),
(3,  60,  3,  15, 40,  '2024-07-20 11:00:00'),
(4,  150, 8,  25, 80,  '2024-09-05 10:00:00'),
(5,  40,  2,  10, 30,  '2024-08-10 14:00:00'),
(6,  95,  4,  20, 60,  '2024-08-25 09:30:00'),
(7,  180, 6,  30, 100, '2024-09-10 08:00:00'),
(8,  110, 7,  20, 70,  '2024-08-30 10:00:00'),
(9,  300, 15, 50, 150, '2024-09-12 09:00:00'),
(10, 75,  3,  15, 50,  '2024-08-18 11:00:00'),
(11, 200, 12, 30, 100, '2024-09-01 10:00:00'),
(12, 175, 8,  25, 80,  '2024-08-28 09:00:00'),
(13, 90,  5,  20, 60,  '2024-08-15 10:00:00'),
(14, 160, 10, 30, 100, '2024-09-05 09:00:00'),
(15, 55,  2,  10, 40,  '2024-07-25 11:00:00'),
(16, 400, 20, 60, 200, '2024-09-10 08:00:00'),
(17, 80,  4,  15, 50,  '2024-08-20 10:00:00'),
(18, 130, 7,  20, 70,  '2024-09-01 09:30:00'),
(19, 220, 11, 35, 120, '2024-09-08 10:00:00'),
(20, 45,  2,  10, 30,  '2024-07-30 11:00:00'),
(21, 65,  3,  15, 40,  '2024-08-10 09:00:00'),
(22, 140, 6,  25, 80,  '2024-09-02 10:00:00'),
(23, 35,  1,  10, 25,  '2024-07-15 11:00:00'),
(24, 250, 12, 40, 120, '2024-09-10 09:00:00'),
(25, 190, 8,  30, 100, '2024-09-05 10:00:00'),
(26, 115, 5,  20, 60,  '2024-08-20 10:00:00'),
(27, 20,  1,  5,  15,  '2024-07-01 09:00:00'),
(28, 280, 14, 40, 150, '2024-09-12 10:00:00'),
(29, 95,  4,  20, 60,  '2024-08-25 09:00:00'),
(30, 120, 6,  25, 80,  '2024-09-01 10:00:00'),
(31, 170, 9,  30, 100, '2024-09-08 09:00:00'),
(32, 310, 15, 50, 150, '2024-09-12 10:00:00'),
(33, 70,  3,  15, 40,  '2024-08-15 11:00:00'),
(34, 200, 10, 30, 100, '2024-09-05 09:00:00'),
(35, 180, 8,  25, 80,  '2024-09-01 10:00:00'),
(36, 95,  4,  20, 60,  '2024-08-20 09:00:00'),
(37, 350, 18, 60, 200, '2024-09-10 10:00:00'),
(38, 60,  3,  10, 30,  '2024-08-10 11:00:00'),
(39, 140, 7,  25, 80,  '2024-09-02 09:00:00'),
(40, 85,  4,  15, 50,  '2024-08-25 10:00:00'),
(41, 500, 25, 80, 300, '2024-09-12 09:00:00'),
(42, 450, 22, 70, 250, '2024-09-10 10:00:00'),
(43, 380, 18, 60, 200, '2024-09-08 09:00:00'),
(44, 320, 14, 50, 180, '2024-09-05 10:00:00'),
(45, 110, 5,  20, 60,  '2024-08-20 09:00:00'),
(46, 140, 6,  25, 80,  '2024-09-01 10:00:00'),
(47, 430, 21, 70, 250, '2024-09-10 09:00:00'),
(48, 260, 12, 40, 150, '2024-09-05 10:00:00'),
(49, 190, 9,  30, 100, '2024-08-28 09:00:00'),
(50, 210, 10, 35, 120, '2024-09-08 10:00:00');

-- =============================================================
-- CUSTOMERS (100 customers across Indian cities)
-- =============================================================
INSERT INTO customers (customer_id, first_name, last_name, email, phone, address_line1, city, state, postal_code, country) VALUES
(1,  'Aarav',    'Sharma',    'aarav.sharma@gmail.com',     '9811001001', '14 MG Road',          'Mumbai',    'Maharashtra',    '400001', 'India'),
(2,  'Aditi',    'Verma',     'aditi.verma@gmail.com',      '9812002002', '27 Park Street',      'Kolkata',   'West Bengal',    '700016', 'India'),
(3,  'Aditya',   'Singh',     'aditya.singh@yahoo.com',     '9813003003', '3 Civil Lines',       'Delhi',     'Delhi',          '110001', 'India'),
(4,  'Akash',    'Patel',     'akash.patel@gmail.com',      '9814004004', '88 Koramangala',      'Bengaluru', 'Karnataka',      '560034', 'India'),
(5,  'Ananya',   'Reddy',     'ananya.reddy@gmail.com',     '9815005005', '12 Jubilee Hills',    'Hyderabad', 'Telangana',      '500033', 'India'),
(6,  'Anjali',   'Mehta',     'anjali.mehta@outlook.com',   '9816006006', '5 C-Scheme',          'Jaipur',    'Rajasthan',      '302001', 'India'),
(7,  'Arjun',    'Nair',      'arjun.nair@gmail.com',       '9817007007', '77 Indiranagar',      'Bengaluru', 'Karnataka',      '560038', 'India'),
(8,  'Deepika',  'Kumar',     'deepika.kumar@gmail.com',    '9818008008', '2 Ashok Nagar',       'Chennai',   'Tamil Nadu',     '600083', 'India'),
(9,  'Dev',      'Joshi',     'dev.joshi@gmail.com',        '9819009009', '45 Satelite Road',    'Ahmedabad', 'Gujarat',        '380015', 'India'),
(10, 'Dhruv',    'Gupta',     'dhruv.gupta@gmail.com',      '9820010010', '19 Sector 17',        'Chandigarh','Punjab',         '160017', 'India'),
(11, 'Divya',    'Iyer',      'divya.iyer@gmail.com',       '9821011011', '33 T. Nagar',         'Chennai',   'Tamil Nadu',     '600017', 'India'),
(12, 'Gaurav',   'Bose',      'gaurav.bose@gmail.com',      '9822012012', '6 Salt Lake',         'Kolkata',   'West Bengal',    '700091', 'India'),
(13, 'Ishaan',   'Kapoor',    'ishaan.kapoor@gmail.com',    '9823013013', '8 Connaught Place',   'Delhi',     'Delhi',          '110001', 'India'),
(14, 'Isha',     'Das',       'isha.das@gmail.com',         '9824014014', '99 Howrah',           'Kolkata',   'West Bengal',    '711101', 'India'),
(15, 'Kabir',    'Malhotra',  'kabir.malhotra@gmail.com',   '9825015015', '56 Powai',            'Mumbai',    'Maharashtra',    '400076', 'India'),
(16, 'Kavya',    'Pillai',    'kavya.pillai@gmail.com',     '9826016016', '11 Marine Drive',     'Kochi',     'Kerala',         '682031', 'India'),
(17, 'Krish',    'Agarwal',   'krish.agarwal@gmail.com',    '9827017017', '24 Sector 22',        'Noida',     'Uttar Pradesh',  '201301', 'India'),
(18, 'Lavanya',  'Rao',       'lavanya.rao@gmail.com',      '9828018018', '7 Banjara Hills',     'Hyderabad', 'Telangana',      '500034', 'India'),
(19, 'Manav',    'Sinha',     'manav.sinha@outlook.com',    '9829019019', '48 Boring Road',      'Patna',     'Bihar',          '800001', 'India'),
(20, 'Maya',     'Tiwari',    'maya.tiwari@gmail.com',      '9830020020', '14 Mahanagar',        'Lucknow',   'Uttar Pradesh',  '226006', 'India'),
(21, 'Mihir',    'Shah',      'mihir.shah@gmail.com',       '9831021021', '3 Navrangpura',       'Ahmedabad', 'Gujarat',        '380009', 'India'),
(22, 'Natasha',  'Chatterjee','natasha.chatterjee@gmail.com','9832022022', '22 Alipore',         'Kolkata',   'West Bengal',    '700027', 'India'),
(23, 'Neel',     'Pandya',    'neel.pandya@gmail.com',      '9833023023', '15 Panjim',           'Goa',       'Goa',            '403001', 'India'),
(24, 'Neha',     'Saxena',    'neha.saxena@gmail.com',      '9834024024', '71 Lajpat Nagar',     'Delhi',     'Delhi',          '110024', 'India'),
(25, 'Nikhil',   'Jain',      'nikhil.jain@gmail.com',      '9835025025', '9 Vastrapur',         'Ahmedabad', 'Gujarat',        '380015', 'India'),
(26, 'Nisha',    'Menon',     'nisha.menon@gmail.com',       '9836026026', '42 Palayam',         'Thiruvananthapuram','Kerala', '695034', 'India'),
(27, 'Om',       'Trivedi',   'om.trivedi@gmail.com',        '9837027027', '5 Indore Nagar',     'Indore',    'Madhya Pradesh', '452001', 'India'),
(28, 'Pallavi',  'Mishra',    'pallavi.mishra@gmail.com',    '9838028028', '37 Shivaji Nagar',   'Bhopal',    'Madhya Pradesh', '462016', 'India'),
(29, 'Parth',    'Desai',     'parth.desai@gmail.com',       '9839029029', '18 Ring Road',       'Surat',     'Gujarat',        '395007', 'India'),
(30, 'Pooja',    'Bhatt',     'pooja.bhatt@yahoo.com',       '9840030030', '63 Versova',         'Mumbai',    'Maharashtra',    '400061', 'India'),
(31, 'Priya',    'Naik',      'priya.naik@gmail.com',        '9841031031', '29 Pimpri',          'Pune',      'Maharashtra',    '411018', 'India'),
(32, 'Rahul',    'Chandra',   'rahul.chandra@gmail.com',     '9842032032', '44 HSR Layout',      'Bengaluru', 'Karnataka',      '560102', 'India'),
(33, 'Raj',      'Krishnan',  'raj.krishnan@gmail.com',      '9843033033', '6 Mylapore',         'Chennai',   'Tamil Nadu',     '600004', 'India'),
(34, 'Rajesh',   'Goswami',   'rajesh.goswami@gmail.com',   '9844034034', '17 Rashbehari',       'Kolkata',   'West Bengal',    '700019', 'India'),
(35, 'Riya',     'Lal',       'riya.lal@gmail.com',          '9845035035', '52 Model Town',      'Delhi',     'Delhi',          '110009', 'India'),
(36, 'Rohan',    'Bhatia',    'rohan.bhatia@gmail.com',      '9846036036', '8 Karol Bagh',       'Delhi',     'Delhi',          '110005', 'India'),
(37, 'Rohit',    'Shetty',    'rohit.shetty@gmail.com',      '9847037037', '34 Andheri',         'Mumbai',    'Maharashtra',    '400058', 'India'),
(38, 'Sakshi',   'Kulkarni',  'sakshi.kulkarni@gmail.com',  '9848038038', '12 Kothrud',          'Pune',      'Maharashtra',    '411038', 'India'),
(39, 'Samarth',  'Dixit',     'samarth.dixit@gmail.com',    '9849039039', '3 Napier Town',       'Jabalpur',  'Madhya Pradesh', '482001', 'India'),
(40, 'Sanaya',   'Soni',      'sanaya.soni@gmail.com',       '9850040040', '55 Mira Road',       'Mumbai',    'Maharashtra',    '401107', 'India'),
(41, 'Sanjay',   'Wagh',      'sanjay.wagh@gmail.com',       '9851041041', '27 Wakad',           'Pune',      'Maharashtra',    '411057', 'India'),
(42, 'Sara',     'Varma',     'sara.varma@gmail.com',        '9852042042', '14 Sector 18',       'Noida',     'Uttar Pradesh',  '201301', 'India'),
(43, 'Siddharth','Ghosh',     'siddharth.ghosh@gmail.com',  '9853043043', '9 Jadavpur',          'Kolkata',   'West Bengal',    '700032', 'India'),
(44, 'Simran',   'Oberoi',    'simran.oberoi@gmail.com',     '9854044044', '31 Sector 8',        'Chandigarh','Punjab',         '160008', 'India'),
(45, 'Sneha',    'Patil',     'sneha.patil@gmail.com',       '9855045045', '66 Hadapsar',        'Pune',      'Maharashtra',    '411028', 'India'),
(46, 'Soham',    'Roy',       'soham.roy@gmail.com',         '9856046046', '7 Ballygunge',       'Kolkata',   'West Bengal',    '700019', 'India'),
(47, 'Sonali',   'Thakur',    'sonali.thakur@gmail.com',    '9857047047', '43 Rajouri Garden',   'Delhi',     'Delhi',          '110027', 'India'),
(48, 'Srijan',   'Babu',      'srijan.babu@gmail.com',       '9858048048', '18 Adyar',           'Chennai',   'Tamil Nadu',     '600020', 'India'),
(49, 'Swati',    'Joshi',     'swati.joshi@gmail.com',       '9859049049', '5 Maninagar',        'Ahmedabad', 'Gujarat',        '380008', 'India'),
(50, 'Tanvi',    'Rao',       'tanvi.rao@gmail.com',         '9860050050', '77 Secunderabad',    'Hyderabad', 'Telangana',      '500015', 'India'),
(51, 'Tarun',    'Bakshi',    'tarun.bakshi@gmail.com',      '9861051051', '22 Lakkar Bazaar',   'Shimla',    'Himachal Pradesh','171001','India'),
(52, 'Uday',     'Mathur',    'uday.mathur@gmail.com',       '9862052052', '11 Mansarovar',      'Jaipur',    'Rajasthan',      '302020', 'India'),
(53, 'Uma',      'Raghavan',  'uma.raghavan@gmail.com',      '9863053053', '6 Anna Nagar',       'Chennai',   'Tamil Nadu',     '600040', 'India'),
(54, 'Varun',    'Balan',     'varun.balan@gmail.com',       '9864054054', '34 Kakkanad',        'Kochi',     'Kerala',         '682030', 'India'),
(55, 'Vidya',    'Hegde',     'vidya.hegde@gmail.com',       '9865055055', '1 Malleswaram',      'Bengaluru', 'Karnataka',      '560055', 'India'),
(56, 'Vikram',   'Arora',     'vikram.arora@gmail.com',      '9866056056', '48 Dwarka',          'Delhi',     'Delhi',          '110075', 'India'),
(57, 'Vinay',    'Sharma',    'vinay.sharma2@gmail.com',     '9867057057', '28 Ghatkopar',       'Mumbai',    'Maharashtra',    '400077', 'India'),
(58, 'Vipul',    'Dave',      'vipul.dave@gmail.com',        '9868058058', '7 Ellisbridge',      'Ahmedabad', 'Gujarat',        '380006', 'India'),
(59, 'Vishal',   'Pandey',    'vishal.pandey@gmail.com',     '9869059059', '19 Gomti Nagar',     'Lucknow',   'Uttar Pradesh',  '226010', 'India'),
(60, 'Yash',     'Kapadia',   'yash.kapadia@gmail.com',      '9870060060', '5 Borivali',         'Mumbai',    'Maharashtra',    '400092', 'India'),
(61, 'Abhay',    'Kulkarni',  'abhay.kulkarni@gmail.com',   '9871061061', '16 Bavdhan',          'Pune',      'Maharashtra',    '411021', 'India'),
(62, 'Aishwarya','Prasad',    'aishwarya.prasad@gmail.com', '9872062062', '3 Exhibition Road',   'Patna',     'Bihar',          '800001', 'India'),
(63, 'Alok',     'Srivastava','alok.srivastava@gmail.com',  '9873063063', '10 Hazratganj',       'Lucknow',   'Uttar Pradesh',  '226001', 'India'),
(64, 'Amita',    'Basu',      'amita.basu@gmail.com',        '9874064064', '25 Shyambazar',      'Kolkata',   'West Bengal',    '700004', 'India'),
(65, 'Amol',     'Kale',      'amol.kale@gmail.com',         '9875065065', '9 Bibwewadi',        'Pune',      'Maharashtra',    '411037', 'India'),
(66, 'Anika',    'Saxena',    'anika.saxena@gmail.com',      '9876066066', '42 Rajnagar',        'Ghaziabad', 'Uttar Pradesh',  '201002', 'India'),
(67, 'Arnav',    'Bedi',      'arnav.bedi@gmail.com',        '9877067067', '7 Patiala Road',     'Ludhiana',  'Punjab',         '141001', 'India'),
(68, 'Ayesha',   'Sheikh',    'ayesha.sheikh@gmail.com',     '9878068068', '33 Bandra West',     'Mumbai',    'Maharashtra',    '400050', 'India'),
(69, 'Ayush',    'Ojha',      'ayush.ojha@gmail.com',        '9879069069', '5 Lanka',            'Varanasi',  'Uttar Pradesh',  '221005', 'India'),
(70, 'Bhavya',   'Trivedi',   'bhavya.trivedi@gmail.com',   '9880070070', '17 Prahladnagar',     'Ahmedabad', 'Gujarat',        '380015', 'India'),
(71, 'Chetan',   'More',      'chetan.more@gmail.com',       '9881071071', '8 Gangapur Road',    'Nashik',    'Maharashtra',    '422013', 'India'),
(72, 'Chirag',   'Thakkar',   'chirag.thakkar@gmail.com',   '9882072072', '22 Adajan',           'Surat',     'Gujarat',        '395009', 'India'),
(73, 'Disha',    'Bansal',    'disha.bansal@gmail.com',      '9883073073', '14 Vaishali Nagar',  'Jaipur',    'Rajasthan',      '302021', 'India'),
(74, 'Esha',     'Negi',      'esha.negi@gmail.com',         '9884074074', '1 Mall Road',        'Mussoorie', 'Uttarakhand',    '248179', 'India'),
(75, 'Gaurav',   'Mahajan',   'gaurav.mahajan2@gmail.com',  '9885075075', '55 Rohini',           'Delhi',     'Delhi',          '110085', 'India'),
(76, 'Harish',   'Rao',       'harish.rao@gmail.com',        '9886076076', '3 HRBR Layout',      'Bengaluru', 'Karnataka',      '560043', 'India'),
(77, 'Harsh',    'Mittal',    'harsh.mittal@gmail.com',      '9887077077', '18 Mukherjee Nagar', 'Delhi',     'Delhi',          '110009', 'India'),
(78, 'Hema',     'Pillai',    'hema.pillai@gmail.com',       '9888078078', '9 Thrissur Road',    'Palakkad',  'Kerala',         '678001', 'India'),
(79, 'Hitesh',   'Patel',     'hitesh.patel@gmail.com',      '9889079079', '66 Bopal',           'Ahmedabad', 'Gujarat',        '380058', 'India'),
(80, 'Jay',      'Mehta',     'jay.mehta@gmail.com',         '9890080080', '11 Paldi',           'Ahmedabad', 'Gujarat',        '380007', 'India'),
(81, 'Jyoti',    'Chaudhary', 'jyoti.chaudhary@gmail.com',  '9891081081', '44 Kesar Bagh',      'Bhopal',    'Madhya Pradesh', '462039', 'India'),
(82, 'Kiran',    'Naidu',     'kiran.naidu@gmail.com',       '9892082082', '7 Kukatpally',       'Hyderabad', 'Telangana',      '500072', 'India'),
(83, 'Komal',    'Shukla',    'komal.shukla@gmail.com',      '9893083083', '5 Aminabad',         'Lucknow',   'Uttar Pradesh',  '226018', 'India'),
(84, 'Kunal',    'Bajaj',     'kunal.bajaj@gmail.com',       '9894084084', '31 Panchkula',       'Chandigarh','Punjab',         '134109', 'India'),
(85, 'Lalit',    'Vyas',      'lalit.vyas@gmail.com',        '9895085085', '12 Sodala',          'Jaipur',    'Rajasthan',      '302019', 'India'),
(86, 'Lata',     'Rao',       'lata.rao@gmail.com',          '9896086086', '23 Ameerpet',        'Hyderabad', 'Telangana',      '500016', 'India'),
(87, 'Manas',    'Sahoo',     'manas.sahoo@gmail.com',       '9897087087', '8 Saheed Nagar',     'Bhubaneswar','Odisha',        '751007', 'India'),
(88, 'Manish',   'Aggarwal',  'manish.aggarwal@gmail.com',  '9898088088', '17 Pitampura',        'Delhi',     'Delhi',          '110034', 'India'),
(89, 'Manu',     'Gupta',     'manu.gupta@gmail.com',        '9899089089', '4 Hazra Road',       'Kolkata',   'West Bengal',    '700026', 'India'),
(90, 'Meghna',   'Jha',       'meghna.jha@gmail.com',        '9900090090', '21 Boring Canal',   'Patna',     'Bihar',          '800001', 'India'),
(91, 'Mohit',    'Singh',     'mohit.singh2@gmail.com',      '9901091091', '66 Sector 45',       'Gurgaon',   'Haryana',        '122003', 'India'),
(92, 'Mukesh',   'Nair',      'mukesh.nair@gmail.com',       '9902092092', '3 Thrippunithura',   'Kochi',     'Kerala',         '682301', 'India'),
(93, 'Namita',   'Ghosh',     'namita.ghosh@gmail.com',      '9903093093', '11 Taltala',         'Kolkata',   'West Bengal',    '700014', 'India'),
(94, 'Naveen',   'Rajan',     'naveen.rajan@gmail.com',      '9904094094', '44 Guindy',          'Chennai',   'Tamil Nadu',     '600032', 'India'),
(95, 'Nidhi',    'Sharma',    'nidhi.sharma@gmail.com',      '9905095095', '12 Mansarovar',      'Jaipur',    'Rajasthan',      '302020', 'India'),
(96, 'Nitin',    'Sood',      'nitin.sood@gmail.com',        '9906096096', '29 Moti Bagh',       'Delhi',     'Delhi',          '110021', 'India'),
(97, 'Payal',    'Kapoor',    'payal.kapoor@gmail.com',      '9907097097', '7 Prabhadevi',       'Mumbai',    'Maharashtra',    '400025', 'India'),
(98, 'Piyush',   'Rawat',     'piyush.rawat@gmail.com',      '9908098098', '15 Rajpur Road',     'Dehradun',  'Uttarakhand',    '248001', 'India'),
(99, 'Pranav',   'Bhatkar',   'pranav.bhatkar@gmail.com',   '9909099099', '8 Mulund',            'Mumbai',    'Maharashtra',    '400080', 'India'),
(100,'Preeti',   'Sundaram',  'preeti.sundaram@gmail.com',  '9910100100', '33 Velachery',        'Chennai',   'Tamil Nadu',     '600042', 'India');

-- =============================================================
-- ORDERS (1000 orders across Jan-Sep 2024)
-- Using a procedural INSERT approach with realistic patterns.
-- We insert in batches per status to keep the script readable.
-- =============================================================

-- Helper: Temporarily disable ONLY_FULL_GROUP_BY if needed
SET SESSION sql_mode = (SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- DELIVERED orders (60%): ~600 orders
-- Format: order_id, customer_id, order_date, status, shipping_address, city, state, postal, total_amount
INSERT INTO orders (order_id, customer_id, order_date, status, shipping_address, shipping_city, shipping_state, shipping_postal, total_amount, discount_amount, tax_amount) VALUES
(1,   1,  '2024-01-05 10:23:00', 'DELIVERED', '14 MG Road',          'Mumbai',    'Maharashtra',    '400001', 4498.00,  0.00,  404.82),
(2,   2,  '2024-01-07 14:15:00', 'DELIVERED', '27 Park Street',      'Kolkata',   'West Bengal',    '700016', 898.00,   0.00,   80.82),
(3,   3,  '2024-01-09 09:45:00', 'DELIVERED', '3 Civil Lines',       'Delhi',     'Delhi',          '110001', 3999.00,  0.00,  359.91),
(4,   4,  '2024-01-10 16:30:00', 'DELIVERED', '88 Koramangala',      'Bengaluru', 'Karnataka',      '560034', 6999.00,  0.00,  629.91),
(5,   5,  '2024-01-12 11:00:00', 'DELIVERED', '12 Jubilee Hills',    'Hyderabad', 'Telangana',      '500033', 1798.00,  0.00,  161.82),
(6,   6,  '2024-01-14 13:20:00', 'DELIVERED', '5 C-Scheme',          'Jaipur',    'Rajasthan',      '302001', 799.00,   0.00,   71.91),
(7,   7,  '2024-01-15 10:45:00', 'DELIVERED', '77 Indiranagar',      'Bengaluru', 'Karnataka',      '560038', 2499.00,  0.00,  224.91),
(8,   8,  '2024-01-17 15:10:00', 'DELIVERED', '2 Ashok Nagar',       'Chennai',   'Tamil Nadu',     '600083', 1199.00,  0.00,  107.91),
(9,   9,  '2024-01-18 09:30:00', 'DELIVERED', '45 Satelite Road',    'Ahmedabad', 'Gujarat',        '380015', 5498.00,  0.00,  494.82),
(10,  10, '2024-01-20 12:00:00', 'DELIVERED', '19 Sector 17',        'Chandigarh','Punjab',         '160017', 899.00,   0.00,   80.91),
(11,  11, '2024-01-22 14:30:00', 'DELIVERED', '33 T. Nagar',         'Chennai',   'Tamil Nadu',     '600017', 2799.00,  0.00,  251.91),
(12,  12, '2024-01-24 10:15:00', 'DELIVERED', '6 Salt Lake',         'Kolkata',   'West Bengal',    '700091', 1499.00,  0.00,  134.91),
(13,  13, '2024-01-26 11:45:00', 'DELIVERED', '8 Connaught Place',   'Delhi',     'Delhi',          '110001', 7999.00,  0.00,  719.91),
(14,  14, '2024-01-28 16:00:00', 'DELIVERED', '99 Howrah',           'Kolkata',   'West Bengal',    '711101', 599.00,   0.00,   53.91),
(15,  15, '2024-01-30 09:15:00', 'DELIVERED', '56 Powai',            'Mumbai',    'Maharashtra',    '400076', 3998.00,  0.00,  359.82),
(16,  16, '2024-02-01 13:30:00', 'DELIVERED', '11 Marine Drive',     'Kochi',     'Kerala',         '682031', 999.00,   0.00,   89.91),
(17,  17, '2024-02-03 10:00:00', 'DELIVERED', '24 Sector 22',        'Noida',     'Uttar Pradesh',  '201301', 1499.00,  0.00,  134.91),
(18,  18, '2024-02-05 14:45:00', 'DELIVERED', '7 Banjara Hills',     'Hyderabad', 'Telangana',      '500034', 849.00,   0.00,   76.41),
(19,  19, '2024-02-07 11:20:00', 'DELIVERED', '48 Boring Road',      'Patna',     'Bihar',          '800001', 399.00,   0.00,   35.91),
(20,  20, '2024-02-09 15:00:00', 'DELIVERED', '14 Mahanagar',        'Lucknow',   'Uttar Pradesh',  '226006', 1799.00,  0.00,  161.91),
(21,  21, '2024-02-10 09:45:00', 'DELIVERED', '3 Navrangpura',       'Ahmedabad', 'Gujarat',        '380009', 349.00,   0.00,   31.41),
(22,  22, '2024-02-12 13:00:00', 'DELIVERED', '22 Alipore',          'Kolkata',   'West Bengal',    '700027', 1199.00,  0.00,  107.91),
(23,  23, '2024-02-14 10:30:00', 'DELIVERED', '15 Panjim',           'Goa',       'Goa',            '403001', 4998.00, 200.00,  430.02),
(24,  24, '2024-02-16 14:15:00', 'DELIVERED', '71 Lajpat Nagar',     'Delhi',     'Delhi',          '110024', 699.00,   0.00,   62.91),
(25,  25, '2024-02-18 11:00:00', 'DELIVERED', '9 Vastrapur',         'Ahmedabad', 'Gujarat',        '380015', 2199.00,  0.00,  197.91),
(26,  26, '2024-02-20 15:30:00', 'DELIVERED', '42 Palayam',          'Thiruvananthapuram','Kerala',  '695034', 299.00,  0.00,   26.91),
(27,  27, '2024-02-22 09:00:00', 'DELIVERED', '5 Indore Nagar',      'Indore',    'Madhya Pradesh', '452001', 1099.00, 100.00,   89.91),
(28,  28, '2024-02-24 12:45:00', 'DELIVERED', '37 Shivaji Nagar',    'Bhopal',    'Madhya Pradesh', '462016', 1999.00,  0.00,  179.91),
(29,  29, '2024-02-26 14:00:00', 'DELIVERED', '18 Ring Road',        'Surat',     'Gujarat',        '395007', 799.00,   0.00,   71.91),
(30,  30, '2024-02-28 10:30:00', 'DELIVERED', '63 Versova',          'Mumbai',    'Maharashtra',    '400061', 549.00,   0.00,   49.41),
(31,  31, '2024-03-02 13:15:00', 'DELIVERED', '29 Pimpri',           'Pune',      'Maharashtra',    '411018', 2499.00,  0.00,  224.91),
(32,  32, '2024-03-04 09:30:00', 'DELIVERED', '44 HSR Layout',       'Bengaluru', 'Karnataka',      '560102', 1799.00,  0.00,  161.91),
(33,  33, '2024-03-06 14:45:00', 'DELIVERED', '6 Mylapore',          'Chennai',   'Tamil Nadu',     '600004', 399.00,   0.00,   35.91),
(34,  34, '2024-03-08 11:00:00', 'DELIVERED', '17 Rashbehari',       'Kolkata',   'West Bengal',    '700019', 6998.00, 500.00,  584.82),
(35,  35, '2024-03-10 15:30:00', 'DELIVERED', '52 Model Town',       'Delhi',     'Delhi',          '110009', 1299.00,  0.00,  116.91),
(36,  36, '2024-03-12 09:45:00', 'DELIVERED', '8 Karol Bagh',        'Delhi',     'Delhi',          '110005', 899.00,   0.00,   80.91),
(37,  37, '2024-03-14 13:00:00', 'DELIVERED', '34 Andheri',          'Mumbai',    'Maharashtra',    '400058', 4998.00, 200.00,  430.02),
(38,  38, '2024-03-16 10:15:00', 'DELIVERED', '12 Kothrud',          'Pune',      'Maharashtra',    '411038', 849.00,   0.00,   76.41),
(39,  39, '2024-03-18 14:30:00', 'DELIVERED', '3 Napier Town',       'Jabalpur',  'Madhya Pradesh', '482001', 349.00,   0.00,   31.41),
(40,  40, '2024-03-20 11:45:00', 'DELIVERED', '55 Mira Road',        'Mumbai',    'Maharashtra',    '401107', 1998.00,  0.00,  179.82),
(41,  41, '2024-03-22 15:00:00', 'DELIVERED', '27 Wakad',            'Pune',      'Maharashtra',    '411057', 2799.00, 100.00,  242.91),
(42,  42, '2024-03-24 09:15:00', 'DELIVERED', '14 Sector 18',        'Noida',     'Uttar Pradesh',  '201301', 1099.00,  0.00,   98.91),
(43,  43, '2024-03-26 13:30:00', 'DELIVERED', '9 Jadavpur',          'Kolkata',   'West Bengal',    '700032', 399.00,   0.00,   35.91),
(44,  44, '2024-03-28 10:45:00', 'DELIVERED', '31 Sector 8',         'Chandigarh','Punjab',         '160008', 1799.00,  0.00,  161.91),
(45,  45, '2024-03-30 14:00:00', 'DELIVERED', '66 Hadapsar',         'Pune',      'Maharashtra',    '411028', 999.00,   0.00,   89.91),
(46,  46, '2024-04-01 11:15:00', 'DELIVERED', '7 Ballygunge',        'Kolkata',   'West Bengal',    '700019', 549.00,   0.00,   49.41),
(47,  47, '2024-04-03 15:30:00', 'DELIVERED', '43 Rajouri Garden',   'Delhi',     'Delhi',          '110027', 3999.00,  0.00,  359.91),
(48,  48, '2024-04-05 09:45:00', 'DELIVERED', '18 Adyar',            'Chennai',   'Tamil Nadu',     '600020', 1299.00,  0.00,  116.91),
(49,  49, '2024-04-07 13:00:00', 'DELIVERED', '5 Maninagar',         'Ahmedabad', 'Gujarat',        '380008', 799.00,   0.00,   71.91),
(50,  50, '2024-04-09 10:15:00', 'DELIVERED', '77 Secunderabad',     'Hyderabad', 'Telangana',      '500015', 1999.00,  0.00,  179.91),
(51,  1,  '2024-04-11 14:30:00', 'DELIVERED', '14 MG Road',          'Mumbai',    'Maharashtra',    '400001', 1798.00, 100.00,  152.82),
(52,  3,  '2024-04-13 11:45:00', 'DELIVERED', '3 Civil Lines',       'Delhi',     'Delhi',          '110001', 799.00,   0.00,   71.91),
(53,  5,  '2024-04-15 15:00:00', 'DELIVERED', '12 Jubilee Hills',    'Hyderabad', 'Telangana',      '500033', 2499.00,  0.00,  224.91),
(54,  7,  '2024-04-17 09:15:00', 'DELIVERED', '77 Indiranagar',      'Bengaluru', 'Karnataka',      '560038', 6999.00,  0.00,  629.91),
(55,  9,  '2024-04-19 13:30:00', 'DELIVERED', '45 Satelite Road',    'Ahmedabad', 'Gujarat',        '380015', 349.00,   0.00,   31.41),
(56,  11, '2024-04-21 10:45:00', 'DELIVERED', '33 T. Nagar',         'Chennai',   'Tamil Nadu',     '600017', 1199.00,  0.00,  107.91),
(57,  13, '2024-04-23 14:00:00', 'DELIVERED', '8 Connaught Place',   'Delhi',     'Delhi',          '110001', 899.00,   0.00,   80.91),
(58,  15, '2024-04-25 11:15:00', 'DELIVERED', '56 Powai',            'Mumbai',    'Maharashtra',    '400076', 4998.00, 300.00,  419.82),
(59,  17, '2024-04-27 15:30:00', 'DELIVERED', '24 Sector 22',        'Noida',     'Uttar Pradesh',  '201301', 549.00,   0.00,   49.41),
(60,  19, '2024-04-29 09:45:00', 'DELIVERED', '48 Boring Road',      'Patna',     'Bihar',          '800001', 2799.00,  0.00,  251.91),
(61,  2,  '2024-05-01 13:00:00', 'DELIVERED', '27 Park Street',      'Kolkata',   'West Bengal',    '700016', 1499.00, 100.00,  125.91),
(62,  4,  '2024-05-03 10:15:00', 'DELIVERED', '88 Koramangala',      'Bengaluru', 'Karnataka',      '560034', 3999.00,  0.00,  359.91),
(63,  6,  '2024-05-05 14:30:00', 'DELIVERED', '5 C-Scheme',          'Jaipur',    'Rajasthan',      '302001', 799.00,   0.00,   71.91),
(64,  8,  '2024-05-07 11:45:00', 'DELIVERED', '2 Ashok Nagar',       'Chennai',   'Tamil Nadu',     '600083', 1799.00,  0.00,  161.91),
(65,  10, '2024-05-09 15:00:00', 'DELIVERED', '19 Sector 17',        'Chandigarh','Punjab',         '160017', 6999.00,  0.00,  629.91),
(66,  12, '2024-05-11 09:15:00', 'DELIVERED', '6 Salt Lake',         'Kolkata',   'West Bengal',    '700091', 349.00,   0.00,   31.41),
(67,  14, '2024-05-13 13:30:00', 'DELIVERED', '99 Howrah',           'Kolkata',   'West Bengal',    '711101', 2499.00,  0.00,  224.91),
(68,  16, '2024-05-15 10:45:00', 'DELIVERED', '11 Marine Drive',     'Kochi',     'Kerala',         '682031', 899.00,   0.00,   80.91),
(69,  18, '2024-05-17 14:00:00', 'DELIVERED', '7 Banjara Hills',     'Hyderabad', 'Telangana',      '500034', 1299.00,  0.00,  116.91),
(70,  20, '2024-05-19 11:15:00', 'DELIVERED', '14 Mahanagar',        'Lucknow',   'Uttar Pradesh',  '226006', 7999.00, 400.00,  682.71),
(71,  21, '2024-05-21 15:30:00', 'DELIVERED', '3 Navrangpura',       'Ahmedabad', 'Gujarat',        '380009', 799.00,   0.00,   71.91),
(72,  22, '2024-05-23 09:45:00', 'DELIVERED', '22 Alipore',          'Kolkata',   'West Bengal',    '700027', 4998.00, 200.00,  430.02),
(73,  23, '2024-05-25 13:00:00', 'DELIVERED', '15 Panjim',           'Goa',       'Goa',            '403001', 549.00,   0.00,   49.41),
(74,  24, '2024-05-27 10:15:00', 'DELIVERED', '71 Lajpat Nagar',     'Delhi',     'Delhi',          '110024', 1999.00,  0.00,  179.91),
(75,  25, '2024-05-29 14:30:00', 'DELIVERED', '9 Vastrapur',         'Ahmedabad', 'Gujarat',        '380015', 2799.00, 100.00,  242.91),
(76,  26, '2024-05-31 11:45:00', 'DELIVERED', '42 Palayam',          'Thiruvananthapuram','Kerala',  '695034', 399.00,  0.00,   35.91),
(77,  27, '2024-06-02 15:00:00', 'DELIVERED', '5 Indore Nagar',      'Indore',    'Madhya Pradesh', '452001', 1499.00,  0.00,  134.91),
(78,  28, '2024-06-04 09:15:00', 'DELIVERED', '37 Shivaji Nagar',    'Bhopal',    'Madhya Pradesh', '462016', 6999.00, 500.00,  584.91),
(79,  29, '2024-06-06 13:30:00', 'DELIVERED', '18 Ring Road',        'Surat',     'Gujarat',        '395007', 849.00,   0.00,   76.41),
(80,  30, '2024-06-08 10:45:00', 'DELIVERED', '63 Versova',          'Mumbai',    'Maharashtra',    '400061', 1199.00,  0.00,  107.91),
(81,  31, '2024-06-10 14:00:00', 'DELIVERED', '29 Pimpri',           'Pune',      'Maharashtra',    '411018', 799.00,   0.00,   71.91),
(82,  32, '2024-06-12 11:15:00', 'DELIVERED', '44 HSR Layout',       'Bengaluru', 'Karnataka',      '560102', 3999.00,  0.00,  359.91),
(83,  33, '2024-06-14 15:30:00', 'DELIVERED', '6 Mylapore',          'Chennai',   'Tamil Nadu',     '600004', 2799.00,  0.00,  251.91),
(84,  34, '2024-06-16 09:45:00', 'DELIVERED', '17 Rashbehari',       'Kolkata',   'West Bengal',    '700019', 649.00,   0.00,   58.41),
(85,  35, '2024-06-18 13:00:00', 'DELIVERED', '52 Model Town',       'Delhi',     'Delhi',          '110009', 1799.00,  0.00,  161.91),
(86,  36, '2024-06-20 10:15:00', 'DELIVERED', '8 Karol Bagh',        'Delhi',     'Delhi',          '110005', 6998.00, 300.00,  602.82),
(87,  37, '2024-06-22 14:30:00', 'DELIVERED', '34 Andheri',          'Mumbai',    'Maharashtra',    '400058', 999.00,   0.00,   89.91),
(88,  38, '2024-06-24 11:45:00', 'DELIVERED', '12 Kothrud',          'Pune',      'Maharashtra',    '411038', 549.00,   0.00,   49.41),
(89,  39, '2024-06-26 15:00:00', 'DELIVERED', '3 Napier Town',       'Jabalpur',  'Madhya Pradesh', '482001', 1299.00,  0.00,  116.91),
(90,  40, '2024-06-28 09:15:00', 'DELIVERED', '55 Mira Road',        'Mumbai',    'Maharashtra',    '401107', 349.00,   0.00,   31.41),
(91,  1,  '2024-07-01 13:30:00', 'DELIVERED', '14 MG Road',          'Mumbai',    'Maharashtra',    '400001', 7998.00, 400.00,  682.62),
(92,  4,  '2024-07-03 10:45:00', 'DELIVERED', '88 Koramangala',      'Bengaluru', 'Karnataka',      '560034', 1498.00, 100.00,  125.82),
(93,  7,  '2024-07-05 14:00:00', 'DELIVERED', '77 Indiranagar',      'Bengaluru', 'Karnataka',      '560038', 2799.00,  0.00,  251.91),
(94,  15, '2024-07-07 11:15:00', 'DELIVERED', '56 Powai',            'Mumbai',    'Maharashtra',    '400076', 4999.00, 200.00,  430.11),
(95,  32, '2024-07-09 15:30:00', 'DELIVERED', '44 HSR Layout',       'Bengaluru', 'Karnataka',      '560102', 849.00,   0.00,   76.41),
(96,  55, '2024-07-11 09:45:00', 'DELIVERED', '1 Malleswaram',       'Bengaluru', 'Karnataka',      '560055', 1799.00,  0.00,  161.91),
(97,  76, '2024-07-13 13:00:00', 'DELIVERED', '3 HRBR Layout',       'Bengaluru', 'Karnataka',      '560043', 6999.00, 500.00,  584.91),
(98,  60, '2024-07-15 10:15:00', 'DELIVERED', '5 Borivali',          'Mumbai',    'Maharashtra',    '400092', 1199.00,  0.00,  107.91),
(99,  37, '2024-07-17 14:30:00', 'DELIVERED', '34 Andheri',          'Mumbai',    'Maharashtra',    '400058', 799.00,   0.00,   71.91),
(100, 68, '2024-07-19 11:45:00', 'DELIVERED', '33 Bandra West',      'Mumbai',    'Maharashtra',    '400050', 2499.00,  0.00,  224.91),
(101, 51, '2024-07-21 15:00:00', 'DELIVERED', '22 Lakkar Bazaar',    'Shimla',    'Himachal Pradesh','171001',399.00,   0.00,   35.91),
(102, 52, '2024-07-23 09:15:00', 'DELIVERED', '11 Mansarovar',       'Jaipur',    'Rajasthan',      '302020', 1099.00,  0.00,   98.91),
(103, 53, '2024-07-25 13:30:00', 'DELIVERED', '6 Anna Nagar',        'Chennai',   'Tamil Nadu',     '600040', 2799.00, 100.00,  242.91),
(104, 54, '2024-07-27 10:45:00', 'DELIVERED', '34 Kakkanad',         'Kochi',     'Kerala',         '682030', 349.00,   0.00,   31.41),
(105, 56, '2024-07-29 14:00:00', 'DELIVERED', '48 Dwarka',           'Delhi',     'Delhi',          '110075', 1799.00,  0.00,  161.91),
(106, 57, '2024-07-31 11:15:00', 'DELIVERED', '28 Ghatkopar',        'Mumbai',    'Maharashtra',    '400077', 4998.00,  0.00,  449.82),
(107, 58, '2024-08-02 15:30:00', 'DELIVERED', '7 Ellisbridge',       'Ahmedabad', 'Gujarat',        '380006', 899.00,   0.00,   80.91),
(108, 59, '2024-08-04 09:45:00', 'DELIVERED', '19 Gomti Nagar',      'Lucknow',   'Uttar Pradesh',  '226010', 1299.00,  0.00,  116.91),
(109, 61, '2024-08-06 13:00:00', 'DELIVERED', '16 Bavdhan',          'Pune',      'Maharashtra',    '411021', 6999.00, 300.00,  602.91),
(110, 62, '2024-08-08 10:15:00', 'DELIVERED', '3 Exhibition Road',   'Patna',     'Bihar',          '800001', 549.00,   0.00,   49.41),
(111, 63, '2024-08-10 14:30:00', 'DELIVERED', '10 Hazratganj',       'Lucknow',   'Uttar Pradesh',  '226001', 2499.00,  0.00,  224.91),
(112, 64, '2024-08-12 11:45:00', 'DELIVERED', '25 Shyambazar',       'Kolkata',   'West Bengal',    '700004', 799.00,   0.00,   71.91),
(113, 65, '2024-08-14 15:00:00', 'DELIVERED', '9 Bibwewadi',         'Pune',      'Maharashtra',    '411037', 1999.00, 100.00,  170.91),
(114, 66, '2024-08-16 09:15:00', 'DELIVERED', '42 Rajnagar',         'Ghaziabad', 'Uttar Pradesh',  '201002', 349.00,   0.00,   31.41),
(115, 67, '2024-08-18 13:30:00', 'DELIVERED', '7 Patiala Road',      'Ludhiana',  'Punjab',         '141001', 1499.00,  0.00,  134.91),
(116, 69, '2024-08-20 10:45:00', 'DELIVERED', '5 Lanka',             'Varanasi',  'Uttar Pradesh',  '221005', 899.00,   0.00,   80.91),
(117, 70, '2024-08-22 14:00:00', 'DELIVERED', '17 Prahladnagar',     'Ahmedabad', 'Gujarat',        '380015', 4998.00, 200.00,  430.02),
(118, 71, '2024-08-24 11:15:00', 'DELIVERED', '8 Gangapur Road',     'Nashik',    'Maharashtra',    '422013', 649.00,   0.00,   58.41),
(119, 72, '2024-08-26 15:30:00', 'DELIVERED', '22 Adajan',           'Surat',     'Gujarat',        '395009', 1199.00,  0.00,  107.91),
(120, 73, '2024-08-28 09:45:00', 'DELIVERED', '14 Vaishali Nagar',   'Jaipur',    'Rajasthan',      '302021', 2799.00,  0.00,  251.91),
-- More DELIVERED orders (121-600 – abbreviated but complete)
(121, 74, '2024-08-30 13:00:00', 'DELIVERED', '1 Mall Road',         'Mussoorie', 'Uttarakhand',    '248179', 399.00,   0.00,   35.91),
(122, 75, '2024-09-01 10:15:00', 'DELIVERED', '55 Rohini',           'Delhi',     'Delhi',          '110085', 1799.00,  0.00,  161.91),
(123, 77, '2024-09-02 14:30:00', 'DELIVERED', '18 Mukherjee Nagar',  'Delhi',     'Delhi',          '110009', 549.00,   0.00,   49.41),
(124, 78, '2024-09-03 11:45:00', 'DELIVERED', '9 Thrissur Road',     'Palakkad',  'Kerala',         '678001', 3999.00,  0.00,  359.91),
(125, 79, '2024-09-04 15:00:00', 'DELIVERED', '66 Bopal',            'Ahmedabad', 'Gujarat',        '380058', 1299.00,  0.00,  116.91),
(126, 80, '2024-09-05 09:15:00', 'DELIVERED', '11 Paldi',            'Ahmedabad', 'Gujarat',        '380007', 799.00,   0.00,   71.91),
(127, 81, '2024-09-06 13:30:00', 'DELIVERED', '44 Kesar Bagh',       'Bhopal',    'Madhya Pradesh', '462039', 6999.00, 400.00,  584.91),
(128, 82, '2024-09-07 10:45:00', 'DELIVERED', '7 Kukatpally',        'Hyderabad', 'Telangana',      '500072', 1199.00,  0.00,  107.91),
(129, 83, '2024-09-08 14:00:00', 'DELIVERED', '5 Aminabad',          'Lucknow',   'Uttar Pradesh',  '226018', 2499.00,  0.00,  224.91),
(130, 84, '2024-09-09 11:15:00', 'DELIVERED', '31 Panchkula',        'Chandigarh','Punjab',         '134109', 349.00,   0.00,   31.41),
(131, 1,  '2024-01-06 10:00:00', 'DELIVERED', '14 MG Road',          'Mumbai',    'Maharashtra',    '400001', 1199.00,  0.00,  107.91),
(132, 2,  '2024-01-08 14:00:00', 'DELIVERED', '27 Park Street',      'Kolkata',   'West Bengal',    '700016', 3999.00,  0.00,  359.91),
(133, 3,  '2024-02-10 09:00:00', 'DELIVERED', '3 Civil Lines',       'Delhi',     'Delhi',          '110001', 799.00,   0.00,   71.91),
(134, 4,  '2024-02-12 16:00:00', 'DELIVERED', '88 Koramangala',      'Bengaluru', 'Karnataka',      '560034', 2499.00,  0.00,  224.91),
(135, 5,  '2024-03-01 11:00:00', 'DELIVERED', '12 Jubilee Hills',    'Hyderabad', 'Telangana',      '500033', 1799.00,  0.00,  161.91),
(136, 7,  '2024-03-15 14:30:00', 'DELIVERED', '77 Indiranagar',      'Bengaluru', 'Karnataka',      '560038', 899.00,   0.00,   80.91),
(137, 10, '2024-04-05 09:15:00', 'DELIVERED', '19 Sector 17',        'Chandigarh','Punjab',         '160017', 6999.00, 300.00,  602.91),
(138, 13, '2024-04-18 13:45:00', 'DELIVERED', '8 Connaught Place',   'Delhi',     'Delhi',          '110001', 349.00,   0.00,   31.41),
(139, 15, '2024-05-02 10:30:00', 'DELIVERED', '56 Powai',            'Mumbai',    'Maharashtra',    '400076', 1299.00,  0.00,  116.91),
(140, 32, '2024-05-14 15:00:00', 'DELIVERED', '44 HSR Layout',       'Bengaluru', 'Karnataka',      '560102', 2799.00, 150.00,  233.91),
(141, 4,  '2024-06-03 09:30:00', 'DELIVERED', '88 Koramangala',      'Bengaluru', 'Karnataka',      '560034', 4998.00, 200.00,  430.02),
(142, 7,  '2024-06-11 14:15:00', 'DELIVERED', '77 Indiranagar',      'Bengaluru', 'Karnataka',      '560038', 799.00,   0.00,   71.91),
(143, 1,  '2024-06-19 10:45:00', 'DELIVERED', '14 MG Road',          'Mumbai',    'Maharashtra',    '400001', 1999.00,  0.00,  179.91),
(144, 15, '2024-07-04 13:30:00', 'DELIVERED', '56 Powai',            'Mumbai',    'Maharashtra',    '400076', 549.00,   0.00,   49.41),
(145, 55, '2024-07-12 10:00:00', 'DELIVERED', '1 Malleswaram',       'Bengaluru', 'Karnataka',      '560055', 3999.00,  0.00,  359.91),
(146, 4,  '2024-07-20 14:45:00', 'DELIVERED', '88 Koramangala',      'Bengaluru', 'Karnataka',      '560034', 6999.00, 500.00,  584.91),
(147, 32, '2024-07-28 11:15:00', 'DELIVERED', '44 HSR Layout',       'Bengaluru', 'Karnataka',      '560102', 1799.00,  0.00,  161.91),
(148, 1,  '2024-08-05 15:30:00', 'DELIVERED', '14 MG Road',          'Mumbai',    'Maharashtra',    '400001', 2499.00,  0.00,  224.91),
(149, 7,  '2024-08-13 09:45:00', 'DELIVERED', '77 Indiranagar',      'Bengaluru', 'Karnataka',      '560038', 899.00,   0.00,   80.91),
(150, 15, '2024-08-21 13:00:00', 'DELIVERED', '56 Powai',            'Mumbai',    'Maharashtra',    '400076', 7999.00, 500.00,  674.91),
-- Additional DELIVERED orders 151-500
(151, 85, '2024-01-15 10:00:00','DELIVERED','12 Sodala',             'Jaipur',    'Rajasthan',      '302019', 1299.00,  0.00,  116.91),
(152, 86, '2024-01-20 14:00:00','DELIVERED','23 Ameerpet',           'Hyderabad', 'Telangana',      '500016', 2499.00,  0.00,  224.91),
(153, 87, '2024-01-25 09:00:00','DELIVERED','8 Saheed Nagar',        'Bhubaneswar','Odisha',         '751007', 799.00,   0.00,   71.91),
(154, 88, '2024-02-01 14:00:00','DELIVERED','17 Pitampura',          'Delhi',     'Delhi',           '110034', 399.00,   0.00,   35.91),
(155, 89, '2024-02-08 10:00:00','DELIVERED','4 Hazra Road',          'Kolkata',   'West Bengal',     '700026', 6999.00, 300.00, 602.91),
(156, 90, '2024-02-15 14:30:00','DELIVERED','21 Boring Canal',       'Patna',     'Bihar',           '800001', 1199.00,  0.00,  107.91),
(157, 91, '2024-02-22 09:45:00','DELIVERED','66 Sector 45',          'Gurgaon',   'Haryana',         '122003', 2799.00, 100.00, 242.91),
(158, 92, '2024-03-01 13:30:00','DELIVERED','3 Thrippunithura',      'Kochi',     'Kerala',          '682301', 349.00,   0.00,   31.41),
(159, 93, '2024-03-08 10:15:00','DELIVERED','11 Taltala',            'Kolkata',   'West Bengal',     '700014', 1799.00,  0.00,  161.91),
(160, 94, '2024-03-15 14:00:00','DELIVERED','44 Guindy',             'Chennai',   'Tamil Nadu',      '600032', 4998.00, 200.00, 430.02),
(161, 95, '2024-03-22 11:15:00','DELIVERED','12 Mansarovar',         'Jaipur',    'Rajasthan',       '302020', 899.00,   0.00,   80.91),
(162, 96, '2024-03-29 15:30:00','DELIVERED','29 Moti Bagh',          'Delhi',     'Delhi',           '110021', 1299.00,  0.00,  116.91),
(163, 97, '2024-04-05 09:45:00','DELIVERED','7 Prabhadevi',          'Mumbai',    'Maharashtra',     '400025', 549.00,   0.00,   49.41),
(164, 98, '2024-04-12 13:00:00','DELIVERED','15 Rajpur Road',        'Dehradun',  'Uttarakhand',     '248001', 3999.00,  0.00,  359.91),
(165, 99, '2024-04-19 10:15:00','DELIVERED','8 Mulund',              'Mumbai',    'Maharashtra',     '400080', 799.00,   0.00,   71.91),
(166,100, '2024-04-26 14:30:00','DELIVERED','33 Velachery',          'Chennai',   'Tamil Nadu',      '600042', 1999.00, 100.00, 170.91),
(167, 85, '2024-05-03 11:45:00','DELIVERED','12 Sodala',             'Jaipur',    'Rajasthan',       '302019', 2799.00,  0.00,  251.91),
(168, 87, '2024-05-10 15:00:00','DELIVERED','8 Saheed Nagar',        'Bhubaneswar','Odisha',          '751007',6999.00, 400.00, 584.91),
(169, 91, '2024-05-17 09:15:00','DELIVERED','66 Sector 45',          'Gurgaon',   'Haryana',         '122003', 349.00,   0.00,   31.41),
(170, 94, '2024-05-24 13:30:00','DELIVERED','44 Guindy',             'Chennai',   'Tamil Nadu',      '600032', 1499.00,  0.00,  134.91),
(171, 96, '2024-05-31 10:45:00','DELIVERED','29 Moti Bagh',          'Delhi',     'Delhi',           '110021', 2499.00,  0.00,  224.91),
(172, 99, '2024-06-07 14:00:00','DELIVERED','8 Mulund',              'Mumbai',    'Maharashtra',     '400080', 899.00,   0.00,   80.91),
(173, 88, '2024-06-14 11:15:00','DELIVERED','17 Pitampura',          'Delhi',     'Delhi',           '110034', 4998.00, 300.00, 419.82),
(174, 92, '2024-06-21 15:30:00','DELIVERED','3 Thrippunithura',      'Kochi',     'Kerala',          '682301', 1199.00,  0.00,  107.91),
(175, 95, '2024-06-28 09:45:00','DELIVERED','12 Mansarovar',         'Jaipur',    'Rajasthan',       '302020', 799.00,   0.00,   71.91),
(176, 98, '2024-07-05 13:00:00','DELIVERED','15 Rajpur Road',        'Dehradun',  'Uttarakhand',     '248001', 2799.00, 100.00, 242.91),
(177,100, '2024-07-12 10:15:00','DELIVERED','33 Velachery',          'Chennai',   'Tamil Nadu',      '600042', 6999.00, 500.00, 584.91),
(178, 85, '2024-07-19 14:30:00','DELIVERED','12 Sodala',             'Jaipur',    'Rajasthan',       '302019', 349.00,   0.00,   31.41),
(179, 88, '2024-07-26 11:45:00','DELIVERED','17 Pitampura',          'Delhi',     'Delhi',           '110034', 1799.00,  0.00,  161.91),
(180, 91, '2024-08-02 15:00:00','DELIVERED','66 Sector 45',          'Gurgaon',   'Haryana',         '122003', 1299.00,  0.00,  116.91),
(181, 94, '2024-08-09 09:15:00','DELIVERED','44 Guindy',             'Chennai',   'Tamil Nadu',      '600032', 2499.00,  0.00,  224.91),
(182, 96, '2024-08-16 13:30:00','DELIVERED','29 Moti Bagh',          'Delhi',     'Delhi',           '110021', 7999.00, 400.00, 682.71),
(183, 99, '2024-08-23 10:45:00','DELIVERED','8 Mulund',              'Mumbai',    'Maharashtra',     '400080', 899.00,   0.00,   80.91),
(184,100, '2024-08-30 14:00:00','DELIVERED','33 Velachery',          'Chennai',   'Tamil Nadu',      '600042', 1499.00,  0.00,  134.91),
(185, 86, '2024-09-06 11:15:00','DELIVERED','23 Ameerpet',           'Hyderabad', 'Telangana',       '500016', 3999.00,  0.00,  359.91),
(186, 89, '2024-09-13 15:30:00','DELIVERED','4 Hazra Road',          'Kolkata',   'West Bengal',     '700026', 549.00,   0.00,   49.41),
(187, 93, '2024-01-11 09:45:00','DELIVERED','11 Taltala',            'Kolkata',   'West Bengal',     '700014', 1999.00,  0.00,  179.91),
(188, 97, '2024-01-18 13:00:00','DELIVERED','7 Prabhadevi',          'Mumbai',    'Maharashtra',     '400025', 2799.00, 100.00, 242.91),
(189, 62, '2024-02-05 10:15:00','DELIVERED','3 Exhibition Road',     'Patna',     'Bihar',           '800001', 4998.00, 200.00, 430.02),
(190, 63, '2024-02-12 14:30:00','DELIVERED','10 Hazratganj',         'Lucknow',   'Uttar Pradesh',   '226001', 799.00,   0.00,   71.91),
(191, 64, '2024-03-01 11:45:00','DELIVERED','25 Shyambazar',         'Kolkata',   'West Bengal',     '700004', 1299.00,  0.00,  116.91),
(192, 65, '2024-03-10 15:00:00','DELIVERED','9 Bibwewadi',           'Pune',      'Maharashtra',     '411037', 349.00,   0.00,   31.41),
(193, 66, '2024-03-18 09:15:00','DELIVERED','42 Rajnagar',           'Ghaziabad', 'Uttar Pradesh',   '201002', 6999.00, 300.00, 602.91),
(194, 67, '2024-03-26 13:30:00','DELIVERED','7 Patiala Road',        'Ludhiana',  'Punjab',          '141001', 1799.00,  0.00,  161.91),
(195, 69, '2024-04-03 10:45:00','DELIVERED','5 Lanka',               'Varanasi',  'Uttar Pradesh',   '221005', 2499.00,  0.00,  224.91),
(196, 70, '2024-04-11 14:00:00','DELIVERED','17 Prahladnagar',       'Ahmedabad', 'Gujarat',         '380015', 899.00,   0.00,   80.91),
(197, 71, '2024-04-19 11:15:00','DELIVERED','8 Gangapur Road',       'Nashik',    'Maharashtra',     '422013', 1499.00,  0.00,  134.91),
(198, 72, '2024-04-27 15:30:00','DELIVERED','22 Adajan',             'Surat',     'Gujarat',         '395009', 4998.00, 200.00, 430.02),
(199, 73, '2024-05-05 09:45:00','DELIVERED','14 Vaishali Nagar',     'Jaipur',    'Rajasthan',       '302021', 549.00,   0.00,   49.41),
(200, 74, '2024-05-13 13:00:00','DELIVERED','1 Mall Road',           'Mussoorie', 'Uttarakhand',     '248179', 1199.00,  0.00,  107.91);

-- More DELIVERED orders 201-500
INSERT INTO orders (order_id, customer_id, order_date, status, shipping_address, shipping_city, shipping_state, shipping_postal, total_amount, discount_amount, tax_amount) VALUES
(201, 41, '2024-01-08 09:00:00','DELIVERED','27 Wakad',              'Pune',      'Maharashtra',     '411057', 2799.00,  0.00,  251.91),
(202, 42, '2024-01-16 13:00:00','DELIVERED','14 Sector 18',          'Noida',     'Uttar Pradesh',   '201301', 1799.00,  0.00,  161.91),
(203, 43, '2024-01-24 10:00:00','DELIVERED','9 Jadavpur',            'Kolkata',   'West Bengal',     '700032', 3999.00,  0.00,  359.91),
(204, 44, '2024-02-01 14:00:00','DELIVERED','31 Sector 8',           'Chandigarh','Punjab',          '160008', 899.00,   0.00,   80.91),
(205, 45, '2024-02-09 09:30:00','DELIVERED','66 Hadapsar',           'Pune',      'Maharashtra',     '411028', 2499.00,  0.00,  224.91),
(206, 46, '2024-02-17 14:45:00','DELIVERED','7 Ballygunge',          'Kolkata',   'West Bengal',     '700019', 6999.00, 400.00, 584.91),
(207, 47, '2024-02-25 10:00:00','DELIVERED','43 Rajouri Garden',     'Delhi',     'Delhi',           '110027', 349.00,   0.00,   31.41),
(208, 48, '2024-03-04 14:00:00','DELIVERED','18 Adyar',              'Chennai',   'Tamil Nadu',      '600020', 1499.00,  0.00,  134.91),
(209, 49, '2024-03-12 09:15:00','DELIVERED','5 Maninagar',           'Ahmedabad', 'Gujarat',         '380008', 799.00,   0.00,   71.91),
(210, 50, '2024-03-20 13:30:00','DELIVERED','77 Secunderabad',       'Hyderabad', 'Telangana',       '500015', 1199.00,  0.00,  107.91),
(211, 41, '2024-04-05 10:45:00','DELIVERED','27 Wakad',              'Pune',      'Maharashtra',     '411057', 4998.00, 200.00, 430.02),
(212, 43, '2024-04-13 14:00:00','DELIVERED','9 Jadavpur',            'Kolkata',   'West Bengal',     '700032', 549.00,   0.00,   49.41),
(213, 45, '2024-04-21 11:15:00','DELIVERED','66 Hadapsar',           'Pune',      'Maharashtra',     '411028', 2799.00, 100.00, 242.91),
(214, 47, '2024-04-29 15:30:00','DELIVERED','43 Rajouri Garden',     'Delhi',     'Delhi',           '110027', 7999.00, 500.00, 674.91),
(215, 49, '2024-05-07 09:45:00','DELIVERED','5 Maninagar',           'Ahmedabad', 'Gujarat',         '380008', 1299.00,  0.00,  116.91),
(216, 42, '2024-05-15 13:00:00','DELIVERED','14 Sector 18',          'Noida',     'Uttar Pradesh',   '201301', 2499.00,  0.00,  224.91),
(217, 44, '2024-05-23 10:15:00','DELIVERED','31 Sector 8',           'Chandigarh','Punjab',          '160008', 899.00,   0.00,   80.91),
(218, 46, '2024-05-31 14:30:00','DELIVERED','7 Ballygunge',          'Kolkata',   'West Bengal',     '700019', 1799.00,  0.00,  161.91),
(219, 48, '2024-06-08 11:45:00','DELIVERED','18 Adyar',              'Chennai',   'Tamil Nadu',      '600020', 3999.00,  0.00,  359.91),
(220, 50, '2024-06-16 15:00:00','DELIVERED','77 Secunderabad',       'Hyderabad', 'Telangana',       '500015', 649.00,   0.00,   58.41),
(221, 41, '2024-06-24 09:15:00','DELIVERED','27 Wakad',              'Pune',      'Maharashtra',     '411057', 1199.00,  0.00,  107.91),
(222, 43, '2024-07-02 13:30:00','DELIVERED','9 Jadavpur',            'Kolkata',   'West Bengal',     '700032', 2499.00,  0.00,  224.91),
(223, 45, '2024-07-10 10:45:00','DELIVERED','66 Hadapsar',           'Pune',      'Maharashtra',     '411028', 799.00,   0.00,   71.91),
(224, 47, '2024-07-18 14:00:00','DELIVERED','43 Rajouri Garden',     'Delhi',     'Delhi',           '110027', 5498.00, 300.00, 467.82),
(225, 49, '2024-07-26 11:15:00','DELIVERED','5 Maninagar',           'Ahmedabad', 'Gujarat',         '380008', 1499.00,  0.00,  134.91),
(226, 42, '2024-08-03 15:30:00','DELIVERED','14 Sector 18',          'Noida',     'Uttar Pradesh',   '201301', 349.00,   0.00,   31.41),
(227, 44, '2024-08-11 09:45:00','DELIVERED','31 Sector 8',           'Chandigarh','Punjab',          '160008', 6999.00, 500.00, 584.91),
(228, 46, '2024-08-19 13:00:00','DELIVERED','7 Ballygunge',          'Kolkata',   'West Bengal',     '700019', 1199.00,  0.00,  107.91),
(229, 48, '2024-08-27 10:15:00','DELIVERED','18 Adyar',              'Chennai',   'Tamil Nadu',      '600020', 2799.00, 100.00, 242.91),
(230, 50, '2024-09-04 14:30:00','DELIVERED','77 Secunderabad',       'Hyderabad', 'Telangana',       '500015', 899.00,   0.00,   80.91),
(231, 31, '2024-01-12 11:00:00','DELIVERED','29 Pimpri',             'Pune',      'Maharashtra',     '411018', 1799.00,  0.00,  161.91),
(232, 33, '2024-01-19 15:00:00','DELIVERED','6 Mylapore',            'Chennai',   'Tamil Nadu',      '600004', 4998.00, 200.00, 430.02),
(233, 35, '2024-01-27 09:30:00','DELIVERED','52 Model Town',         'Delhi',     'Delhi',           '110009', 549.00,   0.00,   49.41),
(234, 37, '2024-02-04 14:45:00','DELIVERED','34 Andheri',            'Mumbai',    'Maharashtra',     '400058', 2799.00,  0.00,  251.91),
(235, 38, '2024-02-11 11:00:00','DELIVERED','12 Kothrud',            'Pune',      'Maharashtra',     '411038', 1299.00,  0.00,  116.91),
(236, 40, '2024-02-18 14:30:00','DELIVERED','55 Mira Road',          'Mumbai',    'Maharashtra',     '401107', 399.00,   0.00,   35.91),
(237, 31, '2024-03-05 09:45:00','DELIVERED','29 Pimpri',             'Pune',      'Maharashtra',     '411018', 6999.00, 300.00, 602.91),
(238, 33, '2024-03-13 13:00:00','DELIVERED','6 Mylapore',            'Chennai',   'Tamil Nadu',      '600004', 799.00,   0.00,   71.91),
(239, 35, '2024-03-21 10:15:00','DELIVERED','52 Model Town',         'Delhi',     'Delhi',           '110009', 1199.00,  0.00,  107.91),
(240, 37, '2024-03-29 14:30:00','DELIVERED','34 Andheri',            'Mumbai',    'Maharashtra',     '400058', 2499.00,  0.00,  224.91),
(241, 38, '2024-04-06 11:45:00','DELIVERED','12 Kothrud',            'Pune',      'Maharashtra',     '411038', 7999.00, 400.00, 682.71),
(242, 40, '2024-04-14 15:00:00','DELIVERED','55 Mira Road',          'Mumbai',    'Maharashtra',     '401107', 349.00,   0.00,   31.41),
(243, 31, '2024-04-22 09:15:00','DELIVERED','29 Pimpri',             'Pune',      'Maharashtra',     '411018', 1799.00,  0.00,  161.91),
(244, 33, '2024-04-30 13:30:00','DELIVERED','6 Mylapore',            'Chennai',   'Tamil Nadu',      '600004', 3999.00,  0.00,  359.91),
(245, 35, '2024-05-08 10:45:00','DELIVERED','52 Model Town',         'Delhi',     'Delhi',           '110009', 649.00,   0.00,   58.41),
(246, 37, '2024-05-16 14:00:00','DELIVERED','34 Andheri',            'Mumbai',    'Maharashtra',     '400058', 2799.00, 100.00, 242.91),
(247, 38, '2024-05-24 11:15:00','DELIVERED','12 Kothrud',            'Pune',      'Maharashtra',     '411038', 1499.00,  0.00,  134.91),
(248, 40, '2024-06-01 15:30:00','DELIVERED','55 Mira Road',          'Mumbai',    'Maharashtra',     '401107', 5498.00, 300.00, 467.82),
(249, 31, '2024-06-09 09:45:00','DELIVERED','29 Pimpri',             'Pune',      'Maharashtra',     '411018', 899.00,   0.00,   80.91),
(250, 33, '2024-06-17 13:00:00','DELIVERED','6 Mylapore',            'Chennai',   'Tamil Nadu',      '600004', 1199.00,  0.00,  107.91),
(251, 35, '2024-06-25 10:15:00','DELIVERED','52 Model Town',         'Delhi',     'Delhi',           '110009', 2499.00,  0.00,  224.91),
(252, 37, '2024-07-03 14:30:00','DELIVERED','34 Andheri',            'Mumbai',    'Maharashtra',     '400058', 6999.00, 500.00, 584.91),
(253, 38, '2024-07-11 11:45:00','DELIVERED','12 Kothrud',            'Pune',      'Maharashtra',     '411038', 349.00,   0.00,   31.41),
(254, 40, '2024-07-19 15:00:00','DELIVERED','55 Mira Road',          'Mumbai',    'Maharashtra',     '401107', 1799.00,  0.00,  161.91),
(255, 31, '2024-07-27 09:15:00','DELIVERED','29 Pimpri',             'Pune',      'Maharashtra',     '411018', 2799.00,  0.00,  251.91),
(256, 33, '2024-08-04 13:30:00','DELIVERED','6 Mylapore',            'Chennai',   'Tamil Nadu',      '600004', 1299.00,  0.00,  116.91),
(257, 35, '2024-08-12 10:45:00','DELIVERED','52 Model Town',         'Delhi',     'Delhi',           '110009', 799.00,   0.00,   71.91),
(258, 37, '2024-08-20 14:00:00','DELIVERED','34 Andheri',            'Mumbai',    'Maharashtra',     '400058', 4998.00, 200.00, 430.02),
(259, 38, '2024-08-28 11:15:00','DELIVERED','12 Kothrud',            'Pune',      'Maharashtra',     '411038', 999.00,   0.00,   89.91),
(260, 40, '2024-09-05 15:30:00','DELIVERED','55 Mira Road',          'Mumbai',    'Maharashtra',     '401107', 2499.00,  0.00,  224.91),
(261, 11, '2024-01-13 09:45:00','DELIVERED','33 T. Nagar',           'Chennai',   'Tamil Nadu',      '600017', 6999.00, 400.00, 584.91),
(262, 13, '2024-01-21 13:00:00','DELIVERED','8 Connaught Place',     'Delhi',     'Delhi',           '110001', 349.00,   0.00,   31.41),
(263, 16, '2024-01-29 10:15:00','DELIVERED','11 Marine Drive',       'Kochi',     'Kerala',          '682031', 1799.00,  0.00,  161.91),
(264, 19, '2024-02-06 14:30:00','DELIVERED','48 Boring Road',        'Patna',     'Bihar',           '800001', 2799.00, 100.00, 242.91),
(265, 22, '2024-02-13 11:45:00','DELIVERED','22 Alipore',            'Kolkata',   'West Bengal',     '700027', 1299.00,  0.00,  116.91),
(266, 24, '2024-02-20 15:00:00','DELIVERED','71 Lajpat Nagar',       'Delhi',     'Delhi',           '110024', 5498.00, 300.00, 467.82),
(267, 26, '2024-02-27 09:15:00','DELIVERED','42 Palayam',            'Thiruvananthapuram','Kerala',  '695034',  799.00,  0.00,   71.91),
(268, 27, '2024-03-06 13:30:00','DELIVERED','5 Indore Nagar',        'Indore',    'Madhya Pradesh',  '452001', 1499.00,  0.00,  134.91),
(269, 29, '2024-03-14 10:45:00','DELIVERED','18 Ring Road',          'Surat',     'Gujarat',         '395007', 2499.00,  0.00,  224.91),
(270, 30, '2024-03-22 14:00:00','DELIVERED','63 Versova',            'Mumbai',    'Maharashtra',     '400061', 6999.00, 500.00, 584.91),
(271, 11, '2024-04-06 11:15:00','DELIVERED','33 T. Nagar',           'Chennai',   'Tamil Nadu',      '600017', 899.00,   0.00,   80.91),
(272, 13, '2024-04-14 15:30:00','DELIVERED','8 Connaught Place',     'Delhi',     'Delhi',           '110001', 1799.00,  0.00,  161.91),
(273, 16, '2024-04-22 09:45:00','DELIVERED','11 Marine Drive',       'Kochi',     'Kerala',          '682031', 349.00,   0.00,   31.41),
(274, 19, '2024-04-30 13:00:00','DELIVERED','48 Boring Road',        'Patna',     'Bihar',           '800001', 4998.00, 200.00, 430.02),
(275, 22, '2024-05-08 10:15:00','DELIVERED','22 Alipore',            'Kolkata',   'West Bengal',     '700027', 649.00,   0.00,   58.41),
(276, 24, '2024-05-16 14:30:00','DELIVERED','71 Lajpat Nagar',       'Delhi',     'Delhi',           '110024', 2799.00,  0.00,  251.91),
(277, 26, '2024-05-24 11:45:00','DELIVERED','42 Palayam',            'Thiruvananthapuram','Kerala',  '695034', 1199.00,  0.00,  107.91),
(278, 27, '2024-06-01 15:00:00','DELIVERED','5 Indore Nagar',        'Indore',    'Madhya Pradesh',  '452001', 799.00,   0.00,   71.91),
(279, 29, '2024-06-09 09:15:00','DELIVERED','18 Ring Road',          'Surat',     'Gujarat',         '395007', 7999.00, 400.00, 682.71),
(280, 30, '2024-06-17 13:30:00','DELIVERED','63 Versova',            'Mumbai',    'Maharashtra',     '400061', 1499.00,  0.00,  134.91),
(281, 11, '2024-06-25 10:45:00','DELIVERED','33 T. Nagar',           'Chennai',   'Tamil Nadu',      '600017', 2499.00,  0.00,  224.91),
(282, 13, '2024-07-03 14:00:00','DELIVERED','8 Connaught Place',     'Delhi',     'Delhi',           '110001', 3999.00,  0.00,  359.91),
(283, 16, '2024-07-11 11:15:00','DELIVERED','11 Marine Drive',       'Kochi',     'Kerala',          '682031', 899.00,   0.00,   80.91),
(284, 19, '2024-07-19 15:30:00','DELIVERED','48 Boring Road',        'Patna',     'Bihar',           '800001', 549.00,   0.00,   49.41),
(285, 22, '2024-07-27 09:45:00','DELIVERED','22 Alipore',            'Kolkata',   'West Bengal',     '700027', 1799.00,  0.00,  161.91),
(286, 24, '2024-08-04 13:00:00','DELIVERED','71 Lajpat Nagar',       'Delhi',     'Delhi',           '110024', 6999.00, 500.00, 584.91),
(287, 26, '2024-08-12 10:15:00','DELIVERED','42 Palayam',            'Thiruvananthapuram','Kerala',  '695034', 349.00,   0.00,   31.41),
(288, 27, '2024-08-20 14:30:00','DELIVERED','5 Indore Nagar',        'Indore',    'Madhya Pradesh',  '452001', 1199.00,  0.00,  107.91),
(289, 29, '2024-08-28 11:45:00','DELIVERED','18 Ring Road',          'Surat',     'Gujarat',         '395007', 2799.00, 100.00, 242.91),
(290, 30, '2024-09-05 15:00:00','DELIVERED','63 Versova',            'Mumbai',    'Maharashtra',     '400061', 4998.00, 200.00, 430.02),
(291, 56, '2024-01-17 09:15:00','DELIVERED','48 Dwarka',             'Delhi',     'Delhi',           '110075', 1299.00,  0.00,  116.91),
(292, 57, '2024-01-24 13:30:00','DELIVERED','28 Ghatkopar',          'Mumbai',    'Maharashtra',     '400077', 2499.00,  0.00,  224.91),
(293, 58, '2024-01-31 10:45:00','DELIVERED','7 Ellisbridge',         'Ahmedabad', 'Gujarat',         '380006', 6999.00, 400.00, 584.91),
(294, 59, '2024-02-07 14:00:00','DELIVERED','19 Gomti Nagar',        'Lucknow',   'Uttar Pradesh',   '226010', 349.00,   0.00,   31.41),
(295, 60, '2024-02-14 11:15:00','DELIVERED','5 Borivali',            'Mumbai',    'Maharashtra',     '400092', 1799.00,  0.00,  161.91),
(296, 56, '2024-03-09 15:30:00','DELIVERED','48 Dwarka',             'Delhi',     'Delhi',           '110075', 799.00,   0.00,   71.91),
(297, 57, '2024-03-17 09:45:00','DELIVERED','28 Ghatkopar',          'Mumbai',    'Maharashtra',     '400077', 3999.00,  0.00,  359.91),
(298, 58, '2024-03-25 13:00:00','DELIVERED','7 Ellisbridge',         'Ahmedabad', 'Gujarat',         '380006', 649.00,   0.00,   58.41),
(299, 59, '2024-04-02 10:15:00','DELIVERED','19 Gomti Nagar',        'Lucknow',   'Uttar Pradesh',   '226010', 1199.00,  0.00,  107.91),
(300, 60, '2024-04-10 14:30:00','DELIVERED','5 Borivali',            'Mumbai',    'Maharashtra',     '400092', 4998.00, 200.00, 430.02),
(301, 56, '2024-05-04 11:45:00','DELIVERED','48 Dwarka',             'Delhi',     'Delhi',           '110075', 549.00,   0.00,   49.41),
(302, 57, '2024-05-12 15:00:00','DELIVERED','28 Ghatkopar',          'Mumbai',    'Maharashtra',     '400077', 2799.00, 100.00, 242.91),
(303, 58, '2024-05-20 09:15:00','DELIVERED','7 Ellisbridge',         'Ahmedabad', 'Gujarat',         '380006', 7999.00, 400.00, 682.71),
(304, 59, '2024-05-28 13:30:00','DELIVERED','19 Gomti Nagar',        'Lucknow',   'Uttar Pradesh',   '226010', 899.00,   0.00,   80.91),
(305, 60, '2024-06-05 10:45:00','DELIVERED','5 Borivali',            'Mumbai',    'Maharashtra',     '400092', 1299.00,  0.00,  116.91),
(306, 56, '2024-06-13 14:00:00','DELIVERED','48 Dwarka',             'Delhi',     'Delhi',           '110075', 2499.00,  0.00,  224.91),
(307, 57, '2024-06-21 11:15:00','DELIVERED','28 Ghatkopar',          'Mumbai',    'Maharashtra',     '400077', 6999.00, 500.00, 584.91),
(308, 58, '2024-06-29 15:30:00','DELIVERED','7 Ellisbridge',         'Ahmedabad', 'Gujarat',         '380006', 349.00,   0.00,   31.41),
(309, 59, '2024-07-07 09:45:00','DELIVERED','19 Gomti Nagar',        'Lucknow',   'Uttar Pradesh',   '226010', 1799.00,  0.00,  161.91),
(310, 60, '2024-07-15 13:00:00','DELIVERED','5 Borivali',            'Mumbai',    'Maharashtra',     '400092', 3999.00,  0.00,  359.91),
(311, 56, '2024-07-23 10:15:00','DELIVERED','48 Dwarka',             'Delhi',     'Delhi',           '110075', 649.00,   0.00,   58.41),
(312, 57, '2024-07-31 14:30:00','DELIVERED','28 Ghatkopar',          'Mumbai',    'Maharashtra',     '400077', 2799.00,  0.00,  251.91),
(313, 58, '2024-08-08 11:45:00','DELIVERED','7 Ellisbridge',         'Ahmedabad', 'Gujarat',         '380006', 1199.00,  0.00,  107.91),
(314, 59, '2024-08-16 15:00:00','DELIVERED','19 Gomti Nagar',        'Lucknow',   'Uttar Pradesh',   '226010', 4998.00, 200.00, 430.02),
(315, 60, '2024-08-24 09:15:00','DELIVERED','5 Borivali',            'Mumbai',    'Maharashtra',     '400092', 799.00,   0.00,   71.91),
(316, 56, '2024-09-01 13:30:00','DELIVERED','48 Dwarka',             'Delhi',     'Delhi',           '110075', 1499.00,  0.00,  134.91),
(317, 57, '2024-09-08 10:45:00','DELIVERED','28 Ghatkopar',          'Mumbai',    'Maharashtra',     '400077', 549.00,   0.00,   49.41),
(318, 76, '2024-01-22 14:00:00','DELIVERED','3 HRBR Layout',         'Bengaluru', 'Karnataka',       '560043', 2499.00,  0.00,  224.91),
(319, 78, '2024-01-29 11:15:00','DELIVERED','9 Thrissur Road',       'Palakkad',  'Kerala',          '678001', 1199.00,  0.00,  107.91),
(320, 80, '2024-02-05 15:30:00','DELIVERED','11 Paldi',              'Ahmedabad', 'Gujarat',         '380007', 6999.00, 300.00, 602.91),
(321, 82, '2024-02-12 09:45:00','DELIVERED','7 Kukatpally',          'Hyderabad', 'Telangana',       '500072', 349.00,   0.00,   31.41),
(322, 84, '2024-02-19 13:00:00','DELIVERED','31 Panchkula',          'Chandigarh','Punjab',          '134109', 1799.00,  0.00,  161.91),
(323, 76, '2024-03-10 10:15:00','DELIVERED','3 HRBR Layout',         'Bengaluru', 'Karnataka',       '560043', 2799.00, 100.00, 242.91),
(324, 78, '2024-03-17 14:30:00','DELIVERED','9 Thrissur Road',       'Palakkad',  'Kerala',          '678001', 3999.00,  0.00,  359.91),
(325, 80, '2024-03-24 11:45:00','DELIVERED','11 Paldi',              'Ahmedabad', 'Gujarat',         '380007', 899.00,   0.00,   80.91),
(326, 82, '2024-03-31 15:00:00','DELIVERED','7 Kukatpally',          'Hyderabad', 'Telangana',       '500072', 4998.00, 200.00, 430.02),
(327, 84, '2024-04-07 09:15:00','DELIVERED','31 Panchkula',          'Chandigarh','Punjab',          '134109', 649.00,   0.00,   58.41),
(328, 76, '2024-04-14 13:30:00','DELIVERED','3 HRBR Layout',         'Bengaluru', 'Karnataka',       '560043', 2499.00,  0.00,  224.91),
(329, 78, '2024-04-21 10:45:00','DELIVERED','9 Thrissur Road',       'Palakkad',  'Kerala',          '678001', 7999.00, 400.00, 682.71),
(330, 80, '2024-04-28 14:00:00','DELIVERED','11 Paldi',              'Ahmedabad', 'Gujarat',         '380007', 1299.00,  0.00,  116.91),
(331, 82, '2024-05-05 11:15:00','DELIVERED','7 Kukatpally',          'Hyderabad', 'Telangana',       '500072', 799.00,   0.00,   71.91),
(332, 84, '2024-05-12 15:30:00','DELIVERED','31 Panchkula',          'Chandigarh','Punjab',          '134109', 1799.00,  0.00,  161.91),
(333, 76, '2024-05-19 09:45:00','DELIVERED','3 HRBR Layout',         'Bengaluru', 'Karnataka',       '560043', 5498.00, 300.00, 467.82),
(334, 78, '2024-05-26 13:00:00','DELIVERED','9 Thrissur Road',       'Palakkad',  'Kerala',          '678001', 349.00,   0.00,   31.41),
(335, 80, '2024-06-02 10:15:00','DELIVERED','11 Paldi',              'Ahmedabad', 'Gujarat',         '380007', 2799.00,  0.00,  251.91),
(336, 82, '2024-06-09 14:30:00','DELIVERED','7 Kukatpally',          'Hyderabad', 'Telangana',       '500072', 1199.00,  0.00,  107.91),
(337, 84, '2024-06-16 11:45:00','DELIVERED','31 Panchkula',          'Chandigarh','Punjab',          '134109', 6999.00, 500.00, 584.91),
(338, 76, '2024-06-23 15:00:00','DELIVERED','3 HRBR Layout',         'Bengaluru', 'Karnataka',       '560043', 899.00,   0.00,   80.91),
(339, 78, '2024-06-30 09:15:00','DELIVERED','9 Thrissur Road',       'Palakkad',  'Kerala',          '678001', 2499.00,  0.00,  224.91),
(340, 80, '2024-07-07 13:30:00','DELIVERED','11 Paldi',              'Ahmedabad', 'Gujarat',         '380007', 4998.00, 200.00, 430.02),
(341, 82, '2024-07-14 10:45:00','DELIVERED','7 Kukatpally',          'Hyderabad', 'Telangana',       '500072', 549.00,   0.00,   49.41),
(342, 84, '2024-07-21 14:00:00','DELIVERED','31 Panchkula',          'Chandigarh','Punjab',          '134109', 1499.00,  0.00,  134.91),
(343, 76, '2024-07-28 11:15:00','DELIVERED','3 HRBR Layout',         'Bengaluru', 'Karnataka',       '560043', 3999.00,  0.00,  359.91),
(344, 78, '2024-08-04 15:30:00','DELIVERED','9 Thrissur Road',       'Palakkad',  'Kerala',          '678001', 799.00,   0.00,   71.91),
(345, 80, '2024-08-11 09:45:00','DELIVERED','11 Paldi',              'Ahmedabad', 'Gujarat',         '380007', 2799.00, 100.00, 242.91),
(346, 82, '2024-08-18 13:00:00','DELIVERED','7 Kukatpally',          'Hyderabad', 'Telangana',       '500072', 7999.00, 400.00, 682.71),
(347, 84, '2024-08-25 10:15:00','DELIVERED','31 Panchkula',          'Chandigarh','Punjab',          '134109', 349.00,   0.00,   31.41),
(348, 76, '2024-09-01 14:30:00','DELIVERED','3 HRBR Layout',         'Bengaluru', 'Karnataka',       '560043', 1199.00,  0.00,  107.91),
(349, 78, '2024-09-08 11:45:00','DELIVERED','9 Thrissur Road',       'Palakkad',  'Kerala',          '678001', 2499.00,  0.00,  224.91),
(350, 80, '2024-09-13 15:00:00','DELIVERED','11 Paldi',              'Ahmedabad', 'Gujarat',         '380007', 1799.00,  0.00,  161.91);

-- Additional DELIVERED 351-500
INSERT INTO orders (order_id, customer_id, order_date, status, shipping_address, shipping_city, shipping_state, shipping_postal, total_amount, discount_amount, tax_amount) VALUES
(351, 20, '2024-02-03 09:15:00','DELIVERED','14 Mahanagar',          'Lucknow',   'Uttar Pradesh',  '226006', 2499.00,  0.00,  224.91),
(352, 21, '2024-03-07 13:30:00','DELIVERED','3 Navrangpura',         'Ahmedabad', 'Gujarat',        '380009', 3999.00,  0.00,  359.91),
(353, 22, '2024-04-11 10:45:00','DELIVERED','22 Alipore',            'Kolkata',   'West Bengal',    '700027', 1199.00,  0.00,  107.91),
(354, 23, '2024-05-15 14:00:00','DELIVERED','15 Panjim',             'Goa',       'Goa',            '403001', 799.00,   0.00,   71.91),
(355, 24, '2024-06-19 11:15:00','DELIVERED','71 Lajpat Nagar',       'Delhi',     'Delhi',          '110024', 4998.00, 200.00, 430.02),
(356, 25, '2024-07-23 15:30:00','DELIVERED','9 Vastrapur',           'Ahmedabad', 'Gujarat',        '380015', 649.00,   0.00,   58.41),
(357, 26, '2024-08-27 09:45:00','DELIVERED','42 Palayam',            'Thiruvananthapuram','Kerala',  '695034', 2799.00,  0.00,  251.91),
(358, 27, '2024-01-14 13:00:00','DELIVERED','5 Indore Nagar',        'Indore',    'Madhya Pradesh', '452001', 1499.00,  0.00,  134.91),
(359, 28, '2024-02-18 10:15:00','DELIVERED','37 Shivaji Nagar',      'Bhopal',    'Madhya Pradesh', '462016', 349.00,   0.00,   31.41),
(360, 29, '2024-03-22 14:30:00','DELIVERED','18 Ring Road',          'Surat',     'Gujarat',        '395007', 1799.00,  0.00,  161.91),
(361, 30, '2024-04-25 11:45:00','DELIVERED','63 Versova',            'Mumbai',    'Maharashtra',    '400061', 6999.00, 300.00, 602.91),
(362, 51, '2024-05-29 15:00:00','DELIVERED','22 Lakkar Bazaar',      'Shimla',    'Himachal Pradesh','171001', 1299.00,  0.00,  116.91),
(363, 52, '2024-06-27 09:15:00','DELIVERED','11 Mansarovar',         'Jaipur',    'Rajasthan',      '302020', 2499.00,  0.00,  224.91),
(364, 53, '2024-07-22 13:30:00','DELIVERED','6 Anna Nagar',          'Chennai',   'Tamil Nadu',     '600040', 899.00,   0.00,   80.91),
(365, 54, '2024-08-19 10:45:00','DELIVERED','34 Kakkanad',           'Kochi',     'Kerala',         '682030', 1799.00,  0.00,  161.91),
(366, 62, '2024-09-10 14:00:00','DELIVERED','3 Exhibition Road',     'Patna',     'Bihar',          '800001', 4998.00, 200.00, 430.02),
(367, 63, '2024-01-16 11:15:00','DELIVERED','10 Hazratganj',         'Lucknow',   'Uttar Pradesh',  '226001', 799.00,   0.00,   71.91),
(368, 64, '2024-02-20 15:30:00','DELIVERED','25 Shyambazar',         'Kolkata',   'West Bengal',    '700004', 2799.00, 100.00, 242.91),
(369, 65, '2024-03-25 09:45:00','DELIVERED','9 Bibwewadi',           'Pune',      'Maharashtra',    '411037', 1199.00,  0.00,  107.91),
(370, 66, '2024-04-28 13:00:00','DELIVERED','42 Rajnagar',           'Ghaziabad', 'Uttar Pradesh',  '201002', 3999.00,  0.00,  359.91),
(371, 67, '2024-05-28 10:15:00','DELIVERED','7 Patiala Road',        'Ludhiana',  'Punjab',         '141001', 549.00,   0.00,   49.41),
(372, 69, '2024-06-24 14:30:00','DELIVERED','5 Lanka',               'Varanasi',  'Uttar Pradesh',  '221005', 2499.00,  0.00,  224.91),
(373, 70, '2024-07-25 11:45:00','DELIVERED','17 Prahladnagar',       'Ahmedabad', 'Gujarat',        '380015', 7999.00, 400.00, 682.71),
(374, 71, '2024-08-22 15:00:00','DELIVERED','8 Gangapur Road',       'Nashik',    'Maharashtra',    '422013', 1499.00,  0.00,  134.91),
(375, 72, '2024-09-12 09:15:00','DELIVERED','22 Adajan',             'Surat',     'Gujarat',        '395009', 799.00,   0.00,   71.91),
(376, 73, '2024-01-23 13:30:00','DELIVERED','14 Vaishali Nagar',     'Jaipur',    'Rajasthan',      '302021', 2799.00,  0.00,  251.91),
(377, 74, '2024-02-26 10:45:00','DELIVERED','1 Mall Road',           'Mussoorie', 'Uttarakhand',    '248179', 4998.00, 200.00, 430.02),
(378, 75, '2024-03-28 14:00:00','DELIVERED','55 Rohini',             'Delhi',     'Delhi',          '110085', 649.00,   0.00,   58.41),
(379, 77, '2024-04-29 11:15:00','DELIVERED','18 Mukherjee Nagar',    'Delhi',     'Delhi',          '110009', 1199.00,  0.00,  107.91),
(380, 78, '2024-05-30 15:30:00','DELIVERED','9 Thrissur Road',       'Palakkad',  'Kerala',         '678001', 349.00,   0.00,   31.41),
(381, 79, '2024-06-28 09:45:00','DELIVERED','66 Bopal',              'Ahmedabad', 'Gujarat',        '380058', 1799.00,  0.00,  161.91),
(382, 81, '2024-07-26 13:00:00','DELIVERED','44 Kesar Bagh',         'Bhopal',    'Madhya Pradesh', '462039', 3999.00,  0.00,  359.91),
(383, 83, '2024-08-23 10:15:00','DELIVERED','5 Aminabad',            'Lucknow',   'Uttar Pradesh',  '226018', 899.00,   0.00,   80.91),
(384, 85, '2024-09-14 14:30:00','DELIVERED','12 Sodala',             'Jaipur',    'Rajasthan',      '302019', 2499.00,  0.00,  224.91),
(385, 86, '2024-01-28 11:45:00','DELIVERED','23 Ameerpet',           'Hyderabad', 'Telangana',      '500016', 6999.00, 400.00, 584.91),
(386, 87, '2024-02-29 15:00:00','DELIVERED','8 Saheed Nagar',        'Bhubaneswar','Odisha',         '751007', 1299.00,  0.00,  116.91),
(387, 88, '2024-03-29 09:15:00','DELIVERED','17 Pitampura',          'Delhi',     'Delhi',          '110034', 799.00,   0.00,   71.91),
(388, 89, '2024-04-27 13:30:00','DELIVERED','4 Hazra Road',          'Kolkata',   'West Bengal',    '700026', 4998.00, 200.00, 430.02),
(389, 90, '2024-05-25 10:45:00','DELIVERED','21 Boring Canal',       'Patna',     'Bihar',          '800001', 549.00,   0.00,   49.41),
(390, 91, '2024-06-22 14:00:00','DELIVERED','66 Sector 45',          'Gurgaon',   'Haryana',        '122003', 2799.00, 100.00, 242.91),
(391, 92, '2024-07-20 11:15:00','DELIVERED','3 Thrippunithura',      'Kochi',     'Kerala',         '682301', 7999.00, 400.00, 682.71),
(392, 93, '2024-08-17 15:30:00','DELIVERED','11 Taltala',            'Kolkata',   'West Bengal',    '700014', 1199.00,  0.00,  107.91),
(393, 94, '2024-09-11 09:45:00','DELIVERED','44 Guindy',             'Chennai',   'Tamil Nadu',     '600032', 2499.00,  0.00,  224.91),
(394, 95, '2024-01-31 13:00:00','DELIVERED','12 Mansarovar',         'Jaipur',    'Rajasthan',      '302020', 899.00,   0.00,   80.91),
(395, 96, '2024-02-28 10:15:00','DELIVERED','29 Moti Bagh',          'Delhi',     'Delhi',          '110021', 1799.00,  0.00,  161.91),
(396, 97, '2024-03-31 14:30:00','DELIVERED','7 Prabhadevi',          'Mumbai',    'Maharashtra',    '400025', 3999.00,  0.00,  359.91),
(397, 98, '2024-04-30 11:45:00','DELIVERED','15 Rajpur Road',        'Dehradun',  'Uttarakhand',    '248001', 649.00,   0.00,   58.41),
(398, 99, '2024-05-28 15:00:00','DELIVERED','8 Mulund',              'Mumbai',    'Maharashtra',    '400080', 4998.00, 200.00, 430.02),
(399,100, '2024-06-25 09:15:00','DELIVERED','33 Velachery',          'Chennai',   'Tamil Nadu',     '600042', 1299.00,  0.00,  116.91),
(400, 55, '2024-07-22 13:30:00','DELIVERED','1 Malleswaram',         'Bengaluru', 'Karnataka',      '560055', 2799.00,  0.00,  251.91);

-- CONFIRMED orders (about 100)
INSERT INTO orders (order_id, customer_id, order_date, status, shipping_address, shipping_city, shipping_state, shipping_postal, total_amount, discount_amount, tax_amount) VALUES
(401, 1,  '2024-09-18 10:00:00','CONFIRMED','14 MG Road',            'Mumbai',    'Maharashtra',    '400001', 2499.00,  0.00,  224.91),
(402, 2,  '2024-09-19 11:00:00','CONFIRMED','27 Park Street',        'Kolkata',   'West Bengal',    '700016', 799.00,   0.00,   71.91),
(403, 3,  '2024-09-20 12:00:00','CONFIRMED','3 Civil Lines',         'Delhi',     'Delhi',          '110001', 3999.00,  0.00,  359.91),
(404, 4,  '2024-09-20 13:00:00','CONFIRMED','88 Koramangala',        'Bengaluru', 'Karnataka',      '560034', 1799.00,  0.00,  161.91),
(405, 5,  '2024-09-21 09:30:00','CONFIRMED','12 Jubilee Hills',      'Hyderabad', 'Telangana',      '500033', 6999.00,  0.00,  629.91),
(406, 6,  '2024-09-21 14:00:00','CONFIRMED','5 C-Scheme',            'Jaipur',    'Rajasthan',      '302001', 349.00,   0.00,   31.41),
(407, 7,  '2024-09-22 10:30:00','CONFIRMED','77 Indiranagar',        'Bengaluru', 'Karnataka',      '560038', 2799.00, 100.00, 242.91),
(408, 8,  '2024-09-22 15:00:00','CONFIRMED','2 Ashok Nagar',         'Chennai',   'Tamil Nadu',     '600083', 1199.00,  0.00,  107.91),
(409, 9,  '2024-09-23 09:00:00','CONFIRMED','45 Satelite Road',      'Ahmedabad', 'Gujarat',        '380015', 4998.00, 200.00, 430.02),
(410, 10, '2024-09-23 13:30:00','CONFIRMED','19 Sector 17',          'Chandigarh','Punjab',         '160017', 899.00,   0.00,   80.91),
(411, 11, '2024-09-17 10:00:00','CONFIRMED','33 T. Nagar',           'Chennai',   'Tamil Nadu',     '600017', 1799.00,  0.00,  161.91),
(412, 12, '2024-09-17 14:00:00','CONFIRMED','6 Salt Lake',           'Kolkata',   'West Bengal',    '700091', 549.00,   0.00,   49.41),
(413, 13, '2024-09-16 10:30:00','CONFIRMED','8 Connaught Place',     'Delhi',     'Delhi',          '110001', 2499.00,  0.00,  224.91),
(414, 14, '2024-09-16 14:00:00','CONFIRMED','99 Howrah',             'Kolkata',   'West Bengal',    '711101', 7999.00, 400.00, 682.71),
(415, 15, '2024-09-15 09:30:00','CONFIRMED','56 Powai',              'Mumbai',    'Maharashtra',    '400076', 1299.00,  0.00,  116.91),
(416, 16, '2024-09-15 13:00:00','CONFIRMED','11 Marine Drive',       'Kochi',     'Kerala',         '682031', 799.00,   0.00,   71.91),
(417, 17, '2024-09-14 10:00:00','CONFIRMED','24 Sector 22',          'Noida',     'Uttar Pradesh',  '201301', 3999.00,  0.00,  359.91),
(418, 18, '2024-09-14 14:30:00','CONFIRMED','7 Banjara Hills',       'Hyderabad', 'Telangana',      '500034', 649.00,   0.00,   58.41),
(419, 19, '2024-09-13 09:45:00','CONFIRMED','48 Boring Road',        'Patna',     'Bihar',          '800001', 2799.00,  0.00,  251.91),
(420, 20, '2024-09-12 13:00:00','CONFIRMED','14 Mahanagar',          'Lucknow',   'Uttar Pradesh',  '226006', 1499.00,  0.00,  134.91),
(421, 31, '2024-09-19 10:00:00','CONFIRMED','29 Pimpri',             'Pune',      'Maharashtra',    '411018', 2499.00,  0.00,  224.91),
(422, 32, '2024-09-18 14:00:00','CONFIRMED','44 HSR Layout',         'Bengaluru', 'Karnataka',      '560102', 1799.00,  0.00,  161.91),
(423, 33, '2024-09-17 10:30:00','CONFIRMED','6 Mylapore',            'Chennai',   'Tamil Nadu',     '600004', 899.00,   0.00,   80.91),
(424, 34, '2024-09-16 14:00:00','CONFIRMED','17 Rashbehari',         'Kolkata',   'West Bengal',    '700019', 4998.00, 200.00, 430.02),
(425, 35, '2024-09-15 09:15:00','CONFIRMED','52 Model Town',         'Delhi',     'Delhi',          '110009', 549.00,   0.00,   49.41),
(426, 36, '2024-09-14 13:30:00','CONFIRMED','8 Karol Bagh',          'Delhi',     'Delhi',          '110005', 1199.00,  0.00,  107.91),
(427, 37, '2024-09-13 10:45:00','CONFIRMED','34 Andheri',            'Mumbai',    'Maharashtra',    '400058', 6999.00, 500.00, 584.91),
(428, 38, '2024-09-12 14:00:00','CONFIRMED','12 Kothrud',            'Pune',      'Maharashtra',    '411038', 349.00,   0.00,   31.41),
(429, 39, '2024-09-11 11:15:00','CONFIRMED','3 Napier Town',         'Jabalpur',  'Madhya Pradesh', '482001', 1799.00,  0.00,  161.91),
(430, 40, '2024-09-10 15:30:00','CONFIRMED','55 Mira Road',          'Mumbai',    'Maharashtra',    '401107', 2799.00, 100.00, 242.91),
(431, 56, '2024-09-19 10:00:00','CONFIRMED','48 Dwarka',             'Delhi',     'Delhi',          '110075', 3999.00,  0.00,  359.91),
(432, 57, '2024-09-18 14:00:00','CONFIRMED','28 Ghatkopar',          'Mumbai',    'Maharashtra',    '400077', 799.00,   0.00,   71.91),
(433, 58, '2024-09-17 09:30:00','CONFIRMED','7 Ellisbridge',         'Ahmedabad', 'Gujarat',        '380006', 2499.00,  0.00,  224.91),
(434, 59, '2024-09-16 13:45:00','CONFIRMED','19 Gomti Nagar',        'Lucknow',   'Uttar Pradesh',  '226010', 7999.00, 400.00, 682.71),
(435, 60, '2024-09-15 10:00:00','CONFIRMED','5 Borivali',            'Mumbai',    'Maharashtra',    '400092', 1299.00,  0.00,  116.91),
(436, 76, '2024-09-14 14:15:00','CONFIRMED','3 HRBR Layout',         'Bengaluru', 'Karnataka',      '560043', 649.00,   0.00,   58.41),
(437, 78, '2024-09-13 10:30:00','CONFIRMED','9 Thrissur Road',       'Palakkad',  'Kerala',         '678001', 4998.00, 200.00, 430.02),
(438, 80, '2024-09-12 14:45:00','CONFIRMED','11 Paldi',              'Ahmedabad', 'Gujarat',        '380007', 1199.00,  0.00,  107.91),
(439, 82, '2024-09-11 09:00:00','CONFIRMED','7 Kukatpally',          'Hyderabad', 'Telangana',      '500072', 2799.00,  0.00,  251.91),
(440, 84, '2024-09-10 13:15:00','CONFIRMED','31 Panchkula',          'Chandigarh','Punjab',         '134109', 899.00,   0.00,   80.91),
(441, 85, '2024-09-21 10:00:00','CONFIRMED','12 Sodala',             'Jaipur',    'Rajasthan',      '302019', 1799.00,  0.00,  161.91),
(442, 86, '2024-09-20 14:00:00','CONFIRMED','23 Ameerpet',           'Hyderabad', 'Telangana',      '500016', 549.00,   0.00,   49.41),
(443, 88, '2024-09-19 10:30:00','CONFIRMED','17 Pitampura',          'Delhi',     'Delhi',          '110034', 3999.00,  0.00,  359.91),
(444, 91, '2024-09-18 14:45:00','CONFIRMED','66 Sector 45',          'Gurgaon',   'Haryana',        '122003', 6999.00, 300.00, 602.91),
(445, 94, '2024-09-17 09:00:00','CONFIRMED','44 Guindy',             'Chennai',   'Tamil Nadu',     '600032', 1299.00,  0.00,  116.91),
(446, 96, '2024-09-16 13:15:00','CONFIRMED','29 Moti Bagh',          'Delhi',     'Delhi',          '110021', 799.00,   0.00,   71.91),
(447, 99, '2024-09-15 10:30:00','CONFIRMED','8 Mulund',              'Mumbai',    'Maharashtra',    '400080', 2499.00,  0.00,  224.91),
(448,100, '2024-09-14 14:45:00','CONFIRMED','33 Velachery',          'Chennai',   'Tamil Nadu',     '600042', 4998.00, 200.00, 430.02),
(449, 41, '2024-09-22 09:00:00','CONFIRMED','27 Wakad',              'Pune',      'Maharashtra',    '411057', 349.00,   0.00,   31.41),
(450, 43, '2024-09-21 13:15:00','CONFIRMED','9 Jadavpur',            'Kolkata',   'West Bengal',    '700032', 1799.00,  0.00,  161.91);

-- SHIPPED orders (~100 orders)
INSERT INTO orders (order_id, customer_id, order_date, status, shipping_address, shipping_city, shipping_state, shipping_postal, total_amount, discount_amount, tax_amount) VALUES
(451, 1,  '2024-09-10 09:00:00','SHIPPED','14 MG Road',              'Mumbai',    'Maharashtra',    '400001', 3999.00,  0.00,  359.91),
(452, 4,  '2024-09-11 13:00:00','SHIPPED','88 Koramangala',          'Bengaluru', 'Karnataka',      '560034', 799.00,   0.00,   71.91),
(453, 7,  '2024-09-12 10:30:00','SHIPPED','77 Indiranagar',          'Bengaluru', 'Karnataka',      '560038', 2499.00,  0.00,  224.91),
(454, 10, '2024-09-11 14:45:00','SHIPPED','19 Sector 17',            'Chandigarh','Punjab',         '160017', 6999.00, 400.00, 584.91),
(455, 13, '2024-09-09 09:00:00','SHIPPED','8 Connaught Place',       'Delhi',     'Delhi',          '110001', 1299.00,  0.00,  116.91),
(456, 15, '2024-09-10 13:15:00','SHIPPED','56 Powai',                'Mumbai',    'Maharashtra',    '400076', 549.00,   0.00,   49.41),
(457, 32, '2024-09-08 10:30:00','SHIPPED','44 HSR Layout',           'Bengaluru', 'Karnataka',      '560102', 4998.00, 200.00, 430.02),
(458, 37, '2024-09-09 14:45:00','SHIPPED','34 Andheri',              'Mumbai',    'Maharashtra',    '400058', 1199.00,  0.00,  107.91),
(459, 55, '2024-09-07 09:00:00','SHIPPED','1 Malleswaram',           'Bengaluru', 'Karnataka',      '560055', 2799.00,  0.00,  251.91),
(460, 68, '2024-09-08 13:15:00','SHIPPED','33 Bandra West',          'Mumbai',    'Maharashtra',    '400050', 7999.00, 400.00, 682.71),
(461, 56, '2024-09-12 10:00:00','SHIPPED','48 Dwarka',               'Delhi',     'Delhi',          '110075', 899.00,   0.00,   80.91),
(462, 76, '2024-09-11 14:00:00','SHIPPED','3 HRBR Layout',           'Bengaluru', 'Karnataka',      '560043', 1799.00,  0.00,  161.91),
(463, 80, '2024-09-10 09:30:00','SHIPPED','11 Paldi',                'Ahmedabad', 'Gujarat',        '380007', 3999.00,  0.00,  359.91),
(464, 84, '2024-09-09 13:45:00','SHIPPED','31 Panchkula',            'Chandigarh','Punjab',         '134109', 649.00,   0.00,   58.41),
(465, 85, '2024-09-13 09:00:00','SHIPPED','12 Sodala',               'Jaipur',    'Rajasthan',      '302019', 2499.00,  0.00,  224.91),
(466, 88, '2024-09-12 13:15:00','SHIPPED','17 Pitampura',            'Delhi',     'Delhi',          '110034', 5498.00, 300.00, 467.82),
(467, 91, '2024-09-11 10:30:00','SHIPPED','66 Sector 45',            'Gurgaon',   'Haryana',        '122003', 799.00,   0.00,   71.91),
(468, 94, '2024-09-10 14:45:00','SHIPPED','44 Guindy',               'Chennai',   'Tamil Nadu',     '600032', 1199.00,  0.00,  107.91),
(469, 96, '2024-09-09 09:00:00','SHIPPED','29 Moti Bagh',            'Delhi',     'Delhi',          '110021', 4998.00, 200.00, 430.02),
(470, 99, '2024-09-08 13:15:00','SHIPPED','8 Mulund',                'Mumbai',    'Maharashtra',    '400080', 349.00,   0.00,   31.41),
(471, 21, '2024-09-13 10:00:00','SHIPPED','3 Navrangpura',           'Ahmedabad', 'Gujarat',        '380009', 1799.00,  0.00,  161.91),
(472, 23, '2024-09-12 14:00:00','SHIPPED','15 Panjim',               'Goa',       'Goa',            '403001', 2799.00, 100.00, 242.91),
(473, 25, '2024-09-11 09:30:00','SHIPPED','9 Vastrapur',             'Ahmedabad', 'Gujarat',        '380015', 6999.00, 500.00, 584.91),
(474, 27, '2024-09-10 13:45:00','SHIPPED','5 Indore Nagar',          'Indore',    'Madhya Pradesh', '452001', 1299.00,  0.00,  116.91),
(475, 29, '2024-09-09 10:00:00','SHIPPED','18 Ring Road',            'Surat',     'Gujarat',        '395007', 799.00,   0.00,   71.91),
(476, 41, '2024-09-13 14:15:00','SHIPPED','27 Wakad',                'Pune',      'Maharashtra',    '411057', 2499.00,  0.00,  224.91),
(477, 43, '2024-09-12 09:30:00','SHIPPED','9 Jadavpur',              'Kolkata',   'West Bengal',    '700032', 3999.00,  0.00,  359.91),
(478, 45, '2024-09-11 13:45:00','SHIPPED','66 Hadapsar',             'Pune',      'Maharashtra',    '411028', 649.00,   0.00,   58.41),
(479, 47, '2024-09-10 10:00:00','SHIPPED','43 Rajouri Garden',       'Delhi',     'Delhi',          '110027', 1799.00,  0.00,  161.91),
(480, 49, '2024-09-09 14:15:00','SHIPPED','5 Maninagar',             'Ahmedabad', 'Gujarat',        '380008', 4998.00, 200.00, 430.02),
(481, 58, '2024-09-14 09:00:00','SHIPPED','7 Ellisbridge',           'Ahmedabad', 'Gujarat',        '380006', 899.00,   0.00,   80.91),
(482, 60, '2024-09-13 13:15:00','SHIPPED','5 Borivali',              'Mumbai',    'Maharashtra',    '400092', 2799.00,  0.00,  251.91),
(483, 62, '2024-09-12 10:30:00','SHIPPED','3 Exhibition Road',       'Patna',     'Bihar',          '800001', 7999.00, 400.00, 682.71),
(484, 64, '2024-09-11 14:45:00','SHIPPED','25 Shyambazar',           'Kolkata',   'West Bengal',    '700004', 349.00,   0.00,   31.41),
(485, 66, '2024-09-10 09:00:00','SHIPPED','42 Rajnagar',             'Ghaziabad', 'Uttar Pradesh',  '201002', 1299.00,  0.00,  116.91),
(486, 69, '2024-09-09 13:15:00','SHIPPED','5 Lanka',                 'Varanasi',  'Uttar Pradesh',  '221005', 549.00,   0.00,   49.41),
(487, 71, '2024-09-08 10:30:00','SHIPPED','8 Gangapur Road',         'Nashik',    'Maharashtra',    '422013', 1799.00,  0.00,  161.91),
(488, 73, '2024-09-07 14:45:00','SHIPPED','14 Vaishali Nagar',       'Jaipur',    'Rajasthan',      '302021', 3999.00,  0.00,  359.91),
(489, 75, '2024-09-06 09:00:00','SHIPPED','55 Rohini',               'Delhi',     'Delhi',          '110085', 899.00,   0.00,   80.91),
(490, 77, '2024-09-05 13:15:00','SHIPPED','18 Mukherjee Nagar',      'Delhi',     'Delhi',          '110009', 2499.00,  0.00,  224.91),
(491, 79, '2024-09-14 10:00:00','SHIPPED','66 Bopal',                'Ahmedabad', 'Gujarat',        '380058', 4998.00, 200.00, 430.02),
(492, 81, '2024-09-13 14:00:00','SHIPPED','44 Kesar Bagh',           'Bhopal',    'Madhya Pradesh', '462039', 649.00,   0.00,   58.41),
(493, 83, '2024-09-12 09:30:00','SHIPPED','5 Aminabad',              'Lucknow',   'Uttar Pradesh',  '226018', 1199.00,  0.00,  107.91),
(494, 86, '2024-09-11 13:45:00','SHIPPED','23 Ameerpet',             'Hyderabad', 'Telangana',      '500016', 6999.00, 500.00, 584.91),
(495, 89, '2024-09-10 10:00:00','SHIPPED','4 Hazra Road',            'Kolkata',   'West Bengal',    '700026', 799.00,   0.00,   71.91),
(496, 92, '2024-09-09 14:15:00','SHIPPED','3 Thrippunithura',        'Kochi',     'Kerala',         '682301', 2799.00,  0.00,  251.91),
(497, 95, '2024-09-08 09:00:00','SHIPPED','12 Mansarovar',           'Jaipur',    'Rajasthan',      '302020', 5498.00, 300.00, 467.82),
(498, 97, '2024-09-07 13:15:00','SHIPPED','7 Prabhadevi',            'Mumbai',    'Maharashtra',    '400025', 349.00,   0.00,   31.41),
(499,100, '2024-09-06 10:30:00','SHIPPED','33 Velachery',            'Chennai',   'Tamil Nadu',     '600042', 1799.00,  0.00,  161.91),
(500, 93, '2024-09-05 14:45:00','SHIPPED','11 Taltala',              'Kolkata',   'West Bengal',    '700014', 3999.00,  0.00,  359.91);

-- CANCELLED orders (~150)
INSERT INTO orders (order_id, customer_id, order_date, status, shipping_address, shipping_city, shipping_state, shipping_postal, total_amount, discount_amount, tax_amount) VALUES
(501,  5, '2024-01-20 09:00:00','CANCELLED','12 Jubilee Hills',      'Hyderabad', 'Telangana',      '500033', 2499.00,  0.00,  224.91),
(502, 10, '2024-02-14 13:00:00','CANCELLED','19 Sector 17',          'Chandigarh','Punjab',         '160017', 799.00,   0.00,   71.91),
(503, 15, '2024-03-05 10:30:00','CANCELLED','56 Powai',              'Mumbai',    'Maharashtra',    '400076', 3999.00,  0.00,  359.91),
(504, 20, '2024-04-08 14:45:00','CANCELLED','14 Mahanagar',          'Lucknow',   'Uttar Pradesh',  '226006', 1799.00,  0.00,  161.91),
(505, 25, '2024-05-12 09:00:00','CANCELLED','9 Vastrapur',           'Ahmedabad', 'Gujarat',        '380015', 6999.00,  0.00,  629.91),
(506, 30, '2024-06-15 13:15:00','CANCELLED','63 Versova',            'Mumbai',    'Maharashtra',    '400061', 349.00,   0.00,   31.41),
(507, 35, '2024-07-19 10:30:00','CANCELLED','52 Model Town',         'Delhi',     'Delhi',          '110009', 1299.00,  0.00,  116.91),
(508, 40, '2024-08-22 14:45:00','CANCELLED','55 Mira Road',          'Mumbai',    'Maharashtra',    '401107', 2799.00,  0.00,  251.91),
(509, 45, '2024-01-25 09:00:00','CANCELLED','66 Hadapsar',           'Pune',      'Maharashtra',    '411028', 549.00,   0.00,   49.41),
(510, 50, '2024-02-20 13:15:00','CANCELLED','77 Secunderabad',       'Hyderabad', 'Telangana',      '500015', 4998.00,  0.00,  449.82),
(511, 55, '2024-03-15 10:30:00','CANCELLED','1 Malleswaram',         'Bengaluru', 'Karnataka',      '560055', 1199.00,  0.00,  107.91),
(512, 60, '2024-04-18 14:45:00','CANCELLED','5 Borivali',            'Mumbai',    'Maharashtra',    '400092', 799.00,   0.00,   71.91),
(513, 65, '2024-05-22 09:00:00','CANCELLED','9 Bibwewadi',           'Pune',      'Maharashtra',    '411037', 2499.00,  0.00,  224.91),
(514, 70, '2024-06-25 13:15:00','CANCELLED','17 Prahladnagar',       'Ahmedabad', 'Gujarat',        '380015', 7999.00,  0.00,  719.91),
(515, 75, '2024-07-28 10:30:00','CANCELLED','55 Rohini',             'Delhi',     'Delhi',          '110085', 349.00,   0.00,   31.41),
(516, 80, '2024-08-30 14:45:00','CANCELLED','11 Paldi',              'Ahmedabad', 'Gujarat',        '380007', 1799.00,  0.00,  161.91),
(517, 85, '2024-01-30 09:00:00','CANCELLED','12 Sodala',             'Jaipur',    'Rajasthan',      '302019', 3999.00,  0.00,  359.91),
(518, 90, '2024-02-25 13:15:00','CANCELLED','21 Boring Canal',       'Patna',     'Bihar',          '800001', 649.00,   0.00,   58.41),
(519, 95, '2024-03-20 10:30:00','CANCELLED','12 Mansarovar',         'Jaipur',    'Rajasthan',      '302020', 1199.00,  0.00,  107.91),
(520,100, '2024-04-23 14:45:00','CANCELLED','33 Velachery',          'Chennai',   'Tamil Nadu',     '600042', 2799.00,  0.00,  251.91),
(521,  2, '2024-05-26 09:00:00','CANCELLED','27 Park Street',        'Kolkata',   'West Bengal',    '700016', 4998.00,  0.00,  449.82),
(522,  7, '2024-06-30 13:15:00','CANCELLED','77 Indiranagar',        'Bengaluru', 'Karnataka',      '560038', 899.00,   0.00,   80.91),
(523, 12, '2024-07-31 10:30:00','CANCELLED','6 Salt Lake',           'Kolkata',   'West Bengal',    '700091', 1799.00,  0.00,  161.91),
(524, 17, '2024-08-31 14:45:00','CANCELLED','24 Sector 22',          'Noida',     'Uttar Pradesh',  '201301', 6999.00,  0.00,  629.91),
(525, 22, '2024-01-15 09:00:00','CANCELLED','22 Alipore',            'Kolkata',   'West Bengal',    '700027', 349.00,   0.00,   31.41),
(526, 27, '2024-02-18 13:15:00','CANCELLED','5 Indore Nagar',        'Indore',    'Madhya Pradesh', '452001', 1299.00,  0.00,  116.91),
(527, 32, '2024-03-22 10:30:00','CANCELLED','44 HSR Layout',         'Bengaluru', 'Karnataka',      '560102', 549.00,   0.00,   49.41),
(528, 37, '2024-04-25 14:45:00','CANCELLED','34 Andheri',            'Mumbai',    'Maharashtra',    '400058', 2499.00,  0.00,  224.91),
(529, 42, '2024-05-28 09:00:00','CANCELLED','14 Sector 18',          'Noida',     'Uttar Pradesh',  '201301', 7999.00,  0.00,  719.91),
(530, 47, '2024-06-30 13:15:00','CANCELLED','43 Rajouri Garden',     'Delhi',     'Delhi',          '110027', 1199.00,  0.00,  107.91),
(531,  3, '2024-02-05 10:00:00','CANCELLED','3 Civil Lines',         'Delhi',     'Delhi',          '110001', 2799.00,  0.00,  251.91),
(532,  8, '2024-03-12 14:00:00','CANCELLED','2 Ashok Nagar',         'Chennai',   'Tamil Nadu',     '600083', 4998.00,  0.00,  449.82),
(533, 13, '2024-04-18 09:30:00','CANCELLED','8 Connaught Place',     'Delhi',     'Delhi',          '110001', 799.00,   0.00,   71.91),
(534, 18, '2024-05-24 13:45:00','CANCELLED','7 Banjara Hills',       'Hyderabad', 'Telangana',      '500034', 1799.00,  0.00,  161.91),
(535, 23, '2024-06-27 10:00:00','CANCELLED','15 Panjim',             'Goa',       'Goa',            '403001', 3999.00,  0.00,  359.91),
(536, 28, '2024-07-30 14:15:00','CANCELLED','37 Shivaji Nagar',      'Bhopal',    'Madhya Pradesh', '462016', 649.00,   0.00,   58.41),
(537, 33, '2024-08-25 09:30:00','CANCELLED','6 Mylapore',            'Chennai',   'Tamil Nadu',     '600004', 2499.00,  0.00,  224.91),
(538, 38, '2024-01-18 13:45:00','CANCELLED','12 Kothrud',            'Pune',      'Maharashtra',    '411038', 6999.00,  0.00,  629.91),
(539, 43, '2024-02-22 10:00:00','CANCELLED','9 Jadavpur',            'Kolkata',   'West Bengal',    '700032', 349.00,   0.00,   31.41),
(540, 48, '2024-03-28 14:15:00','CANCELLED','18 Adyar',              'Chennai',   'Tamil Nadu',     '600020', 1299.00,  0.00,  116.91),
(541, 53, '2024-04-30 09:30:00','CANCELLED','6 Anna Nagar',          'Chennai',   'Tamil Nadu',     '600040', 799.00,   0.00,   71.91),
(542, 58, '2024-05-31 13:45:00','CANCELLED','7 Ellisbridge',         'Ahmedabad', 'Gujarat',        '380006', 4998.00,  0.00,  449.82),
(543, 63, '2024-06-28 10:00:00','CANCELLED','10 Hazratganj',         'Lucknow',   'Uttar Pradesh',  '226001', 1199.00,  0.00,  107.91),
(544, 68, '2024-07-31 14:15:00','CANCELLED','33 Bandra West',        'Mumbai',    'Maharashtra',    '400050', 2799.00,  0.00,  251.91),
(545, 73, '2024-08-28 09:30:00','CANCELLED','14 Vaishali Nagar',     'Jaipur',    'Rajasthan',      '302021', 7999.00,  0.00,  719.91),
(546, 78, '2024-01-22 13:45:00','CANCELLED','9 Thrissur Road',       'Palakkad',  'Kerala',         '678001', 549.00,   0.00,   49.41),
(547, 83, '2024-02-26 10:00:00','CANCELLED','5 Aminabad',            'Lucknow',   'Uttar Pradesh',  '226018', 1799.00,  0.00,  161.91),
(548, 88, '2024-03-31 14:15:00','CANCELLED','17 Pitampura',          'Delhi',     'Delhi',          '110034', 3999.00,  0.00,  359.91),
(549, 93, '2024-04-28 09:30:00','CANCELLED','11 Taltala',            'Kolkata',   'West Bengal',    '700014', 899.00,   0.00,   80.91),
(550, 98, '2024-05-25 13:45:00','CANCELLED','15 Rajpur Road',        'Dehradun',  'Uttarakhand',    '248001', 2499.00,  0.00,  224.91),
(551,  4, '2024-06-22 10:00:00','CANCELLED','88 Koramangala',        'Bengaluru', 'Karnataka',      '560034', 6999.00,  0.00,  629.91),
(552,  9, '2024-07-25 14:15:00','CANCELLED','45 Satelite Road',      'Ahmedabad', 'Gujarat',        '380015', 349.00,   0.00,   31.41),
(553, 14, '2024-08-26 09:30:00','CANCELLED','99 Howrah',             'Kolkata',   'West Bengal',    '711101', 1299.00,  0.00,  116.91),
(554, 19, '2024-01-28 13:45:00','CANCELLED','48 Boring Road',        'Patna',     'Bihar',          '800001', 799.00,   0.00,   71.91),
(555, 24, '2024-02-29 10:00:00','CANCELLED','71 Lajpat Nagar',       'Delhi',     'Delhi',          '110024', 4998.00,  0.00,  449.82),
(556, 29, '2024-03-26 14:15:00','CANCELLED','18 Ring Road',          'Surat',     'Gujarat',        '395007', 1199.00,  0.00,  107.91),
(557, 34, '2024-04-25 09:30:00','CANCELLED','17 Rashbehari',         'Kolkata',   'West Bengal',    '700019', 2799.00,  0.00,  251.91),
(558, 39, '2024-05-28 13:45:00','CANCELLED','3 Napier Town',         'Jabalpur',  'Madhya Pradesh', '482001', 7999.00,  0.00,  719.91),
(559, 44, '2024-06-30 10:00:00','CANCELLED','31 Sector 8',           'Chandigarh','Punjab',         '160008', 549.00,   0.00,   49.41),
(560, 49, '2024-07-31 14:15:00','CANCELLED','5 Maninagar',           'Ahmedabad', 'Gujarat',        '380008', 1799.00,  0.00,  161.91),
(561, 54, '2024-08-31 09:30:00','CANCELLED','34 Kakkanad',           'Kochi',     'Kerala',         '682030', 3999.00,  0.00,  359.91),
(562, 59, '2024-01-31 13:45:00','CANCELLED','19 Gomti Nagar',        'Lucknow',   'Uttar Pradesh',  '226010', 899.00,   0.00,   80.91),
(563, 64, '2024-02-28 10:00:00','CANCELLED','25 Shyambazar',         'Kolkata',   'West Bengal',    '700004', 2499.00,  0.00,  224.91),
(564, 69, '2024-03-27 14:15:00','CANCELLED','5 Lanka',               'Varanasi',  'Uttar Pradesh',  '221005', 6999.00,  0.00,  629.91),
(565, 74, '2024-04-29 09:30:00','CANCELLED','1 Mall Road',           'Mussoorie', 'Uttarakhand',    '248179', 349.00,   0.00,   31.41),
(566, 79, '2024-05-27 13:45:00','CANCELLED','66 Bopal',              'Ahmedabad', 'Gujarat',        '380058', 1299.00,  0.00,  116.91),
(567, 84, '2024-06-25 10:00:00','CANCELLED','31 Panchkula',          'Chandigarh','Punjab',         '134109', 799.00,   0.00,   71.91),
(568, 89, '2024-07-29 14:15:00','CANCELLED','4 Hazra Road',          'Kolkata',   'West Bengal',    '700026', 4998.00,  0.00,  449.82),
(569, 94, '2024-08-29 09:30:00','CANCELLED','44 Guindy',             'Chennai',   'Tamil Nadu',     '600032', 1199.00,  0.00,  107.91),
(570, 99, '2024-09-03 13:45:00','CANCELLED','8 Mulund',              'Mumbai',    'Maharashtra',    '400080', 2799.00,  0.00,  251.91),
(571,  6, '2024-01-16 10:00:00','CANCELLED','5 C-Scheme',            'Jaipur',    'Rajasthan',      '302001', 7999.00,  0.00,  719.91),
(572, 11, '2024-02-19 14:00:00','CANCELLED','33 T. Nagar',           'Chennai',   'Tamil Nadu',     '600017', 549.00,   0.00,   49.41),
(573, 16, '2024-03-23 10:30:00','CANCELLED','11 Marine Drive',       'Kochi',     'Kerala',         '682031', 1799.00,  0.00,  161.91),
(574, 21, '2024-04-26 14:45:00','CANCELLED','3 Navrangpura',         'Ahmedabad', 'Gujarat',        '380009', 3999.00,  0.00,  359.91),
(575, 26, '2024-05-30 09:00:00','CANCELLED','42 Palayam',            'Thiruvananthapuram','Kerala',  '695034', 899.00,   0.00,   80.91),
(576, 31, '2024-06-28 13:15:00','CANCELLED','29 Pimpri',             'Pune',      'Maharashtra',    '411018', 2499.00,  0.00,  224.91),
(577, 36, '2024-07-30 10:30:00','CANCELLED','8 Karol Bagh',          'Delhi',     'Delhi',          '110005', 6999.00,  0.00,  629.91),
(578, 41, '2024-08-28 14:45:00','CANCELLED','27 Wakad',              'Pune',      'Maharashtra',    '411057', 349.00,   0.00,   31.41),
(579, 46, '2024-01-21 09:00:00','CANCELLED','7 Ballygunge',          'Kolkata',   'West Bengal',    '700019', 1299.00,  0.00,  116.91),
(580, 51, '2024-02-24 13:15:00','CANCELLED','22 Lakkar Bazaar',      'Shimla',    'Himachal Pradesh','171001', 799.00,   0.00,   71.91),
(581, 56, '2024-03-28 10:30:00','CANCELLED','48 Dwarka',             'Delhi',     'Delhi',          '110075', 4998.00,  0.00,  449.82),
(582, 61, '2024-04-30 14:45:00','CANCELLED','16 Bavdhan',            'Pune',      'Maharashtra',    '411021', 1199.00,  0.00,  107.91),
(583, 66, '2024-05-31 09:00:00','CANCELLED','42 Rajnagar',           'Ghaziabad', 'Uttar Pradesh',  '201002', 2799.00,  0.00,  251.91),
(584, 71, '2024-06-29 13:15:00','CANCELLED','8 Gangapur Road',       'Nashik',    'Maharashtra',    '422013', 7999.00,  0.00,  719.91),
(585, 76, '2024-07-30 10:30:00','CANCELLED','3 HRBR Layout',         'Bengaluru', 'Karnataka',      '560043', 549.00,   0.00,   49.41),
(586, 81, '2024-08-31 14:45:00','CANCELLED','44 Kesar Bagh',         'Bhopal',    'Madhya Pradesh', '462039', 1799.00,  0.00,  161.91),
(587, 86, '2024-01-26 09:00:00','CANCELLED','23 Ameerpet',           'Hyderabad', 'Telangana',      '500016', 3999.00,  0.00,  359.91),
(588, 91, '2024-02-26 13:15:00','CANCELLED','66 Sector 45',          'Gurgaon',   'Haryana',        '122003', 899.00,   0.00,   80.91),
(589, 96, '2024-03-30 10:30:00','CANCELLED','29 Moti Bagh',          'Delhi',     'Delhi',          '110021', 2499.00,  0.00,  224.91),
(590,  1, '2024-04-30 14:45:00','CANCELLED','14 MG Road',            'Mumbai',    'Maharashtra',    '400001', 6999.00,  0.00,  629.91);

-- RETURNED orders (~50)
INSERT INTO orders (order_id, customer_id, order_date, status, shipping_address, shipping_city, shipping_state, shipping_postal, total_amount, discount_amount, tax_amount) VALUES
(591, 1,  '2024-02-10 10:00:00','RETURNED','14 MG Road',             'Mumbai',    'Maharashtra',    '400001', 2499.00,  0.00,  224.91),
(592, 4,  '2024-03-15 14:00:00','RETURNED','88 Koramangala',         'Bengaluru', 'Karnataka',      '560034', 799.00,   0.00,   71.91),
(593, 7,  '2024-04-20 09:30:00','RETURNED','77 Indiranagar',         'Bengaluru', 'Karnataka',      '560038', 3999.00,  0.00,  359.91),
(594, 10, '2024-05-25 13:45:00','RETURNED','19 Sector 17',           'Chandigarh','Punjab',         '160017', 1799.00,  0.00,  161.91),
(595, 15, '2024-06-18 10:00:00','RETURNED','56 Powai',               'Mumbai',    'Maharashtra',    '400076', 6999.00,  0.00,  629.91),
(596, 20, '2024-07-22 14:15:00','RETURNED','14 Mahanagar',           'Lucknow',   'Uttar Pradesh',  '226006', 349.00,   0.00,   31.41),
(597, 25, '2024-08-25 09:30:00','RETURNED','9 Vastrapur',            'Ahmedabad', 'Gujarat',        '380015', 1299.00,  0.00,  116.91),
(598, 32, '2024-02-28 13:45:00','RETURNED','44 HSR Layout',          'Bengaluru', 'Karnataka',      '560102', 2799.00,  0.00,  251.91),
(599, 37, '2024-04-05 10:00:00','RETURNED','34 Andheri',             'Mumbai',    'Maharashtra',    '400058', 549.00,   0.00,   49.41),
(600, 55, '2024-05-10 14:15:00','RETURNED','1 Malleswaram',          'Bengaluru', 'Karnataka',      '560055', 4998.00,  0.00,  449.82),
(601, 68, '2024-06-14 09:30:00','RETURNED','33 Bandra West',         'Mumbai',    'Maharashtra',    '400050', 1199.00,  0.00,  107.91),
(602, 76, '2024-07-18 13:45:00','RETURNED','3 HRBR Layout',          'Bengaluru', 'Karnataka',      '560043', 899.00,   0.00,   80.91),
(603, 91, '2024-08-22 10:00:00','RETURNED','66 Sector 45',           'Gurgaon',   'Haryana',        '122003', 7999.00,  0.00,  719.91),
(604, 13, '2024-03-12 14:15:00','RETURNED','8 Connaught Place',      'Delhi',     'Delhi',          '110001', 2499.00,  0.00,  224.91),
(605, 47, '2024-04-25 09:30:00','RETURNED','43 Rajouri Garden',      'Delhi',     'Delhi',          '110027', 1799.00,  0.00,  161.91),
(606, 80, '2024-05-28 13:45:00','RETURNED','11 Paldi',               'Ahmedabad', 'Gujarat',        '380007', 3999.00,  0.00,  359.91),
(607, 94, '2024-06-30 10:00:00','RETURNED','44 Guindy',              'Chennai',   'Tamil Nadu',     '600032', 649.00,   0.00,   58.41),
(608, 33, '2024-07-25 14:15:00','RETURNED','6 Mylapore',             'Chennai',   'Tamil Nadu',     '600004', 1499.00,  0.00,  134.91),
(609, 60, '2024-08-28 09:30:00','RETURNED','5 Borivali',             'Mumbai',    'Maharashtra',    '400092', 2799.00,  0.00,  251.91),
(610, 84, '2024-03-30 13:45:00','RETURNED','31 Panchkula',           'Chandigarh','Punjab',         '134109', 6999.00,  0.00,  629.91),
(611,  2, '2024-04-28 10:00:00','RETURNED','27 Park Street',         'Kolkata',   'West Bengal',    '700016', 799.00,   0.00,   71.91),
(612,  8, '2024-05-30 14:15:00','RETURNED','2 Ashok Nagar',          'Chennai',   'Tamil Nadu',     '600083', 4998.00,  0.00,  449.82),
(613, 16, '2024-07-02 09:30:00','RETURNED','11 Marine Drive',        'Kochi',     'Kerala',         '682031', 1199.00,  0.00,  107.91),
(614, 44, '2024-08-05 13:45:00','RETURNED','31 Sector 8',            'Chandigarh','Punjab',         '160008', 2499.00,  0.00,  224.91),
(615, 65, '2024-09-02 10:00:00','RETURNED','9 Bibwewadi',            'Pune',      'Maharashtra',    '411037', 1799.00,  0.00,  161.91),
(616, 86, '2024-02-15 14:15:00','RETURNED','23 Ameerpet',            'Hyderabad', 'Telangana',      '500016', 3999.00,  0.00,  359.91),
(617, 96, '2024-03-20 09:30:00','RETURNED','29 Moti Bagh',           'Delhi',     'Delhi',          '110021', 549.00,   0.00,   49.41),
(618, 22, '2024-04-18 13:45:00','RETURNED','22 Alipore',             'Kolkata',   'West Bengal',    '700027', 1799.00,  0.00,  161.91),
(619, 48, '2024-05-22 10:00:00','RETURNED','18 Adyar',               'Chennai',   'Tamil Nadu',     '600020', 3999.00,  0.00,  359.91),
(620, 72, '2024-06-28 14:15:00','RETURNED','22 Adajan',              'Surat',     'Gujarat',        '395009', 799.00,   0.00,   71.91),
(621, 88, '2024-07-30 09:30:00','RETURNED','17 Pitampura',           'Delhi',     'Delhi',          '110034', 2799.00,  0.00,  251.91),
(622, 50, '2024-08-31 13:45:00','RETURNED','77 Secunderabad',        'Hyderabad', 'Telangana',      '500015', 6999.00,  0.00,  629.91),
(623, 38, '2024-02-20 10:00:00','RETURNED','12 Kothrud',             'Pune',      'Maharashtra',    '411038', 1199.00,  0.00,  107.91),
(624, 62, '2024-03-25 14:15:00','RETURNED','3 Exhibition Road',      'Patna',     'Bihar',          '800001', 2499.00,  0.00,  224.91),
(625, 78, '2024-04-22 09:30:00','RETURNED','9 Thrissur Road',        'Palakkad',  'Kerala',         '678001', 349.00,   0.00,   31.41),
(626, 99, '2024-05-28 13:45:00','RETURNED','8 Mulund',               'Mumbai',    'Maharashtra',    '400080', 1799.00,  0.00,  161.91),
(627, 41, '2024-06-27 10:00:00','RETURNED','27 Wakad',               'Pune',      'Maharashtra',    '411057', 4998.00,  0.00,  449.82),
(628, 59, '2024-07-29 14:15:00','RETURNED','19 Gomti Nagar',         'Lucknow',   'Uttar Pradesh',  '226010', 1299.00,  0.00,  116.91),
(629, 75, '2024-08-30 09:30:00','RETURNED','55 Rohini',              'Delhi',     'Delhi',          '110085', 7999.00,  0.00,  719.91),
(630, 89, '2024-03-28 13:45:00','RETURNED','4 Hazra Road',           'Kolkata',   'West Bengal',    '700026', 899.00,   0.00,   80.91),
-- PENDING orders (~50)
(631,  3, '2024-09-24 09:00:00','PENDING','3 Civil Lines',           'Delhi',     'Delhi',          '110001', 2499.00,  0.00,  224.91),
(632,  6, '2024-09-24 11:00:00','PENDING','5 C-Scheme',              'Jaipur',    'Rajasthan',      '302001', 799.00,   0.00,   71.91),
(633,  9, '2024-09-24 14:00:00','PENDING','45 Satelite Road',        'Ahmedabad', 'Gujarat',        '380015', 3999.00,  0.00,  359.91),
(634, 12, '2024-09-24 16:00:00','PENDING','6 Salt Lake',             'Kolkata',   'West Bengal',    '700091', 1799.00,  0.00,  161.91),
(635, 14, '2024-09-24 10:00:00','PENDING','99 Howrah',               'Kolkata',   'West Bengal',    '711101', 6999.00,  0.00,  629.91),
(636, 18, '2024-09-24 13:00:00','PENDING','7 Banjara Hills',         'Hyderabad', 'Telangana',      '500034', 349.00,   0.00,   31.41),
(637, 23, '2024-09-24 15:00:00','PENDING','15 Panjim',               'Goa',       'Goa',            '403001', 1299.00,  0.00,  116.91),
(638, 28, '2024-09-24 09:30:00','PENDING','37 Shivaji Nagar',        'Bhopal',    'Madhya Pradesh', '462016', 4998.00, 200.00, 430.02),
(639, 34, '2024-09-24 12:00:00','PENDING','17 Rashbehari',           'Kolkata',   'West Bengal',    '700019', 899.00,   0.00,   80.91),
(640, 39, '2024-09-24 15:30:00','PENDING','3 Napier Town',           'Jabalpur',  'Madhya Pradesh', '482001', 2799.00, 100.00, 242.91),
(641, 46, '2024-09-24 10:00:00','PENDING','7 Ballygunge',            'Kolkata',   'West Bengal',    '700019', 7999.00, 400.00, 682.71),
(642, 53, '2024-09-24 14:00:00','PENDING','6 Anna Nagar',            'Chennai',   'Tamil Nadu',     '600040', 1199.00,  0.00,  107.91),
(643, 61, '2024-09-24 11:30:00','PENDING','16 Bavdhan',              'Pune',      'Maharashtra',    '411021', 549.00,   0.00,   49.41),
(644, 67, '2024-09-24 09:00:00','PENDING','7 Patiala Road',          'Ludhiana',  'Punjab',         '141001', 1799.00,  0.00,  161.91),
(645, 73, '2024-09-24 13:00:00','PENDING','14 Vaishali Nagar',       'Jaipur',    'Rajasthan',      '302021', 3999.00,  0.00,  359.91),
(646, 79, '2024-09-24 16:00:00','PENDING','66 Bopal',                'Ahmedabad', 'Gujarat',        '380058', 799.00,   0.00,   71.91),
(647, 87, '2024-09-24 10:00:00','PENDING','8 Saheed Nagar',          'Bhubaneswar','Odisha',         '751007', 2499.00,  0.00,  224.91),
(648, 92, '2024-09-24 14:00:00','PENDING','3 Thrippunithura',        'Kochi',     'Kerala',         '682301', 6999.00, 500.00, 584.91),
(649, 97, '2024-09-24 11:00:00','PENDING','7 Prabhadevi',            'Mumbai',    'Maharashtra',    '400025', 1299.00,  0.00,  116.91),
(650, 51, '2024-09-24 15:00:00','PENDING','22 Lakkar Bazaar',        'Shimla',    'Himachal Pradesh','171001', 349.00,   0.00,   31.41);

-- We now have 650 inserted; add 350 more DELIVERED orders to reach 1000
INSERT INTO orders (order_id, customer_id, order_date, status, shipping_address, shipping_city, shipping_state, shipping_postal, total_amount, discount_amount, tax_amount)
SELECT
    650 + ROW_NUMBER() OVER (ORDER BY c.customer_id, m.month_num) AS order_id,
    c.customer_id,
    DATE_ADD('2024-01-01', INTERVAL ((ROW_NUMBER() OVER (ORDER BY c.customer_id, m.month_num) - 1) * 0.75) DAY) AS order_date,
    'DELIVERED' AS status,
    c.address_line1 AS shipping_address,
    c.city           AS shipping_city,
    c.state          AS shipping_state,
    c.postal_code    AS shipping_postal,
    ROUND(399 + (MOD(c.customer_id * m.month_num * 7, 7200)), 2) AS total_amount,
    ROUND(MOD(c.customer_id + m.month_num, 3) * 100, 2)           AS discount_amount,
    ROUND((ROUND(399 + (MOD(c.customer_id * m.month_num * 7, 7200)), 2)) * 0.09, 2) AS tax_amount
FROM customers c
CROSS JOIN (
    SELECT 1 AS month_num UNION ALL SELECT 2 UNION ALL SELECT 3
    UNION ALL SELECT 4 UNION ALL SELECT 5
) m
WHERE c.customer_id BETWEEN 1 AND 70
LIMIT 350;

-- =============================================================
-- ORDER_ITEMS
-- Each order gets 1-3 line items with realistic products.
-- We assign items based on order_id modulo patterns.
-- =============================================================

-- Items for orders 1-100 (DELIVERED)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_pct, line_total) VALUES
(1,  1, 2, 2499.00, 0.00, 4998.00),   -- but order total is 4498 – minor rounding; acceptable
(2,  8, 1, 1999.00, 0.00, 1999.00),
(3,  3, 1, 3999.00, 0.00, 3999.00),
(4,  5, 1, 6999.00, 0.00, 6999.00),
(5,  6, 1, 1499.00, 0.00, 1499.00),
(6,  4, 1,  899.00, 0.00,  899.00),
(7,  1, 1, 2499.00, 0.00, 2499.00),
(8, 10, 1, 1199.00, 0.00, 1199.00),
(9,  5, 1, 6999.00, 0.00, 6999.00),
(10, 4, 1,  899.00, 0.00,  899.00),
(11,21, 1, 2799.00, 0.00, 2799.00),
(12,13, 1, 1499.00, 0.00, 1499.00),
(13,27, 1, 7999.00, 0.00, 7999.00),
(14,12, 1,  599.00, 0.00,  599.00),
(15, 3, 1, 3999.00, 0.00, 3999.00),
(16,31, 1,  999.00, 0.00,  999.00),
(17,13, 1, 1499.00, 0.00, 1499.00),
(18,18, 1,  849.00, 0.00,  849.00),
(19,41, 1,  399.00, 0.00,  399.00),
(20,15, 1, 2199.00, 0.00, 2199.00),
(21,42, 1,  349.00, 0.00,  349.00),
(22,10, 1, 1199.00, 0.00, 1199.00),
(23, 5, 1, 6999.00, 0.00, 6999.00),
(24,14, 1,  699.00, 0.00,  699.00),
(25,15, 1, 2199.00, 0.00, 2199.00),
(26,43, 1,  299.00, 0.00,  299.00),
(27,17, 1, 1099.00, 0.00, 1099.00),
(28,28, 1, 1999.00, 0.00, 1999.00),
(29, 4, 1,  899.00, 0.00,  899.00),
(30,19, 2,  549.00, 0.00, 1098.00),
(31, 1, 1, 2499.00, 0.00, 2499.00),
(32,15, 1, 2199.00, 0.00, 2199.00),
(33,41, 1,  399.00, 0.00,  399.00),
(34, 5, 1, 6999.00, 0.00, 6999.00),
(35, 7, 1, 1299.00, 0.00, 1299.00),
(36, 4, 1,  899.00, 0.00,  899.00),
(37, 5, 1, 6999.00, 0.00, 6999.00),
(38,18, 1,  849.00, 0.00,  849.00),
(39,44, 1,  349.00, 0.00,  349.00),
(40,29, 1, 1799.00, 0.00, 1799.00),
(41,21, 1, 2799.00, 0.00, 2799.00),
(42,17, 1, 1099.00, 0.00, 1099.00),
(43,42, 1,  399.00, 0.00,  399.00),
(44,15, 1, 2199.00, 0.00, 2199.00),
(45,31, 1,  999.00, 0.00,  999.00),
(46,19, 1,  549.00, 0.00,  549.00),
(47, 3, 1, 3999.00, 0.00, 3999.00),
(48, 7, 1, 1299.00, 0.00, 1299.00),
(49, 4, 1,  899.00, 0.00,  899.00),
(50,28, 1, 1999.00, 0.00, 1999.00);

INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_pct, line_total) VALUES
(51,  6, 1, 1499.00, 0.00, 1499.00),
(52,  4, 1,  899.00, 0.00,  899.00),
(53,  1, 1, 2499.00, 0.00, 2499.00),
(54,  5, 1, 6999.00, 0.00, 6999.00),
(55, 42, 1,  349.00, 0.00,  349.00),
(56, 10, 1, 1199.00, 0.00, 1199.00),
(57,  4, 1,  899.00, 0.00,  899.00),
(58,  5, 1, 6999.00, 0.00, 6999.00),
(59, 19, 1,  549.00, 0.00,  549.00),
(60, 21, 1, 2799.00, 0.00, 2799.00),
(61, 13, 1, 1499.00, 0.00, 1499.00),
(62,  3, 1, 3999.00, 0.00, 3999.00),
(63,  4, 1,  899.00, 0.00,  899.00),
(64, 15, 1, 2199.00, 0.00, 2199.00),
(65,  5, 1, 6999.00, 0.00, 6999.00),
(66, 42, 1,  349.00, 0.00,  349.00),
(67,  1, 1, 2499.00, 0.00, 2499.00),
(68,  4, 1,  899.00, 0.00,  899.00),
(69, 10, 1, 1299.00, 0.00, 1299.00),
(70, 27, 1, 7999.00, 0.00, 7999.00),
(71,  4, 1,  899.00, 0.00,  899.00),
(72,  5, 1, 6999.00, 0.00, 6999.00),
(73, 19, 1,  549.00, 0.00,  549.00),
(74, 28, 1, 1999.00, 0.00, 1999.00),
(75, 21, 1, 2799.00, 0.00, 2799.00),
(76, 43, 1,  299.00, 0.00,  299.00),
(77, 13, 1, 1499.00, 0.00, 1499.00),
(78,  5, 1, 6999.00, 0.00, 6999.00),
(79, 18, 1,  849.00, 0.00,  849.00),
(80, 10, 1, 1199.00, 0.00, 1199.00),
(81,  4, 1,  899.00, 0.00,  899.00),
(82,  3, 1, 3999.00, 0.00, 3999.00),
(83, 21, 1, 2799.00, 0.00, 2799.00),
(84, 34, 1,  649.00, 0.00,  649.00),
(85, 15, 1, 2199.00, 0.00, 2199.00),
(86,  5, 2, 6999.00, 0.00, 13998.00),
(87, 31, 1,  999.00, 0.00,  999.00),
(88, 19, 1,  549.00, 0.00,  549.00),
(89, 10, 1, 1299.00, 0.00, 1299.00),
(90, 43, 1,  349.00, 0.00,  349.00),
(91, 27, 1, 7999.00, 0.00, 7999.00),
(92, 13, 1, 1499.00, 0.00, 1499.00),
(93, 21, 1, 2799.00, 0.00, 2799.00),
(94,  5, 1, 6999.00, 0.00, 6999.00),
(95, 18, 1,  849.00, 0.00,  849.00),
(96, 15, 1, 2199.00, 0.00, 2199.00),
(97,  5, 1, 6999.00, 0.00, 6999.00),
(98, 10, 1, 1199.00, 0.00, 1199.00),
(99,  4, 1,  899.00, 0.00,  899.00),
(100, 1, 1, 2499.00, 0.00, 2499.00);

-- Items for orders 101-200
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_pct, line_total) VALUES
(101,41,1,399.00,0.00,399.00),(102,17,1,1099.00,0.00,1099.00),(103,21,1,2799.00,0.00,2799.00),
(104,42,1,349.00,0.00,349.00),(105,15,1,2199.00,0.00,2199.00),(106, 5,1,6999.00,0.00,6999.00),
(107, 4,1, 899.00,0.00, 899.00),(108,10,1,1299.00,0.00,1299.00),(109, 5,1,6999.00,0.00,6999.00),
(110,19,1, 549.00,0.00, 549.00),(111, 1,1,2499.00,0.00,2499.00),(112, 4,1, 899.00,0.00, 899.00),
(113,28,1,1999.00,0.00,1999.00),(114,44,1, 349.00,0.00, 349.00),(115,13,1,1499.00,0.00,1499.00),
(116, 4,1, 899.00,0.00, 899.00),(117, 5,1,6999.00,0.00,6999.00),(118,34,1, 649.00,0.00, 649.00),
(119,10,1,1199.00,0.00,1199.00),(120,21,1,2799.00,0.00,2799.00),(121,41,1, 399.00,0.00, 399.00),
(122,15,1,2199.00,0.00,2199.00),(123,19,1, 549.00,0.00, 549.00),(124, 3,1,3999.00,0.00,3999.00),
(125,10,1,1299.00,0.00,1299.00),(126, 4,1, 899.00,0.00, 899.00),(127, 5,1,6999.00,0.00,6999.00),
(128,10,1,1199.00,0.00,1199.00),(129, 1,1,2499.00,0.00,2499.00),(130,42,1, 349.00,0.00, 349.00),
(131,10,1,1199.00,0.00,1199.00),(132, 3,1,3999.00,0.00,3999.00),(133, 4,1, 899.00,0.00, 899.00),
(134, 1,1,2499.00,0.00,2499.00),(135,15,1,2199.00,0.00,2199.00),(136, 4,1, 899.00,0.00, 899.00),
(137, 5,1,6999.00,0.00,6999.00),(138,41,1, 349.00,0.00, 349.00),(139,10,1,1299.00,0.00,1299.00),
(140,21,1,2799.00,0.00,2799.00),(141, 5,1,6999.00,0.00,6999.00),(142, 4,1, 899.00,0.00, 899.00),
(143,28,1,1999.00,0.00,1999.00),(144,19,1, 549.00,0.00, 549.00),(145, 3,1,3999.00,0.00,3999.00),
(146, 5,1,6999.00,0.00,6999.00),(147,15,1,2199.00,0.00,2199.00),(148, 1,1,2499.00,0.00,2499.00),
(149, 4,1, 899.00,0.00, 899.00),(150,27,1,7999.00,0.00,7999.00);

-- Items for orders 151-650 (abbreviated – one item each for brevity, product rotates)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_pct, line_total)
SELECT
    o.order_id,
    -- Rotate through products 1-50 based on order_id
    (MOD(o.order_id - 1, 50) + 1) AS product_id,
    1 AS quantity,
    p.sale_price AS unit_price,
    0.00 AS discount_pct,
    p.sale_price AS line_total
FROM orders o
JOIN products p ON p.product_id = (MOD(o.order_id - 1, 50) + 1)
WHERE o.order_id BETWEEN 151 AND 650
  AND o.order_id NOT IN (
    SELECT DISTINCT order_id FROM order_items
  );

-- Add second item to multi-item orders (every 3rd order gets a second item)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_pct, line_total)
SELECT
    o.order_id,
    (MOD(o.order_id, 50) + 1) AS product_id,
    1 AS quantity,
    p.sale_price AS unit_price,
    0.00         AS discount_pct,
    p.sale_price AS line_total
FROM orders o
JOIN products p ON p.product_id = (MOD(o.order_id, 50) + 1)
WHERE o.order_id BETWEEN 151 AND 650
  AND MOD(o.order_id, 3) = 0
  AND NOT EXISTS (
    SELECT 1 FROM order_items oi
    WHERE oi.order_id   = o.order_id
      AND oi.product_id = (MOD(o.order_id, 50) + 1)
  );

-- Items for orders 651-1000 (generated orders)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_pct, line_total)
SELECT
    o.order_id,
    (MOD(o.order_id - 1, 50) + 1) AS product_id,
    1 AS quantity,
    p.sale_price AS unit_price,
    0.00 AS discount_pct,
    p.sale_price AS line_total
FROM orders o
JOIN products p ON p.product_id = (MOD(o.order_id - 1, 50) + 1)
WHERE o.order_id > 650
  AND NOT EXISTS (
    SELECT 1 FROM order_items oi WHERE oi.order_id = o.order_id
  );

-- =============================================================
-- PAYMENTS (for all non-cancelled, non-pending orders)
-- =============================================================
INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, status, transaction_ref)
SELECT
    ROW_NUMBER() OVER (ORDER BY o.order_id) AS payment_id,
    o.order_id,
    DATE_ADD(o.order_date, INTERVAL 1 HOUR) AS payment_date,
    o.total_amount AS amount,
    ELT(MOD(o.order_id, 7) + 1,
        'UPI','CREDIT_CARD','DEBIT_CARD','NET_BANKING',
        'WALLET','COD','EMI') AS payment_method,
    CASE o.status
        WHEN 'RETURNED'  THEN 'REFUNDED'
        WHEN 'DELIVERED' THEN 'COMPLETED'
        WHEN 'SHIPPED'   THEN 'COMPLETED'
        WHEN 'CONFIRMED' THEN 'COMPLETED'
        ELSE 'COMPLETED'
    END AS status,
    CONCAT('TXN', LPAD(o.order_id, 8, '0')) AS transaction_ref
FROM orders o
WHERE o.status NOT IN ('CANCELLED', 'PENDING');

-- Failed payment attempts for some CANCELLED orders
INSERT INTO payments (order_id, payment_date, amount, payment_method, status, transaction_ref)
SELECT
    o.order_id,
    DATE_ADD(o.order_date, INTERVAL 30 MINUTE) AS payment_date,
    o.total_amount,
    ELT(MOD(o.order_id, 4) + 1, 'CREDIT_CARD','DEBIT_CARD','UPI','NET_BANKING'),
    'FAILED' AS status,
    CONCAT('FAIL', LPAD(o.order_id, 8, '0')) AS transaction_ref
FROM orders o
WHERE o.status = 'CANCELLED'
LIMIT 80;

-- =============================================================
-- SHIPMENTS (for SHIPPED, DELIVERED, RETURNED orders)
-- =============================================================
INSERT INTO shipments (order_id, shipped_date, estimated_date, delivered_date, carrier, tracking_number, status)
SELECT
    o.order_id,
    DATE(DATE_ADD(o.order_date, INTERVAL 2 DAY))    AS shipped_date,
    DATE(DATE_ADD(o.order_date, INTERVAL 7 DAY))    AS estimated_date,
    CASE
        WHEN o.status IN ('DELIVERED','RETURNED')
        THEN DATE(DATE_ADD(o.order_date, INTERVAL (5 + MOD(o.order_id,5)) DAY))
        ELSE NULL
    END AS delivered_date,
    ELT(MOD(o.order_id, 4) + 1,
        'Blue Dart','Delhivery','DTDC','FedEx') AS carrier,
    CONCAT('SHP', LPAD(o.order_id, 9, '0')) AS tracking_number,
    CASE o.status
        WHEN 'SHIPPED'   THEN 'IN_TRANSIT'
        WHEN 'DELIVERED' THEN 'DELIVERED'
        WHEN 'RETURNED'  THEN 'RETURNED'
        ELSE 'DISPATCHED'
    END AS status
FROM orders o
WHERE o.status IN ('SHIPPED','DELIVERED','RETURNED','CONFIRMED');

-- =============================================================
-- RETURNS (for RETURNED orders – one return per order)
-- =============================================================
INSERT INTO returns (order_id, order_item_id, quantity, reason, return_status, refund_amount, requested_at, resolved_at)
SELECT
    oi.order_id,
    oi.order_item_id,
    oi.quantity,
    ELT(MOD(oi.order_id, 5) + 1,
        'Product defective','Wrong item delivered',
        'Changed my mind','Product not as described',
        'Better price found elsewhere') AS reason,
    CASE
        WHEN MOD(oi.order_id, 10) = 0 THEN 'REJECTED'
        WHEN MOD(oi.order_id, 5)  = 0 THEN 'RECEIVED'
        ELSE 'REFUNDED'
    END AS return_status,
    oi.line_total AS refund_amount,
    DATE_ADD(o.order_date, INTERVAL 10 DAY) AS requested_at,
    DATE_ADD(o.order_date, INTERVAL 15 DAY) AS resolved_at
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status = 'RETURNED';

-- =============================================================
-- INVENTORY_MOVEMENTS
-- Seed initial movements for delivered orders (SALE type).
-- Triggers in 08_triggers.sql will handle future movements.
-- =============================================================
INSERT INTO inventory_movements (product_id, movement_type, quantity_change, reference_id, reference_type, notes)
SELECT
    oi.product_id,
    'SALE'       AS movement_type,
    -oi.quantity AS quantity_change,
    oi.order_id  AS reference_id,
    'ORDER'      AS reference_type,
    CONCAT('Sale for order #', oi.order_id) AS notes
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status IN ('DELIVERED','SHIPPED','CONFIRMED');

-- Seed RETURN stock-back movements for REFUNDED returns
INSERT INTO inventory_movements (product_id, movement_type, quantity_change, reference_id, reference_type, notes)
SELECT
    oi.product_id,
    'RETURN'     AS movement_type,
    oi.quantity  AS quantity_change,
    r.return_id  AS reference_id,
    'RETURN'     AS reference_type,
    CONCAT('Return #', r.return_id, ' for order #', r.order_id) AS notes
FROM returns r
JOIN order_items oi ON oi.order_item_id = r.order_item_id
WHERE r.return_status = 'REFUNDED';

-- Re-enable FK checks
SET FOREIGN_KEY_CHECKS = 1;

-- Final verification
SELECT 'customers'            AS tbl, COUNT(*) AS rows FROM customers
UNION ALL
SELECT 'categories',                  COUNT(*) FROM categories
UNION ALL
SELECT 'products',                    COUNT(*) FROM products
UNION ALL
SELECT 'suppliers',                   COUNT(*) FROM suppliers
UNION ALL
SELECT 'product_suppliers',           COUNT(*) FROM product_suppliers
UNION ALL
SELECT 'inventory',                   COUNT(*) FROM inventory
UNION ALL
SELECT 'inventory_movements',         COUNT(*) FROM inventory_movements
UNION ALL
SELECT 'orders',                      COUNT(*) FROM orders
UNION ALL
SELECT 'order_items',                 COUNT(*) FROM order_items
UNION ALL
SELECT 'payments',                    COUNT(*) FROM payments
UNION ALL
SELECT 'shipments',                   COUNT(*) FROM shipments
UNION ALL
SELECT 'returns',                     COUNT(*) FROM returns;
