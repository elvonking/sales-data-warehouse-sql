-- a view of customer lifetime value (CLV) and related metrics

DROP VIEW IF EXISTS analytics.customer_lifetime_value;

CREATE VIEW analytics.customer_lifetime_value AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.customer_segment,
    COUNT(DISTINCT f.order_number) AS total_orders,
    ROUND(SUM(COALESCE(f.sales_amount, 0)), 2) AS lifetime_value,
    ROUND(SUM(COALESCE(f.profit, 0)), 2) AS lifetime_profit,
 -- True Average Order Value (AOV)
    ROUND(
        COALESCE(
            SUM(f.sales_amount) / NULLIF(COUNT(DISTINCT f.order_number), 0),
            0
        ), 
        2
    ) AS average_order_value,
    MIN(d.full_date) AS first_order_date,
    MAX(d.full_date) AS last_order_date,
    GREATEST(
        (MAX(d.full_date)::date - MIN(d.full_date)::date), 
        1
    ) AS customer_lifespan_days

FROM mart.dim_customer c
LEFT JOIN mart.fact_sales f ON f.customer_key = c.customer_key
LEFT JOIN mart.dim_date d ON f.date_key = d.date_key
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.customer_segment;
