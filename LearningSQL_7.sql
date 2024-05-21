/*WORKING WITH DATA*/

-- Including special characters
USE sakila;

SELECT 'abcdefg', char(97,98,99,100,101,102,103);

SELECT char(128,129,130,131,132,133,134,135,136,137);

-- Building strings characters
SELECT concat('danke sch', char(148), 'n') FROM DUAL;

-- Busca el codigo ascii de un caracter
SELECT ascii('a');

/*String manipulation*/
CREATE TABLE string_tbl (
	char_fld char(255),
	vchar_fld varchar(255),
	text_fld text(1000)
);

INSERT INTO string_tbl (char_fld, vchar_fld, text_fld) VALUES
('This string is 28 characters',
'This string is 28 characters',
'This string is 28 characters');

-- String functions that returns numbers
SELECT length(char_fld) char_length,
length(vchar_fld) vchar_length,
length(text_fld) text_length
FROM string_tbl g;

-- Find the position at wich the string 'characters' appears in the vchar_fld you could use poosition() function
SELECT POSITION('characters' IN vchar_fld) FROM string_tbl g;

-- Locate() empieza a mirar desde el caracters 5 en busca de la palabra is
SELECT locate('is', vchar_fld, 5) FROM string_tbl;

-- Using regex or like
/*Like devuelve 0 si es falso 1 si es verdadero*/
SELECT name, name LIKE '%y' as ends_in_y

-- Perform more complex pattern matches you can use regexp

SELECT name, name REGEXP 'y$' AS ends_in_y
FROM category;

/*String Functions that return string*/
Truncate TABLE string_tbl;

INSERT INTO string_tbl (text_fld) VALUES
('This string was 29 characters');

-- Concatenar texto ya existente
UPDATE string_tbl SET text_fld = concat(text_fld, ', but now is longer'); 
SELECT text_fld
FROM string_tbl;

-- The following query generates a narrative string for each customer
SELECT concat(first_name, ' ', last_name, ' has been a customer since ', date(create_date))
FROM customer;

/*Insert strings in the middle of a string
*Insert() function takes four arguments:
*- the original string
*-the position at wich to start
*-number of characters to replace
*-replacement string
*/
SELECT insert('goodbye world', 9, 0, 'cruel ') AS string;

-- Empieza el 'hello' desde la posicion 1 y debe reemplazar 7 caracteres
SELECT insert('goodbye world',1 ,7 ,'hello');

/*Extract a substring from a string*/
-- Extraer de ese texto, desde la posicion 9 5 caracteres
SELECT substr('goodbye cruel world', 9, 5); 

/*Working with numerical data*/

-- Performing arithmetic functions
SELECT mod(22.75, 5) AS modulo;

SELECT pow(2,8) AS potencia;

SELECT ceil(72.445) AS number;
SELECT floor(72.445) AS number;

SELECT ceil(72.00000000001) AS number;
SELECT floor(72.9999999999999) AS number;

-- Use round instead
SELECT round(72.49999), round(62.5), round(75.50001);

SELECT round(72.0909, 1), round(72.0909, 2), round(72.0909, 3);

SELECT ROUND(17, -1) AS redondeo, truncate(17, -1) AS truncamiento;

/*Handling signed data*/
CREATE TABLE accounts(
	account_id int UNSIGNED PRIMARY KEY,
	acct_type enum('MONEY MARKET', 'SAVINGS', 'CHECKING'),
	balance decimal(6,2)
);

INSERT INTO accounts VALUES
(123, 'MONEY MARKET', 785.22),
(456, 'SAVINGS', 0),
(789, 'CHECKING', -324.22);

SELECT account_id, SIGN(balance), ABS(balance)
FROM accounts;

/*Working with temporal data*/

SELECT @@global.time_zone, @@session.time_zone;

/*Required date components
 * date => YYYY-MM-DD
 * datetime => YYYY-MM-DD HH:MI:SS
 * timestamp => YYYY-MM-DD HH:MI:SS
 * time => HHH:MI:SS
 * 
 * */
-- datetime with 3:30 PM on september 17
-- '2019-09-17 15:30:00'

UPDATE rental SET return_date = '2019-09-17 15:30:00'
WHERE rental_id = 99999;

/*String to date conversions*/
SELECT cast('2019-09-17 15:30:00' AS datetime);

/*Functions for generating dates*/

UPDATE rental SET return_date = str_to_date('September 17, 2019', '%M-%d-%Y')
WHERE rental_id = 99999;

SELECT return_date 
FROM rental r 
WHERE rental_id = 99999;

SELECT current_date(), current_time(), current_timestamp();

/*Manipulating temporal data*/
-- How to add five days to a current date:

SELECT date_add(current_date(), INTERVAL 5 DAY);

UPDATE rental 
SET return_date = date_add(return_date, INTERVAL '3:27:11' hour_second)
-- Aqui decimos el intervalo cada elemento de la fecha separado por dos puntos y despues 
-- del intervalo le decimos que cual es el elemento mayor seguido de _ hasta el elemento menor
WHERE rental_id = 99999;

SELECT create_date  FROM customer c 
WHERE customer_id = 2;

SELECT return_date FROM rental 
WHERE rental_id = 99999;

-- Sumar fechas y horas
UPDATE customer 
SET create_date = date_add(create_date, INTERVAL '9-11' YEAR_MONTH)
WHERE customer_id = 2;

-- You know where you want to arrive but not how many days it takes to get there
-- Si quieres arrojar el ultimo dia de ese mes dependiendo de la fecha dada
SELECT last_day('2019-09-17'); -- Last_day ALWAYS RETURNS a date

/*Temporal functions that return strings*/
SELECT dayname('2019-09-18'); -- Devuelve el nombre del dia

SELECT EXTRACT(YEAR_MONTH  FROM '2019-09-18 22:19:05');

/*Temporal functions that return numbers*/
-- datediff() return the numbers of full days between two dates
SELECT datediff('2019-09-03', '2019-06-21');

-- Conversion Functions
-- String to a integer
SELECT cast('1456328' AS signed integer);

SELECT cast('999ABC111' AS UNSIGNED integer);

SHOW warnings;

/*STR_TO_DATE()*/

/*Excersice 7-1*/
SELECT substring('Please find the substring in this string', 17, 25);

SELECT abs(-25.76823), sign(-25.76823), round(-25.768);

SELECT EXTRACT(MONTH FROM current_date());
