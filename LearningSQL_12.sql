/*TRANSACTIONS*/

START TRANSACTION;
/*withdraw money from first account, making sure balance is sufficient*/
UPDATE account SET avail_balance = avail_balance - 500 WHERE account_id = 9988
AND avail_balance > 500;

IF <exactly one ROW was updated BY the previous STATEMENT> THEN 
/*Deposit money into second account*/
UPDATE account SET avail_balance = avail_balance + 500 WHERE account_id = 9989;

IF <exactly one ROW was updated BY the previous STATEMENT> THEN 
/* everything worked, make the changes permanent  */
COMMIT;
ELSE 
/*Something went wrong, undo all changes in this transaction*/
	ROLLBACK;
END IF
ELSE 
/* Insufficient funds, or error encountered during update */
ROLLBACK;
END IF;

/*STARTING A TRANSACTION
 * 
 */
-- First step 
-- Disable autocommit
SET autocommit=0;

/*Transactions savepoints*/
START TRANSACTION;
UPDATE product SET date_retired = current_timestamp() 
WHERE product_cd = 'XYZ';
SAVEPOINT before_close_accounts;
UPDATE account SET status='CLOSED', close_date= current_timestamp(),
last_activity_date = current_timestamp() 
WHERE product_cd = 'XYZ';
ROLLBACK TO SAVEPOINT before_close_accounts;
COMMIT;

/*Test your knowledge*/

-- Exercise 12-1

CREATE TABLE account(
account_id int UNSIGNED PRIMARY KEY,
avail_balance double,
last_activity_date timestamp
);

CREATE TABLE transaccion(
txn_id_amount int,
txn_date datetime,
account_id int UNSIGNED,
txn_type_cd char(1),
amount double,
CONSTRAINT FOREIGN KEY (account_id) REFERENCES account(account_id)
);

DROP TABLE transaccion;

INSERT INTO account (account_id, avail_balance, last_activity_date) VALUES
(123, 500, '2019-07-10 20:53:27'),
(789, 75, '2019-06-22 15:18:35');

INSERT INTO transaccion (txn_id_amount, txn_date, account_id, txn_type_cd, amount) VALUES
(1001, '2019-05-15', 123, 'C', 500),
(1002, '2019-06-01', 789, 'C', 75 );

START TRANSACTION;

UPDATE account SET avail_balance = 500 - 50, last_activity_date = now()
WHERE account_id = 123;

INSERT INTO transaccion (txn_id_amount, txn_date, account_id, txn_type_cd, amount) VALUES
(1003, now(), 123, 'D', 450);


UPDATE account SET avail_balance = 75 + 50, last_activity_date = now() 
WHERE account_id = 789;

INSERT INTO transaccion (txn_id_amount, txn_date, account_id, txn_type_cd, amount) VALUES
(1004, now(), 789, 'C', 125);

ROLLBACK;
COMMIT;
