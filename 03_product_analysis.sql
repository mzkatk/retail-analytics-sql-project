--Task1: Revenue per product
WITH product_rev_cte AS (
	SELECT stockcode, SUM(revenue) AS product_revenue
	FROM clean_retail
	GROUP BY stockcode
),


--Task2: Write a query that produces- stockcode, product_revenue, revenue_percentage, cumulative_revenue, cumulative_percentage

rev_percent as(
 	SELECT stockcode, product_revenue, 100.0*(product_revenue/SUM(product_revenue) over()) as revenue_percentage,
		SUM(product_revenue) over(order by product_revenue desc) as cumulative_revenue
	FROM product_rev_cte
),
final_calc as (SELECT stockcode, product_revenue, revenue_percentage as rev_percentage, cumulative_revenue, 
	100.0*cumulative_revenue/SUM(product_revenue) OVER () as cumulative_revenue_percentage
FROM rev_percent
),


--Task3: Write a query that returns- Total distinct products, Number of products contributing to 80% revenue,
--Percentage of products contributing to 80% revenue

final1_calc as (
	select COUNT(stockcode) as total_products, 
		COUNT(stockcode) filter(where cumulative_revenue_percentage <=80) as products_contributing_80
	from final_calc
)
select total_products, products_contributing_80, round(100.0*products_contributing_80/total_products,2) as percentage_of_products
from final1_calc