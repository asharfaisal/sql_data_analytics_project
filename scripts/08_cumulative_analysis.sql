/*
===============================================================================
Cumulative Analysis
===============================================================================

Purpose:
    - Analyze yearly sales performance and pricing trends.
    - Evaluate revenue growth using running totals.
    - Track changes in average product prices over time.

Business Use Cases:
    - Identify long-term sales growth patterns.
    - Monitor pricing changes and their impact on revenue.
    - Support strategic decisions using historical sales trends.

===============================================================================
*/

-- total sales by year
-- running total sales over time(year)
-- moving average price over time(year)

select 
	year,
	total_sales,
	SUM(total_sales) over (order by year) as running_total_sales,
	AVG(avg_price) over (order by year) as moving_average_price

from
(
        select  
        		DATETRUNC(YEAR, order_date) as year,
        		SUM(sales) as total_sales,
        		AVG(price) as avg_price
        from gold.fact_sales
        where order_date is not null
        group by DATETRUNC(YEAR, order_date)
)t
