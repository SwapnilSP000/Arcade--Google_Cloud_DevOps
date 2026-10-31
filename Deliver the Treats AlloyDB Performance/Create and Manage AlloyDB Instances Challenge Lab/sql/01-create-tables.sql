-- ==============================================================================
-- Script: 01-create-tables.sql
-- Lab: GSP395 - Create and Manage AlloyDB Instances
-- Environment: PostgreSQL Console (psql connected to AlloyDB)
-- Description: Define database schemas for regions, countries, and departments.
-- ==============================================================================

-- 1. Table: regions
CREATE TABLE IF NOT EXISTS regions (
    region_id BIGINT NOT NULL PRIMARY KEY,
    region_name VARCHAR(25)
);

-- 2. Table: countries
CREATE TABLE IF NOT EXISTS countries (
    country_id CHAR(2) NOT NULL PRIMARY KEY,
    country_name VARCHAR(40),
    region_id BIGINT
);

-- 3. Table: departments
CREATE TABLE IF NOT EXISTS departments (
    department_id SMALLINT NOT NULL PRIMARY KEY,
    department_name VARCHAR(30),
    manager_id INTEGER,
    location_id SMALLINT
);

