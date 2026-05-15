CREATE DATABASE amazon_project;
use amazon_project;


-- AMAZON E-COMMERCE CAPSTONE PROJECT (SQL)



-- Top 10 Customers by Orders
SELECT
c.cid,
c.cname,
COUNT(o.oid) AS total_orders
FROM customers c
JOIN orders o ON c.cid = o.cid
GROUP BY c.cid, c.cname
ORDER BY total_orders DESC
LIMIT 10;

-- Customers Who Never Placed Orders
SELECT
c.cid,
c.cname
FROM customers c
LEFT JOIN orders o ON c.cid = o.cid
WHERE o.oid IS NULL;

-- Repeat Customers (>= 5 Orders)
SELECT
c.cid,
c.cname,
COUNT(o.oid) AS total_orders
FROM customers c
JOIN orders o ON c.cid = o.cid
GROUP BY c.cid, c.cname
HAVING COUNT(o.oid) >= 5
ORDER BY total_orders DESC;

-- Top 5 Most Sold Products
SELECT
p.pid,
p.pname,
COUNT(o.oid) AS total_sold
FROM products p
JOIN orders o ON p.pid = o.pid
GROUP BY p.pid, p.pname
ORDER BY total_sold DESC
LIMIT 5;

-- Revenue by Product
SELECT
p.pid,
p.pname,
SUM(p.price) AS total_revenue
FROM orders o
JOIN products p ON o.pid = p.pid
GROUP BY p.pid, p.pname
ORDER BY total_revenue DESC;

-- Products with Low Ratings (<= 2)
SELECT
p.pid,
p.pname,
AVG(f.rating) AS avg_rating
FROM products p
JOIN orders o ON p.pid = o.pid
JOIN feedback f ON o.oid = f.oid
GROUP BY p.pid, p.pname
HAVING AVG(f.rating) <= 2;

-- Average Rating per Product
SELECT
p.pid,
p.pname,
AVG(f.rating) AS avg_rating
FROM products p
JOIN orders o ON p.pid = o.pid
JOIN feedback f ON o.oid = f.oid
GROUP BY p.pid, p.pname
ORDER BY avg_rating DESC;


-- Revenue by City
SELECT
c.city,
SUM(p.price) AS total_revenue
FROM orders o
JOIN customers c ON o.cid = c.cid
JOIN products p ON o.pid = p.pid
GROUP BY c.city
ORDER BY total_revenue DESC;

-- Monthly Order Trend
SELECT
DATE_FORMAT(order_date, '%Y-%m') AS month,
COUNT(oid) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;

-- Monthly Revenue Trend
SELECT
DATE_FORMAT(o.order_date, '%Y-%m') AS month,
SUM(t.amount) AS total_revenue
FROM orders o
JOIN transactions t ON o.oid = t.oid
GROUP BY month
ORDER BY month;


-- Overall Conversion Rate
SELECT
COUNT(*) AS total_orders,
SUM(t.status = 'Success') AS successful_orders,
ROUND(SUM(t.status = 'Success') * 100.0 / COUNT(*), 2) AS conversion_rate
FROM orders o
LEFT JOIN transactions t ON o.oid = t.oid;

-- City-wise Conversion Rate
SELECT
c.city,
COUNT(*) AS total_orders,
SUM(t.status = 'Success') AS successful_orders,
ROUND(SUM(t.status = 'Success') * 100.0 / COUNT(*), 2) AS conversion_rate
FROM orders o
LEFT JOIN transactions t ON o.oid = t.oid
JOIN customers c ON c.cid = o.cid
GROUP BY c.city
ORDER BY conversion_rate DESC;



-- Orders Without Feedback
SELECT
c.cid,
c.cname,
o.oid
FROM customers c
JOIN orders o ON c.cid = o.cid
LEFT JOIN feedback f ON o.oid = f.oid
WHERE f.oid IS NULL;

-- Customers Giving Low Ratings (<=2)
SELECT
c.cid,
c.cname,
f.rating
FROM customers c
JOIN orders o ON c.cid = o.cid
JOIN feedback f ON o.oid = f.oid
WHERE f.rating <= 2;


-- Rank Products by Revenue
SELECT 
    p.pname,
    SUM(p.price) AS total_revenue,
    RANK() OVER (ORDER BY SUM(p.price) DESC) AS product_rank
FROM orders o
JOIN products p 
ON o.pid = p.pid
GROUP BY p.pname;

-- Top Customers by Revenue Contribution
WITH customer_revenue AS (
SELECT 
    c.cid,
    c.cname,
    SUM(p.price) AS total_spent
FROM customers c
JOIN orders o 
ON c.cid = o.cid
JOIN products p 
ON o.pid = p.pid
GROUP BY c.cid, c.cname
)
SELECT 
    cname,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) AS customer_rank
FROM customer_revenue;

-- Month wise Orders
SELECT 
MONTHNAME(order_date) AS month,
COUNT(oid) AS total_orders
FROM orders
GROUP BY MONTHNAME(order_date), MONTH(order_date)
ORDER BY MONTH(order_date);

-- Month wise Revenue
SELECT 
MONTHNAME(o.order_date) AS month,
SUM(t.amount) AS total_revenue
FROM orders o
JOIN transactions t 
ON o.oid = t.oid
GROUP BY MONTHNAME(o.order_date), MONTH(o.order_date)
ORDER BY MONTH(o.order_date);



