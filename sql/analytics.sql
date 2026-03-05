-- =============================================
-- Analytics Layer Transformations
-- Populates analytics tables from warehouse layer
-- =============================================

-- Create schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS analytics;

-- =============================================
-- 1. Customer Lifetime Value
-- =============================================
DROP TABLE IF EXISTS analytics.customer_lifetime_value;

CREATE TABLE analytics.customer_lifetime_value AS
SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(price) AS lifetime_value
FROM warehouse.fact_orders
GROUP BY customer_id;

-- =============================================
-- 2. Top Customers (by total spend)
-- =============================================
DROP TABLE IF EXISTS analytics.top_customers;

CREATE TABLE analytics.top_customers AS
SELECT
    customer_id,
    SUM(price) AS total_spent
FROM warehouse.fact_orders
GROUP BY customer_id
ORDER BY total_spent DESC;

-- =============================================
-- 3. Monthly Revenue
-- =============================================
DROP TABLE IF EXISTS analytics.revenue_monthly;

CREATE TABLE analytics.revenue_monthly AS
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(price) AS revenue
FROM warehouse.fact_orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;
