# Power BI build specification

## Model
- Fact table: Order Lines (one row per order-product line).
- Dimensions recommended: Date, Customer, Product, Channel.
- Relationships: each dimension's primary key (1) to fact foreign key (*); single-direction filtering.
- Create a contiguous Date table, mark as date table, and relate Date[Date] to Order Lines[order_date].
- For cohort analysis, use the SQL view `retail.v_customer_cohort_retention` as a separate fact-like table.

## Page 1 — Executive overview
Top row: Net Sales, Orders, Average Order Value, Customers.
Middle: monthly Net Sales line chart; sales by channel clustered bar; category sales bar.
Bottom: discount amount and units sold. Slicers: Date, Channel, Category.

## Page 2 — Customer cohorts
Matrix rows = cohort_month; columns = month_number; values = retention_pct. Apply background conditional formatting.
Add customer segment bar chart and RFM table. Add drill-through page filtered by customer_id.

## Interaction & accessibility
Use synced date/channel slicers, descriptive titles, meaningful alt text, keyboard tab order, and consistent currency formatting. Avoid pie charts with many categories. Show the definition of net sales in a tooltip.
