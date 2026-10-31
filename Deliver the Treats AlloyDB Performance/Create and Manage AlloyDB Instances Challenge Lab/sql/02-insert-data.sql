-- ==============================================================================
-- Script: 02-insert-data.sql
-- Lab: GSP395 - Create and Manage AlloyDB Instances
-- Environment: PostgreSQL Console (psql connected to AlloyDB)
-- Description: Insert 19 records across regions, countries, and departments.
-- ==============================================================================

-- 1. Insert records into regions (4 records)
INSERT INTO regions (region_id, region_name) VALUES
    (1, 'Europe'),
    (2, 'Americas'),
    (3, 'Asia'),
    (4, 'Middle East and Africa');

-- 2. Insert records into countries (9 records)
INSERT INTO countries (country_id, country_name, region_id) VALUES
    ('IT', 'Italy', 1),
    ('JP', 'Japan', 3),
    ('US', 'United States of America', 2),
    ('CA', 'Canada', 2),
    ('CN', 'China', 3),
    ('IN', 'India', 3),
    ('AU', 'Australia', 3),
    ('ZW', 'Zimbabwe', 4),
    ('SG', 'Singapore', 3);

-- 3. Insert records into departments (6 records)
INSERT INTO departments (department_id, department_name, manager_id, location_id) VALUES
    (10, 'Administration', 200, 1700),
    (20, 'Marketing', 201, 1800),
    (30, 'Purchasing', 114, 1700),
    (40, 'Human Resources', 203, 2400),
    (50, 'Shipping', 121, 1500),
    (60, 'IT', 103, 1400);

