USE sakila;

DESCRIBE customer;

DESCRIBE address;

/*Cartesian Product*/

SELECT c.first_name, c.last_name, a.address  FROM customer c 
JOIN address a;

/*Inner Joins*/
SELECT c.first_name, c.last_name, a.address 
FROM customer c 
INNER JOIN address a 
ON (c.address_id = a.address_id);

-- If the names of the columns used to join the two tables are identical,
-- you can use the using subclause instead of the on subclause

SELECT c.first_name, c.last_name, a.address  FROM customer c 
INNER JOIN address a
USING (address_id);

SELECT c.first_name, c.last_name, a.address  
FROM customer c, address a 
WHERE c.address_id = a.address_id 
AND a.postal_code = 52137; -- Do NOT do this

-- Do this instead
SELECT c.first_name, c.last_name, a.address  
FROM customer c 
INNER JOIN address a 
ON (c.address_id = a.address_id)
WHERE a.postal_code = 52137;

/*JOINING THREE OR MORE TABLES*/
-- Show each customer city, need to traverse from the customer table to the address table using address_id 
-- and then from the address table to the city table using the city_id column
SELECT c.first_name, c.last_name, ct.city 
FROM customer c 
INNER JOIN address a 
ON (c.address_id = a.address_id)
INNER JOIN city ct
ON (a.city_id = ct.city_id);

-- No importa si se alteran el orden los join siempre se van a obtener el mismo resultado

/*Using subqueries as tables*/
SELECT c.first_name, c.last_name, addr.address, addr.city
FROM customer c 
	INNER JOIN
		(SELECT a.address_id, a.address, ct.city FROM address a
		INNER JOIN city ct
			USING (city_id)
			WHERE a.district = 'California'
		) AS addr
		ON c.address_id = addr.address_id;
	
/*Previous subquery*/
SELECT a.address_id, a.address, ct.city
FROM address a 
INNER JOIN city ct
	USING (city_id)
WHERE a.district = 'California';

/*Using the same table twice*/
SELECT f.title 
FROM film f 
	INNER JOIN film_actor fa 
	ON f.film_id = fa.film_id 
	INNER JOIN actor a 
	ON a.actor_id = fa.actor_id 
	WHERE ((a.first_name = 'CATE' AND a.last_name = 'MCQUEEN')
	or (a.first_name = 'CUBA' AND a.last_name = 'BIRCH'));

SELECT f.title 
FROM film f 
	INNER JOIN film_actor fa1
	ON f.film_id = fa1.film_id 
	INNER JOIN actor a1
	ON a1.actor_id = fa1.actor_id 
	INNER JOIN film_actor fa2
	ON f.film_id = fa2.film_id 
	INNER JOIN actor a2
	ON fa2.actor_id = a2.actor_id 
	WHERE (a1.first_name = 'CATE' AND a1.last_name = 'MCQUEEN')
	AND
	(a2.first_name = 'CUBA' AND a2.last_name = 'BIRCH');



ALTER TABLE film MODIFY prequel_film_id smallint(5) UNSIGNED,
ADD CONSTRAINT fk_prequel_film_id FOREIGN KEY (prequel_film_id) REFERENCES film(film_id);

UPDATE film SET prequel_film_id = 4 WHERE film_id = 5;

SELECT * FROM film;

/*Using a self join*/
SELECT f.title, f_prnt.title 
FROM film f 
	INNER JOIN film f_prnt
	ON f_prnt.film_id = f.prequel_film_id
WHERE f.prequel_film_id IS NOT NULL;

/*TEST YOUR KNOWLEDGE*/
-- Exercise 5-1
SELECT c.first_name, c.last_name, a.address, ct.city 
FROM customer c
	INNER JOIN address a 
	ON c.address_id = a.address_id 
	INNER JOIN city ct
	ON a.city_id = ct.city_id 
WHERE a.district = 'California';

-- Exercise 5-2
SELECT a.actor_id ,a.first_name, a.last_name, f.title 
FROM actor a
INNER JOIN film_actor fa 
ON a.actor_id = fa.actor_id 
INNER JOIN film f 
ON fa.film_id = f.film_id 
WHERE a.first_name = 'JOHN';
	
-- Exercise 5-3
SELECT a1.address, a2.address, a1.city_id
FROM address a1
	INNER JOIN address a2
WHERE a1.city_id = a2.city_id 
AND a1.address_id <> a2.address_id;
