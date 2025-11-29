CREATE OR REPLACE VIEW vw_sales AS
SELECT
-- Fact columns
    fs.order_date,
    fs.stock_date,
    fs.order_number,
    fs.order_lineitem,
    fs.order_quantity,

-- Calendar fields
    c.year,          
    c.quarter,       
    c.month,         
    c.month_name,    

-- Customer fields
    cu.customer_key,
    cu.gender,
    cu.annual_income,

-- Product fields
    p.product_key,
    p.product_name,
    p.product_cost,
    p.product_price,

-- Subcategory + Category
    psc.subcategory_name,
    pc.category_name,

    -- Territory fields
    t.territory_key,
    t.region,
    t.country,
    t.continent,

-- Calculated fields
    fs.order_quantity * p.product_price AS revenue,
    fs.order_quantity * (p.product_price - p.product_cost) AS gross_profit

FROM fact_sales fs
JOIN calendar AS c
    ON fs.order_date = c.calendar_date
JOIN dim_customer AS cu
    ON fs.customer_key = cu.customer_key
JOIN dim_product AS p
    ON fs.product_key = p.product_key
JOIN dim_product_subcategories AS psc
    ON p.product_subcategory_key = psc.product_subcategory_key
JOIN dim_product_categories AS pc
    ON psc.product_category_key = pc.product_category_key
JOIN dim_territory AS t
    ON fs.territory_key = t.territory_key;
