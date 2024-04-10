/*1. How many pubs are located in each country?*/


SELECT  country,  count(pub_name) AS otal_pubs 
FROM pubs 
GROUP BY country ;


/*2. What is the total sales amount for each pub, including the beverage price and quantity sold?*/

SELECT p.pub_name, 
SUM(s.quantity* b.price_per_unit) AS total_sales
FROM pubS AS p
JOIN sales AS s ON p.pub_id = s.pub_id 
JOIN beverages b ON s.beverage_id = b.beverage_id
GROUP BY p.pub_name 
ORDER BY 2 DESC ;

-- Another way

SELECT p.pub_name, 
SUM(s.quantity* b.price_per_unit) as total_sales
FROM pubS AS p
join sales AS s USING (pub_id)
JOIN beverages b USING (beverage_id)
GROUP BY p.pub_name 
ORDER BY 2 DESC ;


/*3. Which pub has the highest average rating?*/

SELECT r.pub_id, p.pub_name , round(avg(r.rating),2) AS avg_rating
FROM pubs AS p 
JOIN ratings AS r USING(pub_id)
GROUP BY 1, 2
ORDER BY avg_rating DESC 
lIMIT 1 ;


/*4. What are the top 5 beverages by sales quantity across all pubs?*/

SELECT s.beverage_id, b.beverage_name, SUM(s.quantity) AS Total_quantity
FROM sales AS s
INNER JOIN beverages AS b USING (beverage_id)
GROUP BY  1,2
ORDER BY  SUM(s.quantity) DESC
LIMIT 5 ;

/*5. How many sales transactions occurred on each date?*/

SELECT transaction_date, count(*) AS No_of_transaction
FROM sales
GROUP BY transaction_date
ORDER BY transaction_date DESC;

/*6. Find the name of someone that had cocktails and which pub they had it in.*/

SELECT r.customer_name, p.pub_name 
FROM ratings AS r 
JOIN pubs AS p  USING (pub_id)
JOIN sales AS s USING (pub_id)
JOIN beverages AS b USING (beverage_id)
WHERE b.category = "cocktail"
;
 

/*7. What is the average price per unit for each 
category of beverages, excluding the category 'Spirit'?*/

SELECT category , Round(avg(price_per_unit),2) AS avg_price_per_unit
FROM beverages 
WHERE category Not In ("Spirit")
GROUP BY category 
ORDER BY avg_price_per_unit DESC  ; 



/*8. Which pubs have a rating higher than the average rating of all pubs?*/

 WITH cte as (
 SELECT p.pub_id , p.pub_name , round(avg(r.rating),2) AS avg_rating
 FROM pubs AS p
 JOIN ratings AS r USING (pub_id)
 GROUP BY 1,2 ) 
  
 SELECT pub_id , pub_name , avg_rating
 FROM cte 
 WHERE avg_rating > (select avg(r.rating) AS avg_rating
 FROM pubs as p
 INNER JOIN  ratings AS r USING (pub_id)
  ) ;
  
/*9. What is the running total of sales amount for each pub, 
ordered by the transaction date?*/

SELECT p.pub_id, p.pub_name, p.city, p.state, p.country,
       s.transaction_date, 
       SUM(b.price_per_unit * s.quantity) 
       OVER (PARTITION BY p.pub_id ORDER BY s.transaction_date) AS running_total
FROM pubs p
JOIN sales s ON p.pub_id = s.pub_id
JOIN beverages b ON s.beverage_id = b.beverage_id
ORDER BY p.pub_id, s.transaction_date ;

/*10. For each country, what is the average price per unit of beverages in each category,
 and what is the overall average price per unit of beverages across all categories?*/
 
 SELECT 
   b.beverage_name AS beverage_Name,
   p.country AS country, 
   b.category AS category,
   ROUND(AVG(b.price_per_unit), 2) AS avg_price,
   ROUND((SELECT AVG(price_per_unit) FROM beverages), 2) AS overall_average_price_per_unit
FROM pubs AS p
LEFT JOIN sales AS s
   ON s.pub_id = p.pub_id
LEFT JOIN beverages AS b
   ON b.beverage_id = s.beverage_id
GROUP BY beverage_name, country, category;
 
/*11. For each pub, what is the percentage contribution of each category of beverages to the total sales amount, 
and what is the pub's overall sales amount?*/

WITH CTE_1 AS (
	SELECT p.pub_id, p.pub_name, b.category,
		SUM(b.price_per_unit*s.quantity) AS TS
    FROM sales s
		JOIN pubs p USING(pub_id)
        JOIN beverages b USING(beverage_id)
	GROUP BY p.pub_id, p.pub_name, b.category),
	CTE_2 AS (
    SELECT *,
		SUM(TS) OVER (PARTITION BY pub_name) AS TSO
    FROM CTE_1)
SELECT pub_id, pub_name, category, TS, 
	ROUND(((TS/TSO)*100),2) AS Cotribution_percentage
FROM CTE_2
ORDER BY pub_id;