/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.
*/


/*Group products by cost categories and
calculate the number of products in each category*/

with cost_cte as
(
select 
		product_key,
		product_name,
		cost,
		CASE WHEN cost < 100 then 'Below 100'
			 WHEN cost between 100 and 500 then '100-500'
			 WHEN cost between 500 and 1000 then '500-1000'
			 ELSE 'Above 1000'
		END AS cost_segments
from gold.dim_products
) 
    select 
    
    cost_segments,
    COUNT(product_key) as total_products
    from cost_cte
    group by cost_segments
    order by count_products desc


/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

with lifespan as
(
select 
	c.customer_key,
	SUM(sales) as total_sales,
	MIN(order_date) as first_order,
	MAX(order_date) as last_order,
	DATEDIFF(month,MIN(order_date),MAX(order_date)) as lifespan
from gold.fact_sales as s
left join gold.dim_customers as c
on s.customer_key = c.customer_key
group by c.customer_key
)
  select 
  COUNT(customer_key) as total_customers,
  customer_segments
  from
  (
      		select 
      		customer_key,
      		total_sales,
      		lifespan,
      		CASE WHEN lifespan >= 12 AND total_sales > 5000 then 'VIP'
      			 WHEN lifespan >= 12 AND total_sales <= 5000 then 'regular'
      			 ELSE 'NEW'
      		END AS customer_segments
      		from lifespan
  )t
  group by customer_segments
