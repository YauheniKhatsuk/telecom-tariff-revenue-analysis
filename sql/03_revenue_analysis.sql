-- =====================================================
-- 03_revenue_analysis.sql
-- Purpose: Calculate overlimit usage and monthly revenue
-- =====================================================

-- 1. Build monthly activity base
WITH monthly_duration AS (
    SELECT
        user_id,
        DATE_TRUNC('month', call_date)::date AS dt_month,
        CEIL(SUM(duration)) AS month_duration
    FROM telecom.calls
    GROUP BY user_id, dt_month
),

monthly_internet AS (
    SELECT
        user_id,
        DATE_TRUNC('month', session_date)::date AS dt_month,
        SUM(mb_used) AS month_mb_traffic
    FROM telecom.internet
    GROUP BY user_id, dt_month
),

monthly_sms AS (
    SELECT
        user_id,
        DATE_TRUNC('month', message_date)::date AS dt_month,
        COUNT(*) AS month_sms
    FROM telecom.messages
    GROUP BY user_id, dt_month
),

user_activity_months AS (
    SELECT user_id, dt_month FROM monthly_duration
    UNION
    SELECT user_id, dt_month FROM monthly_internet
    UNION
    SELECT user_id, dt_month FROM monthly_sms
),

users_stat AS (
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
),

-- 2. Join tariff data
user_tariff AS (
    SELECT user_id, tariff
    FROM telecom.users
),

-- 3. Calculate overlimits
user_over_limits AS (
    SELECT
        us.*,
        ut.tariff,
        t.rub_monthly_fee,

        GREATEST(us.month_duration - t.minutes_included, 0) AS duration_over,

        GREATEST(
            (us.month_mb_traffic - t.mb_per_month_included) / 1024.0,
            0
        ) AS gb_traffic_over,

        GREATEST(us.month_sms - t.messages_included, 0) AS sms_over,

        t.rub_per_minute,
        t.rub_per_gb,
        t.rub_per_message

    FROM users_stat us
    LEFT JOIN user_tariff ut
        ON us.user_id = ut.user_id
    LEFT JOIN telecom.tariffs t
        ON ut.tariff = t.tariff_name
),

-- 4. Calculate total monthly revenue
final_revenue AS (
    SELECT
        user_id,
        dt_month,
        tariff,
        month_duration,
        month_mb_traffic,
        month_sms,
        duration_over,
        gb_traffic_over,
        sms_over,

        rub_monthly_fee
        + duration_over * rub_per_minute
        + gb_traffic_over * rub_per_gb
        + sms_over * rub_per_message
        AS total_month_revenue,

        duration_over * rub_per_minute
        + gb_traffic_over * rub_per_gb
        + sms_over * rub_per_message
        AS overpayment

    FROM user_over_limits
)

-- 5. Final output
SELECT *
FROM final_revenue
ORDER BY user_id, dt_month;

-- 6. Average revenue by tariffs
SELECT
    tariff,
    AVG(total_month_revenue) AS avg_monthly_revenue
FROM final_revenue
GROUP BY tariff;

-- 7. Average overpayment of active users
SELECT
    tariff,
    AVG(overpayment) AS avg_overpayment
FROM final_revenue
WHERE overpayment > 0
GROUP BY tariff;

-- 8. Share of users exceeding limits
SELECT
    tariff,
    COUNT(DISTINCT user_id) FILTER (WHERE overpayment > 0)::float
    / COUNT(DISTINCT user_id) AS overlimit_user_share
FROM final_revenue
GROUP BY tariff;
