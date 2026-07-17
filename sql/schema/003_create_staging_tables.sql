-- create the staging.customers_clean table
DROP TABLE IF EXISTS staging.customers_clean CASCADE;
CREATE TABLE staging.customers_clean(
    customer_id INT PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    phone TEXT,
    gender TEXT,
    birth_date DATE,
    city TEXT,
    state TEXT,
    country TEXT,
    signup_date DATE,
    customer_segment TEXT,
    loyalty_points INT
);
-- insert cleaned data into the staging.customers_clean table
INSERT INTO staging.customers_clean
SELECT
    customer_id,
    INITCAP(TRIM(first_name)) AS first_name,
    INITCAP(TRIM(last_name)) AS last_name,
    TRIM(email) AS email,
    NULLIF(TRIM(phone), '') AS phone,
    gender,
    birth_date,
    INITCAP(TRIM(city)) AS city,
    INITCAP(TRIM(state)) AS state,
    country,
    signup_date,
    COALESCE(customer_segment, 'Unknown') AS customer_segment,
    COALESCE(loyalty_points, 0) AS loyalty_points
FROM raw.customers;

-- create the staging.products_clean table
DROP TABLE IF EXISTS staging.products_clean CASCADE;

CREATE TABLE staging.products_clean(
    product_id INT PRIMARY KEY,
    product_name TEXT,
    category TEXT,
    subcategory TEXT,
    brand TEXT,
    supplier TEXT,
    unit_cost NUMERIC(10,2),
    selling_price NUMERIC(10,2),
    stock_quantity INT,
    reorder_level INT,
    launch_date DATE,
    discontinued BOOLEAN
);

-- insert cleaned data into the staging.products_clean table
INSERT INTO staging.products_clean
SELECT
    product_id,
    INITCAP(TRIM(product_name)) AS product_name,   
    INITCAP(TRIM(category)) AS category,
    INITCAP(TRIM(subcategory)) AS subcategory,
    COALESCE(INITCAP(TRIM(brand)), 'Unknown') AS brand,
    supplier,
    CASE WHEN unit_cost < 0 THEN NULL ELSE unit_cost END AS unit_cost,
    CASE WHEN selling_price < 0 THEN NULL ELSE selling_price END AS selling_price,
    COALESCE(stock_quantity, 0) AS stock_quantity,
    reorder_level,
    launch_date,
    discontinued
FROM raw.products;

-- create the staging.sales_clean table
DROP TABLE IF EXISTS staging.sales_clean CASCADE;
CREATE TABLE staging.sales_clean(
    sale_id INT PRIMARY KEY,
    order_number TEXT,
    customer_id INT REFERENCES staging.customers_clean(customer_id),
    product_id INT REFERENCES staging.products_clean(product_id),
    order_date DATE,
    quantity INT,
    unit_price NUMERIC(10,2),
    discount_percent NUMERIC(5,2),
    tax_percent NUMERIC(5,2),
    payment_method TEXT,
    sales_channel TEXT,
    sales_rep TEXT,
    warehouse TEXT,
    shipping_cost NUMERIC(10,2),
    order_status TEXT,
    delivery_days INT
);

-- insert cleaned data into the staging.sales_clean table
INSERT INTO staging.sales_clean
SELECT
    sale_id,
    order_number,
    customer_id,
    product_id,
    order_date,
    CASE WHEN quantity < 0 THEN NULL ELSE quantity END AS quantity,
    CASE WHEN unit_price < 0 THEN NULL ELSE unit_price END AS unit_price,
    CASE WHEN discount_percent > 100 THEN 0 
         WHEN discount_percent < 0 THEN 0
         ELSE discount_percent END AS discount_percent,
    tax_percent,
    COALESCE(payment_method, 'Unknown') AS payment_method,
    sales_channel,
    sales_rep,
    warehouse,
    COALESCE(shipping_cost, 0) AS shipping_cost,
    order_status,
    CASE WHEN delivery_days < 0 THEN NULL ELSE delivery_days END AS delivery_days
FROM raw.sales;

-- create indexes on the staging.sales_clean table
CREATE INDEX idx_sales_customer
ON staging.sales_clean(customer_id);

CREATE INDEX idx_sales_product
ON staging.sales_clean(product_id);