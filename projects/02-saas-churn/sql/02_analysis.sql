-- Monthly snapshot. Current sample is deliberately small and synthetic.
CREATE OR REPLACE VIEW saas.v_monthly_mrr AS
WITH bounds AS (
 SELECT date_trunc('month', MIN(start_date))::date AS first_month,
        date_trunc('month', GREATEST(CURRENT_DATE, MAX(COALESCE(end_date,CURRENT_DATE))))::date AS last_month
 FROM saas.subscriptions
), months AS (
 SELECT generate_series(first_month, last_month, interval '1 month')::date AS month_start FROM bounds
)
SELECT m.month_start,
       COALESCE(SUM(s.monthly_price) FILTER (
         WHERE s.start_date <= (m.month_start + interval '1 month - 1 day')::date
           AND (s.end_date IS NULL OR s.end_date >= (m.month_start + interval '1 month - 1 day')::date)
       ),0)::numeric(14,2) AS ending_mrr,
       COUNT(s.subscription_id) FILTER (
         WHERE s.start_date <= (m.month_start + interval '1 month - 1 day')::date
           AND (s.end_date IS NULL OR s.end_date >= (m.month_start + interval '1 month - 1 day')::date)
       ) AS active_subscriptions,
       COALESCE(SUM(s.monthly_price) FILTER (
         WHERE s.end_date >= m.month_start AND s.end_date < (m.month_start + interval '1 month')
       ),0)::numeric(14,2) AS churned_mrr,
       COUNT(s.subscription_id) FILTER (
         WHERE s.end_date >= m.month_start AND s.end_date < (m.month_start + interval '1 month')
       ) AS cancelled_subscriptions
FROM months m LEFT JOIN saas.subscriptions s ON s.start_date < m.month_start + interval '1 month'
GROUP BY m.month_start ORDER BY m.month_start;

CREATE OR REPLACE VIEW saas.v_subscription_detail AS
SELECT *, COALESCE(end_date, CURRENT_DATE) - start_date AS tenure_days,
       CASE WHEN end_date IS NULL THEN 'Active' ELSE 'Cancelled' END AS lifecycle_status
FROM saas.subscriptions;

-- Start-of-month active denominator, aligned to explicit inclusive end-date convention.
CREATE OR REPLACE VIEW saas.v_monthly_churn AS
WITH months AS (SELECT month_start FROM saas.v_monthly_mrr)
SELECT m.month_start,
       COUNT(s.subscription_id) FILTER (
         WHERE s.start_date < m.month_start
           AND (s.end_date IS NULL OR s.end_date >= m.month_start)
       ) AS opening_subscriptions,
       COUNT(s.subscription_id) FILTER (
         WHERE s.end_date >= m.month_start AND s.end_date < m.month_start + interval '1 month'
       ) AS churned_subscriptions,
       ROUND(100.0 * COUNT(s.subscription_id) FILTER (
         WHERE s.end_date >= m.month_start AND s.end_date < m.month_start + interval '1 month'
       ) / NULLIF(COUNT(s.subscription_id) FILTER (
         WHERE s.start_date < m.month_start
           AND (s.end_date IS NULL OR s.end_date >= m.month_start)
       ),0),2) AS logo_churn_pct
FROM months m LEFT JOIN saas.subscriptions s ON TRUE
GROUP BY m.month_start ORDER BY m.month_start;
