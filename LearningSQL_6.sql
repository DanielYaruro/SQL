USE sakila;

DESC customer;
DESC city;

/*The union operator*/
SELECT 1 num, 'abc' str
UNION 
SELECT 9 num, 'xyz' str;

SELECT 'CUST' typ, c.first_name, c.last_name 
FROM customer c 
UNION ALL 
SELECT 'ACTR' typ, a.first_name, a.last_name  
FROM actor a;

SELECT c.first_name, c.last_name 
FROM customer c 
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
UNION ALL 
SELECT a.first_name, a.last_name
FROM actor a 
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';

SELECT c.first_name, c.last_name 
FROM customer c 
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
UNION 
SELECT a.first_name, a.last_name
FROM actor a 
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';

/*Intersect*/

SELECT c.first_name, c.last_name 
FROM customer c 
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
INTERSECT 
SELECT a.first_name, a.last_name
FROM actor a 
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';

SELECT a.first_name, a.last_name 
FROM actor a 
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
EXCEPT 
SELECT c.first_name, c.last_name
FROM customer c 
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%';

/*Set operation Precedence*/

SELECT a.first_name, a.last_name 
FROM actor a 
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
UNION ALL 
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'M%' AND a.last_name LIKE 'T%'
UNION
SELECT c.first_name, c.last_name
FROM customer c 
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%';

-- Exercise 6-2
SELECT a.first_name fname, a.last_name lname
FROM actor a 
WHERE a.last_name LIKE 'L%'
UNION all
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.last_name LIKE 'L%';

-- Exercise 6-3

SELECT a.first_name fname, a.last_name lname
FROM actor a 
WHERE a.last_name LIKE 'L%'
UNION all
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.last_name LIKE 'L%'
ORDER BY lname;
