# Power BI build specification

## Model
Subscriptions fact-like table with one row per subscription; Date dimension marked as date table. Active/start date is the primary relationship. Add an inactive relationship from Date[Date] to Subscriptions[end_date] for cancellation measures using USERELATIONSHIP. For ending-MRR snapshots, use the measure's as-of-date logic or import the SQL monthly snapshot view.

## Page 1 — Recurring revenue
KPI cards: Ending MRR, Active Subscriptions, Churned MRR, Logo Churn Rate. Line chart: Ending MRR by month. Bar charts: MRR by plan and by acquisition channel. Add month and plan slicers.

## Page 2 — Retention & cancellations
Monthly logo churn line, churned MRR by plan, cancellations by channel, subscription table with tenure days. Use tooltips to show metric definitions and drill-through to subscription detail.

## Validation
Reconcile Ending MRR with SQL view for the selected month. Validate end-date inclusivity. Explain that snapshot-based logo churn is not equivalent to customer-level retention cohorts.
