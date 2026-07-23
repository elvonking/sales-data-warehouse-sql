-- create an analytics view of product performance metrics

DROP VIEW IF EXISTS analytics.product_performance;

CREATE VIEW analytics.product_performance AS
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.brand,
    SUM(s.quantity) AS units_sold,
    ROUND(SUM(s.sales_amount), 2) as revenue,
    ROUND(SUM(s.profit), 2) as profit,
    ROUND((SUM(s.profit) / NULLIF(SUM(s.sales_amount), 0)) * 100, 2) AS profit_margin_percentage
FROM mart.dim_product p
JOIN mart.fact_sales s ON p.product_key = s.product_key
GROUP BY p.product_id, p.product_name, p.category, p.brand
ORDER BY revenue DESC;