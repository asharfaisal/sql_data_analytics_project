/*
===============================================================================
Customer Report
===============================================================================

Purpose:
    - This report consolidates key customer metrics and behaviors.

Highlights:
    1. Collects essential customer details such as names, ages, and transaction data.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Calculates customer-level metrics:
       - Total orders
       - Total sales
       - Total quantity purchased
       - Total products
       - Customer lifespan (in months)

    4. Calculates important KPIs:
       - Recency (months since last order)
       - Average order value
       - Average monthly spend

===============================================================================
*/
CREATE VIEW gold.customer_report AS 

                                  -- Base CTE: Combines customer and sales information for further analysis
with base_query as
(
select 
    c.customer_key,
    CONCAT(first_name,' ',last_name) as customer_name,
    DATEDIFF(YEAR, c.birthdate,GETDATE()) as age,
    f.order_number,
    f.order_date,
    f.sales,
    f.product_key,
    f.quantity
from
gold.fact_sales as f
left join gold.dim_customers as c
on f.customer_key = c.customer_key
where order_date is not null
)
                                   -- Aggregation CTE: Calculates customer-level purchasing metrics
,aggregation_query as
(
    select
        customer_key,
        customer_name,
        age,
        COUNT(distinct order_number) as total_orders,
        COUNT(distinct product_key) as total_products,
        SUM(quantity) as total_quantity,
        SUM(sales) as total_sales,
        MAX(order_date) as last_order,
        DATEDIFF(month,MIN(order_date),MAX(order_date)) as lifespan
        
    from base_query
    group by 
        customer_key,
        customer_name,
        age
)
                                    -- Final CTE: Applies customer segmentation and calculates business KPIs
    select
        customer_key,
        customer_name,
        CASE 
    
        WHEN lifespan >= 12 AND total_sales > 5000 then 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 then 'regular'
        ELSE 'NEW'
    
        END AS customer_segments,	
        age,
        CASE 
                WHEN age < 20 then 'Under 20'
                WHEN age between 20 and 29 then '20-29'
                WHEN age between 30 and 39 then '30-39'
                WHEN age between 40 and 49 then '40-49'
                ELSE 'Above 50'
        END AS age_group,
        total_orders,
        total_products,
        total_quantity,
        total_sales,
        last_order,
        lifespan,
                     --Calculates important KPIs:
    DATEDIFF(month,last_order,GETDATE()) as recency,
    CASE
        WHEN total_sales = 0 then 0
        ELSE total_sales/total_orders 
    END AS avg_order_value,
    CASE
        WHEN lifespan = 0 then 0
        ELSE total_sales/lifespan
    END AS avg_monthly_spend
   
from aggregation_query
  

  
