
--calculate the total no of rows or total no of invoices

select * from supermarket_sales

Select Count(*) as total_invoice from supermarket_sales

-- look for duplicates

Select invoice_ID,
count(*) AS occurances
from supermarket_sales
group by Invoice_ID
having COUNT(*) > 1;

-- total invoices of a single day
Select
Count(*) as today 
from supermarket_sales
where date = '2019-02-07'

--count the number of invoices paid by e wallet

Select 
COUNT(*) as No_of_ewallet
from supermarket_sales
where Payment = 'Ewallet'



-- The number of sales per category/productline

Select Product_line,
Count(*) AS Count_per_productline
from supermarket_sales
group by Product_line
order by Count_per_productline

-- here is to get total number of sales from each payment method

select Payment, 
Count(*) AS Total_payment_type
from supermarket_sales
group by Payment
order by Total_payment_type desc;

-- finding which gender does more shopping

select gender,
count(*) as male_female
from supermarket_sales
group by gender


-- total sales from each city

Select City,
Sum(total) as total_sales
from supermarket_sales
group by city
order by total_sales


-- how many of our members/normal customer are male/female

SELECT customer_type, gender, 
count(*) as Member_gender
from supermarket_sales
group by Customer_type, gender
order by Customer_type;


-- how much our members spend and how much the normal customers spend

select customer_type, city, 
sum(total) as totalsales_perregion_bymemebers
from supermarket_sales
group by Customer_type, city
order by totalsales_perregion_bymemebers desc;

-- which customer type spends most
select customer_type, 
sum(total) as total_sales
from supermarket_sales
group by Customer_type
order by total_sales desc;

-- descriptive analysis

SELECT AVG(Total) as avg_purchase
from supermarket_sales

SELECT MAX(Total) as max_purchase
from supermarket_sales

SELECT MIN(Total) as min_purchase
from supermarket_sales


-- we are categorizing how much the customers spend into levels
SELECT *,
CASE
WHEN Total < 100 THEN 'LOW'
WHEN Total BETWEEN 100 AND 400 THEN 'MID'
WHEN Total > 400 THEN 'HIGH'
END AS Purchase_level
from supermarket_sales;

-- we will categorize payment method further

SELECT *,
CASE 
WHEN Payment = 'cash' THEN 'old'
when payment  = 'Credit Card' then 'modern'
when payment = 'Ewallet' then 'future boy'
end as Payment_Status
from supermarket_sales

--  categorizing the ratings

Select Invoice_ID, Rating,
Case
when rating <= 2 then 'very bad'
when rating <= 4 then 'bad'
when rating <= 6 then 'adequate'
when rating <= 8 then 'good' 
when rating <= 10 then 'very good'
end as customer_happiness
from supermarket_sales


-- Rounding up the ratings to the nearest integer

update supermarket_sales
set rating = ROUND(Rating, 0)  

-- creating a new column
ALTER TABLE supermarket_sales
ADD Purchase_level int

-- changing the datatype of the column
ALTER TABLE supermarket_sales
ALTER COLUMN Purchase_level varchar(25)

-- case function with update command

UPDATE supermarket_sales -- must use SET command with update command
SET Purchase_level =
CASE
when Total < 100 then 'LOW'
when Total between 100 and 400 then 'MID' 
when Total > 400 then 'HIGH'
end;


-- using case with order 

SELECT* from supermarket_sales
ORDER BY 
Case
when Purchase_level = 'high' then 3
when Purchase_level = 'mid' then 2
when purchase_level = 'low' then 1
END desc;

--to show the highest total sales first

select * from supermarket_sales
order by Total DESC


-- here we are playing with the case function, we are categorizing Quantity column
Select *,
case
when quantity < 3 then 'casual'
when quantity between 3 and 5 then 'average'
when quantity between 6 and 8 then 'Large'
when quantity > 8 then 'Huge'
end as Big_status 
FROM supermarket_sales
ORDER BY Quantity Desc

-- number of sales per city

SELECT CITY, count(*) as count_per_city
from supermarket_sales
group by City
--having count(*) > 10
Order by count_per_city DESC;

-- lots of restrictions in using having clause, like we must choose the specific colum with select clause

SELECT City,
sum(total) as total_sales
FROM supermarket_sales
group by city
having sum(total) > 50000
order by total_sales;

-- finding cities that has higher average than 300

SELECT City, AVG(Total) as average_purchase
FROM supermarket_sales
group by city
having AVG(Total) > 300
Order by average_purchase DESC

-- finding cities with total purchase greater than 110000

SELECT city, sum(Total) as total_sales
from supermarket_sales
group by city
having sum(Total) > 110000
order by total_sales DESC

-- Finding which payment method total more than 35500 in every city

select city, payment, sum(total) as total_sales
from supermarket_sales
group by city, payment
having sum(total) > 35500
order by total_sales DESC


-- finding city where average rating greater than 7 and total sales greater than 100000

select city, AVG(rating) as Average_rating, SUM(total) as total_sum
from supermarket_sales
group by city
having Avg(rating) > 7 and sum(total) > 100000
order by Average_rating DESC


--finding the sales after January in each product line greater than certain number

Select Product_line, sum(total) as total_sales
from supermarket_sales
where date > '2019-01-31'
group by Product_line
having sum(total) > 400
order by total_sales

-- finding which city has avg sale greater than 400 in Electronics

Select city, AVG(total) as Avg_purchase
from supermarket_sales
where Product_line = 'Electronic accessories'
group by city
having avg(total) > 200
order by avg(total) DESC


-- finding which city has sales greater than 15000 for 'home and lifestyle'

Select city, sum(total) as Total_sales
from supermarket_sales
where Product_line = 'Home and lifestyle'
group by city
having sum(total) > 15000
order by sum(total) DESC



--dateadd is used to add or subtract days to a date

SELECT DATEADD(day, 10, '2024-07-21') AS NewDate;
SELECT DATEADD(month, -2, '2024-07-21') AS NewDate;


--dateiff is used to calculate the difference between 2 dates

SELECT DATEDIFF(day, '2024-07-01', '2024-07-21') AS DaysDifference;
SELECT DATEDIFF(month, '2024-01-01', '2024-07-21') AS MonthsDifference;


-- subquery

select Invoice_ID, Product_line, (select avg(total) as Average_sales from supermarket_sales)
from supermarket_sales


-- this subquery counts the sales per productline in every city, then the outer query averages no of count per city, giving us the average number of sales per city.
-- subquery with from

Select city, avg(count_total) from (
select city, product_line, count(total) as count_total
from supermarket_sales
group by city, product_line) as sub
group by city 


-- subquery with 'where' keyword works like join query with two tables.



-- here now with partition by

select Invoice_ID, city, total, gender, count(gender)
OVER (Partition by gender) as total_gender
from supermarket_sales


--count the Product_line and display other columns

select Invoice_ID, City, Product_line, count(product_line) 
over (partition by product_line) as count_product 
from supermarket_sales


--------------CTE------------------
-- In this cte we are findng out what highest sale made in each productline, and then outside it we are selecting only sales that are greater than 1000

WITH CTE_MAXcatagory as (
select product_line, MAX(Total) as Highest
from supermarket_sales
group by Product_line
) Select * FROM CTE_MAXcatagory  
where Highest > 1000


-- CTE with partition by, which gives us the flexibility to display other columns

with CTEMAX_catagory as (
Select Invoice_ID, City, Customer_type, Product_line, Max(total)
over (Partition by Product_line) as Highest
from supermarket_sales
) Select DISTINCT city, customer_type, product_line, Highest  
from CTEMAX_catagory
where Highest > 1000
-- distinct gives us a smaller result, because since we used partition by our result displays the other column in original form with out any effect, while product line and highest are the only one connected.
-- that is why its better to use group by in this case
-------------


----productline vs cogs

select Product_line, avg(cogs) as average_cogs
from supermarket_sales
group by Product_line
order by average_cogs 

-----city vs cogs

select city, avg(cogs) as average_cogs
from supermarket_sales
group by city
order by average_cogs 



select * from supermarket_sales

