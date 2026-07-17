
DROP TABLE IF EXISTS raw.sales CASCADE;

DROP TABLE IF EXISTS raw.products CASCADE;

DROP TABLE IF EXISTS raw.customers CASCADE;


CREATE TABLE IF NOT EXISTS raw.customers (
    customer_id INT,
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


CREATE TABLE IF NOT EXISTS raw.products (
    product_id INT,
    product_name TEXT,
    category TEXT,
    subcategory TEXT,
    brand TEXT,
    supplier TEXT,
    unit_cost NUMERIC,
    selling_price NUMERIC,
    stock_quantity INT,
    reorder_level INT,
    launch_date DATE,
    discontinued BOOLEAN
);


CREATE TABLE IF NOT EXISTS raw.sales (
    sale_id INT,
    order_number TEXT,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT,
    unit_price NUMERIC,
    discount_percent NUMERIC,
    tax_percent NUMERIC,
    payment_method TEXT,
    sales_channel TEXT,
    sales_rep TEXT,
    warehouse TEXT,
    shipping_cost NUMERIC,
    order_status TEXT,
    delivery_days INT
);
