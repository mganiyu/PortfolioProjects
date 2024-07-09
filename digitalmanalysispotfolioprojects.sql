# digital music analysis portfolio projectss

# Question:: Set 1 - Essay
	# (1) who is the senior most employee base on  ?
		SELECT * 
        FROM employee
        ORDER BY levels DESC
        LIMIT 1;
        
	# (2) which country has the most invoice ?
        SELECT   billing_country, SUM(total)
        FROM invoice
        GROUP BY billing_country;
        
    # (3) what are top 3 values of total invoice ?
        SELECT   billing_country, SUM(total) AS total
        FROM invoice
        GROUP BY billing_country
        ORDER BY  total DESC
        LIMIT 3;
        
	# (4) which city has the best customer ?
        SELECT  c.city, ROUND(SUM(i.total),2) AS Total
        FROM customer c
		INNER JOIN invoice i
        ON c.customer_id = i.customer_id
        GROUP BY  c.city
        ORDER BY Total DESC
        LIMIT  1;
        
	# (5) who is best customer ?
         SELECT c.customer_id,
         c.first_name,
         c.last_name,
         ROUND(SUM(i.total),2) AS Total
        FROM customer c
		INNER JOIN invoice i
        ON c.customer_id = i.customer_id
        GROUP BY  c.customer_id,c.first_name, c.last_name
        ORDER BY Total DESC
        LIMIT  1;SELECT   * 
        FROM customer;

# Question: Set 2 - Moderate
	# (1) write query to return the email, first name, last name & Genre of all Rock music listens.
           # Return your list ordered alphabetically by email starting with A  ?
           
           
           SELECT   c.email, c.first_name, c.last_name
           FROM customer c
           JOIN  invoice i
           ON C.customer_id = i.customer_id
           JOIN invoice_line il
           ON i.invoice_id = il.invoice_id
           WHERE il.track_id IN (
					   SELECT  t.track_id
					   FROM  track t
					   JOIN genre g
					   ON t.genre_id = g.genre_id
					   WHERE g.name LIKE "%Rock%"
		)			   
        ORDER BY c.email ASC;   
        
     # (2) let's invite the artist who has written the most rock song in our data set
           # write a query that returns the artist name and total track count of the top 10 rock band ?
           
           SELECT  ar.artist_id, ar.`name`,COUNT(ar.artist_id) AS Total_Counts
           FROM artist ar
           JOIN   album2 al
           ON ar.artist_id = al.artist_id
           JOIN track tr 
           ON al.album_id = tr.album_id
           JOIN genre ge
           ON tr.genre_id =  ge.genre_id
           WHERE  ge.`name` LIKE  "%Rock%"
          GROUP BY  ar.artist_id, ar.`name`
          ORDER BY  3  DESC
          LIMIT 10;
          
 # (3) Return all the track names that has a song lenght longer than the average song lenth
           # Return the name and milliseconds for each tracks. Order by the song length with the longest song listed first ?    
           
          SELECT name, milliseconds
          FROM track
          WHERE milliseconds > (
			  SELECT AVG(milliseconds)
			   FROM track
           );
                    

 # Question:: Set 3 - Advance
	# (1) find how much amount spent by each customer on artists  ? Write a query to return customer name, artist name and total spent
         SELECT cus.customer_id, cus.first_name, cus.last_name,  art.`name`,
         SUM(invl.unit_price * invl.quantity) Total_Sale
         FROM  customer cus
          JOIN invoice inv
          ON cus.customer_id = inv.customer_id
		JOIN invoice_line invl
        ON inv.invoice_id = invl.invoice_id
        JOIN track  tr
        ON invl.track_id = tr.track_id
        JOIN album2  al
        ON tr.album_id = al.album_id
        JOIN artist  art
        ON al.artist_id = art.artist_id
        GROUP BY 1,2,3,4
        ORDER BY 5 DESC;
        
       # (2) most popular music genrre for eah country
       
       WITH best_selling_artist AS  (
			SELECT art.artist_id AS artist_id, art.name AS artist_name,
            SUM(invl.quantity * invl. unit_price) AS Total_Sale
            FROM invoice_line invl
            JOIN track  tr
            ON invl.track_id = tr.track_id
            JOIN album2  alb
            ON tr.album_id = alb.album_id
            JOIN artist  art
            ON alb.artist_id = art.artist_id
            GROUP BY 1
            ORDER BY 3 DESC
            LIMIT 1
)
       SELECT  c.customer_id, c.first_name, c.last_name, 
       SUM(il.unit_price * il.quantity) Amount_Apent
       FROM invoice i
		JOIN customer  c
		ON i.customer_id = c.customer_id
        JOIN invoice_line il
        ON i.invoice_id = il.invoice_id
        JOIN track t
        ON il.track_id = t.track_id
        JOIN album2  a2
        ON t.album_id  = a2.album_id
       JOIN best_selling_artist  bsa 
       ON bsa.artist_id = alb.artist_id
       GROUP BY 1,2,3,4
       ORDER BY 5 DESC;
       
       
# (3) customer thta spend the most on music  for eah country
       
       WITH Customer_with_country AS  (
			SELECT cus.customer_id, cus.first_name, cus.last_name, inv.billing_country, SUM(inv.total) AS total_pending,
            ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo
            FROM invoice inv
            JOIN customer  cus
            ON inv.invoice_id = cus.customer_id
            GROUP BY 1,2,3,4
            ORDER BY 4 ASC, 5 DESC
       )
       SELECT * 
       FROM Customer_with_country
       WHERE RowNo >1;
   
        
           
           
           
           
           