-- creates a view of the sales channel performance metrics by quarter and year ranked by revenue

DROP VIEW IF EXISTS analytics.sales_channel_performance;

CREATE VIEW analytics.sales_channel_performance AS
SELECT
    d.year,
    d.quarter,
    s.sales_channel,
    COUNT(DISTINCT s.order_number) AS orders,
    SUM(s.quantity) AS units_sold,
    ROUND(SUM(s.sales_amount), 2) AS revenue,
    ROUND(SUM(s.profit), 2) AS profit,
    DENSE_RANK() OVER (
        PARTITION BY d.year, d.quarter 
        ORDER BY SUM(s.sales_amount) DESC
    ) AS channel_revenue_rank
FROM mart.fact_sales s
JOIN mart.dim_date d ON s.date_key = d.date_key 
GROUP BY 
    d.year,
    d.quarter,
    s.sales_channel;
