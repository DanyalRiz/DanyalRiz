# Project 02 — SaaS Subscription & Churn Intelligence

## Executive brief
A fictional B2B SaaS company needs a trustworthy recurring-revenue view and a clear picture of cancellation patterns. The analysis distinguishes monthly recurring revenue (MRR) from one-time revenue and defines churn explicitly.

## Questions
- How does end-of-month MRR change?
- What are logo churn and revenue churn?
- Which plan tiers and acquisition channels show higher cancellation?
- How much MRR is associated with cancelled subscriptions?

## Data and assumptions
`data/subscriptions.csv` contains one row per synthetic subscription, including start/end dates, plan, monthly price, acquisition channel, and status. For simplicity, each subscription is treated as active from start_date through end_date inclusive; blank end_date means still active. Monthly price is already normalized MRR. This dataset is a compact snapshot, not a full event ledger.

## Run
```bash
psql "$DATABASE_URL" -f projects/02-saas-churn/sql/01_schema_and_load.sql
psql "$DATABASE_URL" -f projects/02-saas-churn/sql/02_analysis.sql
```
Run from repository root because the CSV path is root-relative.

## Metric definitions
- **Ending MRR:** sum of monthly_price for subscriptions active on the final day of a month.
- **Logo churn:** subscriptions ending in month ÷ subscriptions active at the start of month. This simple denominator is documented; exclude voluntary/involuntary reason distinctions unless added.
- **Churned MRR:** monthly_price for subscriptions ending in the month.
- No expansion, contraction, trial, refund, or mid-month proration is modelled.

## Dashboard spec
**Page 1 — Recurring revenue:** Ending MRR, active subscriptions, churned MRR, logo churn; monthly MRR trend; MRR by plan; acquisition channel matrix.
**Page 2 — Retention:** churn by plan and channel; cancellation trend; subscription detail table with tenure and status; slicers for month, plan, channel.

## Advanced extension
For production-grade SaaS analytics, model subscription lifecycle events (new, expansion, contraction, churn, reactivation) and compute opening-to-closing MRR bridge. Never infer historic MRR solely from current status when historical price changes exist.
