/*Comparison operator such as : =, !=, <, >, <>, like, in, between*/

/*Filtering Data*/

-- Equality conditions
title = 'River Outlaw'
fed_id = '111-11-111'
amount = 375.25
film_id = SELECT film_id FROM film WHERE title = 'RIVER OUTLAW';

SELECT c.email 
FROM customer c 
INNER JOIN rental r 
ON c.customer_id = r.customer_id 
WHERE date(r.rental_date) = '2005-06-14';

/*Inequality conditions*/

SELECT c.email 
FROM customer c
INNER JOIN rental r 
ON c.customer_id = r.customer_id 
WHERE date(r.rental_date) <> '2005-06-14';

/*Data modification using equality conditions*/
DELETE FROM rental WHERE year(rental_date) = 2004;

DELETE FROM rental WHERE year(rental_date) <> 2005 AND year(rental_date) <> 2006;

/*Range conditions*/

SELECT customer_id, rental_date FROM rental r 
WHERE rental_date < '2005-05-25';

SELECT customer_id, rental_date FROM rental r 
WHERE rental_date <= '2005-06-16' -- upper conditions
AND rental_date >= '2005-06-14'; -- lower conditions

/*The Between operator*/
SELECT customer_id, rental_date FROM rental r 
WHERE rental_date BETWEEN '2005-06-14' AND '2005-06-16';

-- When using the between you have always to specify first the lower limit range first
-- and the uper limit range second

SELECT customer_id, rental_date 
FROM rental r
WHERE rental_date BETWEEN '2005-06-16' AND '2005-06-14'; -- Wrong!

-- The values in the upper limit and lower limit are included
SELECT customer_id, payment_date, amount  
FROM payment p 
WHERE amount BETWEEN 10.0 AND 11.99 ORDER BY amount;

/*String ranges*/
SELECT c.last_name, c.first_name 
FROM customer c 
WHERE last_name BETWEEN 'FA' AND  'FRB';

/*Memberships conditions*/
SELECT title, rating
FROM film
WHERE rating = 'G' OR rating = 'PG';

-- Use the in operator instead
SELECT f.title, f.rating 
FROM film f
WHERE rating IN ('G', 'PG');

/*Using subqueries*/
SELECT f.title, f.rating 
FROM film f 
WHERE rating IN (SELECT rating FROM film WHERE title LIKE '%PET%');

/*Using not in*/

SELECT f.title, f.rating 
FROM film f 
WHERE rating NOT IN ('PG-13', 'R', 'NC-17');

/*MATCHING CONDITIONS*/

-- Customers whose last names begins with Q
SELECT c.last_name, c.first_name 
FROM customer c 
WHERE LEFT(last_name, 1) = 'Q';

/*Using wildcards*/

-- ( _ ) exactly one character
-- ( % ) any numbers of character (including 0)

SELECT last_name, first_name 
FROM customer c 
WHERE last_name LIKE '_A_T%S';

SELECT last_name, first_name
FROM customer c 
WHERE last_name LIKE 'Q%' OR last_name LIKE 'Y%'; -- Que empiecen con y o con q

/*Using regular expressions*/

SELECT last_name, first_name
FROM customer c 
WHERE last_name REGEXP '^[QY]';

/*NULL: THAT FOUR LETTER WORD*/

SELECT r.rental_id, r.customer_id, r.return_date
FROM rental r 
WHERE return_date IS NULL;

SELECT r.rental_id, r.customer_id, r.return_date 
FROM rental r 
WHERE return_date IS NOT NULL;

SELECT rental_id, customer_id, return_date 
FROM rental r 
WHERE return_date NOT BETWEEN '2005-05-01' AND '2005-09-01' OR return_date IS NULL;
-- What about the 183 rentals that were never returned?
-- Have to return null too

/*Test your knowledge*/
-- return 101 and 107 id customer
-- Exercise 4-3
SELECT *
FROM payment p
WHERE amount IN (1.98, 7.98, 9.98);

-- Exercise 4-4
SELECT * 
FROM customer c 
WHERE last_name LIKE '_A%W%';
