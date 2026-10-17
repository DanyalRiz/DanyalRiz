# Project 03 — Marketplace Operations & Delivery Performance

## Executive brief
A fictional online marketplace wants to reduce late deliveries and refunds while comparing seller reliability fairly. The project analyses order-level fulfilment outcomes and creates an operations scorecard.

## Questions
- What proportion of orders miss the promised delivery date?
- How do delivery delays and refunds vary by seller and shipping method?
- Which regions contribute most to operational friction?
- What are median and 90th-percentile delivery durations?

## Dataset
`data/shipments.csv`: one synthetic record per marketplace order. It includes order date, region, seller, shipping method, promised and actual delivery dates, order value, and refund amount.

## Run
From repository root:
```bash
psql "$DATABASE_URL" -f projects/03-marketplace-ops/sql/01_schema_and_load.sql
psql "$DATABASE_URL" -f projects/03-marketplace-ops/sql/02_analysis.sql
```

## Definitions
- **Late order:** actual_delivery_date > promised_delivery_date.
- **Delivery days:** actual delivery date − order date.
- **Late rate:** late orders ÷ delivered orders. All supplied rows are delivered; production analysis should separately handle undelivered/censored shipments.
- **Refund rate:** sum of refund amount ÷ sum of order value. This is value-weighted, not order-count-weighted.

## Dashboard spec
**Page 1 — Service levels:** delivered orders, late rate, median delivery days, refund rate; monthly late-rate trend; late rate by shipping method and region.
**Page 2 — Seller scorecard:** seller rank by late rate with minimum-volume context, refund value by seller, delivery-day distribution, order detail drill-through.

## Caveats
Small synthetic sample sizes can produce unstable seller rankings. Always show order volume beside rates and set minimum sample thresholds before using results to evaluate real partners.
