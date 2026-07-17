#runs the 001_load_raw.sql file to load the raw data into the sales_analytics db raw schema

psql -U postgres -d sales_analytics -f sql/load/001_load_raw.sql