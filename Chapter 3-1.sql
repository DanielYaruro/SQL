/*WORKING WITH MULTIPLE TABLES*/

-- 3.1 Stacking one rowset atop another
USE databook;
SELECT ename AS ename_and_dname, deptno FROM emp WHERE deptno = 10
UNION ALL 
SELECT '------------', NULL FROM t1
UNION ALL
SELECT dname,deptno FROM dept; 

-- Union all combines rows from multiple row sources into one reult set, the items y all the selects
-- must match in number and data type
-- Union all will include duplicates
-- Just Union won't
SELECT deptno  FROM emp
UNION 
SELECT deptno FROM dept;

/*Combining related rows*/

SELECT e.ename, d.loc FROM emp e, dept d
WHERE e.deptno = d.deptno; -- Esto para hacer el JOIN

SELECT e.ename, d.loc FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.deptno = 10;

-- Using inner join
SELECT e.ename, d.loc  
FROM emp e JOIN dept d
ON (e.deptno = d.deptno)
;

/*Finding rows in common between two tables*/
CREATE VIEW v AS
SELECT ename,job,sal FROM emp e WHERE job = 'CLERK';

SELECT * FROM v;
DESCRIBE emp;

SELECT e.empno, e.ename, e.job, e.sal, e.deptno FROM v JOIN emp e 
ON (e.ename = v.ename 
AND e.job = v.job
AND e.sal = v.sal);

/*Retrieving values from one table that do not exist in another*/
-- Selecciona valores de dept que no estan en emp
SELECT deptno  FROM dept d
EXCEPT 
SELECT deptno FROM emp;

/*Retrieving rows from one table that do not correspond to rows in another*/

-- Wich department has no employees
-- Outer join and filter nulls
SELECT d.* FROM dept d LEFT JOIN emp e
ON (d.deptno = e.deptno)
WHERE e.deptno IS NULL;

/*Adding joins to a query without interfering with other joins*/

CREATE TABLE emp_bonus(
	kind INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	received DATE,
	empno INT,
	FOREIGN KEY(empno) REFERENCES emp(empno)
);
DROP TABLE emp_bonus;

INSERT INTO emp_bonus (received, empno) VALUES
('2005-03-14', 7369),
('2205-03-14', 7900),
('2005-03-14', 7788)
;
SELECT * FROM emp_bonus;

SELECT e.ename, d.loc FROM emp e LEFT JOIN dept d 
ON (e.deptno = d.deptno);

-- Como no todos los empleados recibieron bonus si hacemos esto no nos dara el resultado deseado:
SELECT e.ename, d.loc, eb.received FROM emp e, dept d, emp_bonus eb
WHERE e.deptno = d.deptno 
AND e.empno = eb.empno;

-- Solucion correcta
-- Joins recursivos
SELECT e.ename, d.loc, eb.received FROM emp e LEFT JOIN dept d 
	ON (e.deptno = d.deptno)
	LEFT JOIN emp_bonus eb
	ON (e.empno = eb.empno)
	ORDER BY eb.received DESC, e.ename ASC;

/*Determining whether two tables have the same data*/

CREATE VIEW v AS
SELECT * FROM emp WHERE deptno <> 10
UNION ALL
SELECT * FROM emp WHERE ename = 'WARD';

SELECT * FROM v;

-- Devuelve los valores que no estan en la vista y los duplicados
(
SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno, 
	count(*) AS cnt
	FROM v 
	GROUP BY empno, ename, job, mgr, hiredate, sal, comm, deptno
	EXCEPT
	SELECT empno, ename,job,mgr, hiredate, sal, comm, deptno,
	COUNT(*) AS cnt
	FROM emp
	GROUP BY empno, ename, job, mgr, hiredate, sal, comm, deptno
	)
UNION ALL
(
	SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno,
	COUNT(*) AS cnt
	FROM emp e
	GROUP BY empno, ename, job, mgr, hiredate, sal, comm, deptno
	EXCEPT
	SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno,
	COUNT(*) AS cnt
	FROM v 
	GROUP BY empno, ename, job, mgr, hiredate, sal, comm, deptno
);

/* Identifying and avoiding cartesian products */

SELECT e.ename,d.loc  FROM emp e, dept d 
WHERE e.deptno = 10; -- This IS wrong

SELECT e.ename, d.loc FROM emp e JOIN dept d -- This IS correct
ON (e.deptno = d.deptno)
AND e.deptno = 10;

/*Performing joins when using aggregates*/




