/*
===============================================================================
Product Sales Performance Analysis
===============================================================================

Purpose:
    - Analyze yearly sales performance for each product.
    - Compare product sales against its average yearly sales.
    - Identify year-over-year sales changes.
/*

with current_sales as
(
select 
	   year(s.order_date) as year,
	   p.product_name,
	   SUM(s.sales) as current_sales

from gold.fact_sales as s
left join gold.dim_products as p
on s.product_key = p.product_key
where order_date is not null
group by p.product_name,year(s.order_date)
)
      select 
          year,
      	product_name,
      	current_sales,
      	AVG(current_sales) over (partition by product_name) as average_sales,
      	current_sales - AVG(current_sales) over (partition by product_name) as diff_avg,
      
          	CASE 
          	WHEN current_sales - AVG(current_sales) over (partition by product_name) < 0 then 'Below Avg'
          	when current_sales - AVG(current_sales) over (partition by product_name) > 0 then 'Above Avg'
          	else 'Avg'
          	END AS flag_avg,
          
      	LAG(current_sales) over(partition by product_name order by year) as previous_year_sales,
      	current_sales - LAG(current_sales) over(partition by product_name order by year) as diff_previous_year,
      
          	CASE
          	WHEN current_sales - LAG(current_sales) over(partition by product_name order by year) > 0 then 'Increase'
          	WHEN current_sales - LAG(current_sales) over(partition by product_name order by year) < 0 then 'Decrease'
          	else 'No change'
          	END AS flag_previous_year_change
          
      from current_sales
      order by product_name,year
