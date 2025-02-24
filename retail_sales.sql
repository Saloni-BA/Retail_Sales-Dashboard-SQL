create database retail_sales;
use retail_sales;
create table retail_sales(
transactions_id	int primary key,
sale_date	date,
sale_time	time,
customer_id	int,
gender	varchar(20),
age	int,
category varchar(20),	
quantiy	int,
price_per_unit float,	
cogs	float,
total_sale float
);

select * from retail_sales;

select count(*) from retail_sales limit 10;

-----------------------------

select * from retail_sales
where transactions_id is null;

select * from retail_sales
where sale_date is null;

select * from retail_sales
where sale_time is null;

select * from retail_sales
where
 transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;

delete from retail_sales
where
 transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;

select count(*) from retail_sales limit 10;


------------------------- data exploration

-- how many sales we have?

select count(*) as total_sales from retail_sales;

-- how many cutomers we have? 

select count(distinct customer_id) as total_sales from retail_sales;

select distinct category from retail_sales;


-- data analysis and business key problems & answers
-- My analysis & Findings

-- write a sql query to retrieve all col for sale made on '2022-11-05'
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';
 
 
 -- write a sql query to retrieve all transaction where the category is: clothing and the quantity sold is more than 4 in the month of nov-2022
 SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'Clothing'
        AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
        AND quantity >= 4;


-- Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM
    retail_sales
GROUP BY 1;


-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
    ROUND(AVG(age), 2) AS avg_age
FROM
    retail_sales
WHERE
    category = 'Beauty';


-- Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale <= 1000;


-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    category, gender, COUNT(*) AS total_trans
FROM
    retail_sales
GROUP BY category , gender
ORDER BY 1;


-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select * from
(
select 
extract(year from sale_date) as year,
extract(month from sale_date) as month,
round(avg(total_sale),2) as avg_sale,
rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank_by
from retail_sales
group by 1,2
) as t1
where rank_by=1;


-- Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id, SUM(total_sale) AS total_sales
FROM
    retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Write a SQL query to find the number of unique customers who purchased items from each category. 
SELECT 
    category, COUNT(DISTINCT customer_id)
FROM
    retail_sales
GROUP BY 1;


-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
with hourly_sale
as
(
select *, 
case 
when extract(hour from sale_time) <12 then 'Morning'
when extract(hour from sale_time) between 12 and 17 then 'Afternoon' 
else 'Evening'
end as shift
from retail_sales
)
select shift,
count(*) as total_orders
from hourly_sale
group by shift
