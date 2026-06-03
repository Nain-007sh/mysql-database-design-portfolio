-- ============================================================
-- SQL Assignment 03 - Intermediate SQL
-- Course    : Database Management Systems
-- Instructor: Ahmed Shahzad
-- Due Date  : Sept 20, 2025 - 1 PM
-- ============================================================


-- ============================================================
-- PART A: BASIC QUERIES
-- ============================================================

-- ------------------------------------------------------------
-- QUESTION 1 (5 pts)
-- All customers from the USA, ordered by last_name ASC
-- ------------------------------------------------------------

SELECT *
FROM customers
WHERE country = 'USA'
ORDER BY last_name ASC;


-- ------------------------------------------------------------
-- QUESTION 2 (5 pts)
-- Products with price > $100, showing product_name and price only
-- ------------------------------------------------------------

SELECT product_name, price
FROM products
WHERE price > 100;


-- ------------------------------------------------------------
-- QUESTION 3 (5 pts)
-- All orders placed in 2023, with customer first_name, last_name, and order_date
-- ------------------------------------------------------------

SELECT
    c.first_name,
    c.last_name,
    o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE YEAR(o.order_date) = 2023;


-- ------------------------------------------------------------
-- QUESTION 4 (5 pts)
-- Total number of products in each category, ordered by count DESC
-- ------------------------------------------------------------

SELECT
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM categories c
JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
ORDER BY product_count DESC;


-- ------------------------------------------------------------
-- QUESTION 5 (5 pts)
-- Customers who registered in January 2023, showing full name and email
-- ------------------------------------------------------------

SELECT
    CONCAT(first_name, ' ', last_name) AS full_name,
    email
FROM customers
WHERE YEAR(registration_date)  = 2023
  AND MONTH(registration_date) = 1;


-- ------------------------------------------------------------
-- QUESTION 6 (5 pts)
-- Products that are out of stock (stock_quantity = 0),
-- showing product_name and category_name
-- ------------------------------------------------------------

SELECT
    p.product_name,
    c.category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.stock_quantity = 0;


-- ============================================================
-- PART B: INTERMEDIATE QUERIES
-- ============================================================

-- ------------------------------------------------------------
-- QUESTION 7 (8 pts)
-- Top 5 customers by total order value: name, email, total spent
-- ------------------------------------------------------------

SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY total_spent DESC
LIMIT 5;


-- ------------------------------------------------------------
-- QUESTION 8 (8 pts)
-- Products that have NEVER been ordered: product_name and category_name
-- ------------------------------------------------------------

SELECT
    p.product_name,
    c.category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.product_id NOT IN (
    SELECT DISTINCT product_id
    FROM order_items
);


-- ------------------------------------------------------------
-- QUESTION 9 (8 pts)
-- Monthly sales summary for 2023:
-- month, number of orders, total revenue
-- ------------------------------------------------------------

SELECT
    DATE_FORMAT(order_date, '%Y-%m')    AS month,
    COUNT(order_id)                     AS number_of_orders,
    SUM(total_amount)                   AS total_revenue
FROM orders
WHERE YEAR(order_date) = 2023
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month ASC;


-- ------------------------------------------------------------
-- QUESTION 10 (8 pts)
-- Customers who placed more than 2 orders:
-- name, email, order count
-- ------------------------------------------------------------

SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
HAVING COUNT(o.order_id) > 2;


-- ------------------------------------------------------------
-- QUESTION 11 (8 pts)
-- Average order value by country, ordered highest to lowest
-- ------------------------------------------------------------

SELECT
    c.country,
    AVG(o.total_amount) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY avg_order_value DESC;


-- ============================================================
-- PART C: ADVANCED QUERIES
-- ============================================================

-- ------------------------------------------------------------
-- QUESTION 12 (10 pts)
-- ROW_NUMBER() to rank products within each category by price DESC
-- Shows: product_name, category_name, price, rank
-- ------------------------------------------------------------

SELECT
    p.product_name,
    c.category_name,
    p.price,
    ROW_NUMBER() OVER (
        PARTITION BY p.category_id
        ORDER BY p.price DESC
    ) AS price_rank
FROM products p
JOIN categories c ON p.category_id = c.category_id
ORDER BY c.category_name, price_rank;


-- ------------------------------------------------------------
-- QUESTION 13 (10 pts)
-- Each customer with their most recent order details:
-- customer name, most recent order date, order total,
-- number of items in that order
-- ------------------------------------------------------------

WITH ranked_orders AS (
    SELECT
        o.customer_id,
        o.order_id,
        o.order_date,
        o.total_amount,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id
            ORDER BY o.order_date DESC
        ) AS rn
    FROM orders o
),
latest_orders AS (
    SELECT *
    FROM ranked_orders
    WHERE rn = 1
)
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    lo.order_date                           AS most_recent_order_date,
    lo.total_amount                         AS order_total,
    COUNT(oi.order_item_id)                 AS items_in_order
FROM customers c
JOIN latest_orders lo  ON c.customer_id  = lo.customer_id
JOIN order_items   oi  ON lo.order_id    = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name,
         lo.order_date, lo.total_amount
ORDER BY c.last_name;


-- ------------------------------------------------------------
-- QUESTION 14 (10 pts)
-- Products with above-average ratings that have at least 3 reviews:
-- product_name, average rating, number of reviews, category_name
-- ------------------------------------------------------------

SELECT
    p.product_name,
    AVG(r.rating)      AS avg_rating,
    COUNT(r.review_id) AS review_count,
    c.category_name
FROM products p
JOIN reviews    r ON p.product_id  = r.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY p.product_id, p.product_name, c.category_name
HAVING COUNT(r.review_id) >= 3
   AND AVG(r.rating) > (
       SELECT AVG(rating) FROM reviews
   )
ORDER BY avg_rating DESC;


-- ============================================================
-- BONUS QUESTIONS (Extra Credit)
-- ============================================================

-- ------------------------------------------------------------
-- BONUS QUESTION 1 (10 pts)
-- Customer retention rate by month in 2023:
-- For each month, % of customers who made a repeat purchase
-- (i.e., had more than one order total across all time)
-- ------------------------------------------------------------

WITH repeat_customers AS (
    -- customers who have placed more than 1 order (ever)
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
),
monthly_customers AS (
    -- distinct customers who ordered each month in 2023
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        customer_id
    FROM orders
    WHERE YEAR(order_date) = 2023
    GROUP BY DATE_FORMAT(order_date, '%Y-%m'), customer_id
)
SELECT
    mc.month,
    COUNT(DISTINCT mc.customer_id)                               AS total_customers_that_month,
    COUNT(DISTINCT rc.customer_id)                               AS repeat_customers_that_month,
    ROUND(
        100.0 * COUNT(DISTINCT rc.customer_id)
              / NULLIF(COUNT(DISTINCT mc.customer_id), 0),
    2)                                                           AS retention_rate_pct
FROM monthly_customers mc
LEFT JOIN repeat_customers rc
       ON mc.customer_id = rc.customer_id
GROUP BY mc.month
ORDER BY mc.month;


-- ------------------------------------------------------------
-- BONUS QUESTION 2 (10 pts)
-- High-value customers: top 20% by total spending
-- Shows their details + suggested marketing strategy
-- ------------------------------------------------------------

WITH customer_spending AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS full_name,
        c.email,
        c.country,
        SUM(o.total_amount)                     AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.country
),
ranked_spending AS (
    SELECT
        *,
        PERCENT_RANK() OVER (ORDER BY total_spent DESC) AS spend_percentile
    FROM customer_spending
)
SELECT
    customer_id,
    full_name,
    email,
    country,
    total_spent,
    ROUND(spend_percentile * 100, 2) AS percentile,
    -- Marketing strategy suggestion
    CASE
        WHEN total_spent >= 5000
            THEN 'VIP Tier - Assign dedicated account manager, offer exclusive early access to new products and premium loyalty rewards.'
        WHEN total_spent >= 2000
            THEN 'Gold Tier - Send personalised discount codes (15-20%), invite to beta product launches and member-only sale events.'
        ELSE
            'High-Value Tier - Enrol in loyalty programme, send targeted upsell emails based on purchase history.'
    END AS marketing_strategy
FROM ranked_spending
WHERE spend_percentile <= 0.20
ORDER BY total_spent DESC;

-- ============================================================
-- END OF ASSIGNMENT 03
-- ============================================================
