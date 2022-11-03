SELECT NAME, SURNAME, d.DEPT_NAME, d.ADDRESS 
FROM EMPLOYEES e 
INNER JOIN DEPARTMENTS d ON e.DEPT_ID  = d.DEPT_ID 
ORDER BY SURNAME;
SELECT 
	'Employee' || NAME || ' ' || SURNAME || ' works in ' || d.DEPT_NAME || ' located at ' || d.ADDRESS AS "sentence"
FROM EMPLOYEES e 
INNER JOIN DEPARTMENTS d ON e.DEPT_ID  = d.DEPT_ID 
ORDER BY SURNAME;
SELECT SURNAME , SALARY 
FROM EMPLOYEES e 
INNER JOIN DEPARTMENTS d ON d.DEPT_ID = e.DEPT_ID 
WHERE d.ADDRESS LIKE '47TH STR'
ORDER BY SURNAME;
SELECT COUNT(*) AS "num_of_employees", ROUND(AVG(SALARY), 2) AS "average_salary"  
FROM EMPLOYEES e 
INNER JOIN DEPARTMENTS d ON d.DEPT_ID = e.DEPT_ID 
WHERE d.ADDRESS LIKE '47TH STR'
ORDER BY SURNAME;