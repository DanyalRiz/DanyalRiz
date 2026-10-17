CREATE SCHEMA IF NOT EXISTS saas;
DROP TABLE IF EXISTS saas.subscriptions;
CREATE TABLE saas.subscriptions (
 subscription_id TEXT PRIMARY KEY,
 customer_id TEXT NOT NULL,
 start_date DATE NOT NULL,
 end_date DATE,
 plan TEXT NOT NULL,
 monthly_price NUMERIC(12,2) NOT NULL CHECK (monthly_price >= 0),
 acquisition_channel TEXT NOT NULL,
 status TEXT NOT NULL CHECK (status IN ('Active','Cancelled')),
 CHECK (end_date IS NULL OR end_date >= start_date)
);
\copy saas.subscriptions FROM 'projects/02-saas-churn/data/subscriptions.csv' WITH (FORMAT csv, HEADER true);
CREATE INDEX IF NOT EXISTS idx_saas_dates ON saas.subscriptions(start_date, end_date);
ANALYZE saas.subscriptions;
