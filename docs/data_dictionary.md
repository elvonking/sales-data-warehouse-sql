# Sales Analytics Data Warehouse - Data Dictionary

## Overview

This document describes the data warehouse used in the Sales Analytics project. The warehouse follows a layered architecture:

```
Raw → Staging → Mart → Analytics
```

| Layer | Purpose |
|--------|---------|
| **Raw** | Stores ingested CSV data exactly as received. |
| **Staging** | Cleans, standardizes, validates, and prepares data for analytics. |
| **Mart** | Stores dimensional models (star schema) optimized for analysis. |
| **Analytics** | Business-ready views for dashboards and reporting. |

---

# Warehouse Schemas

## raw

Contains the original imported (in this case, generated using the faker library) CSV data with minimal transformations.

### Tables

| Table | Description |
|--------|-------------|
| customers | Raw customer records |
| products | Raw product records |
| sales | Raw sales transactions |

---

## staging

Contains cleaned and standardized data.

### Tables

| Table | Description |
|--------|-------------|
| customers_clean | Cleaned customer records |
| products_clean | Cleaned product records |
| sales_clean | Cleaned sales transactions |

Cleaning performed includes:

- Data type validation
- Standardized capitalization
- Trimmed whitespace
- Null handling
- Referential integrity
- Data quality checks

---

# Mart Schema

The mart schema follows a **star schema**.

```
                   dim_customer
                         |
                         |
dim_date -------- fact_sales -------- dim_product
```

---

# Table: mart.dim_customer

**Description**

Stores customer attributes used for reporting.

**Primary Key**

- customer_key

| Column | Type | Description |
|---------|------|-------------|
| customer_key | SERIAL | Warehouse surrogate key |
| customer_id | INT | Source system customer ID |
| first_name | TEXT | Customer first name |
| last_name | TEXT | Customer last name |
| email | TEXT | Customer email |
| phone | TEXT | Phone number |
| gender | TEXT | Gender |
| birth_date | DATE | Date of birth |
| city | TEXT | City |
| state | TEXT | State/Province |
| country | TEXT | Country |
| customer_segment | TEXT | Original customer segment from source |
| signup_date | DATE | Customer registration date |
| loyalty_points | INT | Loyalty program points |

---

# Table: mart.dim_product

**Description**

Stores descriptive information about products.

**Primary Key**

- product_key

| Column | Type | Description |
|---------|------|-------------|
| product_key | SERIAL | Warehouse surrogate key |
| product_id | INT | Source system product ID |
| product_name | TEXT | Product name |
| category | TEXT | Product category |
| subcategory | TEXT | Product subcategory |
| brand | TEXT | Product brand |
| supplier | TEXT | Supplier name |
| unit_cost | NUMERIC | Cost per unit |
| selling_price | NUMERIC | Selling price |
| stock_quantity | INT | Current inventory quantity |
| reorder_level | INT | Reorder threshold |
| launch_date | DATE | Product launch date |
| discontinued | BOOLEAN | Product availability flag |

---

# Table: mart.dim_date

**Description**

Calendar dimension for time-based analysis.

**Primary Key**

- date_key

| Column | Type | Description |
|---------|------|-------------|
| date_key | SERIAL | Warehouse surrogate key |
| full_date | DATE | Calendar date |
| year | INT | Calendar year |
| quarter | INT | Quarter number |
| month | INT | Month number |
| month_name | TEXT | Month name |
| day | INT | Day of month |
| day_name | TEXT | Weekday name |
| week | INT | ISO week number |

---

# Table: mart.fact_sales

**Description**

Stores sales transactions at the transaction level.

**Grain**

One row represents **one sales transaction**.

**Primary Key**

- sales_key

**Foreign Keys**

- customer_key → dim_customer
- product_key → dim_product
- date_key → dim_date

| Column | Type | Description |
|---------|------|-------------|
| sales_key | SERIAL | Warehouse surrogate key |
| sale_id | INT | Source system transaction ID |
| order_number | TEXT | Business order number |
| customer_key | INT | Customer dimension key |
| product_key | INT | Product dimension key |
| date_key | INT | Date dimension key |
| payment_method | TEXT | Payment method |
| sales_channel | TEXT | Sales channel |
| sales_rep | TEXT | Sales representative |
| warehouse | TEXT | Fulfillment warehouse |
| quantity | INT | Units sold |
| unit_price | NUMERIC | Selling price per unit |
| discount_percent | NUMERIC | Discount percentage |
| tax_percent | NUMERIC | Tax percentage |
| shipping_cost | NUMERIC | Shipping cost |
| sales_amount | NUMERIC | Net sales after discounts before tax |
| profit | NUMERIC | Sales amount minus product cost |

---

# Analytics Schema

Analytics views provide business-ready metrics for reporting.

---

# View: analytics.monthly_sales_performance

**Purpose**

Tracks monthly business performance.

| Column | Description |
|---------|-------------|
| year | Calendar year |
| month | Month number |
| month_name | Month name |
| total_orders | Number of unique orders |
| units_sold | Total quantity sold |
| revenue | Total sales revenue |
| profit | Total profit |
| profit_margin_percent | Profit margin percentage |

Example questions:

- How are sales trending?
- Which months perform best?
- How profitable is each month?

---

# View: analytics.product_performance

**Purpose**

Measures product sales performance.

| Column | Description |
|---------|-------------|
| product_id | Product identifier |
| product_name | Product name |
| category | Product category |
| brand | Product brand |
| units_sold | Units sold |
| revenue | Total revenue |
| profit | Total profit |
| margin_percent | Profit margin |

Example questions:

- Top-selling products
- Highest-profit products
- Category performance

---

# View: analytics.customer_lifetime_value

**Purpose**

Calculates customer lifetime metrics.

| Column | Description |
|---------|-------------|
| customer_id | Customer ID |
| customer_name | Customer full name |
| customer_segment | Original source segment |
| total_orders | Total completed orders |
| lifetime_value | Total revenue generated |
| average_order_value | Average revenue per order |
| lifetime_profit | Total profit generated |

Example questions:

- Highest-value customers
- Average order value
- Customer profitability

---

# View: analytics.customer_segmentation

**Purpose**

Classifies customers based on purchasing behaviour using Recency, Frequency and Monetary (RFM) metrics.

| Column | Description |
|---------|-------------|
| customer_id | Customer ID |
| customer_name | Customer full name |
| last_purchase_date | Most recent purchase date |
| recency_days | Days since last purchase |
| total_orders | Number of orders |
| lifetime_value | Total customer revenue |
| average_order_value | Average order value |
| customer_segment | Derived behavioural segment |

Possible segments:

| Segment | Description |
|----------|-------------|
| Champions | High value, frequent and recent customers |
| Loyal Customers | Frequent repeat buyers |
| Potential Loyalists | Recent customers with growth potential |
| At Risk | Previously active but becoming inactive |
| Lost | Long inactive customers |

---

# View: analytics.sales_channel_performance

**Purpose**

Measures performance by sales channel.

| Column | Description |
|---------|-------------|
| sales_channel | Sales channel |
| orders | Total orders |
| units_sold | Units sold |
| revenue | Revenue generated |
| profit | Profit generated |

Example questions:

- Which channel generates the most revenue?
- Which channel is most profitable?

---

# View: analytics.sales_rep_performance

**Purpose**

Measures sales representative performance.

| Column | Description |
|---------|-------------|
| sales_rep | Sales representative |
| orders | Total orders |
| revenue | Revenue generated |
| profit | Profit generated |

Example questions:

- Top-performing sales representatives
- Revenue by representative
- Profitability by representative

---

# Data Lineage

```
CSV Files
    │
    ▼
raw.customers
raw.products
raw.sales
    │
    ▼
staging.customers_clean
staging.products_clean
staging.sales_clean
    │
    ▼
mart.dim_customer
mart.dim_product
mart.dim_date
mart.fact_sales
    │
    ▼
analytics.monthly_sales_performance
analytics.product_performance
analytics.customer_lifetime_value
analytics.customer_segmentation
analytics.sales_channel_performance
analytics.sales_rep_performance
    │
    ▼
Streamlit Dashboard
```

---

# Warehouse Design Principles

- Star schema optimized for analytical workloads
- Surrogate keys used for all dimensions
- Business keys retained for traceability
- Referential integrity enforced through foreign keys
- Business-ready analytics exposed as SQL views
- Layered architecture separates ingestion, transformation, modeling and reporting