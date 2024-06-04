use sakila;

SELECT f.film_id, f.title, count(*) num_copies
FROM film f
INNER JOIN inventory i 
	ON f.film_id = i.film_id 
GROUP BY f.film_id, f.title;

SELECT f.film_id, f.title, count(i.inventory_id)
FROM film f 
LEFT JOIN inventory i 
ON f.film_id = i.film_id 
GROUP BY f.film_id, f.title;

SELECT f.film_id, f.title, i.inventory_id 
FROM film f 
INNER JOIN inventory i 
ON f.film_id = i.film_id 
WHERE f.film_id BETWEEN 13 AND 15;

SELECT f.film_id, f.title, i.inventory_id
FROM film f 
LEFT OUTER JOIN inventory i 
ON f.film_id = i.film_id 
WHERE f.film_id BETWEEN 13 AND 15;

/*LEFT VERSUS RIGHT OUTER JOINS*/
SELECT f.film_id, f.title, i.inventory_id 
FROM inventory i 
RIGHT OUTER JOIN film f 
ON i.film_id = f.film_id 
WHERE f.film_id BETWEEN 13 AND 15;

/*Three way outer joins*/
SELECT f.film_id, f.title, i.inventory_id, r.rental_date 
FROM film f 
	LEFT OUTER JOIN inventory i 
	ON f.film_id = i.film_id 
	LEFT OUTER JOIN rental r
	ON i.inventory_id = r.inventory_id 
WHERE f.film_id BETWEEN 13 AND 15;

/*Cross Joins*/
-- Producto cartesiano entre tablas
SELECT c.name AS category_name, l.name AS languange_name
FROM category c 
CROSS JOIN language l ;

/*Natural Joins*/
SELECT c.first_name, c.last_name, date(r.rental_date)
FROM customer c 
NATURAL JOIN rental r;

-- Right way
SELECT cust.first_name, cust.last_name, date(r.rental_date)
FROM
(SELECT customer_id, first_name, last_name
FROM customer
) AS cust
NATURAL JOIN rental r;

CREATE VIEW cust_table AS
(SELECT 1 customer_id, 'John Smith' name
UNION ALL 
SELECT 2 customer_id, 'Kathy Jones' name
UNION ALL
SELECT 3 customer_id, 'Greg Oliver' name);

CREATE VIEW paym_table AS 
(SELECT 101 payment_id, 1 customer_id, 8.99 amount
UNION ALL
SELECT 102 payment_id, 3 customer_id, 4.99 amount
UNION ALL 
SELECT 103 payment_id, 1 customer_id, 7.99 amount);

SELECT * FROM paym_table;

-- Test your knowledge
-- Exercise 1
SELECT ct.customer_id, ct.name, sum(pt.amount) AS total_payms
FROM cust_table ct
LEFT JOIN paym_table pt
ON ct.customer_id = pt.customer_id
GROUP BY ct.customer_id, ct.name;


-- Exercise 2
-- Now with right join

SELECT ct.customer_id, ct.name, sum(pt.amount) total_payms
FROM paym_table pt
RIGHT OUTER JOIN cust_table ct
ON pt.customer_id = ct.customer_id
GROUP BY ct.customer_id, ct.name;
