/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To measure and summarize data in groups
    - To understand how data is spread across different categories
*/


-- Customers by country
        SELECT
                country,
                COUNT(DISTINCT customer_key) AS total_customers_by_country
        FROM gold.dim_customers
        GROUP BY country
        ORDER BY total_customers_by_country DESC;


-- Customers by gender
        SELECT
                gender,
                COUNT(gender) AS total_customers_by_gender
        FROM gold.dim_customers
        GROUP BY gender
        ORDER BY total_customers_by_gender DESC;


-- Customers by country (duplicate analysis)
        SELECT
                country,
                COUNT(DISTINCT customer_key) AS total_customers_by_country
        FROM gold.dim_customers
        GROUP BY country
        ORDER BY total_customers_by_country DESC;


-- Products by category
        SELECT
                category,
                COUNT(product_name) AS total_products_by_category
        FROM gold.dim_products
        GROUP BY category
        ORDER BY total_products_by_category DESC;


-- Average cost by category
        SELECT
                category,
                AVG(cost) AS average_cost_by_category
        FROM gold.dim_products
        GROUP BY category
        ORDER BY average_cost_by_category DESC;


-- Revenue by category
        SELECT
                p.category,
                SUM(f.sales) AS total_revenue
        FROM gold.fact_sales f
        LEFT JOIN gold.dim_products p
                ON p.product_key = f.product_key
        GROUP BY p.category
        ORDER BY total_revenue DESC;


-- Top customers by revenue
        SELECT
                c.customer_key,
                c.first_name,
                SUM(f.sales) AS total_revenue
        FROM gold.fact_sales f
        LEFT JOIN gold.dim_customers c
                ON f.customer_key = c.customer_key
        GROUP BY c.customer_key, c.first_name
        ORDER BY total_revenue DESC;


-- Items sold by country
        SELECT
                c.country,
                SUM(f.quantity) AS total_items_sold
        FROM gold.fact_sales AS f
        LEFT JOIN gold.dim_customers AS c
                ON f.customer_key = c.customer_key
        GROUP BY c.country
        ORDER BY total_items_sold DESC;
