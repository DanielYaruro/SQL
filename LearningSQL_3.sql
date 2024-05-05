USE sakila;

SELECT language_id, -- El select funcion para desplegar cualquier tipo de operaciones en pantalla
'COMMON' language_usage,
language_id * 3.1415927 AS lang_pi_value,
upper(name) language_name
FROM language;

SELECT version(),
user(),
database();

/*Removing duplicates*/

SELECT DISTINCT actor_id FROM film_actor ORDER BY actor_id;
/*Tables*/
-- Derived (Subquery-generated) tables
SELECT CONCAT(cust.last_name, ', ', cust.first_name) AS full_name 
FROM
(SELECT first_name, last_name, email -- el email se pude borrar porque no se hara uso de el
FROM customer
WHERE first_name = 'JESSIE') AS cust;

/*TEMPORARY TABLES*/
-- actors whose last names start with J can be stored temporarly:
CREATE TEMPORARY TABLE actors_j(
	actor_id smallint(5),
    first_name varchar(45),
    last_name varchar(45)
);

INSERT INTO actors_j -- Se pueden insertar elementos tomando los elementos de otra tabla
SELECT actor_id, first_name, last_name FROM actor
WHERE last_name LIKE 'J%';

SELECT * FROM actors_j;

CREATE VIEW cust_vw AS
SELECT customer_id, first_name, last_name, active FROM customer; -- Active en este caso es una columna de la tabla

SELECT first_name, last_name FROM cust_vw WHERE active = 0;

/*Table links*/

SELECT c.first_name, c.last_name, time(r.rental_date) AS rental_time -- Manera correcta para agarrar una hora, 'time'
FROM customer c 
JOIN rental r
ON (c.customer_id = r.customer_id)
WHERE DATE(r.rental_date) = '2005-06-14'; -- Manera correcta para filtrar por fechas, hacerle casting

SELECT c.first_name, c.last_name, time(r.rental_date) AS rental_time
FROM customer AS c 
INNER JOIN rental AS r 
ON (r.customer_id = c.customer_id)
WHERE date(r.rental_date) = '2005-06-14';

/*The where clause*/

SELECT f.title 
FROM film f 
WHERE rating = 'G' AND rental_duration >= 7;

SELECT f.title, f.rating, f.rental_duration 
FROM film f 
WHERE (rating = 'G' AND rental_duration >= 7)
OR (rating = 'PG-13' AND rental_duration <= 3);

/*The group by and having clausses*/

SELECT c.first_name, c.last_name, count(*) AS number_rentals -- Cuenta cuantas veces esta la persona en un registro
FROM customer c 
INNER JOIN rental r 
ON c.customer_id = r.customer_id 
GROUP BY c.first_name, c.last_name 
HAVING number_rentals >= 40;

/*The order by clause*/

SELECT c.first_name, c.last_name, time(r.rental_date) AS rental_time
FROM customer c
INNER JOIN rental r 
ON c.customer_id = r.customer_id 
WHERE DATE(r.rental_date) = '2005-06-14'
ORDER BY last_name, c.first_name;



SELECT c.first_name, c.last_name, time(r.rental_date) AS rental_time
FROM customer c
INNER JOIN rental r 
ON c.customer_id = r.customer_id 
WHERE DATE(r.rental_date) = '2005-06-14'
ORDER BY TIME(r.rental_date) DESC; -- Hora de la mayor a la menor

/*Sorting via numeric placeholders*/

/*TEST YOUR KNOWLEDGE*/
-- Exercise 3-1
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
ORDER BY a.last_name, a.first_name LIMIT 100;

-- Exercise 3-2 
SELECT a.actor_id, a.first_name, a.last_name 
FROM actor a
WHERE a.last_name = 'WILLIAMS' OR a.last_name = 'DAVIS';

-- Exercise 3-3
SELECT DISTINCT c.customer_id, c.first_name, c.last_name, DATE(r.rental_date) AS rental_date
FROM rental r 
INNER JOIN customer c
ON (c.customer_id = r.customer_id) 
WHERE DATE(r.rental_date) = '2005-07-05';

-- Exercise 3-4
SELECT c.email, r.return_date 
FROM customer c 
	INNER JOIN rental r 
	ON (c.customer_id = r.customer_id)
WHERE DATE(r.rental_date) = '2005-06-14'
ORDER BY DATE(r.return_date) DESC, TIME(r.return_date) DESC;
