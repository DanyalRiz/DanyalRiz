# Power BI build specification

## Model
Fact: Shipments, one row per order. Add a Date dimension related to order_date; optionally add inactive relationships for actual and promised delivery dates. Keep rates as measures rather than averaging row-level percentages.

## Page 1 — Service levels
KPI cards: Delivered Orders, Late Rate, Median Delivery Days, Refund Rate. Monthly trend: Late Rate and Order Value. Bar charts: Late Rate by Shipping Method and Region. Add date and region slicers.

## Page 2 — Seller scorecard
Table: Seller, order count, late rate, median delivery days, refund value, refund rate. Conditional formatting for rates; show volume beside every seller rate. Scatter plot: order count vs late rate, size by order value. Drill-through to shipment details.

## UX and governance
Use percentage and currency formats consistently. Add a tooltip explaining late-rate denominator and a note that the dataset is synthetic. For real operations, define treatment for undelivered orders and incomplete delivery observations.
