CREATE SCHEMA IF NOT EXISTS marketplace;
DROP TABLE IF EXISTS marketplace.shipments;
CREATE TABLE marketplace.shipments (
 order_id TEXT PRIMARY KEY,
 order_date DATE NOT NULL,
 region TEXT NOT NULL,
 seller_id TEXT NOT NULL,
 shipping_method TEXT NOT NULL,
 promised_delivery_date DATE NOT NULL,
 actual_delivery_date DATE NOT NULL,
 order_value NUMERIC(12,2) NOT NULL CHECK (order_value >= 0),
 refund_amount NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (refund_amount >= 0 AND refund_amount <= order_value),
 CHECK (promised_delivery_date >= order_date),
 CHECK (actual_delivery_date >= order_date)
);
\copy marketplace.shipments FROM 'projects/03-marketplace-ops/data/shipments.csv' WITH (FORMAT csv, HEADER true);
CREATE INDEX IF NOT EXISTS idx_marketplace_order_date ON marketplace.shipments(order_date);
CREATE INDEX IF NOT EXISTS idx_marketplace_seller ON marketplace.shipments(seller_id);
ANALYZE marketplace.shipments;
