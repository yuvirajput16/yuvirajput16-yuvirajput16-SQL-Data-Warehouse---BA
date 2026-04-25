/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, this script creates a schema called gold
	
WARNING:
    Running this script will drop the entire 'DataWarehouseAnalytics' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouseAnalytics' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;
GO

-- Create the 'DataWarehouseAnalytics' database
CREATE DATABASE DataWarehouseAnalytics;
GO

USE DataWarehouseAnalytics;
GO

-- Create Schemas

CREATE SCHEMA gold;
GO

CREATE TABLE gold.dim_customers(
	customer_key int,
	customer_id int,
	customer_number nvarchar(50),
	first_name nvarchar(50),
	last_name nvarchar(50),
	country nvarchar(50),
	marital_status nvarchar(50),
	gender nvarchar(50),
	birthdate date,
	create_date date
);
GO

CREATE TABLE gold.dim_products(
	product_key int ,
	product_id int ,
	product_number nvarchar(50) ,
	product_name nvarchar(50) ,
	category_id nvarchar(50) ,
	category nvarchar(50) ,
	subcategory nvarchar(50) ,
	maintenance nvarchar(50) ,
	cost int,
	product_line nvarchar(50),
	start_date date 
);
GO

CREATE TABLE gold.fact_sales(
	order_number nvarchar(50),
	product_key int,
	customer_key int,
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity tinyint,
	price int 
);
GO

TRUNCATE TABLE gold.dim_customers;
GO

BULK INSERT gold.dim_customers
FROM 'C:\Users\91982\OneDrive\Desktop\SQL\sql-data-analytics-project\datasets\csv-files\gold.dim_customers.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.dim_products;
GO

BULK INSERT gold.dim_products
FROM 'C:\Users\91982\OneDrive\Desktop\SQL\sql-data-analytics-project\datasets\csv-files\gold.dim_products.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK 
);
GO

TRUNCATE TABLE gold.fact_sales;
GO

BULK INSERT gold.fact_sales
FROM 'C:\Users\91982\OneDrive\Desktop\SQL\sql-data-analytics-project\datasets\csv-files\gold.fact_sales.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO
select distinct 
sales_amount
from gold.fact_sales

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------



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

-----------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
--- Data Analysis 




--1 / CHANGE OVER TIME 

----Analusze salses performance over time 
Select 
year(order_date) as order_year,
SUM(SALES_AMOUNT) AS TOTAL_SALES,
COUNT(distinct customer_key) as  total_customers,
SUM(quantity) as total_quantity
FROM GOLD.fact_sales
where order_date is not NULL
GROUP BY year(order_date)
order by year(order_date)


-- month 
Select 
month(order_date) as order_month,
SUM(SALES_AMOUNT) AS TOTAL_SALES,
COUNT(distinct customer_key) as  total_customers,
SUM(quantity) as total_quantity
FROM GOLD.fact_sales
where order_date is not NULL
GROUP BY month(order_date)
order by month(order_date)

-----
Select 
year(order_date) as order_year,
month(order_date) as order_month,
SUM(SALES_AMOUNT) AS TOTAL_SALES,
COUNT(distinct customer_key) as  total_customers,
SUM(quantity) as total_quantity
FROM GOLD.fact_sales
where order_date is not NULL
GROUP BY year(order_date),month(order_date)
order by year(order_date),month(order_date)


-- dfatetrunc
Select 
datetrunc(month, order_date) as order_date,
SUM(SALES_AMOUNT) AS TOTAL_SALES,
COUNT(distinct customer_key) as  total_customers,
SUM(quantity) as total_quantity
FROM GOLD.fact_sales
where order_date is not NULL
GROUP BY datetrunc(month, order_date)
order by datetrunc(month, order_date) 

-- format 
Select 
format(order_date , 'yyyy-MMM') as order_date,
SUM(SALES_AMOUNT) AS TOTAL_SALES,
COUNT(distinct customer_key) as  total_customers,
SUM(quantity) as total_quantity
FROM GOLD.fact_sales
where order_date is not NULL
GROUP BY format(order_date , 'yyyy-MMM')
order by format(order_date , 'yyyy-MMM')


---2/ CUMULATIVE ANALYSIS  

--- TOTAL SLAES PE MONTH 
-- RUNNIBNG TOTAL SALES OVER TI ME 


select 
order_date,
total_sales,
sum(total_sales) over (PARTITION BY order_date order by order_date) as running_total_sales,
avg_price,
avg(avg_price) over (order by order_date) as moving_average_price
from
(
SELECT 
datetrunc(month ,order_date) AS ORDER_DATE, 
SUM(sales_amount) as total_sales ,
avg(price) as avg_price
from gold.fact_sales
where order_date is not NULL
GROUP BY datetrunc(month ,order_date)
) t

--- year
select 
order_date,
total_sales,
sum(total_sales) over  (order by order_date) as running_total_sales,
avg_price,
avg(avg_price) over (order by order_date) as moving_average_price
from
(
SELECT 
datetrunc(YEAR ,order_date) AS ORDER_DATE, 
SUM(sales_amount) as total_sales ,
avg(price) as avg_price
from gold.fact_sales
where order_date is not NULL
GROUP BY datetrunc(year ,order_date)
) t


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Performance analaysis 
------------------------------------------------------------------------

-- sales vs pervious sales, avg sales 

Select 
year(f.order_date) as order_year ,
p.product_name,
sum(f.sales_amount) as current_sales 
from gold.fact_sales f
left join gold.dim_products p
on f.product_key = p.product_key 
where order_date is not null
group by year(f.order_date) , p.product_name


--- comparing to avg 
with yearly_product_sales as (
Select 
year(f.order_date) as order_year ,
p.product_name,
sum(f.sales_amount) as current_sales 
from gold.fact_sales f
left join gold.dim_products p
on f.product_key = p.product_key 
where order_date is not null
group by year(f.order_date) , p.product_name

)

select 
order_year,
product_name ,
current_sales,
avg(current_sales) over (partition by product_name ) as avg_sales,
current_sales - avg(current_sales) over (partition by product_name ) as diff_avg,
case when current_sales - avg(current_sales) over (partition by product_name )  > 0 then 'above avg'
     when current_sales - avg(current_sales) over (partition by product_name )  < 0 then 'below avg'
	 else ' avg'
end avg_change
from  yearly_product_sales
order by product_name ,order_year

--- comparing with previous year sales
--- comparing to avg 
with yearly_product_sales as (
Select 
year(f.order_date) as order_year ,
p.product_name,
sum(f.sales_amount) as current_sales 
from gold.fact_sales f
left join gold.dim_products p
on f.product_key = p.product_key 
where order_date is not null
group by year(f.order_date) , p.product_name

)

select 
order_year,
product_name ,
current_sales,
avg(current_sales) over (partition by product_name ) as avg_sales,
current_sales - avg(current_sales) over (partition by product_name ) as diff_avg,
case when current_sales - avg(current_sales) over (partition by product_name )  > 0 then 'above avg'
     when current_sales - avg(current_sales) over (partition by product_name )  < 0 then 'below avg'
	 else ' avg'
end avg_change,

-- YOY Analysis ---------------
lag(current_sales) over (partition by product_name order by order_year) py_sales,
current_sales - lag(current_sales) over (partition by product_name order by order_year) as diff_py,
case when current_sales - lag(current_sales) over (partition by product_name order by order_year)  > 0 then 'increase'
     when current_sales - lag(current_sales) over (partition by product_name order by order_year)  < 0 then 'decrease'
	 else ' no change'
end py_change
from  yearly_product_sales
order by product_name ,order_ye



---PART TO WHOLE Analysis 
--- how an individual cstegory is contributuing to whole 


with category_orders as (
select 
count(order_number)as total_order,
category
from gold.fact_sales f
left join gold.dim_products p
on f.product_key = p.product_key
group by category 
)

select 
category,
total_order,
sum(total_order) over () overall_orders,
concat(round ((cast (total_order as float )/ sum(total_order) over ())* 100,2) ,'% ')as percentage_of_total
from category_orders
order by total_order desc


-- which category contributes the most to the sales 
with category_sales as (
select 
category,
sum(sales_amount) total_sales 
from gold.fact_sales f
left join gold.dim_products p
on f.product_key = p.product_key
group by category 
)

select 
category,
total_sales,
sum(total_sales) over () overall_sales,
concat(round ((cast (total_sales as float )/ sum(total_sales) over ())* 100,2) ,'% ')as percentage_of_total
from category_sales
order by total_sales desc
--(over relying on a single category .\, bad for businees)



--DATA SEGMENTATION
-- measure by m easure 

-- segment product in cost ranges and count the product falling in them 
-- measure to dimesnion 
with product_segments as(
Select
product_key,
product_name,
cost,
case when cost <100 then 'below 100'
	when cost between 100 and 500 then '100-500'
	when cost between 500 and 1000 then '500 - 1000'
	else 'above 1000'
end cost_range	
from gold.dim_products)

select 
cost_range ,
count(product_key) as total_product
from product_segments
group by cost_range 
order by total_product desc


-- group customers into 3 segments 
-- VIP - atleat 12 months of history and spending more thn 5000
-- regular - at least 12 mmonts of history and spending 5000 or less
-- new lifespan les than 12 months 


with customers as (
select
c.customer_key,
sum(f.sales_amount) as total_spending,
min(order_date) as first_order,
max(order_date) as last_order,
datediff(month ,min(order_date),max(order_date)) as lifespan
from gold.fact_sales f
left join gold.dim_customers c
on f.customer_key = c.customer_key
group by c.customer_key )

select
customer_segment,
count(customer_key) as total_customers 
from(
select
customer_key,
case when lifespan > 12  and total_spending >5000 then  'VIP'
	 when lifespan >=12 and total_Spending <=5000 then 'regular'
	 else 'new customers'
end customer_segment
from customers ) t
group by customer_segment
order by total_customers desc




---BUILDING CUSTOM REPORT 

/*
===============================================================================================
CUSTOMER REPORT
================================================================================================
Purpose:
 - conso;idating key customer metrics

 Highlights :

 1. Gather essentials suchg as name , ages, transaction details .
 2. Segmnet customers into categories (VIP,Regular, New) and age groups 
 3. Aggregates customer_level metrics
	-total orders
	- total sales
	-total quantity purschsed
	- total products 
	- lifespan in months 

4. Calculate valuabel KPIS
	- recency (months since last order)
	-average money value
	-average monthly spend 

=================================================================================================================
*/

/* ---------------------------------------------------------------------------------------------------
1. Retrieveing core columns 
------------------------------------------------------------------------------------------*/
create view gold.report_customers as
WITH base_query as (
select
f.order_number,
f.product_key ,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key ,
c.customer_number,
CONCAT(c.first_name , ' ' , c.last_name) as customer_name ,
datediff( year, c.birthdate,GETDATE()) as age
from gold.fact_sales f
left join gold.dim_customers c
on c.customer_key = f.customer_key
where order_date is not null

)

/* --------------------------------------------------------------------------------------
CUSTOMER AGGREGATION 
 -------------------------------------------------------*/
,aggregations as (
select
customer_key ,
customer_number,
age,
customer_name,
count(distinct order_number) as total_orders ,
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity,
count(distinct product_key) as total_products ,
max(order_date) as last_order,
min(order_date) as first_order,
DATEDIFF(month, min(order_date),max(order_date)) as lifespan
from base_query
group by customer_key,
		 customer_name,
		 customer_number,
		 age

)

/* --------------------------------------------------------------------------------------
 FINAL RESULTS
 -------------------------------------------------------*/

 select 
 customer_key,
 customer_number,
 customer_name ,
 age,
 case when age <20 then 'under 20'
	  when age  between 20 and 29 then '20-29'
	  when age  between 30 and 39 then '30-39'
	  when age  between 40 and 49 then '40-49'
	  else '50 and above'
end as age_group,
total_sales,
total_orders,
total_products,
total_quantity,
case when lifespan > 12  and total_sales >5000 then  'VIP'
	 when lifespan >=12 and total_sales <=5000 then 'regular'
	 else 'new customers'
end as customer_segment,
last_order,
datediff(month ,last_order ,getdate()) as recency,

---- compute avg order value
case when total_orders=0 then 0 
	 else total_sales/total_orders
end as avg_order_value,

--- avg monthly spends 
case when lifespan=0 then total_sales
	 else total_sales/lifespan
end as avg_monthly_spend
from aggregations

---------PUTTING TABLE AS VIEW at top making changes and creating view 

select
* 
from gold.report_customers



/*==========================================================================================================
REPORT 2
=====================================================================================================*/
with base_query as (
SELECT 
p.product_name,
p.category,
p.subcategory,
p.cost,
f.order_number,
f.quantity,
f.customer_key,
f.order_date,
f.sales_amount
FROM gold.dim_products p
left join gold.fact_sales f
on p.product_key = f.product_key 
where order_date is not null
)

/*====================================================================================================
AGGREGATION
====================================================================================================*/
,aggregator as(
select
product_name,
category,
subcategory,
cost,
count(distinct order_number) as total_orders,
sum(sales_amount) as total_sales,
sum(quantity) as total_qunatity,
min(order_date) as first_order,
max(order_date) as last_order,
count(distinct customer_key) as total_customers,
datediff(month ,min(order_date),max(order_date)) as lifespan
from base_query
group by product_name,
			category,
			subcategory,
			cost
		 

)

/*=================================================================================================
FINAL RESULT
============================================================================*/
SELECT 
product_name,
category,
subcategory,
cost,
total_sales,
lifespan,
case when total_sales <= 50000 then 'low performance '
	 when total_sales between 50000 and 200000 then 'mid performers '
	 else 'high performance'
end revenvue_performance ,
datediff(month , last_order,getdate()) as recency ,
(total_sales)/(total_orders) as AOR ,
total_sales/lifespan as avg_monthly_revenue

from aggregator