-- PostgreSQL 15+ | Run from this project directory with psql.
CREATE SCHEMA IF NOT EXISTS retail;
DROP TABLE IF EXISTS retail.order_lines;
CREATE TABLE retail.order_lines (
    order_id       INTEGER NOT NULL,
    order_date     DATE NOT NULL,
    customer_id    TEXT NOT NULL,
    product_id     TEXT NOT NULL,
    product_name   TEXT NOT NULL,
    category       TEXT NOT NULL,
    channel        TEXT NOT NULL CHECK (channel IN ('Online','Store','Partner')),
    quantity       INTEGER NOT NULL CHECK (quantity > 0),
    unit_price     NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0),
    discount       NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (discount >= 0),
    CHECK (discount <= quantity * unit_price)
);
\copy retail.order_lines FROM 'projects/01-retail-revenue/data/orders.csv' WITH (FORMAT csv, HEADER true);
CREATE INDEX IF NOT EXISTS idx_retail_order_date ON retail.order_lines(order_date);
CREATE INDEX IF NOT EXISTS idx_retail_customer ON retail.order_lines(customer_id);
ANALYZE retail.order_lines;
