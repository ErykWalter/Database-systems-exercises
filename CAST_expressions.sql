SELECT SURNAME, SALARY,
	CASE
		WHEN SALARY < 1500 THEN 'low salary'
		WHEN SALARY < 3000 THEN 'average salary'
		ELSE 'well paid'
	END AS "LABEL"
FROM EMPLOYEES;
SELECT DISTINCT BOSS_ID 
FROM EMPLOYEES
WHERE BOSS_ID IS NOT NULL
ORDER BY BOSS_ID;
SELECT DISTINCT DEPT_ID , JOB 
FROM EMPLOYEES
WHERE DEPT_ID IS NOT NULL
ORDER BY DEPT_ID, JOB;
SELECT DISTINCT EXTRACT(YEAR  FROM HIRE_DATE) AS "years"
FROM EMPLOYEES
ORDER BY EXTRACT(YEAR  FROM HIRE_DATE);
SELECT DEPT_ID 
FROM DEPARTMENTS
MINUS
SELECT DISTINCT DEPT_ID 
FROM EMPLOYEES;
SELECT SURNAME, SALARY, 'low paid' AS "label"
FROM EMPLOYEES e 
WHERE SALARY < 1500
UNION 
SELECT SURNAME, SALARY, 'average paid'
FROM EMPLOYEES e2 
WHERE SALARY >= 1500 AND SALARY < 3000
UNION 
SELECT SURNAME, SALARY, 'well paid'
FROM EMPLOYEES e3 
WHERE SALARY > 3000
ORDER BY SURNAME;
