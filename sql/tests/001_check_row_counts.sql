-- Check row counts in staging and mart tables

SELECT COUNT(*) AS staging_sales_count
FROM staging.sales_clean;

SELECT COUNT(*) AS fact_sales_count
FROM mart.fact_sales;

-- expected output:  counts in the staging.sales_clean = mart.fact_sales tables
/* if the counts are not equal, investigate with: 

SELECT COUNT(*) AS missing_sales
FROM staging.sales_clean s
LEFT JOIN mart.fact_sales f
    ON s.sale_id = f.sale_id
WHERE f.sale_id IS NULL;

*/
