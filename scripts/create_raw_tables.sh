#runs the create_raw_tables.sql file to create the tables in the sales_analytics db schemas

psql -U postgres -d sales_analytics -f sql/schema/002_create_raw_tables.sql