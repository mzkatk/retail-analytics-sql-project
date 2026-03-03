--TASK1: monthly revenue

SELECT DATE_TRUNC('month', invoicedate) as month, SUM(revenue) as monthly_revenue
FROM clean_retail
GROUP BY 1
ORDER BY 1;

--TASK2: month-over-month Comparison

WITH mon_aggregation as (
	SELECT 
		DATE_TRUNC('month', invoicedate) as month, 
		SUM(revenue) as monthly_revenue 
	FROM clean_retail
	GROUP BY 1
	ORDER BY 1
),
prev_mon_rev as(
  SELECT month,monthly_revenue, LAG(monthly_revenue) OVER(ORDER BY month)  as previous_month_revenue
  FROM mon_aggregation
), 
mom_grth as (
	SELECT
		month,
		previous_month_revenue, monthly_revenue,
		ROUND((monthly_revenue - previous_month_revenue),2) as rev_diff,
		ROUND(100.0*(monthly_revenue - previous_month_revenue)/previous_month_revenue,2) as mom_growth_percentage
	FROM prev_mon_rev )
SELECT * FROM mom_grth 
WHERE rev_diff IS NOT NULL AND mom_growth_percentage IS NOT NULL
ORDER BY mom_growth_percentage asc;


--TASK3: Year-over-year Comparison


WITH mon_aggregation as (
	SELECT 
		DATE_TRUNC('month', invoicedate) as month, 
		SUM(revenue) as monthly_revenue 
	FROM clean_retail
	GROUP BY 1
	ORDER BY 1
),
prev_mon_rev as(
  SELECT month,monthly_revenue, LAG(monthly_revenue, 12) OVER(ORDER BY month)  as previous_month_revenue
  FROM mon_aggregation
), 
yoy_grth as (
	SELECT 
		month,
		previous_month_revenue, monthly_revenue,
		ROUND((monthly_revenue - previous_month_revenue),2) as rev_diff,
		ROUND(100.0*(monthly_revenue - previous_month_revenue)/previous_month_revenue,2) as mom_growth_percentage
	FROM prev_mon_rev )
SELECT * FROM yoy_grth WHERE rev_diff IS NOT NULL AND mom_growth_percentage IS NOT NULL
