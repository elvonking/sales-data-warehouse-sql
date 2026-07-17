# runs the 003_create_staging_tables.sql script to create the staging tables in the database

psql -U postgres -d sales_analytics -f sql/schema/003_create_staging_tables.sql
