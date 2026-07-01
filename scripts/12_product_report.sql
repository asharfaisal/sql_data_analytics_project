/*
===============================================================================
Product Report
===============================================================================

Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    
    2. Segments products by revenue to identify:
       - High-Performers
       - Mid-Range
       - Low-Performers

    3. Aggregates product-level metrics:
       - Total orders
       - Total sales
       - Total quantity sold
       - Total customers (unique)
       - Product lifespan (in months)

    4. Calculates valuable KPIs:
       - Recency (months since last sale)
       - Average order revenue (AOR)
       - Average monthly revenue

===============================================================================
*/
CREATE VIEW  gold.products_report AS
                               -- Base CTE: Combines product details with transaction-level sales data
with basic_cte as
(
select 

	p.product_key,
	p.product_number,
	p.product_name,
    p.category,
    p.sub_category,
    p.cost,
    f.order_number,
    f.sales,
    f.customer_key,
    f.quantity,
    f.order_date

from gold.fact_sales as f
left join gold.dim_products as p
on f.product_key = p.product_key
where order_date is not null
)
                                        -- Aggregation CTE: Calculates product-level sales and customer metrics
  
,aggregation_cte as
(
  select
      product_key,
  	product_number,
  	product_name,
      category,
      sub_category,
      cost,
      COUNT(distinct customer_key) as total_customers,
      COUNT(distinct order_number) as total_orders,
      SUM(sales) as total_sales,
      SUM(quantity) as total_quantity,
      MAX(order_date) as product_last_order,
      DATEDIFF(month,MIN(order_date),MAX(order_date)) as lifespan

  from basic_cte
  group by   
      product_key,
      product_number,
  	  product_name,
      category,
      sub_category,
      cost
 )
                                        -- Final query: Applies product segmentation and calculates performance KPIs
  
 select 
    product_key,
    product_number,
    product_name,
    category,
    sub_category,
    cost,
    total_customers,
    total_orders,
    total_quantity,
    total_sales,
    CASE 
    WHEN total_sales > 50000 THEN 'High-performers'
    WHEN total_sales >= 10000 THEN 'Mid-range'
    ELSE 'Low-performers'
    END AS product_performance,
    lifespan,
    DATEDIFF(month,product_last_order,GETDATE()) as recency,

    CASE
    WHEN total_orders = 0 THEN 0
    ELSE total_sales/total_orders
    END AS avg_order_revenue,

    CASE
    WHEN lifespan = 0 then total_sales
    ELSE total_sales/lifespan
    END AS avg_monthly_revenue

 from aggregation_cte
