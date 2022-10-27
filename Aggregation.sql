SELECT MIN(SALARY) AS "minimum_salary", MAX(SALARY) AS "maximum_salary", MAX(SALARY) - MIN(SALARY) AS "difference" 
FROM EMPLOYEES e;
SELECT COUNT(EMP_ID) AS "employees_without_dept"
FROM EMPLOYEES e 
WHERE DEPT_ID IS NULL;
