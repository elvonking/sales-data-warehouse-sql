#runs the create_mart_tables.sql file to create the tables in the sales_analytics db schemas

psql -U postgres -d sales_analytics -f sql/schema/004_create_mart_tables.sql
