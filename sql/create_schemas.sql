-- =============================================
-- Schema Creation Script
-- Creates all schemas used in the E-Commerce
-- Analytics Data Warehouse
-- =============================================
-- Run this script once before executing the ETL pipeline
-- to ensure all required schemas exist in the database.
-- =============================================

-- =============================================
-- 1. Raw Schema
--    Holds raw CSV data loaded directly from source files.
--    Tables: customers, orders, order_items, products, payments
-- =============================================
CREATE SCHEMA IF NOT EXISTS raw;

-- =============================================
-- 2. Staging Schema
--    Holds cleaned and transformed data from the raw layer.
--    Tables: orders, order_items
-- =============================================
CREATE SCHEMA IF NOT EXISTS staging;

-- =============================================
-- 3. Warehouse Schema
--    Holds dimension and fact tables for the data warehouse.
--    Tables: dim_customers, dim_products, fact_orders
-- =============================================
CREATE SCHEMA IF NOT EXISTS warehouse;

-- =============================================
-- 4. Analytics Schema
--    Holds aggregated analytical tables for reporting.
--    Tables: customer_lifetime_value, top_customers, revenue_monthly
-- =============================================
CREATE SCHEMA IF NOT EXISTS analytics;
