USE sakila;

SELECT first_name, last_name, 
	CASE
		WHEN active = 1 THEN 'ACTIVE'
		ELSE 'INACTIVE'
	END as activity_type
FROM customer c;

/*The case Expression*/
CASE 
	WHEN category.name IN 
	('Children', 'Family', 'Sports', 'Animation')
	THEN 'All ages'
	WHEN category.name = 'Horror'
	THEN 'Adult'
	WHEN category.name IN ('Music', 'Games')
	THEN 'Teens'
	ELSE 'Other'
END;

/*Another version of the query from earlier in the chapter that uses a subquery to*/
-- Return the number of rentals, but only for active customers
SELECT c.first_name, c.last_name,
	CASE 
		WHEN active = 0 THEN 0
		ELSE 
		(SELECT count(*) FROM rental r
		WHERE r.customer_id = c.customer_id
		GROUP BY customer_id)
	END AS num_rentals
FROM customer c;

-- Simple case expressions
-- Bit less flexible
CASE category.name
WHEN 'Children' THEN 'All ages'
WHEN 'Family' THEN 'All ages'
WHEN 'Sports' THEN 'All ages'
WHEN 'Animation' THEN 'All ages'
WHEN 'Horror' THEN 'Adult'
WHEN 'Music' THEN 'Teens'
WHEN 'Games' THEN 'Teens'
ELSE 'Other'
END;

/*EXAMPLES OF CASE EXPRESSIONS*/

/*Result set transformations*/
-- Three rows of one column
SELECT monthname(rental_date)  rental_month, count(*) num_rentals
FROM rental
WHERE rental_date BETWEEN '2005-05-01' AND '2005-08-01'
GROUP BY monthname(rental_date);

-- One row of three columns
SELECT 
sum(CASE WHEN monthname(rental_date) = 'May' THEN 1 ELSE 0 END) AS May_rentals,
sum(CASE WHEN monthname(rental_date) = 'June' THEN 1 ELSE 0 END) AS June_rentals,
sum(CASE WHEN monthname(rental_date) = 'July' THEN 1 ELSE 0 END) AS July_rentals
FROM rental
WHERE rental_date BETWEEN '2005-05-01' AND '2005-09-01';

/*Checking for existence*/
-- Query that uses multiple case expressions to generate three outputs columns,
-- one to show wheter the actor has appeared in G-rated films, or PG-rated films, or NC-17 rated films
SELECT a.first_name, a.last_name,
CASE WHEN EXISTS (SELECT 1 FROM film_actor fa INNER JOIN film f ON fa.film_id = f.film_id
WHERE fa.actor_id = a.actor_id AND f.rating = 'G') THEN 'Y' ELSE 'N' END g_actor,
CASE WHEN EXISTS (SELECT 1 FROM film_actor fa INNER JOIN film f ON fa.film_id = f.film_id
WHERE fa.actor_id = a.actor_id AND f.rating = 'PG') THEN 'Y' ELSE 'N' END pg_actor,
CASE WHEN EXISTS (SELECT 1 FROM film_actor fa INNER JOIN film f ON fa.film_id = f.film_id
WHERE fa.actor_id = a.actor_id AND f.rating = 'NC-17') THEN 'Y' ELSE 'N' END nc17_actor
FROM actor a
WHERE a.last_name LIKE 'S%' OR a.first_name LIKE 'S%';

-- The next query uses a simple case expression to count the number of copies in inventory for each film
-- And returns either 'out of stock', 'scarce', 'available', 'common'

SELECT f.title,
CASE (SELECT count(*) FROM inventory i
	WHERE i.film_id = f.film_id)
	WHEN 0 THEN 'Out of stock'
	WHEN 1 THEN 'Scarce'
	WHEN 2 THEN 'Scarce'
	WHEN 3 THEN 'Available'
	WHEN 4 THEN 'Available'
	ELSE 'Common'
	END AS film_availability
FROM film f;

/*Division by zero errors*/
SELECT c.first_name, c.last_name,
sum(p.amount) tot_paymnt_amt,
count(p.amount) num_payments,
sum(p.amount) / CASE WHEN count(p.amount) = 0 THEN 1
ELSE count(p.amount)
END AS avg_payment
FROM customer c 
LEFT OUTER JOIN payment p 
ON c.customer_id = p.customer_id 
GROUP BY c.first_name, c.last_name;

/*Conditional Updates*/
UPDATE customer 
SET active = CASE WHEN 90 <= (SELECT datediff(now(), max(rental_date)) FROM rental r
								WHERE r.customer_id = customer.customer_id)
					THEN 0 ELSE 1 END 
					WHERE active = 1;
					

				
				
				
				
/*Handling null values*/
SELECT c.first_name, c.last_name,
CASE 
	WHEN a.address IS NULL THEN 'Unknown'
	ELSE a.address
	END address,
CASE 
	WHEN ct.city IS NULL THEN 'Unknown'
	ELSE ct.city 
	END city,
CASE 
	WHEN cn.country IS NULL THEN 'Unknown'
	ELSE cn.country
	END country
FROM customer c 
	LEFT JOIN address a 
	ON a.address_id = c.address_id
	LEFT JOIN city ct
	ON ct.city_id = a.city_id
	LEFT JOIN country cn
	ON cn.country_id = ct.country_id;

/*Test your knowledge*/
-- Exercise 11-1
SELECT name,
CASE WHEN l.name IN ('English', 'Italian', 'French', 'German') THEN 'latin1'
WHEN l.name IN ('Japanese', 'Mandarin') THEN 'utf8'
ELSE 'Unknown'
END AS codi
FROM language l;

-- Exercise 11-2
SELECT rating, count(*)
FROM film 
GROUP BY rating;
				
