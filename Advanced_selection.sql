SELECT SURNAME, EMP_ID, SUBSTR(SURNAME, 0, 2) || EMP_ID AS "login"
FROM EMPLOYEES 
ORDER BY SURNAME;
