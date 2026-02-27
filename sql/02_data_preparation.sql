-- =====================================================
-- 02_data_preparation.sql
-- Purpose: Build monthly aggregated user activity dataset
-- =====================================================

-- 1. Monthly call duration per user
WITH monthly_duration AS (
    SELECT
        user_id,
        DATE_TRUNC('month', call_date)::date AS dt_month,
        CEIL(SUM(duration)) AS month_duration
    FROM telecom.calls
    GROUP BY user_id, dt_month
),

-- 2. Monthly internet traffic per user
monthly_internet AS (
    SELECT
        user_id,
        DATE_TRUNC('month', session_date)::date AS dt_month,
        SUM(mb_used) AS month_mb_traffic
    FROM telecom.internet
    GROUP BY user_id, dt_month
),

-- 3. Monthly SMS count per user
monthly_sms AS (
    SELECT
        user_id,
        DATE_TRUNC('month', message_date)::date AS dt_month,
        COUNT(*) AS month_sms
    FROM telecom.messages
    GROUP BY user_id, dt_month
),

-- 4. Combine all active months per user
user_activity_months AS (
    SELECT user_id, dt_month FROM monthly_duration
    UNION
    SELECT user_id, dt_month FROM monthly_internet
    UNION
    SELECT user_id, dt_month FROM monthly_sms
)

-- 5. Final monthly activity dataset
SELECT
    uam.user_id,
    uam.dt_month,
    COALESCE(md.month_duration, 0) AS month_duration,
    COALESCE(mi.month_mb_traffic, 0) AS month_mb_traffic,
    COALESCE(ms.month_sms, 0) AS month_sms
FROM user_activity_months uam
LEFT JOIN monthly_duration md
    ON uam.user_id = md.user_id
    AND uam.dt_month = md.dt_month
LEFT JOIN monthly_internet mi
    ON uam.user_id = mi.user_id
    AND uam.dt_month = mi.dt_month
LEFT JOIN monthly_sms ms
    ON uam.user_id = ms.user_id
    AND uam.dt_month = ms.dt_month
ORDER BY user_id, dt_month;
