CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6, 4) NOT NULL,
    totat DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_pct FLOAT(11, 9),
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT
)

# Feature Enginearing #

#add time of the day

SELECT time,
(CASE
	WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
    WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening"
 END
) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
CASE
	WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
    WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening"
 END
)



#add day name
SELECT 
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10)

UPDATE sales
SET day_name = DAYNAME(date)

#add month name
SELECT 
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10)

UPDATE sales
SET month_name = MONTHNAME(date)


#exploratory data analysis ---EDA 
				#generic 
#how many unique city does the data has
SELECT 
	DISTINCT(city)
FROM sales;
#how many unique branch does the data has
SELECT 
	DISTINCT(branch)
FROM sales;

#in which city is each branch ?
SELECT 
	DISTINCT branch,city
FROM sales;

				#products
#how many unique product line does the data have ?
SELECT 
	COUNT(DISTINCT(product_line))
FROM sales;

#what is the common payment methods
SELECT 
	payment_method,
	COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;

#what is the most selling product line ?
SELECT 
	product_line,
	COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;

#what is the total revenue by months ?
SELECT 
	month_name AS month,
	SUM(totat) AS Total_Revenue
FROM sales
GROUP BY month_name
ORDER BY Total_Revenue DESC;

#which month has the highest cogs ?
SELECT 
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name
ORDER BY cogs DESC;


#what products line has the largest revenue ?
SELECT 
	product_line AS month,
	SUM(totat) AS Total_Revenue
FROM sales
GROUP BY product_line
ORDER BY Total_Revenue DESC;

#what is the city with the largest revenue ?
SELECT 
	branch,
	city,
	SUM(totat) AS Total_Revenue
FROM sales
GROUP BY city,branch
ORDER BY Total_Revenue DESC;

#what product line has the highest VAT ?
SELECT 
	product_line,
	AVG(VAT) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY product_line DESC;

#which of the branch sold more product than average product sold ?
SELECT 
	branch,
	SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales)

#what is the most product line by gender ?
SELECT 
	gender,
    product_line,
	COUNT(gender) AS Total_cnt
FROM sales
GROUP BY gender,product_line
ORDER BY Total_cnt DESC;

#what is the average rating of product line ?
SELECT 
	AVG(rating) as Avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY Avg_rating DESC;

-- ------------sales Analysis-----------
#Number of sales made in each time of the day per week day?
SELECT 
	time_of_day,
	COUNT(*) AS Total_Sales
FROM sales
WHERE day_name = "Monday"
GROUP BY time_of_day
ORDER BY Total_Sales DESC;

#which of the customer type bring the most revenue?
SELECT 
	customer_type,
	SUM(totat) AS Total_rev
FROM sales
GROUP BY customer_type
ORDER BY Total_rev DESC;


#which city has the largest tax percent VAT?
SELECT 
	city,
	AVG(VAT) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

#which customer type pays the most in VAT?
SELECT 
	customer_type,
	AVG(VAT) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;


-- ------------customer Analysis-----------
#how many unique custommer type does the data have ?
SELECT 
	DISTINCT(customer_type)
FROM sales

#how many unique custommer type does the data have ?
SELECT 
	DISTINCT payment_method
FROM sales

# which customer type buy the most ?
SELECT 
	customer_type,
	COUNT(*) AS cstm_cnt
FROM sales
GROUP BY customer_type

# what is the gender of most of the customers ?
SELECT 
	gender,
	COUNT(*) AS gender_cnt
FROM sales
GROUP BY gender

# what is the gender distribution per branch ?
SELECT 
	gender,
	COUNT(*) AS gender_cnt
FROM sales
WHERE branch = "B"
GROUP BY gender
ORDER BY gender_cnt DESC;


# which time of the day did customer give most rating per branch ?
SELECT 
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "C"
GROUP BY time_of_day
ORDER BY avg_rating DESC;


# which day for the week has the best avg rating ?
SELECT 
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;


# which day for the week has the best avg rating per branch?





SELECT * FROM sales;
