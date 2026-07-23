-- a view of sales rep performance metrics

DROP VIEW IF EXISTS analytics.sales_rep_performance;

CREATE VIEW analytics.sales_rep_performance AS
SELECT
    sales_rep,
    COUNT(DISTINCT order_number) AS orders,
    ROUND(SUM(sales_amount), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit
FROM mart.fact_sales
GROUP BY sales_rep;

