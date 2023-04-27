--1 
WITH 
	averages AS 
	(SELECT AVG(e.salary) AS average, e.JOB AS JOB 
	FROM EMPLOYEES e
	GROUP BY e.JOB)
	
SELECT e.SURNAME , e.JOB , e.SALARY, a.average AS average_for_job
FROM EMPLOYEES e 
JOIN averages a ON a.job = e.JOB 
WHERE a.average < e.SALARY 
ORDER BY e.SURNAME;

--2
WITH 
	sums AS 
	(SELECT d.DEPT_NAME , SUM(e.SALARY) AS s
	FROM DEPARTMENTS d
	JOIN EMPLOYEES e ON e.DEPT_ID = d.DEPT_ID
	GROUP BY d.DEPT_NAME)
	
SELECT s.dept_name, s.s AS "sum"
FROM sums s
WHERE s.s = (SELECT max(s2.s) FROM sums s2);

--3
WITH 
	boss_ids AS 
	(SELECT e.BOSS_ID AS id
	FROM EMPLOYEES e),
	bosses_adj_salaries AS 
	(SELECT e2.EMP_ID, e2.SURNAME, e2.SALARY * 0.6 AS SALARY 
	FROM EMPLOYEES e2
	WHERE e2.EMP_ID = ANY (SELECT id FROM boss_ids))
	
SELECT e.SURNAME, e.SALARY, b.surname, b.salary / 0.6 AS boss_salary
FROM EMPLOYEES e 
JOIN bosses_adj_salaries b ON b.emp_id = e.BOSS_ID 
WHERE e.SALARY >= b.salary 
ORDER BY e.SURNAME;

--4
SELECT e.SURNAME, TO_CHAR(e.HIRE_DATE , 'yyyy.mm.dd') AS hire_date
FROM EMPLOYEES e 
ORDER BY e.HIRE_DATE 
FETCH FIRST 1 ROW ONLY;

--5
WITH 
	first_hire_date AS 
	(SELECT e.SURNAME, e.HIRE_DATE AS hire_date
	FROM EMPLOYEES e 
	ORDER BY e.HIRE_DATE 
	FETCH FIRST 1 ROW ONLY),
	hire_dates_diffs AS 
	(SELECT e2.SURNAME, trunc(e2.HIRE_DATE - (SELECT f.hire_date FROM first_hire_date f)) as days
	FROM EMPLOYEES e2 CROSS JOIN first_hire_date d)
SELECT *
FROM hire_dates_diffs h
ORDER BY h.days;

--6
WITH 
	grands AS 
	(SELECT e.SURNAME, 
		CASE 
			WHEN e.SALARY < 1000 THEN 'one'
			WHEN e.SALARY < 2000 THEN 'two'
			WHEN e.SALARY < 3000 THEN 'three'
			WHEN e.salary < 4000 THEN 'four'
			WHEN e.SALARY < 5000 THEN 'five'
			ELSE 'six'
		END AS grand
	FROM EMPLOYEES e)
	
SELECT 
	g.surname || ' earns ' || g.grand || ' grand' AS sentence
FROM grands g
ORDER BY g.surname;

--7
WITH
	emp_hierarchy(emp_id, boss_id, name, p) AS
	(SELECT emp_id, boss_id, name||' '||surname, name||' '||surname AS p
	FROM employees
	WHERE SURNAME = 'Smith'
	UNION ALL
	SELECT e.emp_id, e.boss_id, e.name||' '||e.SURNAME, h.p||' -> '||e.name||' '||e.SURNAME
	FROM employees e 
	JOIN emp_hierarchy h ON e.boss_id = h.emp_id)
	SEARCH DEPTH FIRST 
	BY p SET sib_order
SELECT name, p AS "hierarchy"
FROM emp_hierarchy
ORDER BY sib_order