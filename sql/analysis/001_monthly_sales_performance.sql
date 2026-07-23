
-- create an analytics table to track monthly sales performance
DROP View IF EXISTS analytics.monthly_sales_performance;

CREATE VIEW analytics.monthly_sales_performance AS
SELECT
    d.year,
    d.month,
    d.month_name,
    COUNT(DISTINCT f.order_number) as total_orders,
    SUM(f.quantity) as units_sold,
    ROUND(SUM(f.sales_amount), 2) as revenue,
    ROUND(SUM(f.profit), 2) as profit,
    ROUND((SUM(f.profit) / NULLIF(SUM(f.sales_amount), 0)) * 100, 2) as profit_margin_percentage
FROM mart.fact_sales f
JOIN mart.dim_date d ON f.date_key = d.date_key
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;


--select * from mart.fact_sales