-- a view of customer segmentation based on lifetime value and other metrics

DROP VIEW IF EXISTS analytics.customer_segmentation;

CREATE VIEW analytics.customer_segmentation AS
WITH customer_metrics AS (

    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        clv.lifetime_value,
        clv.average_order_value,
        clv.total_orders,
        MAX(d.full_date) AS last_purchase_date,
        CURRENT_DATE - MAX(d.full_date) AS recency_days

    FROM mart.dim_customer c

    LEFT JOIN mart.fact_sales f
        ON c.customer_key = f.customer_key

    LEFT JOIN mart.dim_date d
        ON f.date_key = d.date_key

    LEFT JOIN analytics.customer_lifetime_value clv
        ON c.customer_id = clv.customer_id

    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        clv.lifetime_value,
        clv.average_order_value,
        clv.total_orders

)
SELECT

    customer_id,

    customer_name,

    last_purchase_date,

    recency_days,

    total_orders,

    lifetime_value,

    average_order_value,

    CASE

        WHEN recency_days <= 500
            AND total_orders >= 15
            AND lifetime_value >= 10000
            THEN 'Champions'

        WHEN recency_days <= 600
            AND total_orders >= 10
            THEN 'Loyal Customers'

        WHEN recency_days <= 750
            AND total_orders < 10
            THEN 'Potential Loyalists'

        WHEN recency_days BETWEEN 751 AND 900
            THEN 'At Risk'

        ELSE 'Lost'

    END AS customer_tier

FROM customer_metrics;
