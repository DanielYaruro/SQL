USE sakila;

CREATE VIEW customer_vw
(customer_id, 
first_name,
last_name,
email) AS 
SELECT customer_id, first_name, last_name,
concat(substr(email, 1, 2), '********', substr(email, -4))
-- Take the first two caracters from 1 to 2, concat **** and add email from -1 to -4 last 4 characters
FROM customer c;

-- You can query it just like a table
SELECT first_name, last_name, email
FROM customer_vw;

DESCRIBE customer_vw;

/* You are free to use any clauses of the select statements */
SELECT first_name, count(*), min(last_name), max(last_name)
FROM customer_vw
WHERE first_name LIKE 'J%'
GROUP BY first_name
HAVING count(*) > 1;

-- You can join views to other tables
SELECT cv.first_name, cv.last_name, p.amount
FROM customer_vw AS cv
	INNER JOIN payment p 
	ON p.customer_id = cv.customer_id
WHERE p.amount >=11;

-- Next view definition excludes inactive customers
CREATE VIEW active_customer_vw
(customer_id,
first_name,
last_name,
email)
AS 
SELECT customer_id, first_name, last_name,
concat(substr(email, 1, 2), '*******', substr(email, -4)) AS email
FROM customer
WHERE active=1;

# DATA AGREGGATION

CREATE VIEW sales_by_film_category 
AS
SELECT 
c.name AS category,
sum(p.amount) AS total_sales
FROM payment p
	INNER JOIN rental AS r ON r.rental_id = p.rental_id
	INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
	INNER JOIN film AS f ON i.film_id = f.film_id
	INNER JOIN film_category AS fc ON f.film_id = fc.film_id
	INNER JOIN category AS c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY total_sales DESC;

SELECT * FROM sales_by_film_category sbfc;

# HIDDING COMPLEXITY
CREATE VIEW film_stats
AS
SELECT f.film_id, f.title, f.description, f.rating,
(SELECT c.name 
FROM category c
	INNER JOIN film_category fc 
	ON c.category_id = fc.category_id
WHERE fc.film_id = f.film_id) AS category_name,
(SELECT count(*)
FROM film_actor fa
WHERE fa.film_id = f.film_id
) AS num_actors,
(SELECT count(*) 
FROM inventory i
WHERE i.film_id = f.film_id) AS inventory_cnt,
(SELECT count(*) FROM inventory i
	INNER JOIN rental r
	ON r.inventory_id = i.inventory_id
	WHERE i.film_id = f.film_id) AS num_rentals
	FROM film f;


SELECT * FROM film_stats;

/* Joining Partitioned Data */
CREATE VIEW payment_all
(payment_id, customer_id,
staff_id, rental_id, amount,
payment_date, last_update)
AS 
SELECT payment_id, customer_id, staff_id, rental_id,
amont, payment_date, last_update
FROM payment_historic
UNION ALL 
SELECT payment_id, customer_id, staff_id, rental_id,
amont, payment_date, last_update
FROM payment_current;


/* UPDATABLE VIEWS*/

-- You can modify data through a view
# In MySQL a view is updatable if the following conditions are met
-- No aggregate functions are used (max(), min(), avg(), etc)

-- The view does not employ group by or having clauses

-- No subqueries exists in the select or from clause, and
-- any subqueries in the where clause do not refer to tables in the from clause

-- The view does not utilize union, union all, or distinct
-- The from clause includes at least one table or updatable view

-- The from clause uses only inner joins if there is more than one table or view


/*Updating Simple Views*/

CREATE VIEW customer_vw
(customer_id,
first_name,
last_name,
email)
AS 
SELECT customer_id, first_name, last_name,
concat(substr(email, 1, 2), '*******', substr(email, -4)) AS email
FROM customer;

-- Update Mary Smith's last name to Smith-Allen:
UPDATE customer_vw 
SET last_name = 'SMITH-ALLEN'
WHERE customer_id = 1;

# Check the underlying customer table just to be sure
SELECT first_name, last_name, email
FROM customer c 
WHERE c.customer_id = 1;

-- You will not be able to modify the email column because of the functions
UPDATE customer_vw 
SET email = 'MARY.SMITH-ALLEN@sakilacustomer.org'
WHERE customer_id = 1; #Error: COLUMN email IS NOT updatable



-- You may use the view to update data in either the customer or 
-- address table, as the following statements demonstrate:

CREATE VIEW customer_details
AS
SELECT c.customer_id,
c.store_id,
c.first_name,
c.last_name,
c.address_id,
c.active,
c.create_date,
a.address,
ct.city,
cn.country,
a.postal_code
FROM customer c 
	INNER JOIN address a
	ON c.address_id = a.address_id
	INNER JOIN city ct
	ON a.city_id = ct.city_id
	INNER JOIN country cn
	ON cn.country_id = ct.country_id;
	
SELECT * FROM customer_details;

UPDATE customer_details 
SET last_name = 'SMITH-ALLEN', active=0
WHERE customer_id = 1;

UPDATE customer_details 
SET address = '999 Mockingbird Lane'
WHERE customer_id = 1;

/*The first statement modifies the customer.last_name 
 * and customer.active columns, whereas the second statement modifies 
 * the address.address column*/

#What happen if you try update columns from bith tables in a single statement
UPDATE customer_details 
SET last_name = 'SMITH-ALLEN',
	active=0,
	address= '999 Mockingbird Lane'
WHERE customer_id = 1;

-- You are allowed to modify both of the underlying tables separately, but not within a single statement

#Insert some data onto both tables for new customers
INSERT INTO customer_details (customer_id, store_id, first_name, last_name,
address_id, active, create_date)
VALUES 
(9998, 1, 'BRIAN', 'SALAZAR', 5, 1, now());

-- The statement only populates columns from the customer table, works fine.
-- Let's what happens if we expand the column list to also include a column from the address table

INSERT INTO customer_details 
(customer_id, store_id, first_name, last_name, address_id, active, create_date, address)
VALUES (9999, 2, 'THOMAS', 'BISHOP', 7, 1, now(), '999 Mockinbird Lane');

# Cannot modify more than one base table through a join view

/*TEST YOUR KNOWLEDGE*/

-- Create a view definition that can be used by the following query
CREATE VIEW film_ctgry_actor 
(title, category_name, first_name, last_name)
AS 
SELECT f.title, c.name, a.first_name, a.last_name
FROM film f 
INNER JOIN film_category fc 
ON fc.film_id = f.film_id
INNER JOIN category c 
ON c.category_id = fc.category_id
INNER JOIN film_actor fa 
ON fa.film_id = f.film_id
INNER JOIN actor a 
ON fa.actor_id = a.actor_id
WHERE a.last_name = 'FAWCETT';


SELECT * FROM film_ctgry_actor;

-- EXERCISE 14-2
CREATE VIEW country_payments
AS 
SELECT c.country,
(SELECT sum(p.amount)
FROM city ct
	INNER JOIN address a
	ON ct.city_id = a.city_id
	INNER JOIN customer cst
	ON a.address_id = cst.address_id
	INNER JOIN payment p
	ON p.customer_id = cst.customer_id
	WHERE ct.country_id = c.country_id) AS tot_payments
FROM country c;
