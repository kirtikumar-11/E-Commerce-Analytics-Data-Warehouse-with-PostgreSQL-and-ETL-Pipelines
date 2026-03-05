-- =============================================
-- Warehouse Layer Transformations
-- Builds dimension and fact tables from staging layer
-- =============================================

-- Create schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS warehouse;

-- =============================================
-- 1. Dimension: Customers
-- =============================================
DROP TABLE IF EXISTS warehouse.dim_customers;

CREATE TABLE warehouse.dim_customers AS
SELECT DISTINCT
    customer_id,
    customer_city,
    customer_state
FROM raw.customers;

-- =============================================
-- 2. Dimension: Products
-- =============================================
DROP TABLE IF EXISTS warehouse.dim_products;

CREATE TABLE warehouse.dim_products AS
SELECT DISTINCT
    product_id,
    product_category_name
FROM raw.products;

-- =============================================
-- 3. Fact: Orders
-- =============================================
DROP TABLE IF EXISTS warehouse.fact_orders;

CREATE TABLE warehouse.fact_orders AS
SELECT
    o.order_id,
    o.customer_id,
    oi.product_id,
    o.order_date,
    oi.price,
    oi.freight_value
FROM staging.orders o
JOIN staging.order_items oi ON o.order_id = oi.order_id;
