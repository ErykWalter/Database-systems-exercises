SELECT *
FROM departments;
SELECT *
FROM employees;
SELECT surname, job, salary
FROM employees;
SELECT surname, job, salary * 12 AS "yearly_income"
FROM employees;
SELECT surname, job, salary + NVL(add_salary, 0) AS "monthly_income"
FROM employees;
SELECT name ||' '|| surname AS "assistants"
FROM employees
WHERE job = 'ASSISTANT'
ORDER BY name, surname;
SELECT name ||' '|| surname AS "employee", job, salary, dept_id
FROM employees
WHERE dept_id IN (30, 40)
ORDER BY salary DESC;
SELECT name ||' '|| surname AS "employee", job, salary
FROM employees
WHERE salary >= 1000 AND salary <= 2000
ORDER BY salary;
SELECT name, surname
FROM employees
WHERE surname LIKE '%son';
SELECT name, surname
FROM employees
WHERE dept_id IS NULL;
SELECT name, surname, boss_id, salary
FROM employees
WHERE boss_id IS NOT NULL AND salary >= 2000;
SELECT name, surname, dept_id
FROM employees
WHERE dept_id = 20 AND (surname LIKE 'W%' OR surname LIKE '%son');
SELECT name, surname, salary + NVL(add_salary, 0) AS "monthly_income"
FROM employees
WHERE salary + NVL(add_salary, 0) >= 4000;
SELECT 
    'Employee '|| name || ' ' || surname ||
    ' works as ' || LOWER(job) ||
    'and earns ' || salary AS "employees"
FROM employees;