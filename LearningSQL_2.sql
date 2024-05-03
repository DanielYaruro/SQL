use sakila;

/*Know the current time and data*/
select now() from dual;

show character set;

CREATE DATABASE chapter2;
USE chapter2;

CREATE TABLE person(
person_id SMALLINT UNSIGNED PRIMARY KEY,
fname VARCHAR(20),
lname VARCHAR(20),
eye_color ENUM('BL','BR','GR'), -- CHECK (eye_color IN ('BL','BR','GR')), -- ENUM for force data to put those values
birth_date DATE,
street VARCHAR(20),
city VARCHAR(20),
state VARCHAR(20),
country VARCHAR(20),
postal_code VARCHAR(20)
);
-- Check constraint

CREATE TABLE favorite_food(
person_id SMALLINT UNSIGNED,
food VARCHAR(20),
CONSTRAINT pk_favorite_food PRIMARY KEY (person_id,food),
CONSTRAINT fk_fav_food_person_id FOREIGN KEY (person_id) 
REFERENCES person(person_id)
);

-- If you forget create the foreign key constraint when you firs create the table, you can add it later via
-- ALTER TABLE

/*Populating and modifying tables*/
-- Generating numeric data
-- Autoincrement
DROP TABLE favorite_food;  
ALTER TABLE person MODIFY person_id SMALLINT UNSIGNED AUTO_INCREMENT; 
-- No va a dejar modificarla directamente porque tiene una llave foranea asociada
desc person;

-- The insert statement
INSERT INTO person (person_id, fname, lname, eye_color, birth_date) VALUES
(null, 'William', 'Turner', 'BR', '1972-05-27');

SELECT person_id, fname, lname, eye_color, birth_date FROM person;

select person_id, fname, lname, eye_color, birth_date from person where lname = 'Turner';

-- His food preferences
INSERT INTO favorite_food (person_id, food) VALUES 
(1, 'pizza'),
(1, 'cookies'),
(1, 'nachos');

SELECT food FROM favorite_food WHERE person_id = 1 ORDER BY food;

INSERT INTO person (person_id, fname, lname, eye_color, birth_date, street, city, state, country, postal_code)
VALUES
(null, 'Susan', 'Smith', 'BL', '1975-11-02', '23 Maple st.', 'Arlignton', 'VA', 'USA', '20220');

/*Updating data*/
UPDATE person SET street = '1225 Tremont St.',
city = 'Boston',
state = 'MA',
country = 'USA',
postal_code = '02138' WHERE person_id = 1; -- Use always WHERE STATEMENT

DELETE FROM person WHERE person_id = 2;

/*Sakila database*/
use sakila;
show tables;
desc customer;


