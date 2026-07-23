# Sales Analytics Data Warehouse with PostgreSQL, SQL, Python & Streamlit

An end-to-end analytics engineering project that demonstrates how raw transactional sales data can be transformed into a production-style analytics warehouse using PostgreSQL. The project covers the complete data lifecycle from ingestion through dimensional modeling to business-ready analytics and visualization.

## Project Overview

The objective of this project is to simulate a real-world sales analytics platform that enables business users to answer questions such as:

- How are sales trending over time?
- Which products generate the most revenue and profit?
- Who are the highest-value customers?
- Which sales channels perform best?
- How are individual sales representatives performing?
- Which customer segments require marketing attention?

The project follows a modern ELT (Extract, Load, Transform) workflow and uses a layered data warehouse architecture.

---

# Architecture

```
                Python
        (Generate CSV Data)
                 │
                 ▼
           Raw CSV Files
                 │
                 ▼
         PostgreSQL Raw Schema
                 │
                 ▼
      SQL Data Cleaning & Validation
          (Staging Schema)
                 │
                 ▼
      Star Schema Data Warehouse
           (Mart Schema)
                 │
                 ▼
      Business Analytics Views
        (Analytics Schema)
                 │
                 ▼
        Streamlit Dashboard
```

---

# Tech Stack

| Technology | Purpose |
|------------|---------|
| PostgreSQL | Data warehouse |
| SQL | Data transformation and analytics |
| Python | Data generation |
| Faker | Synthetic dataset generation |
| Streamlit | Dashboard |
| Git | Version control |
| GitHub | Portfolio hosting |

---

# Project Structure

```
sales-analytics/
│
├── data/
│   └── raw/
│
├── scripts/
│   ├── generate_customers.py
│   ├── generate_products.py
│   └── generate_sales.py
│
├── sql/
│   ├── schema/
│   ├── staging/
│   ├── mart/
│   ├── analytics/
│   └── validation/
│
├── dashboard/
│
├── docs/
│   └── data_dictionary.md
│
├── README.md
└── requirements.txt
```

---

# Data Warehouse Architecture

The warehouse follows four logical layers.

## 1. Raw Layer

Purpose:

- Store source CSV files without modification.
- Preserve original data.
- Serve as the immutable source for transformations.

Tables:

- raw.customers
- raw.products
- raw.sales

---

## 2. Staging Layer

Purpose:

- Clean data
- Standardize formats
- Handle null values
- Validate data types
- Apply business rules
- Enforce referential integrity

Tables:

- staging.customers_clean
- staging.products_clean
- staging.sales_clean

---

## 3. Mart Layer

The warehouse is modeled using a **star schema**.

```
                  dim_customer
                        │
                        │
dim_date ─────── fact_sales ─────── dim_product
```

### Dimension Tables

- dim_customer
- dim_product
- dim_date

### Fact Table

- fact_sales

The fact table stores transactional metrics while the dimension tables provide descriptive business context.

---

## 4. Analytics Layer

Business-ready views built on top of the star schema.

Views include:

- monthly_sales_performance
- product_performance
- customer_lifetime_value
- customer_segmentation
- sales_channel_performance
- sales_rep_performance

These views power dashboards and reporting while hiding warehouse complexity from end users.

---

# Data Pipeline

```
CSV Files
     │
     ▼
Python Ingestion
     │
     ▼
raw Schema
     │
     ▼
Staging Transformations
     │
     ▼
Star Schema (Mart)
     │
     ▼
Analytics Views
     │
     ▼
Streamlit Dashboard
```

---

# Star Schema

```
                 dim_customer
                        │
                        │
                        │
dim_date ─────── fact_sales ─────── dim_product
```

The warehouse uses surrogate keys for all dimensions while preserving business keys for traceability.

---

# Analytics Produced

## Monthly Sales Performance

Provides:

- Monthly revenue
- Monthly profit
- Profit margin
- Units sold
- Orders

---

## Product Performance

Provides:

- Revenue by product
- Profit by product
- Units sold
- Product margins

---

## Customer Lifetime Value

Provides:

- Total customer spend
- Average order value
- Total orders
- Lifetime profit

---

## Customer Segmentation

Customers are segmented using purchasing behaviour based on Recency, Frequency and Monetary (RFM) metrics.

Segments include:

- Champions
- Loyal Customers
- Potential Loyalists
- At Risk
- Lost

---

## Sales Channel Performance

Provides:

- Revenue by channel
- Orders by channel
- Profit by channel

---

## Sales Representative Performance

Provides:

- Revenue by representative
- Profit by representative
- Orders handled

---

# Data Quality

The project includes several validation checks throughout the warehouse pipeline.

Examples include:

- Primary key constraints
- Foreign key constraints
- Row count validation
- Revenue reconciliation
- Duplicate transaction detection
- Referential integrity validation

---

# Key SQL Concepts Demonstrated

This project demonstrates practical experience with:

- Common Table Expressions (CTEs)
- Window Functions
- Aggregate Functions
- CASE Expressions
- Joins
- Views
- Constraints
- Primary and Foreign Keys
- Star Schema Design
- Dimensional Modeling
- Data Cleaning
- Data Validation
- Business Metric Calculation
- RFM Segmentation

---

# Dashboard

The Streamlit dashboard includes interactive visualizations for:

- Executive KPI Overview
- Monthly Sales Trends
- Product Performance
- Customer Analytics
- Sales Channel Analysis
- Sales Representative Performance

---

# Example Business Questions Answered

- Which month generated the highest revenue?
- Which products have the highest profit margins?
- Who are the highest-value customers?
- Which customers are at risk of churn?
- Which sales channel contributes the most revenue?
- Which sales representatives consistently outperform others?
- How does profitability vary across product categories?

---

# Future Improvements

Potential enhancements include:

- Apache Airflow orchestration
- dbt for SQL transformations
- Automated data quality testing
- Slowly Changing Dimensions (SCD Type 2)
- Incremental loading
- Dockerized deployment
- CI/CD with GitHub Actions
- Cloud deployment using AWS or Azure
- Interactive KPI alerts
- Inventory analytics
- Forecasting with machine learning

---

# Learning Outcomes

This project demonstrates the ability to:

- Design relational databases
- Build dimensional data warehouses
- Develop robust SQL transformation pipelines
- Apply analytics engineering principles
- Build business-ready reporting layers
- Translate business questions into analytical models
- Prepare data for BI dashboards

---

# Author

**Elvis Otwoma**

Data Analytics Lead | Analytics Engineer | Data Engineer

If you found this project interesting or have feedback, feel free to connect or reach out.