-- analysis_queries.sql
-- Example analysis queries used in the Retail Sales Analytics Dashboard project

--    Yearly revenue and YoY growth (%) 
--    What is our yearly revenue, and how much did it grow or decline compared to the previous year?
WITH yearly AS (
    SELECT 
        year,
        SUM(revenue) AS revenue
    FROM vw_sales
    GROUP BY year
)
SELECT 
    year,
    revenue,
    LAG(revenue) OVER(ORDER BY year) AS prev_year,
    ROUND(
        (revenue - LAG(revenue) OVER(ORDER BY year))
        / NULLIF(LAG(revenue) OVER(ORDER BY year), 0) * 100
    , 2) AS yoy_growth_pct
FROM yearly
ORDER BY year;



--    3-month moving average of revenue
--    How is our revenue trending over time if we smooth out the noise using a 3-month moving average?
WITH monthly AS (
    SELECT
        year,
        month,
        SUM(revenue) AS revenue
    FROM vw_sales
    GROUP BY year, month
)
SELECT
    year,
    month,
    revenue,
    ROUND(
        AVG(revenue) OVER (
            ORDER BY year, month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        )
    , 2) AS revenue_ma_3m
FROM monthly
ORDER BY year, month;



--    Category performance: revenue, profit, and margin by year
--    For each year, show revenue, gross profit, and profit margin by category.
SELECT 
    year,
    category_name,
    SUM(revenue)      AS total_revenue,
    SUM(gross_profit) AS total_gross_profit,
    ROUND(
        SUM(gross_profit) / NULLIF(SUM(revenue), 0) * 100
    , 2) AS margin_pct
FROM vw_sales
GROUP BY year, category_name
ORDER BY year, total_gross_profit DESC;



--    Top 10% highest-value customers
--    Who are our highest-value customers — the top 10% who bring in the most money?
WITH customer_revenue AS (
    SELECT 
        customer_key,
        SUM(revenue) AS revenue
    FROM vw_sales
    GROUP BY customer_key
), 
ranked AS (
    SELECT 
        customer_key,
        revenue,
        NTILE(10) OVER (ORDER BY revenue DESC) AS revenue_decile
    FROM customer_revenue
)
SELECT
    r.customer_key,
    c.first_name,
    c.last_name,
    r.revenue,
    r.revenue_decile
FROM ranked AS r
LEFT JOIN dim_customer AS c
    ON r.customer_key = c.customer_key
WHERE r.revenue_decile = 1
ORDER BY r.revenue DESC;



--    Products with the highest return rate
--    Which 20 products have the highest return rate, and how bad is it for each one?
WITH sales AS (
    SELECT 
        product_key,
        SUM(order_quantity) AS total_sold
    FROM fact_sales
    GROUP BY product_key
),
returned AS (
    SELECT
        product_key,
        SUM(return_quantity) AS total_returned
    FROM returns_data
    GROUP BY product_key
)
SELECT
    p.product_key,
    p.product_name,
    s.total_sold,
    COALESCE(r.total_returned, 0) AS total_returned,
    ROUND(
        COALESCE(r.total_returned, 0)::numeric
        / NULLIF(s.total_sold, 0) * 100
    , 2) AS return_rate_pct
FROM sales AS s 
JOIN dim_product AS p
    ON s.product_key = p.product_key
LEFT JOIN returned AS r
    ON s.product_key = r.product_key
ORDER BY return_rate_pct DESC
LIMIT 20;
