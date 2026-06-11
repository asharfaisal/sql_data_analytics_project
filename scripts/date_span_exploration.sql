
/*===========================================================
  Data Exploration: Date Range & Customer Demographics
  Purpose:
  - Analyze the time span  of orders since buiseness started
  - Identify the oldest and most recent order dates
  - Examine customer age demographics
  - Determine the age range of the customer base
===========================================================*/

-- Analyze the sales timeline by finding the first and last order dates
-- and calculating the total number of months covered by the sales data
        SELECT
               MIN(order_date) AS first_order_month,
               MAX(order_date) AS last_order_month,
               DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS sales_timeline_month
        FROM gold.fact_sales;

-- Analyze the sales timeline by finding the first and last order dates
-- and calculating the total number of year covered by the sales data
        SELECT
               MIN(order_date) AS first_order_year,
               MAX(order_date) AS last_order_year,
               DATEDIFF(year, MIN(order_date), MAX(order_date)) AS sales_timeline_year
        FROM gold.fact_sales;

-- Analyze customer age demographics by identifying the oldest and youngest
-- customers and calculating their current ages
        SELECT
               MIN(birthdate) AS oldest_customer,
               DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
               MAX(birthdate) AS youngest_customer,
               DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
        FROM gold.dim_customers;
