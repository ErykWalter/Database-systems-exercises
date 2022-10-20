SELECT SURNAME, EMP_ID, SUBSTR(SURNAME, 0, 2) || EMP_ID AS "login"
FROM EMPLOYEES 
ORDER BY SURNAME;
SELECT SURNAME
FROM EMPLOYEES
WHERE SURNAME  LIKE '%L%' OR SURNAME LIKE '%l%'
ORDER BY SURNAME;
SELECT SURNAME 
FROM EMPLOYEES
WHERE SUBSTR(SURNAME, 0, CEIL(LENGTH(SURNAME) / 2)) LIKE '%l%'
OR SUBSTR(SURNAME, 0, CEIL(LENGTH(SURNAME) / 2)) LIKE '%L%'
ORDER BY SURNAME;
SELECT 
	SURNAME, 
	SALARY AS "original_salary", 
	ROUND(SALARY*1.15, 0) AS "increased_salary" 
FROM EMPLOYEES
ORDER BY SURNAME;
SELECT TO_CHAR(CURRENT_DATE, 'DAY') AS "Today is"
FROM DUAL;
SELECT TO_CHAR(TO_DATE('2002.01.09','YYYY.MM.DD'), 'DAY') AS "I was born on"
FROM DUAL;
SELECT SURNAME, TRIM(TRAILING ' ' FROM TO_CHAR(HIRE_DATE, 'D MONTH YYYY, DAY')) AS "hire_date"
FROM EMPLOYEES
ORDER BY SURNAME;
SELECT 
	SURNAME, 
	JOB, 
	(TO_DATE('01.01.2000', 'DD.MM.YYYY') - HIRE_DATE) YEAR TO MONTH AS "Expierience"
FROM EMPLOYEES
WHERE 
	JOB IN ('ASSISTANT', 'PROFESSOR', 'LECTURER')
	AND (TO_DATE('01.01.2000', 'DD.MM.YYYY') - HIRE_DATE) > 0
ORDER BY (TO_DATE('01.01.2000', 'DD.MM.YYYY') - HIRE_DATE) DESC, SURNAME;
SELECT 
	SURNAME, 
	JOB, 
	(TO_DATE('01.01.2000', 'DD.MM.YYYY') - HIRE_DATE) YEAR TO MONTH AS "Expierience"
FROM EMPLOYEES
WHERE 
	JOB IN ('ASSISTANT', 'PROFESSOR', 'LECTURER')
	AND EXTRACT(YEAR FROM (DATE '2000-01-01' - HIRE_DATE) YEAR TO MONTH) > 10 
ORDER BY (TO_DATE('01.01.2000', 'DD.MM.YYYY') - HIRE_DATE) DESC, SURNAME;
SELECT 
	SURNAME, 
	JOB, 
	EXTRACT(YEAR FROM (DATE '2000-01-01' - HIRE_DATE) YEAR TO MONTH) AS "Expierience"
FROM EMPLOYEES
WHERE 
	JOB IN ('ASSISTANT', 'PROFESSOR', 'LECTURER')
	AND EXTRACT(YEAR FROM (DATE '2000-01-01' - HIRE_DATE) YEAR TO MONTH) > 10
ORDER BY (TO_DATE('01.01.2000', 'DD.MM.YYYY') - HIRE_DATE) DESC, SURNAME;

