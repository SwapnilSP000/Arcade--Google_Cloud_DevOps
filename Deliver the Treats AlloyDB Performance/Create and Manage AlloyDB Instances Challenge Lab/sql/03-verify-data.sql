-- ==============================================================================
-- Script: 03-verify-data.sql
-- Lab: GSP395 - Create and Manage AlloyDB Instances
-- Environment: PostgreSQL Console (psql connected to AlloyDB)
-- Description: Inspect table definitions, record counts, and verify 19 records.
-- ==============================================================================

-- 1. Table inspection commands (run in psql)
\dt

-- 2. Describe table schemas
\d regions
\d countries
\d departments

-- 3. Verify record counts for each table
SELECT 'regions' AS table_name, COUNT(*) AS record_count FROM regions
UNION ALL
SELECT 'countries' AS table_name, COUNT(*) AS record_count FROM countries
UNION ALL
SELECT 'departments' AS table_name, COUNT(*) AS record_count FROM departments;

-- Expected Output:
--  table_name  | record_count
-- -------------+--------------
--  regions     |            4
--  countries   |            9
--  departments |            6
-- (Total: 19 records)

-- 4. Sample record retrieval
SELECT * FROM regions ORDER BY region_id;
SELECT * FROM countries ORDER BY country_name;
SELECT * FROM departments ORDER BY department_id;

