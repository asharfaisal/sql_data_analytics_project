/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
*/

-- Explore customer geographic distribution by identifying all countries

SELECT DISTINCT country
FROM gold.dim_customers
ORDER BY country

-- Explore customer demographics by identifying available gender categories

SELECT DISTINCT gender
FROM gold.dim_customers
ORDER BY gender

-- Explore the product catalog structure by listing unique categories,
-- subcategories, and products in a hierarchical order

SELECT DISTINCT 
	   category,
	   sub_category,
	   product_name

FROM gold.dim_products
ORDER BY category,sub_category,product_name
