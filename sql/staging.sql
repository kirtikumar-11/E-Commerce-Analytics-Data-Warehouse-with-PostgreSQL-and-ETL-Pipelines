-- =============================================
-- Staging Layer Transformations
-- Cleans and selects relevant columns from raw layer
-- =============================================

-- Create schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS staging;

-- =============================================
-- 1. Staging Orders
-- =============================================
DROP TABLE IF EXISTS staging.orders;

CREATE TABLE staging.orders AS
SELECT
    order_id,
    customer_id,
    order_purchase_timestamp::DATE AS order_date,
    order_status
FROM raw.orders;

-- =============================================
-- 2. Staging Order Items
-- =============================================
DROP TABLE IF EXISTS staging.order_items;

CREATE TABLE staging.order_items AS
SELECT
    order_id,
    product_id,
    seller_id,
    price::NUMERIC,
    freight_value::NUMERIC
FROM raw.order_items;
