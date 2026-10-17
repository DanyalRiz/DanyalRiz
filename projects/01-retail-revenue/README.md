# Project 01 — Retail Revenue & Customer Cohorts

## Executive brief
A fictional omnichannel retailer wants to understand revenue quality, product mix, repeat purchasing, and customer value. This project builds a repeatable PostgreSQL analysis layer and a Power BI executive dashboard.

## Business questions
1. How do net sales and order volume trend over time and by channel?
2. Which product categories and products contribute most to sales?
3. What share of customers return, and how does retention vary by first-purchase cohort?
4. Which customers appear high-value under a simple recency-frequency-monetary (RFM) view?

## Dataset
- `data/orders.csv`: synthetic order-line records with order/customer/product, date, channel, quantity, unit price, and discount.
- Grain: one order line per row. Multiple lines can belong to the same order.
- Values are illustrative, not market benchmarks.

## Run it
From this folder, run:
```bash
psql "$DATABASE_URL" -f sql/01_schema_and_load.sql
psql "$DATABASE_URL" -f sql/02_analysis.sql
```
The loader uses PostgreSQL's client-side `\copy`; run it from a local terminal with `psql` so the relative CSV path resolves. The analysis creates reusable views.

## Model and metric definitions
- **Gross sales** = quantity × unit price.
- **Net sales** = gross sales − line discount; no tax or shipping is modelled.
- **Repeat customer** = customer with more than one distinct order in the dataset.
- **Cohort month** = calendar month of a customer's first observed order.
- Cohort retention denominator is customers in that first-purchase cohort; the sample is intentionally small.

## Power BI dashboard specification
**Page 1 — Executive overview**
- KPI cards: Net Sales, Orders, Customers, Average Order Value.
- Line chart: monthly net sales and orders.
- Clustered bar: net sales by channel.
- Treemap: net sales by category.
- Slicers: order date, channel, category.

**Page 2 — Customer intelligence**
- Matrix: cohort month × months since first purchase, conditional formatting on retention.
- Bar chart: RFM segment / customer count.
- Detail table: customer, recency days, order frequency, monetary value.
- Drill-through from segment to customer detail.

## Interview talking points
- Explain why order count must use distinct order IDs rather than line count.
- Explain cohort denominator and why incomplete recent cohorts can appear weaker.
- Extend with a proper product/customer/date dimension and incremental refresh for larger data.

## Files
- `sql/01_schema_and_load.sql` — schema, table, CSV load, indexes.
- `sql/02_analysis.sql` — revenue, cohort, and RFM views.
- `powerbi/measures.dax` — core measures.
- `powerbi/dashboard-spec.md` — visual and interaction plan.
