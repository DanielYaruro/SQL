/*SORTING QUERY RESULTS*/

USE databook;

SELECT ename,job, sal  FROM emp WHERE deptno = 10 ORDER BY sal ASC;

SELECT ename, job, sal FROM emp e WHERE deptno = 10 ORDER BY sal DESC; 

-- Sorting by multiple fields
-- first order by deptno ascending and then by salary descending
SELECT empno, deptno, sal, ename, job FROM emp e ORDER BY deptno ASC, sal DESC; 

-- Sorting by substrings
-- Revisa el penultimo caracter y lo ordena de acuerdo a eso
SELECT ename, job  FROM emp ORDER BY substr(job, LENGTH(job) - 1); 

-- Sorting mixed alphanumeric data
DROP VIEW v;
CREATE VIEW v AS (SELECT concat(ename , ' ',deptno) AS data FROM emp e); 
SELECT * FROM v;

-- Dealing with nulls when sorting
-- Pone los nulos primero
SELECT ename, sal, comm FROM emp ORDER BY comm;

-- Pone los nulos de ultimo
SELECT ename, sal, comm FROM emp ORDER BY comm DESC, comm ASC; -- ESTO ULTIMO NO FUNCIONA cuando lo primero evaluado son nulo

/*NON-NULL COMM SORTED ASCENDING, ALL NULLS LAST*/
SELECT ename,sal,comm 
	FROM ( 
SELECT ename, sal, comm,
		CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
FROM emp e) x
ORDER BY is_null DESC, comm ASC;

/*NON-NULL COMM SORTED DESCENDING, ALL NULLS LAST*/

SELECT ename, sal, comm FROM(
	SELECT ename, sal, comm,
	CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
	FROM emp
) x
ORDER BY is_null DESC, comm DESC;

/*NON NULL COMM SORTED ASCENDING, ALL NULLS FIRST*/

SELECT ename, sal, comm 
	FROM(
	SELECT ename, sal, comm,
	CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
	FROM emp e
	) x
	ORDER BY is_null ASC, comm ASC;

/*NON NULL COMM SORTED DESCENDING, ALL NULLS FIRST*/

SELECT ename, sal, comm, is_null
	FROM(
	SELECT ename, sal, comm,
	CASE WHEN comm IS NULL THEN 0 ELSE 1 END AS is_null
	FROM emp e
	) x
	ORDER BY is_null ASC, comm DESC;

-- Sorting on a data dependent key
-- If job is salesman then sort on comm, otherwise sort by sal

SELECT ename, sal, job, comm FROM emp e
ORDER BY CASE WHEN job = 'SALESMAN' THEN comm ELSE sal END;

SELECT ename, sal, job, comm,
	CASE WHEN job = 'SALESMAN' THEN comm ELSE sal END AS ordered
FROM emp ORDER BY ordered ASC;





