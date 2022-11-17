SELECT e.NAME, e.SURNAME, d.DEPT_NAME  AS "department", d.ADDRESS AS "address"
FROM EMPLOYEES e 
LEFT JOIN DEPARTMENTS d ON d.DEPT_ID = e.DEPT_ID
ORDER BY e.SURNAME;

SELECT e.NAME, e.SURNAME, COALESCE(d.DEPT_NAME, 'no dopartment') AS "department", COALESCE(d.ADDRESS, 'no department') AS "address"
FROM EMPLOYEES e 
LEFT JOIN DEPARTMENTS d ON d.DEPT_ID = e.DEPT_ID
ORDER BY e.SURNAME; 

SELECT 
	COALESCE(e.NAME, 'no employees') AS "name",
	COALESCE(e.SURNAME, 'no employees') AS "surname", 
	COALESCE(d.DEPT_NAME, 'no dopartment') AS "department", 
	COALESCE(d.ADDRESS, 'no department') AS "address"
FROM EMPLOYEES e 
FULL OUTER JOIN DEPARTMENTS d ON d.DEPT_ID = e.DEPT_ID
ORDER BY e.SURNAME;

SELECT d.DEPT_NAME, COUNT(e.EMP_ID) AS "employees_at_dept", SUM(e.SALARY) AS "salaries_at_dept"  
FROM DEPARTMENTS d 
LEFT JOIN EMPLOYEES e ON e.DEPT_ID = d.DEPT_ID 
GROUP BY d.DEPT_NAME 
ORDER BY d.DEPT_NAME;

SELECT e.SURNAME , COALESCE(e2.SURNAME, 'no boss') AS "boss"
FROM EMPLOYEES e 
LEFT JOIN EMPLOYEES e2 ON e.BOSS_ID = e2.EMP_ID 
ORDER BY e.SURNAME;

SELECT e.SURNAME , COALESCE(e2.SURNAME, 'no boss') AS "boss"
FROM EMPLOYEES e 
LEFT JOIN EMPLOYEES e2 ON e.BOSS_ID = e2.EMP_ID 
WHERE UPPER(e2.SURNAME) IN ('WILSON', 'SMITH') OR e2.SURNAME IS NULL 
ORDER BY e.SURNAME;

SELECT 
	e.SURNAME , 
	e.SALARY * 12 + COALESCE(e.ADD_SALARY, 0) AS "emp_annual_salary",
	e2.SALARY * 12 + COALESCE(e2.ADD_SALARY, 0) AS "boss_annual_salary"
FROM EMPLOYEES e 
INNER JOIN EMPLOYEES e2 ON e.BOSS_ID = e2.EMP_ID 
ORDER BY e.SURNAME;