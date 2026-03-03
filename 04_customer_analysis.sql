-- SELECT COUNT(DISTINCT customerid) as total_customer FROM clean_retail;

WITH customer_cte AS (
	SELECT customerid, COUNT(DISTINCT invoiceno) as total_invoices, SUM(revenue) as total_revenue_per_customer
	FROM clean_retail
	GROUP BY customerid
),
business_cte AS (
	SELECT COUNT(*) AS total_customers, COUNT(*) filter(where total_invoices > 1) AS repeat_customers,
		100.0 * COUNT(*) FILTER (WHERE total_invoices > 1) / COUNT(*) AS repeat_customer_percentage
	FROM customer_cte
), 
critical_cte AS (
	SELECT SUM(total_revenue_per_customer) as total_revenue,
		SUM(total_revenue_per_customer) filter( WHERE total_invoices > 1) as revenue_from_repeat_cust, 
		SUM(total_revenue_per_customer) filter( WHERE total_invoices <=1) as revenue_from_onetime_cust,
		100.0*SUM(total_revenue_per_customer) filter( WHERE total_invoices > 1)/SUM(total_revenue_per_customer) as rev_prcnt_repeat_cust
	FROM customer_cte
),
customer_pareto AS (
	SELECT customerid, total_revenue_per_customer, 
		total_revenue_per_customer*100.0/SUM(total_revenue_per_customer) OVER () as revenue_percentage,
		SUM(total_revenue_per_customer) OVER( ORDER BY total_revenue_per_customer DESC) as cumulative_revenue,
		SUM(total_revenue_per_customer) OVER (
    		ORDER BY total_revenue_per_customer DESC )* 100.0/SUM(total_revenue_per_customer) OVER () AS cumulative_percentage
	FROM customer_cte
),
final_customer_pareto AS(
	SELECT COUNT(*) FILTER (WHERE cumulative_percentage <= 80)*100.0/COUNT(customerid) as percent_of_customer_contributing_80prcnt_rev
	FROM customer_pareto
	
)
SELECT * FROM final_customer_pareto