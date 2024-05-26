/*SUBQUERIES*/
USE sakila;
SELECT customer_id, first_name, last_name 
FROM customer c 
WHERE customer_id = (SELECT max(customer_id) FROM customer);

-- If you are not sure what the subquery does execute it without the other statement

/*Non correlated subqueries*/

SELECT city_id, city
FROM city c 
WHERE country_id <> (SELECT country_id FROM country c2 WHERE c2.country = 'India');

AND country_id <> (SELECT country_id FROM country c2 WHERE c2.country = 'Brazil')


-- OR

-- Multuiple row, single-column subqueries

SELECT country_id 
FROM country c 
WHERE country IN ('Canada', 'Mexico');

SELECT country_id
FROM country c 
WHERE country = 'Canada' OR country = 'Mexico';

SELECT city_id, city
FROM city c 
WHERE country_id IN 
(SELECT country_id 
FROM country c2
WHERE country = 'Canada' OR country = 'Mexico');

-- With not in
SELECT city_id, city 
FROM city c 
WHERE country_id NOT IN 
(SELECT country_id 
FROM country c2
WHERE country IN ('Canada', 'Mexico'));

-- The ALL operator
SELECT first_name, last_name 
FROM customer c 
WHERE customer_id <> ALL -- WHERE customer_id IS NOT IN the subquery RETURN, ALL OF them
(SELECT customer_id 
FROM payment p 
WHERE amount = 0);

SELECT first_name, last_name 
FROM customer c 
WHERE customer_id NOT IN 
(SELECT customer_id
FROM payment p
WHERE amount = 0);

SELECT customer_id, count(*)
FROM rental
GROUP BY customer_id
HAVING count(*) > ALL 
(SELECT count(*)
FROM rental r
	INNER JOIN customer c 
	ON r.customer_id = c.customer_id
	INNER JOIN address a 
	ON c.address_id = a.address_id
	INNER JOIN city ct
	ON a.city_id = ct.city_id
	INNER JOIN country co
	ON ct.country_id = co.country_id
WHERE co.country IN ('United States', 'Mexico', 'Canada')
GROUP BY r.customer_id
);

-- Subquery
SELECT count(*)
FROM rental r
	INNER JOIN customer c 
	ON r.customer_id = c.customer_id
	INNER JOIN address a 
	ON c.address_id = a.address_id
	INNER JOIN city ct
	ON a.city_id = ct.city_id
	INNER JOIN country co
	ON ct.country_id = co.country_id
WHERE co.country IN ('United States', 'Mexico', 'Canada')
GROUP BY r.customer_id;

/*The any operator*/
SELECT customer_id, sum(amount)
FROM payment
GROUP BY customer_id 
HAVING sum(amount) > ANY 
(SELECT sum(p.amount)
FROM payment p
	INNER JOIN customer c
	ON c.customer_id = p.customer_id
	INNER JOIN address a
	ON c.address_id = a.address_id
	INNER JOIN city ct
	ON ct.city_id = a.city_id
	INNER JOIN country co
	ON ct.country_id = co.country_id
WHERE co.country IN ('Bolivia', 'Paraguay', 'Chile')
GROUP BY co.country);

/*Multicolumn subqueries*/
SELECT fa.actor_id, fa.film_id, f.title, concat(ac.first_name, ' ', ac.last_name) AS actor_name
FROM film_actor fa 
INNER JOIN film f 
ON f.film_id = fa.film_id 
INNER JOIN actor ac
ON ac.actor_id = fa.actor_id 
WHERE fa.actor_id IN 
	(SELECT actor_id FROM actor WHERE last_name = 'MONROE')
	AND fa.film_id IN 
	(SELECT film_id FROM film WHERE rating = 'PG');
	
-- Same as
SELECT fa.actor_id, fa.film_id, f.title, concat(ac.first_name, ' ', ac.last_name) AS actor_name
FROM film_actor fa 
INNER JOIN film f 
ON f.film_id = fa.film_id 
INNER JOIN actor ac
ON ac.actor_id = fa.actor_id 
WHERE (fa.actor_id, fa.film_id) IN 
(SELECT ac.actor_id, f.film_id 
FROM actor ac
CROSS JOIN film f
WHERE ac.last_name = 'MONROE'
AND f.rating = 'PG');

/*Correlated Subqueries*/
SELECT c.first_name, c.last_name 
FROM customer c 
WHERE 20 = 
(SELECT count(*) 
FROM rental r
WHERE r.customer_id = c.customer_id
GROUP BY customer_id);

SELECT c.first_name, c.last_name 
FROM customer c 
WHERE 
	(SELECT sum(p.amount)
	FROM payment p
	WHERE p.customer_id = c.customer_id
	GROUP BY customer_id)
	BETWEEN 180 AND 240;


SELECT c.first_name, c.last_name 
FROM customer c 
WHERE EXISTS 
(
	SELECT 1 FROM rental r 
	WHERE r.customer_id = c.customer_id 
		AND date(r.rental_date) < '2005-05-25'
);

SELECT c.first_name, c.last_name 
FROM customer c 
WHERE EXISTS 
	(SELECT r.rental_date, r.customer_id
FROM rental r 
WHERE r.customer_id = c.customer_id 
	AND date(r.rental_date) < '2005-05-25');
	

/*Data manipulation using correlated subqueries*/

UPDATE customer c
SET c.last_update = 
(SELECT max(r.rental_date)
FROM rental r
WHERE customer_id = r.customer_id)
WHERE EXISTS 
(SELECT 1 FROM rental r
WHERE r.customer_id = c.customer_id);

DELETE  FROM customer c
WHERE 365 < ALL 
(SELECT datediff(now(), r.rental_date) days_since_last_rental
FROM rental r
WHERE c.customer_id = r.customer_id);


/*Subqueries as data sources*/

SELECT c.first_name, c.last_name, pymnt.num_rentals, pymnt.tot_payments
FROM customer c 
	INNER JOIN 
	(SELECT customer_id,
		count(*) num_rentals, sum(amount) tot_payments
		FROM payment p 
		GROUP BY customer_id
		) pymnt
	ON pymnt.customer_id = c.customer_id;


/*DATA FABRICATION*/
SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit
UNION ALL
SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit
UNION ALL
SELECT 'Heavy Hitters' name, 150 low_limit, 99999.99 high_limit;


SELECT pymnt_grps.name, count(*) num_customers
FROM 
(SELECT customer_id, count(*) num_rentals, sum(amount) tot_payments
FROM payment p
GROUP BY customer_id)	pymnt
INNER JOIN
(SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit
UNION ALL
SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit
UNION ALL
SELECT 'Heavy Hitters' name, 150 low_limit, 99999.99 high_limit) AS pymnt_grps
ON pymnt.tot_payments
BETWEEN pymnt_grps.low_limit AND pymnt_grps.high_limit
GROUP BY pymnt_grps.name;

/*Task Oriented Subqueries*
 */
SELECT c.first_name, c.last_name, ct.city, sum(p.amount) tot_payments, count(*) tot_rentals
FROM payment p 
INNER JOIN customer c 
ON p.customer_id = c.customer_id 
INNER JOIN address a 
ON c.address_id = a.address_id 
INNER JOIN city ct
ON a.city_id = ct.city_id 
GROUP BY c.first_name, c.last_name, ct.city;

/*Common table expressions*/

WITH actors_s AS
(SELECT
FROM actor a 
WHERE last_name LIKE 'S%'
),
actors_s_pg AS 
(
	SELECT s.actor_id, s.first_name, s.last_name,
	f.film_id, f.title
	FROM actors_s AS s
	INNER JOIN film_actor fa 
	ON s.actor_id = fa.actor_id
	INNER JOIN film f
	ON f.film_id = fa.film_id
	WHERE f.rating = 'PG'
),
actors_s_pg_revenue AS 
(
	SELECT spg,first_name, spg.last_name, p.amount
	FROM actors_s_pg spg
		INNER JOIN inventory i 
		ON i.film_id = spg.film_id
		INNER JOIN rental r
		ON i.inventory_id = r.inventory_id
		INNER JOIN payment p
		ON r.rental_id = p.rental_id
) -- END OF WITH clause 


/*Subqueries as expression generators*/
SELECT 
(
	SELECT c.first_name 
	FROM customer c 
	WHERE c.customer_id = p.customer_id
) AS first_name,
(
	SELECT c.last_name FROM customer c
	WHERE c.customer_id = p.customer_id
) AS last_name,
(
	SELECT ct.city FROM customer c
	INNER JOIN address a 
		ON c.address_id = a.address_id
	INNER JOIN city ct
		ON a.city_id = ct.city_id
	WHERE c.customer_id = p.customer_id
)	city,
sum(p.amount) tot_payments,
count(*) tot_rentals
FROM payment p 
GROUP BY customer_id;

SELECT a.actor_id, a.first_name, a.last_name 
FROM actor a 
ORDER BY 
(SELECT count(*) FROM film_actor fa
WHERE fa.actor_id = a.actor_id) desc;


INSERT INTO film_actor (actor_id, film_id, last_update)
VALUES 
(
	(SELECT actor_id  FROM actor
	WHERE first_name = 'JENNIFER' AND last_name = 'DAVIS'),
	(SELECT film_id FROM film
	WHERE title = 'ACE GOLDFINGER'),
	now()
);

/*Test your knowledge*/
-- Exercise 9-1
SELECT f.title 
FROM 
film f WHERE f.film_id IN   
(SELECT	fc.film_id
FROM film_category fc
	INNER JOIN category c 
	ON fc.category_id = c.category_id
WHERE c.name = 'Action'
);
