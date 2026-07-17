--Load the data into the raw table

COPY raw.customers
FROM '/Users/elvisotwoma/Desktop/Projects/Sales Data Analysis/data/raw/customers.csv'
WITH (
    FORMAT csv, 
    HEADER true,
    DELIMITER ','
    );

COPY raw.products
FROM '/Users/elvisotwoma/Desktop/Projects/Sales Data Analysis/data/raw/products.csv'
WITH (
    FORMAT csv, 
    HEADER true,
    DELIMITER ','
    );

COPY raw.sales
FROM '/Users/elvisotwoma/Desktop/Projects/Sales Data Analysis/data/raw/sales.csv'
WITH (
    FORMAT csv, 
    HEADER true,
    DELIMITER ','
    );

