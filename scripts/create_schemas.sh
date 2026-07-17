#runs the create_schemas.sql file to create the schemas in the sales_analytics db

psql -U postgres -d sales_analytics -f sql/schema/001_create_schemas.sql