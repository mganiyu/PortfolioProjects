# customer behaviour analysis portfolio projectt in sql
CREATE DATABASE customerbebehaviouranalysis;

# Create all the three needed table

CREATE TABLE  sales (
	customer_id VARCHAR(1),
	order_date DATE,
	product_id INTEGER
);


CREATE TABLE  menu (
		product_id INTEGER,
		product_name VARCHAR(5),
		price INTEGER
);

CREATE TABLE  members (
		customer_id VARCHAR(1), join_date DATE
);
# insert into all the three needed table
INSERT INTO sales (customer_id, order_date, product_id)
VALUES 
			('A', '2021-01-01', 1),
			('A', '2021-01-01', 2),
			('A', '2021-01-07', 2),
			('A', '2021-01-10', 3),
			('A', '2021-01-11', 3),
			('A', '2021-01-11', 3),
			('B', '2021-01-01', 2),
			('B', '2021-01-02', 2),
			('B', '2021-01-04', 1),
			('B', '2021-01-11', 1),
			('B', '2021-01-16', 3),
			('B', '2021-02-01', 3),
			('C', '2021-01-01', 3),
			('C', '2021-01-01', 3),
			('C', '2021-01-07', 3);

INSERT INTO menu (product_id, product_name, price)
VALUES 
			(1, 'sushi', 10),
			(2, 'curry', 15),
			(3, 'ramen', 12);

INSERT INTO members (customer_id, join_date)
VALUES 
			('A', '2021-01-07'),

			('B', '2021-01-09');

SELECT *
FROM menu;

SELECT *
FROM sales;

SELECT *
FROM members;

# 1. What is the total amount each customer spent at the restaurant?
		SELECT  sa.customer_id, SUM(me.price) AS Total_Spent
		FROM sales sa
		INNER JOIN menu me
		ON sa.product_id =  me.product_id
		GROUP BY sa.customer_id;
        
#  2. How many days has each customer visited the restaurant?
		SELECT customer_id,  COUNT(DISTINCT(order_date)) AS Days_Customer_Visited
		FROM sales
		GROUP BY customer_id;

# 3. What was the first item from the menu purchased by each customer?
   WITH cust_first_puchase AS ( 
		SELECT  sa.customer_id, MIN(sa.order_date) AS first_item_purchase
		FROM sales sa
		GROUP BY customer_id 
    )
    SELECT cfp.customer_id, cfp.first_item_purchase, m.product_name
    FROM cust_first_puchase AS cfp
    JOIN sales AS s
    ON cfp.customer_id =  s.customer_id
    AND s.order_date =  cfp.first_item_purchase
    JOIN menu m
    ON m.product_id =  s.product_id;
#  4. What is the most purchased item on the menu and how many times was it purchased by all customers?
	SELECT  m.product_name, COUNT(*) AS Total_Purchase
	FROM sales AS s
	JOIN menu AS m
	ON s.product_id = m.product_id
	GROUP BY m.product_name
	ORDER BY 2 DESC
	LIMIT 1;




#  5. Which item was the most popular for each customer?
WITH Most_popular_Item AS (
		SELECT  s.customer_id, product_name, COUNT(*) AS Most_Popular,
		DENSE_RANK() OVER(PARTITION BY s.customer_id  ORDER BY COUNT(*) DESC) AS num_row
		FROM  sales AS s
		JOIN menu  AS m
		ON s.product_id  =  m.product_id
		GROUP BY s.customer_id, m.product_name
)
SELECT  cp.customer_id, cp.product_name, cp.Most_Popular
FROM Most_popular_Item  AS cp
WHERE  num_row > 1;











#  6. Which item was purchased first by the customer after they became a member?
WITH product_first_purchase_after_membership AS (
		SELECT  s.customer_id, MIN(s.order_date) AS first_purchase
		 FROM sales As s
		 JOIN  members m
		ON   s.customer_id = m.customer_id
		WHERE s.order_date >= m.join_date
		GROUP BY s.customer_id
)
SELECT  pfpam.customer_id, m.product_name
FROM product_first_purchase_after_membership  AS pfpam
JOIN  sales AS s
ON s.customer_id = pfpam.customer_id
AND pfpam.first_purchase = s.order_date
JOIN  menu m  
ON s.product_id = m.product_id;



#  7. Which item was purchased just before the customer became a member?

WITH last_purchase_before_members AS (
		SELECT  s.customer_id, MAX(s.order_date) AS last_purchase_date
		 FROM sales As s
		 JOIN  members m
		ON   s.customer_id = m.customer_id
		WHERE s.order_date <  m.join_date
		GROUP BY s.customer_id
)
SELECT  lpbm.customer_id, m.product_name
FROM last_purchase_before_members  AS lpbm
JOIN  sales AS s
ON s.customer_id = lpbm.customer_id
AND lpbm.last_purchase_date = s.order_date
JOIN  menu m  
ON s.product_id = m.product_id;


#  8. What is the total items and amount spent for each member before they became a member?
		SELECT  s.customer_id, COUNT(*) AS Total_items, SUM(m.price) AS Total_Spent
		FROM sales As s
		JOIN  menu AS m
		ON   m.product_id = s.product_id
		JOIN members AS mb
		ON s.customer_id =  mb.customer_id
        WHERE s.order_date <  m.join_date
        GROUP BY  s.customer_id;
        
#  9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT  s.customer_id,SUM(
		CASE
        WHEN  m.product_name = "sushi" THEN m.price*20
        ELSE m.price * 10
        END) AS total_points
FROM sales As s
JOIN  menu AS m
ON   s.product_id = m.product_id
GROUP BY   s.customer_id;
   

/* 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - 
how many points do customer A and B have at the end of January?*/

		SELECT  s.customer_id,SUM(
				CASE
				WHEN s.order_date  BETWEEN mb.join_date AND date_add(mb.join_date , INTERVAL 7 day)  THEN m.price*20
				WHEN m.product_name   = "sushi" THEN m.price*20
				ELSE m.price * 10
				END) AS total_points
		FROM sales As s
		JOIN  menu AS m
		ON   s.product_id = m.product_id
		LEFT JOIN members mb
		ON s.customer_id = mb.customer_id
		WHERE s.customer_id  IN("A", "B")
		AND s.order_date <= "2021-01-31"
		GROUP BY s.customer_id
		ORDER BY 2 DESC;
        
        
# 11. Recreate the table output using the available data
SELECT  s.customer_id,s.order_date, m.product_name, m.price,
		CASE
        WHEN s.order_date  >= mb.join_date  THEN  "Y"
        ELSE  "N" 
        END AS member_
FROM sales As s
JOIN  menu AS m
ON   s.product_id = m.product_id
LEFT JOIN members mb
ON s.customer_id = mb.customer_id
ORDER BY s.customer_id, s.order_date ;







# 12. Rank all the things:
WITH customer_data AS (
		SELECT  s.customer_id,s.order_date, m.product_name, m.price,
				CASE
						WHEN s.order_date  < mb.join_date  THEN  "N"
						WHEN s.order_date  >= mb.join_date  THEN  "Y"
				ELSE  "N" 
				END AS member_
		FROM sales As s
		JOIN  menu AS m
		ON   s.product_id = m.product_id
		LEFT JOIN members mb
		ON s.customer_id = mb.customer_id
		)        
   SELECT  *,
    CASE 
		   WHEN  member_ = "N " THEN NULL
		   ELSE  RANK() OVER(PARTITION BY  customer_id, member_  ORDER BY order_date)
		   END AS Ranking
   FROM  customer_data 
		   