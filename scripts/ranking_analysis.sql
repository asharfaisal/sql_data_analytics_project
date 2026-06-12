/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - Analyze product sales performance.
    - Identify the top 5 best-performing products and bottom 5 worst-performing
      products based on total revenue
    - Analyze customer contribution to overall revenue.
    - Identify the top 10 customers generating the highest revenue.
===============================================================================
*/


-- Top 5 best-performing products

SELECT *
FROM
(
    SELECT 
        p.product_name,
        SUM(f.sales) AS total_revenue,
        ROW_NUMBER() OVER(ORDER BY SUM(f.sales) DESC) AS ranking
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
        ON f.product_key = p.product_key
    GROUP BY 
        p.product_name

) t
WHERE ranking <= 5;



-- 5 worst-performing products

SELECT *
FROM
(
    SELECT 
        p.product_name,
        SUM(f.sales) AS total_revenue,
        ROW_NUMBER() OVER(ORDER BY SUM(f.sales) ASC) AS ranking
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
        ON f.product_key = p.product_key
    GROUP BY 
        p.product_name

) t
WHERE ranking <= 5;



-- Top 10 customers generating highest revenue

SELECT *
FROM
(
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(f.sales) AS total_revenue,
        ROW_NUMBER() OVER(ORDER BY SUM(f.sales) DESC) AS ranking
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_customers AS c
        ON f.customer_key = c.customer_key
    GROUP BY 
        c.customer_id,
        c.first_name,
        c.last_name

) t
WHERE ranking <= 10;
