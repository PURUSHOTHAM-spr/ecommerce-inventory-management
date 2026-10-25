-- =============================================================
-- E-Commerce Sales & Inventory Management System
-- Script: 01_create_database.sql
-- Purpose: Create the ecommerce_analytics database
-- MySQL Version: 8.0+
-- Run this script FIRST before any other scripts
-- =============================================================

-- Drop and recreate the database (use with caution in production)
DROP DATABASE IF EXISTS ecommerce_analytics;

CREATE DATABASE ecommerce_analytics
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE ecommerce_analytics;

-- Confirm the database is active
SELECT DATABASE() AS current_database;
