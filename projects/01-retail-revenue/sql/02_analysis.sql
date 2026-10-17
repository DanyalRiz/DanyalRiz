-- Revenue is net of line discount; taxes/shipping are out of scope.
CREATE OR REPLACE VIEW retail.v_order_lines AS
SELECT *, quantity * unit_price AS gross_sales,
       quantity * unit_price - discount AS net_sales
FROM retail.order_lines;

CREATE OR REPLACE VIEW retail.v_monthly_performance AS
SELECT date_trunc('month', order_date)::date AS month,
       channel, COUNT(DISTINCT order_id) AS orders,
       COUNT(DISTINCT customer_id) AS customers,
       SUM(quantity) AS units,
       SUM(net_sales)::numeric(14,2) AS net_sales,
       (SUM(net_sales) / NULLIF(COUNT(DISTINCT order_id),0))::numeric(12,2) AS avg_order_value
FROM retail.v_order_lines
GROUP BY 1,2;

CREATE OR REPLACE VIEW retail.v_customer_rfm AS
WITH customer_stats AS (
  SELECT customer_id, MAX(order_date) AS last_order_date,
         COUNT(DISTINCT order_id) AS frequency,
         SUM(net_sales)::numeric(14,2) AS monetary
  FROM retail.v_order_lines GROUP BY customer_id
), scored AS (
  SELECT *, CURRENT_DATE - last_order_date AS recency_days,
         NTILE(5) OVER (ORDER BY CURRENT_DATE - last_order_date DESC) AS r_score,
         NTILE(5) OVER (ORDER BY frequency) AS f_score,
         NTILE(5) OVER (ORDER BY monetary) AS m_score
  FROM customer_stats
)
SELECT *, CASE
  WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
  WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal / engaged'
  WHEN r_score <= 2 AND f_score <= 2 THEN 'Needs reactivation'
  ELSE 'Develop'
END AS segment
FROM scored;

CREATE OR REPLACE VIEW retail.v_customer_cohort_retention AS
WITH first_purchase AS (
  SELECT customer_id, date_trunc('month', MIN(order_date))::date AS cohort_month
  FROM retail.order_lines GROUP BY customer_id
), activity AS (
  SELECT DISTINCT o.customer_id, f.cohort_month,
         date_trunc('month', o.order_date)::date AS activity_month,
         ((EXTRACT(YEAR FROM age(date_trunc('month', o.order_date), f.cohort_month)) * 12)
           + EXTRACT(MONTH FROM age(date_trunc('month', o.order_date), f.cohort_month)))::int AS month_number
  FROM retail.order_lines o JOIN first_purchase f USING (customer_id)
), cohort_size AS (
  SELECT cohort_month, COUNT(DISTINCT customer_id) AS cohort_customers
  FROM first_purchase GROUP BY cohort_month
), retained AS (
  SELECT cohort_month, month_number, COUNT(DISTINCT customer_id) AS active_customers
  FROM activity GROUP BY cohort_month, month_number
)
SELECT r.cohort_month, r.month_number, c.cohort_customers,
       r.active_customers,
       ROUND(100.0 * r.active_customers / NULLIF(c.cohort_customers,0), 1) AS retention_pct
FROM retained r JOIN cohort_size c USING (cohort_month)
ORDER BY 1,2;

-- Useful QA checks: both should return zero rows.
SELECT order_id, product_id, COUNT(*) AS duplicate_lines
FROM retail.order_lines GROUP BY 1,2 HAVING COUNT(*) > 1;
SELECT * FROM retail.order_lines WHERE discount > quantity * unit_price OR quantity <= 0;
