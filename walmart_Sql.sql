CREATE DATABASE PROJECT;

USE PROJECT;
SELECT * FROM WALMART;

# Generic Question
-- 1. How many unique cities does the data have?

SELECT DISTINCT CITY FROM WALMART;

-- 2. In which city is each branch?
select Branch,City from WALMART
group by 1,2
order by Branch;

-- ---------------------------------------------

### Product 

-- 1.How many unique product lines does the data have?

SELECT DISTINCT PRODUCT_LINE FROM WALMART;

-- 2. What is the most common payment method?
SELECT PAYMENT ,COUNT(PAYMENT)
FROM WALMART
GROUP BY PAYMENT
ORDER BY PAYMENT DESC
limit 1;

-- 3 .What is the most selling product line?

SELECT PRODUCT_LINE ,count(Quantity) as sold
FROM WALMART
GROUP BY PRODUCT_LINE
order by sold desc
limit 1;


-- 4. What is the total revenue by month?

SELECT month(date) as month , count(total) as total_revenue 
from walmart
group by month
order by month;


-- 5. What month had the largest COGS?
 
SELECT MONTH(date) AS month , sum(cogs) as largest , count(cogs) as largest_cogs
FROM walmart
group by month 
order by  largest desc;

-- 6.What product line had the largest revenue?

SELECT product_line ,count(total) as largest_revenue
from walmart 
group by product_line
order by largest_revenue desc
limit 1;

-- 7. What is the city with the largest revenue?
SELECT city ,count(total) as largest_revenue
from walmart 
group by city
order by largest_revenue desc
limit 1;

-- 8.  What product line had the largest VAT?
SELECT product_line, SUM(cogs* 5 / 100) AS vat
FROM walmart
GROUP BY product_line
ORDER by vat DESC
limit 1;


-- 9.  Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select product_line,
case when (Sales > avg_sales) then 'Good'
else 'Bad'
end as Status
from 
(select product_line,
sum(Tax + cogs) as Sales,
avg(sum(Tax + cogs)) over() as avg_sales from walmart
group by product_line)y;


-- 10. Which branch sold more products than average product sold?
select branch 
from 
(select branch,count(product_line) as Product_count from walmart group by branch) as branch_sales
where Product_count > (select avg(Product_count) from (select count(product_line) as Product_count  
from walmart group by branch) as avg_sales);


-- 11 What is the most common product line by gender?

SELECT PRODUCT_LINE ,count(gender) AS total_gender
FROM WALMART
GROUP BY PRODUCT_LINE
ORDER BY total_gender dESC
LIMIT 1;

-- 12. What is the average rating of each product line?
SELECT product_line , avg(rating)as avg_rating
FROM walmart
group by product_line ;

-- -----------------------------------------

### Sales

-- 1. Number of sales made in each time of the day per weekday
select 
    time_format(`time`, '%H:%i') as time_of_day,
    count(*) as num_sales
from walmart
group by time_of_day
order by time_of_day;
select* from walmart;


-- 2. Which of the customer types brings the most revenue?
SELECT  customer_type , count(total) as revenue  from walmart
group by customer_type
order by revenue desc
limit 1 ;

-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?

select city, max(Tax) as Largest_tax
from walmart
group by city
order by avg(Tax) desc
limit 1;

-- 4. Which customer type pays the most in VAT?
SELECT customer_type , count(cogs*5/100) as Most_pay
FROM walmart
group by customer_type
order by Most_pay desc
limit 1;




### Customer

-- 1. How many unique customer types does the data have?

SELECT DISTINCT Customer_type FROM walmart;

-- 2. How many unique payment methods does the data have?

SELECT DISTINCT payment FROM walmart;

-- 3. What is the most common customer type?

SELECT CUSTOMER_TYPE , COUNT(CUSTOMER_TYPE) AS COMMON_CUSTOMER
FROM WALMART
GROUP BY CUSTOMER_TYPE
ORDER BY COMMON_CUSTOMER DESC
LIMIT 1;

-- 4. Which customer type buys the most?

SELECT CUSTOMER_TYPE ,COUNT(PRODUCT_LINE) AS MOST_BUY 
FROM WALMART
GROUP BY CUSTOMER_TYPE
ORDER BY MOST_BUY DESC
LIMIT 1;

-- 5. What is the gender of most of the customers?
SELECT gender,count(gender)
FROM walmart 
GROUP BY Gender
limit 1;

-- 6. What is the gender distribution per branch?
SELECT BRANCH,GENDER ,count(gender) as gender_distribution_per_branch
FROM WALMART 
GROUP BY BRANCH, GENDER
ORDER BY  branch;
-- 7. Which time of the day do customers give most ratings?
select date,time , rating from walmart
group by 1,2,3
order by max(rating) desc
limit 1;
-- 8. Which time of the day do customers give most ratings per branch?
select branch, date, time, rating
from 
(select branch, date, time, rating, count(rating) as rating_count,
row_number() over (partition by branch order by max(rating) desc) as rn
from walmart
group by branch, date, time, rating) x
where rn = 1;


-- 9. Which day of the week has the best avg ratings?

select dayname(str_to_date(date, '%y-%m-%d')) as day_of_week
from walmart
group by dayname(str_to_date(date, '%y-%m-%d'))
order by avg(rating) desc
limit 1;

