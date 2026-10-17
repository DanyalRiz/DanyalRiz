CREATE OR REPLACE VIEW marketplace.v_shipment_metrics AS
SELECT *,
       actual_delivery_date - order_date AS delivery_days,
       (actual_delivery_date > promised_delivery_date) AS is_late,
       actual_delivery_date - promised_delivery_date AS days_vs_promise
FROM marketplace.shipments;

CREATE OR REPLACE VIEW marketplace.v_monthly_ops AS
SELECT date_trunc('month', order_date)::date AS month,
       COUNT(*) AS orders,
       COUNT(*) FILTER (WHERE is_late) AS late_orders,
       ROUND(100.0 * COUNT(*) FILTER (WHERE is_late) / NULLIF(COUNT(*),0),2) AS late_rate_pct,
       percentile_cont(0.5) WITHIN GROUP (ORDER BY delivery_days) AS median_delivery_days,
       percentile_cont(0.9) WITHIN GROUP (ORDER BY delivery_days) AS p90_delivery_days,
       SUM(order_value)::numeric(14,2) AS order_value,
       SUM(refund_amount)::numeric(14,2) AS refunds,
       ROUND(100.0 * SUM(refund_amount) / NULLIF(SUM(order_value),0),2) AS refund_rate_pct
FROM marketplace.v_shipment_metrics
GROUP BY 1 ORDER BY 1;

CREATE OR REPLACE VIEW marketplace.v_seller_scorecard AS
SELECT seller_id, COUNT(*) AS order_count,
       COUNT(*) FILTER (WHERE is_late) AS late_orders,
       ROUND(100.0 * COUNT(*) FILTER (WHERE is_late) / NULLIF(COUNT(*),0),2) AS late_rate_pct,
       percentile_cont(0.5) WITHIN GROUP (ORDER BY delivery_days) AS median_delivery_days,
       SUM(order_value)::numeric(14,2) AS order_value,
       SUM(refund_amount)::numeric(14,2) AS refunds,
       ROUND(100.0 * SUM(refund_amount) / NULLIF(SUM(order_value),0),2) AS refund_rate_pct,
       RANK() OVER (ORDER BY COUNT(*) FILTER (WHERE is_late)::numeric / NULLIF(COUNT(*),0)) AS late_rate_rank
FROM marketplace.v_shipment_metrics
GROUP BY seller_id;

-- High-level QA: flag invalid refund totals or negative delivery times.
SELECT * FROM marketplace.v_shipment_metrics
WHERE refund_amount > order_value OR delivery_days < 0;
