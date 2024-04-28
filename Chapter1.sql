SELECT * FROM emp e;

SELECT * FROM emp e WHERE deptno = 10;

SELECT * FROM emp e WHERE deptno = 10 OR comm IS NOT NULL OR (deptno=20 AND sal<=2000)

SELECT ename, deptno, sal FROM emp e;

SELECT sal AS salary, comm AS commision FROM emp e;

/*CONCATENATING COLUMN VALUES*/

SELECT ename,job  FROM emp WHERE deptno = 10;

SELECT concat(ename, ' WORK AS A ', job) AS message FROM emp WHERE deptno = 10;  

/*Using conditional logic in a select statement*/
-- like an if-else

SELECT ename, sal,
	CASE WHEN sal <= 2000 THEN 'UNDERPAID'
	WHEN sal >= 4000 THEN 'OVERPAID'
	ELSE 'OK'
	END AS status
FROM emp;

-- Limiting the number of rows returned
SELECT * FROM emp LIMIT 5;

-- Returning n randoms recors from a table
SELECT ename,job  FROM emp ORDER BY rand() LIMIT 5;

-- Finding null values
SELECT * FROM emp WHERE comm IS NULL;

-- Transforming nulls into real values

-- COALESCE function to substitute real values for nulls

SELECT empno, ename,job ,mgr ,hiredate ,sal,  COALESCE(comm, 0), deptno  AS commission FROM emp;

-- Searching for patterns
-- Selecciona los que estan en ese no intervalo sino esos valores
SELECT ename, job, deptno  FROM emp WHERE deptno IN (10,20);

SELECT ename, job, deptno FROM emp WHERE (ename LIKE '%I%' OR job LIKE '%ER') AND deptno IN (10,20);
