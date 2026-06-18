/*
===============================================================================
Over Time Analysis
===============================================================================

Purpose:
    - Analyze sales performance trends over time.
    - Track yearly changes in total sales, customer activity, and product demand.
    - Helps identify growth patterns and business performance trends.

===============================================================================
*/
-- Analyse sales performance over time

        select 
        		DATETRUNC(YEAR,order_date) as year,
        		SUM(sales) as total_sales,
        		COUNT(distinct customer_key) as total_customers,
        		SUM(quantity) as total_quantity
        from gold.fact_sales
        where order_date is not null
        group by DATETRUNC(YEAR,order_date)
        order by DATETRUNC(YEAR,order_date)
