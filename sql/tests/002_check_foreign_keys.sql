-- Check for missing customer references in fact_sales table (expected: 0)

SELECT COUNT(*) AS missing_customers
FROM mart.fact_sales f
LEFT JOIN mart.dim_customer c
    ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;

-- check for missing product references in fact_sales table (expected: 0)

SELECT COUNT(*) AS missing_products
FROM mart.fact_sales f
LEFT JOIN mart.dim_product p
    ON f.product_key = p.product_key
WHERE p.product_key IS NULL;

-- check for missing date references in fact_sales table (expected: 0)
SELECT COUNT(*) AS missing_dates
FROM mart.fact_sales f
LEFT JOIN mart.dim_date d
    ON f.date_key = d.date_key
WHERE d.date_key IS NULL;

