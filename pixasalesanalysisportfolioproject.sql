
# Pixas sales analysis portfolio project in sql

SELECT *
FROM orders;

SELECT *
FROM order_details;

SELECT *
FROM pizza_types;

SELECT *
FROM pizzas;

# 1 Retrieve the total number of order placed

SELECT  COUNT(DISTINCT(order_id)) AS Total_Order
FROM orders;




# 2 Total Revenue generated from pixas sales
SELECT  ROUND(SUM(p.price * od.quantity),2) AS Total_Revenue
FROM pizzas AS p
JOIN order_details AS od
ON p.pizza_id = od.pizza_id;

# 3 Identify the highest price of pixas
SELECT pt.name, p.price
FROM pizzas AS p
JOIN pizza_types  AS pt
ON p.pizza_type_id = pt.pizza_type_id
ORDER BY price DESC
LIMIT 1;








# alternative way of solving question 3
WITH highest_price_cte AS (
		SELECT pt.name, p.price,
        RANK() OVER(ORDER BY  price DESC ) AS Ranka
		FROM pizzas AS p
		JOIN pizza_types  AS pt
		ON p.pizza_type_id = pt.pizza_type_id
)
SELECT *
FROM highest_price_cte
WHERE Ranka = 1;


# 4 Identify the most common pizzas size ordered
SELECT  p.size,  COUNT(DISTINCT(od.order_id)), SUM(od.quantity)
FROM order_details AS od
JOIN  pizzas  AS p
ON od.pizza_id = p.pizza_id
GROUP BY  p.size
ORDER BY  2 DESC;

# 5 List top 5 most ordered pixazz type along their quantity
SELECT pt.name, SUM(od.quantity) AS Quantity_Ordered
FROM order_details AS od
JOIN pizzas AS p
ON od.pizza_id = p.pizza_id
JOIN pizza_types AS pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY 2 DESC
LIMIT 5;


# 6 join the neccessary table to find the total quantity of each  pizzas category ordered.
SELECT pt.category,   SUM(od.quantity)
FROM pizza_types AS pt
JOIN pizzas AS p
ON pt.pizza_type_id =   p.pizza_type_id
JOIN order_details AS od
ON p.pizza_id = od.pizza_id
GROUP BY  pt.category;

#  7 determine the distribution of orders by hours of the day .
SELECT hour(time) AS 'Hour of the day',  COUNT(DISTINCT(order_id)) AS 'No of orders'
FROM orders
GROUP BY  hour(time)
ORDER BY 1 DESC;
#  8 find the category wise distribution of pizzas .
SELECT  category,  COUNT(DISTINCT(pizza_type_id))
FROM pizza_types
GROUP BY category
ORDER BY 2 DESC;

#  9 calculate the average number of pizzas order per day
WITH average_no_pizzas_per_day AS (
SELECT  o.date, SUM(od.quantity) AS total_no_pizzas
FROM  order_details AS od
JOIN orders AS o
ON od.order_id = o.order_id
GROUP BY o.date
)
SELECT  AVG(total_no_pizzas)
FROM  average_no_pizzas_per_day;
#  alternative to 9 using sub query
SELECT avg(total_no_pizzas) 
FROM (SELECT  o.date, SUM(od.quantity) AS total_no_pizzas
			FROM  order_details AS od
			JOIN orders AS o
			ON od.order_id = o.order_id
			GROUP BY o.date
)  AS  avgs;

#  10 determined the top 3 order pizzas type base on revenu

SELECT pt.name AS 'Pzzas Type', SUM(p.price * od.quantity) AS Revenue
FROM pizza_types AS pt
JOIN pizzas AS p
ON pt.pizza_type_id =   p.pizza_type_id
JOIN order_details AS od
ON p.pizza_id = od.pizza_id
GROUP BY pt.name 
ORDER BY 2 DESC
LIMIT 3;

#  11 calculate the percentage contribution of each pizzas type to total revenue
SELECT pt1.category,
concat(sum(p.price * od1.quantity)
						/
			(SELECT  SUM(quantity * price)
				FROM  pizzas AS p
				JOIN order_details  AS od
				ON p.pizza_id = od.pizza_id

        ) * 100) AS 'Revenue Contributed From Pizzas'
FROM order_details AS od1
JOIN pizzas AS p
ON p.pizza_id =  od1.pizza_id
JOIN pizza_types AS pt1
ON  p.pizza_type_id = pt1.pizza_type_id
GROUP BY pt1.category;






#  12 calculate the percentage contribution of each pizzas name to total revenue
SELECT   pt.name,
CONCAT(round(SUM(p1.price * od1.quantity)  /
				    (SELECT  SUM(p.price * od.quantity)
					FROM  order_details AS od
					JOIN pizzas AS p
					ON od.pizza_id =  p.pizza_id
                    ),3) * 100, "%")  AS 'Revenue Contributed From Pizzas'
FROM order_details AS od1
JOIN pizzas AS p1
ON od1.pizza_id = p1.pizza_id
JOIN pizza_types AS pt
ON p1.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY 2 DESC;






#  13 Analize the cumulative revenue generated over time 

WITH cumulative_revenue_generated_over_time AS (
		SELECT  o.`date`, ROUND(SUM(p.price * od.quantity), 3) AS Revenue
		FROM order_details  AS od
		JOIN orders AS o
		ON od.order_id = o.order_id
		JOIN pizzas AS p
		ON od.pizza_id = p.pizza_id
		GROUP BY o.`date`
)
SELECT date, Revenue , SUM(Revenue)
OVER(ORDER BY date) AS Cumulative_sum
FROM  cumulative_revenue_generated_over_time
GROUP BY date, Revenue;





#  14 determined top 3 most ordered pizzas type base on revenue for each pizzas category
WITH most_order_type_bae_revenue AS (
		SELECT  pt.category, pt.name, ROUND(SUM(p.price * od.quantity),0) As Revenue
		FROM pizzas AS p
		JOIN  order_details AS od
		ON p.pizza_id = od.pizza_id
		JOIN  pizza_types AS pt
		ON p.pizza_type_id = pt.pizza_type_id
		GROUP BY pt.category, pt.name
        ),
        getting_specific_cte  AS (        
        SELECT category, name,  Revenue, 
        RANK() OVER(PARTITION BY category  ORDER BY  Revenue) AS Rank_
        FROM  most_order_type_bae_revenue
)   
        
SELECT category, name,  Revenue
FROM  getting_specific_cte
WHERE Rank_ IN(1,2,3)
ORDER BY category, name,  Revenue;
