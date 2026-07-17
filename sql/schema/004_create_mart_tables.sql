-- Create mart tables: dimension tables (dim_customer, dim_product and dim_date) and fact tables (fact_sales)

-- create dim_customer table

DROP TABLE IF EXISTS mart.dim_customer CASCADE;

CREATE TABLE IF NOT EXISTS mart.dim_customer (
    customer_key SERIAL PRIMARY KEY,
    customer_id INT UNIQUE,
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

INSERT INTO mart.dim_customer(
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    gender,
    birth_date,
    city,
    state,
    country,
    signup_date,
    customer_segment,
    loyalty_points
)
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    gender,
    birth_date,
    city,
    state,
    country,
    signup_date,
    customer_segment,
    loyalty_points
FROM staging.customers_clean;

-- create dim_product table

DROP TABLE IF EXISTS mart.dim_product CASCADE;

CREATE TABLE IF NOT EXISTS mart.dim_product (
    product_key SERIAL PRIMARY KEY,
    product_id INT UNIQUE,
    product_name TEXT,
    category TEXT,
    subcategory TEXT,
    brand TEXT,
    supplier TEXT,
    unit_cost NUMERIC(10,2),
    selling_price NUMERIC(10,2),
    stock_quantity INT, -- leaving this here because the underlying data is a static csv
    reorder_level INT,
    launch_date DATE,
    discontinued BOOLEAN
);

INSERT INTO mart.dim_product(
    product_id,
    product_name,
    category,
    subcategory,
    brand,
    supplier,
    unit_cost,
    selling_price,
    stock_quantity, 
    reorder_level,
    launch_date,
    discontinued
)
SELECT
    product_id,
    product_name,
    category,
    subcategory,
    brand,
    supplier,
    unit_cost,
    selling_price,
    stock_quantity, 
    reorder_level,
    launch_date,
    discontinued
FROM staging.products_clean;

-- create dim_date table

DROP TABLE IF EXISTS mart.dim_date CASCADE;

CREATE TABLE IF NOT EXISTS mart.dim_date (
    date_key SERIAL PRIMARY KEY,
    full_date DATE UNIQUE,
    year INT,
    quarter INT,
    month INT,
    month_name TEXT,
    day INT,
    day_name TEXT,
    week INT
    --,is_weekend BOOLEAN
);

INSERT INTO mart.dim_date(
    full_date,
    year,
    quarter,
    month,
    month_name,
    day,
    day_name,
    week
    --,is_weekend
)
SELECT DISTINCT
    order_date,
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(QUARTER FROM order_date) AS quarter,
    EXTRACT(MONTH FROM order_date) AS month,
    TO_CHAR(order_date, 'Month') AS month_name,
    EXTRACT(DAY FROM order_date) AS day,
    TO_CHAR(order_date, 'Day') AS day_name,
    EXTRACT(WEEK FROM order_date) AS week
    --, CASE WHEN EXTRACT(DOW FROM order_date) IN (0, 6) THEN TRUE ELSE FALSE END AS is_weekend
FROM staging.sales_clean;

-- create fact_sales table
DROP TABLE IF EXISTS mart.fact_sales CASCADE;

DROP TABLE IF EXISTS mart.fact_sales CASCADE;
CREATE TABLE mart.fact_sales (
    sales_key SERIAL PRIMARY KEY,
    sale_id INT UNIQUE,
    order_number TEXT,
    customer_key INT REFERENCES mart.dim_customer(customer_key),
    product_key INT REFERENCES mart.dim_product(product_key),
    date_key INT REFERENCES mart.dim_date(date_key),
    payment_method TEXT,
    sales_channel TEXT,
    sales_rep TEXT,
    warehouse TEXT,
    quantity INT,
    unit_price NUMERIC(10,2),
    discount_percent NUMERIC(5,2),
    tax_percent NUMERIC(5,2),
    shipping_cost NUMERIC(10,2),
    sales_amount NUMERIC(12,2),
    profit NUMERIC(12,2)
);

INSERT INTO mart.fact_sales (
    sale_id,
    order_number,
    customer_key,
    product_key,
    date_key,
    payment_method,
    sales_channel,
    sales_rep,
    warehouse,
    quantity,
    unit_price,
    discount_percent,
    tax_percent,
    shipping_cost,
    sales_amount,
    profit
)
SELECT
    s.sale_id,
    s.order_number,
    c.customer_key,
    p.product_key,
    d.date_key,
    s.payment_method,
    s.sales_channel,
    s.sales_rep,
    s.warehouse,
    s.quantity,
    s.unit_price,
    COALESCE(s.discount_percent,0),
    COALESCE(s.tax_percent,0),
    COALESCE(s.shipping_cost,0),
    ROUND((s.quantity * s.unit_price * (1 - COALESCE(s.discount_percent,0) / 100.0))::numeric, 2) AS sales_amount,
    ROUND(
        (
            (s.quantity * s.unit_price * (1 - COALESCE(s.discount_percent,0) / 100.0))
            -
            (s.quantity * p.unit_cost))::numeric,
        2
    ) AS profit
FROM staging.sales_clean s
INNER JOIN mart.dim_customer c
    ON s.customer_id = c.customer_id
INNER JOIN mart.dim_product p
    ON s.product_id = p.product_id
INNER JOIN mart.dim_date d
    ON s.order_date = d.full_date;

-- create indexes on the fact_sales table
CREATE INDEX idx_fact_sales_customer
ON mart.fact_sales(customer_key);
CREATE INDEX idx_fact_sales_product
ON mart.fact_sales(product_key);
CREATE INDEX idx_fact_sales_date
ON mart.fact_sales(date_key);
CREATE INDEX idx_fact_sales_order
ON mart.fact_sales(order_number);

