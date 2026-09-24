-- E-commerce Sales & Customer Analysis
-- SQL Analysis
-- Dataset: Olist Brazilian E-Commerce Public Dataset

USE ecommerce;


-- ============================================
-- 1. DATA OVERVIEW & QUALITY CHECKS
-- ============================================

-- Check number of customers
SELECT COUNT(*) AS customer_count
FROM customers;


-- Check number of orders
SELECT COUNT(*) AS order_count
FROM orders;


-- Check number of order items
SELECT COUNT(*) AS order_item_count
FROM order_items;


-- Check number of products
SELECT COUNT(*) AS product_count
FROM products;


-- Check number of payment records
SELECT COUNT(*) AS payment_record_count
FROM order_payments;

-- ============================================
-- 2. ORDERS DATA-QUALITY CHECKS
-- ============================================

-- Check for duplicate order IDs
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- Check for missing order approval dates
SELECT COUNT(*) AS missing_approval_dates
FROM orders
WHERE order_approved_at IS NULL;


-- Check for missing delivery dates
SELECT COUNT(*) AS missing_delivery_dates
FROM orders
WHERE order_delivered_customer_date IS NULL;


-- Check order status distribution
SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

-- ============================================
-- 3. ORDER ITEMS & PRODUCT CHECKS
-- ============================================

-- Check for duplicate order-item combinations
SELECT
    order_id,
    order_item_id,
    COUNT(*) AS duplicate_count
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;


-- Check for order items without a matching order
SELECT COUNT(*) AS unmatched_order_items
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- Check for order items without a matching product
SELECT COUNT(*) AS unmatched_products
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


-- Check for missing product categories
SELECT COUNT(*) AS missing_product_categories
FROM products
WHERE product_category_name IS NULL;

-- ============================================
-- 4. PAYMENT DATA CHECKS
-- ============================================

-- Check for missing payment types
SELECT COUNT(*) AS missing_payment_types
FROM order_payments
WHERE payment_type IS NULL;


-- Check for missing payment values
SELECT COUNT(*) AS missing_payment_values
FROM order_payments
WHERE payment_value IS NULL;


-- Check for negative payment values
SELECT COUNT(*) AS negative_payment_values
FROM order_payments
WHERE payment_value < 0;


-- Check payment method distribution
SELECT
    payment_type,
    COUNT(*) AS payment_count
FROM order_payments
GROUP BY payment_type
ORDER BY payment_count DESC;

-- ============================================
-- 5. OVERALL SALES PERFORMANCE
-- ============================================

-- Total product revenue from delivered orders
SELECT
    ROUND(SUM(oi.price), 2) AS total_product_revenue
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';


-- Total delivered orders
SELECT
    COUNT(DISTINCT order_id) AS delivered_orders
FROM orders
WHERE order_status = 'delivered';


-- Average order value
SELECT
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';


-- Average delivery time in days
SELECT
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ),
        2
    ) AS average_delivery_time_days
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;

  -- ============================================
-- 6. MONTHLY SALES ANALYSIS
-- ============================================

-- Monthly product revenue
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
    ROUND(SUM(oi.price), 2) AS monthly_revenue
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY sales_month
ORDER BY sales_month;


-- Monthly delivered orders
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS sales_month,
    COUNT(DISTINCT order_id) AS delivered_orders
FROM orders
WHERE order_status = 'delivered'
GROUP BY sales_month
ORDER BY sales_month;


-- Monthly average order value
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY sales_month
ORDER BY sales_month;

-- ============================================
-- 7. PRODUCT CATEGORY ANALYSIS
-- ============================================

-- Top 10 categories by revenue
SELECT
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS category_revenue
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY p.product_category_name
ORDER BY category_revenue DESC
LIMIT 10;


-- Top 10 categories by number of items sold
SELECT
    p.product_category_name,
    COUNT(*) AS items_sold
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY p.product_category_name
ORDER BY items_sold DESC
LIMIT 10;

-- ============================================
-- 8. CUSTOMER ANALYSIS
-- ============================================

-- Customer purchase frequency
SELECT
    order_count,
    COUNT(*) AS customer_count
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) AS customer_orders
GROUP BY order_count
ORDER BY order_count;


-- One-time vs repeat customers
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) AS customer_orders
GROUP BY customer_type;


-- Top 10 customers by product revenue
SELECT
    c.customer_unique_id,
    ROUND(SUM(oi.price), 2) AS customer_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY customer_revenue DESC
LIMIT 10;

-- ============================================
-- 9. GEOGRAPHIC ANALYSIS
-- ============================================

-- Revenue by customer state
SELECT
    c.customer_state,
    ROUND(SUM(oi.price), 2) AS state_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY state_revenue DESC;


-- Number of delivered orders by state
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS delivered_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY delivered_orders DESC;

-- ============================================
-- 10. PAYMENT ANALYSIS
-- ============================================

-- Orders by payment method
SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS order_count
FROM order_payments
GROUP BY payment_type
ORDER BY order_count DESC;


-- Total payment value by payment method
SELECT
    payment_type,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;


-- Average payment value by payment method
SELECT
    payment_type,
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY average_payment_value DESC;

-- ============================================
-- 11. DELIVERY ANALYSIS
-- ============================================

-- Average delivery time by month
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS sales_month,
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ),
        2
    ) AS average_delivery_days
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
GROUP BY sales_month
ORDER BY sales_month;


-- Average delivery time compared with estimated delivery date
SELECT
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_estimated_delivery_date
            )
        ),
        2
    ) AS average_days_vs_estimated
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;

  -- ============================================
-- 12. KEY BUSINESS INSIGHTS
-- ============================================

-- Overall sales performance
-- Total product revenue: R$13.22M
-- Delivered orders: 96,478
-- Average order value: R$137.04
-- Average delivery time: 12.50 days


-- Customer retention
-- 96.88% of customers made one purchase
-- 3.12% of customers made repeat purchases
-- Repeat customers had a higher average revenue per customer


-- Top revenue categories
-- beleza_saude
-- relogios_presentes
-- cama_mesa_banho


-- Geographic concentration
-- São Paulo (SP) generated the highest product revenue,
-- followed by Rio de Janeiro (RJ) and Minas Gerais (MG).


-- Payment methods
-- Credit card was the most frequently used payment method
-- and generated the highest total payment value.


-- Delivery performance
-- Average delivery time was 12.50 days.
-- Orders were delivered approximately 11.88 days earlier
-- than the estimated delivery date on average.