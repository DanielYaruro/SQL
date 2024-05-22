USE sakila;


/*Aggregates and group by statements*/
SELECT customer_id 
FROM rental r
GROUP BY customer_id;

/*Cuantas peliculas alquilo cada cliente*/

SELECT customer_id, count(*) AS peliculas_alquiladas 
FROM rental r 
GROUP BY customer_id
ORDER BY peliculas_alquiladas desc;

-- YOU CANNOT DO THIS
SELECT customer_id, count(*) AS peliculas_alquiladas
FROM rental r 
WHERE peliculas_alquiladas >= 40
GROUP BY customer_id;

-- INSTEAD YOU HAVE TO USE THE HAVING CLAUSE
SELECT customer_id, count(*) AS peliculas_alquiladas 
FROM rental r 
GROUP BY customer_id
HAVING peliculas_alquiladas >= 40;

/*Aggregate functions*/

-- Query that uses all of the common aggregate functions to analyze the data on film rental payments
SELECT max(amount) AS max_amt,
min(amount) AS min_amt,
avg(amount) AS avg_amt,
sum(amount) AS tot_amt,
count(*) num_payments
FROM payment p;

SELECT customer_id,
max(amount) AS max_amt,
min(amount) AS min_amt,
avg(amount) AS avg_amt,
sum(amount) AS tot_amt,
count(*) AS num_payments
FROM payment p 
GROUP BY customer_id;

SELECT count(customer_id) num_rows,
count(DISTINCT customer_id) num_customers
FROM payment p;

SELECT max(datediff(return_date, rental_date)) AS max_days
FROM rental;

/*How nulls are handled*/

CREATE TABLE number_tbl(
	val SMALLINT 
);

INSERT INTO number_tbl VALUES 
(1),(3),(5);

SELECT count(*) num_rows,
count(val) num_vals,
sum(val) total,
max(val) max_val,
avg(val) avg_val
FROM number_tbl;

-- Now with a null value in the table
INSERT INTO number_tbl VALUES (null);

SELECT count(*) num_rows,
count(val) num_vals,
sum(val) total,
max(val) max_val,
avg(val) avg_val
FROM number_tbl;

/*Generating groups*/

SELECT actor_id, count(*) AS total
FROM film_actor fa 
GROUP BY actor_id;

-- Multicolumn grouping
SELECT fa.actor_id, f.rating, count(f.rating)  -- da igual si usamos count(*)
FROM film_actor fa 
	INNER JOIN film f 
	ON fa.film_id = f.film_id 
GROUP BY fa.actor_id, f.rating
ORDER BY 1,2;

SELECT extract(YEAR FROM rental_date) YEAR,
	count(*) how_many
FROM rental r 
GROUP BY extract(YEAR FROM rental_date);

SELECT fa.actor_id, f.rating, count(*)
FROM film_actor fa 
	INNER JOIN film f 
	ON fa.film_id = f.film_id 
GROUP BY fa.actor_id, f.rating WITH ROLLUP 
ORDER BY 1,2;

/*Group Filter Conditions*/

SELECT fa.actor_id, f.rating, count(*) total
FROM film_actor fa 
	INNER JOIN film f 
	ON fa.film_id = f.film_id 
WHERE f.rating IN ('G', 'PG', 'R')
GROUP BY fa.actor_id, f.rating 
HAVING total > 9;

/*Test your knoledge*/

SELECT count(*)
FROM payment p;

SELECT p.customer_id, c.first_name, count(*) AS pelis_rented, sum(amount) AS total_paid
FROM payment p 
	INNER JOIN customer c 
	ON c.customer_id = p.customer_id
GROUP BY p.customer_id;

SELECT p.customer_id, c.first_name, count(*) AS pelis_rented, sum(amount) AS total_paid
FROM payment p 
	INNER JOIN customer c 
	ON c.customer_id = p.customer_id
GROUP BY p.customer_id
HAVING pelis_rented >= 40;
