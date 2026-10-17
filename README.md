# Danyal's Portfolio | SQL & Power BI

**Advanced Data Analyst Portfolio** · PostgreSQL · Power BI · DAX · Analytics Engineering

I turn messy business questions into clear, decision-ready analytics. This repository is my portfolio hub, with three original end-to-end case studies using fully synthetic data. Each project includes reproducible PostgreSQL scripts, a dataset, DAX measures, and a Power BI dashboard specification.

## Featured projects

| Project | Business question | SQL / analytics focus | Power BI outcome |
|---|---|---|---|
| [01 — Retail Revenue & Customer Cohorts](projects/01-retail-revenue/README.md) | Which products, channels, and customer cohorts drive profitable growth? | Window functions, cohort retention, RFM, revenue reconciliation | Executive sales and customer dashboard |
| [02 — SaaS Subscription & Churn Intelligence](projects/02-saas-churn/README.md) | Where is recurring revenue leaking, and which segments are at risk? | MRR movement, churn, segmentation, date logic | SaaS KPI and churn-risk dashboard |
| [03 — Marketplace Operations & Delivery](projects/03-marketplace-ops/README.md) | What drives late delivery, refunds, and seller performance? | SLA analysis, percentile metrics, operational ranking | Operations and seller scorecard |

## Skills demonstrated

- **SQL (PostgreSQL):** CTEs, window functions, conditional aggregation, date spines, cohort analysis, percentiles, data quality checks, dimensional modelling.
- **Power BI:** star-schema modelling, filter context, KPI design, drill-through and tooltip specifications, time intelligence.
- **DAX:** explicit measures, safe division, dynamic period comparisons, customer / subscription / operations KPIs.
- **Analytics workflow:** business framing, synthetic data generation, reproducible scripts, documented assumptions, recommendations.

## Repository map

```text
.
├── README.md
├── assets/                 # Add dashboard screenshots here
└── projects/
    ├── 01-retail-revenue/  # CSV, PostgreSQL SQL, DAX, dashboard spec
    ├── 02-saas-churn/
    └── 03-marketplace-ops/
```

## Quick start

1. Install PostgreSQL 15+ and create a scratch database.
2. Open a project's README and run its `sql/01_schema_and_load.sql` script with `psql`.
3. Run the analysis script in the same project.
4. Import the project's CSV files into Power BI, or connect Power BI to the PostgreSQL views described in the README.
5. Create the model and measures using `powerbi/measures.dax`, then implement the dashboard from `powerbi/dashboard-spec.md`.

> **Data notice:** all people, companies, transactions, subscriptions, and operational events in this portfolio are synthetic and created for demonstration. They do not describe real customers or business results. Dashboard files (.pbix) are not included; detailed build specifications and DAX are provided so the reports can be recreated.

## About

I'm Danyal, an aspiring data analyst focused on translating business problems into trustworthy metrics and useful decisions. This portfolio is designed to show not just queries and visuals, but the reasoning behind metric definitions and recommendations.

**Contact:** Replace this line with your preferred professional email and LinkedIn URL before sharing with recruiters.
