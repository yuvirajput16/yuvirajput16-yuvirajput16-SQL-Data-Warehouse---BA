
-- eXPLORE ALL OBJECT IS DATA BASE
SELECT * FROM INFORMATION_SCHEMA.TABLES

-- EXPLORE ALL coloumns in database
select * from INFORMATION_SCHEMA.columns

-- DIMESIONS EXPLORATION 
select distinct country from gold.dim_customers


--- exploring categories "the majopr division "
select distinct category,subcategory,product_name from gold.dim_products
order by 1,2,3

----- DATE EXPLORATION
SELECT ORDER_DATE FROM GOLD.fact_sales

SELECT 
MIN(ORDER_DATE) AS FIRST_ORDER_DATE ,
MAX(ORDER_DATE) AS LAST_OREDER_DATE
FROM GOLD.fact_sales

-- HOW MANY YEars 
SELECT 
MIN(ORDER_DATE) AS FIRST_ORDER_DATE ,
MAX(ORDER_DATE) AS LAST_OREDER_DATE
DATEDIFF(year,min(order_date),max(order_date)) AS order_range_in_yeras
FROM GOLD.fact_sales



SELECT 
MIN(ORDER_DATE) AS FIRST_ORDER_DATE ,
MAX(ORDER_DATE) AS LAST_OREDER_DATE
datediff(month,min(order_date),max(order_date)) AS order_range_in_yeras
FROM GOLD.fact_sales


---- cusdtomer 
Select
MIN(birthdate) as Oldest_birthdate,
datediff(year, min(birthdate) , getdate()) as oldest_age,
max(birthdate) as youngest
from gold.dim_customers

--- MEASURE EXPLORATION 


-- total sale s
select sum(sales_amount) as total_sales from gold.fact_sales

-- total items sold 
select sum(quantity) as total_items_sold from gold.fact_sales

-- avg selling price
select avg(price) as avg_price from gold.fact_sales

--- total orders 

select count(order_number) as total_orders from gold.fact_sales

select count(distinct order_number) as total_orders from gold.fact_sales


-- total number of producrt 
select count(product_key) as total_product from gold.dim_products
select count(distinct product_key) as total_product from gold.dim_products 
-- as each is diff

-- total customers 
select count(customer_key) as number_of_customers from gold.dim_customers 

-- total customers that placed order 
select count(distinct customer_key) as customer_order_placed from gold.fact_sales

-----------------------------------------------------------------------------------------------------------------
-- report showing all metrics of business 
select 'total sales' as measure_name ,  sum(sales_amount) as measure_value from gold.fact_sales
union all
select  'total quantity ' as measure_name , sum(quantity) as total_items_sold from gold.fact_sales
union all
select  'average price ' as measure_name , avg(price) as avg_price from gold.fact_sales 
union all
select  'total no. orders ' as measure_name , count(distinct order_number) as total_orders from gold.fact_sales 
union all
select  'total no product ' as measure_name ,count(distinct product_key) as total_product from gold.dim_products  
union all
select  'total no.customers ' as measure_name ,  count(distinct customer_key) as customer_order_placed from gold.fact_sales


----------------------------------------------------------------------------------------------------------------
----MAGNITUDE ANALYSIS 
-- COMPARING MEASURE VALUES ACROSS CATEGORIES 
--- MEASURE BY DIMENSION

--- TOTAL NUMBEROF CUSTOMERS BY COUNTRIES 
SELECT 
COUNTRY, 
COUNT(CUSTOMER_KEY) AS TOTAL_CUSTOMERS
FROM GOLD.dim_customers
GROUP BY COUNTRY 
ORDER BY TOTAL_CUSTOMERS DESC

--- TOTAL PRODUCT BY CATERGORY 
SELECT 
CATEGORY,
COUNT (DISTINCT PRODUCT_KEY ) AS tOTAL_PROD
FROM GOLD.dim_products
GROUP BY CATEGORY 
ORDER BY tOTAL_PROD DESC

-- TOTAL CUSTOMERS BY GENDER
SELECT 
gender, 
COUNT(CUSTOMER_KEY) AS TOTAL_CUSTOMERS
FROM GOLD.dim_customers
GROUP BY GENDER 
ORDER BY TOTAL_CUSTOMERS DESC

-- AVG COST IN EACH CATEGORY 
SELECT 
CATEGORY ,
AVG( COST) AS AVG_PRICE
FROM GOLD.dim_products
GROUP BY CATEGORY
ORDER BY AVG_PRICE DESC

-- TOTAL REVENUE OF EACH CATEGORY 
SELECT 
P.CATEGORY ,
SUM( F.SALES_AMOUNT) TOTAL_REVENUE
FROM GOLD.fact_sales F
LEFT JOIN  GOLD.dim_products P
ON P.PRODUCT_KEY = F.product_key
GROUP BY P.category
ORDER BY TOTAL_REVENUE DESC
--business make major money by bikes

---- TOTAL REVENUE BY EACH CUSTOMER
SELECT 
sum(f.sales_amount) total_revenue,
c.customer_key,
c.first_name,
c.last_name
FROM gold.fact_sales f
left join gold.dim_customers c
on c.customer_key = f.customer_key
group by c.customer_key,
c.first_name,
c.last_name 
order by  total_revenue desc

---- districution across countries 
SELECT 
sum(f.quantity) total_sold_items ,
c.country
FROM gold.fact_sales f
left join gold.dim_customers c
on c.customer_key = f.customer_key
group by c.country
order by  total_sold_items desc
--- us max items sold 

--------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

---RANKING ANALYSIS 

-- 5 PRODUCT WITH HIGHEST REVENUE 
SELECT top 5 
P.product_name ,
SUM( F.SALES_AMOUNT) TOTAL_REVENUE
FROM GOLD.fact_sales F
LEFT JOIN  GOLD.dim_products P
ON P.PRODUCT_KEY = F.product_key
GROUP BY P.product_name
ORDER BY TOTAL_REVENUE DESC

-- 5 worst products
SELECT top 5 
P.product_name ,
SUM( F.SALES_AMOUNT) TOTAL_REVENUE
FROM GOLD.fact_sales F
LEFT JOIN  GOLD.dim_products P
ON P.PRODUCT_KEY = F.product_key
GROUP BY P.product_name
ORDER BY TOTAL_REVENUE asc

----- 5 subcategories WITH HIGHEST REVENUE 
SELECT top 5 
P.subcategory ,
SUM( F.SALES_AMOUNT) TOTAL_REVENUE
FROM GOLD.fact_sales F
LEFT JOIN  GOLD.dim_products P
ON P.PRODUCT_KEY = F.product_key
GROUP BY P.subcategory
ORDER BY TOTAL_REVENUE DESC

-- window function 
SELECT* 
FROM ( 
SELECT
	P.product_name ,
	SUM( F.SALES_AMOUNT) TOTAL_REVENUE
	RANK() over ( order by SUM( F.SALES_AMOUNT) desc ) as rank_products 
	FROM GOLD.fact_sales F
	LEFT JOIN  GOLD.dim_products P
	ON P.PRODUCT_KEY = F.product_key
	GROUP BY P.product_name
WHERE RANK_PRODUCT <=5


---top 10 customers eho generated highest reveue
SELECT  top 10
sum(f.sales_amount) total_revenue,
c.customer_key,
c.first_name,
c.last_name
FROM gold.fact_sales f
left join gold.dim_customers c
on c.customer_key = f.customer_key
group by c.customer_key,
c.first_name,
c.last_name 
order by  total_revenue desc

-- lowest 3 with order numbers
SELECT  top 3
sum(f.sales_amount) total_revenue,
c.customer_key,
c.first_name,
c.last_name,
count (distinct order_number) total_orders
FROM gold.fact_sales f
left join gold.dim_customers c
on c.customer_key = f.customer_key
group by c.customer_key,
c.first_name,
c.last_name 
order by  total_revenue asc
