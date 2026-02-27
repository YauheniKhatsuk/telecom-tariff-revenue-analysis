-- =====================================================
-- 01_data_validation.sql
-- Project: Telecom Tariff Revenue Analysis
-- Purpose: Data quality checks before analytical calculations
-- =====================================================


-- 1. Inspect users table structure
SELECT *
FROM telecom.users
LIMIT 20;


-- 2. Check active users (churn_date IS NULL)
SELECT *
FROM telecom.users
WHERE churn_date IS NULL
LIMIT 10;


-- 3. Calculate retention rate
-- Retention = 1 - churned_users / total_users
SELECT 
    1 - (CAST(COUNT(churn_date) AS REAL) / COUNT(*)) AS retention_rate
FROM telecom.users;


-- 4. Check if active users have multiple tariffs (data inconsistency check)
SELECT 
    user_id, 
    COUNT(tariff) AS tariff_count
FROM telecom.users
WHERE churn_date IS NULL
GROUP BY user_id
HAVING COUNT(tariff) > 1;


-- 5. Check for NULL values in calls table
SELECT *
FROM telecom.calls
WHERE duration IS NULL 
   OR call_date IS NULL;


-- 6. Calculate missed call ratio (duration = 0)
SELECT 
    CAST(COUNT(*) AS REAL) / 
    (SELECT COUNT(*) FROM telecom.calls) AS missed_call_ratio
FROM telecom.calls
WHERE duration = 0;


-- 7. Identify users with unusually high daily call duration
SELECT
    user_id,
    call_date,
    SUM(duration) / 60 AS total_day_duration_hours
FROM telecom.calls
GROUP BY user_id, call_date
ORDER BY total_day_duration_hours DESC
LIMIT 10;
