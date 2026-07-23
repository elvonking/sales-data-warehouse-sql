# this script runs the analytics view creation sql for all the views in the analytics schema

# psql -U postgres -d sales_analytics -f sql/analysis/001_monthly_sales_performance.sql
# psql -U postgres -d sales_analytics -f sql/analysis/002_product_performance.sql
# psql -U postgres -d sales_analytics -f sql/analysis/003_sales_channel_performance.sql
# psql -U postgres -d sales_analytics -f sql/analysis/004_customer_lifetime_value.sql
# psql -U postgres -d sales_analytics -f sql/analysis/005_customer_segmentation.sql
# psql -U postgres -d sales_analytics -f sql/analysis/006_sales_rep_performance.sql

# using a loop incase more views are added later
for file in sql/analysis/*.sql; do
    psql -U postgres -d sales_analytics -f "$file"
done
