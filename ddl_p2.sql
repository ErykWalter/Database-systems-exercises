--1
-- there is only one constraint about the project_id which cannot be null

--2
ALTER TABLE projects ADD(
    CONSTRAINT pk_projects PRIMARY KEY(project_id),
    CONSTRAINT uk_projects_name UNIQUE(project_name),
    CONSTRAINT chk_projects_end_start_date CHECK(end_date > start_date),
    CONSTRAINT chk_projects_budget CHECK(project_budget > 0),
    CONSTRAINT chk_projects_no_of_emp CHECK(number_of_emp >= 0)
);

ALTER TABLE projects 
MODIFY (project_name NOT NULL, 
 		start_date NOT NULL);

--3
ALTER TABLE projects 
MODIFY number_of_emp NOT NULL;

-- in this column are already null values so they has to be updeted to zero

UPDATE projects 
SET number_of_emp=0 
WHERE number_of_emp IS NULL;

ALTER TABLE projects
MODIFY number_of_emp DEFAULT 0 NOT NULL;

--4
ALTER TABLE projects
ADD manager_id number(4) 
	CONSTRAINT projects_fk_emps 
	REFERENCES employees(emp_id);

--5
UPDATE PROJECTS 
SET manager_id = 3
WHERE PROJECT_NAME = 'Advanced Data Analysis'
-- foreign key works as expected

--6
UPDATE PROJECTS 
SET manager_id = (SELECT e.emp_id FROM EMPLOYEES e WHERE e.NAME='Mark' AND e.SURNAME='Clark')
WHERE PROJECT_NAME = 'Advanced Data Analysis';

DELETE FROM EMPLOYEES e 
WHERE e.NAME='Mark' AND e.SURNAME='Clark';
-- it is impossible because there is no on delete action defined

--7
CREATE TABLE Assignments (
    project_id integer NOT NULL REFERENCES projects(project_id),
    emp_id numeric(4) NOT NULL REFERENCES employees(emp_id),
    function character varying(100) NOT NULL CONSTRAINT chk_function CHECK(function in ('designer', 'programmer', 'tester')),
    start_date date DEFAULT current_date NOT NULL,
    end_date date,
    salary numeric(8,2) NOT NULL CONSTRAINT chk_salary CHECK(salary > 0),
    CONSTRAINT chk_end_start_date CHECK(end_date > start_date),
    CONSTRAINT pk_assignment PRIMARY KEY(project_id, emp_id, start_date)
);

--8
INSERT INTO assignments (project_id, emp_id, function, end_date, salary)
VALUES(1, 100, 'designer', to_date('23/05/13','yy/mm/dd'), 2100);

INSERT INTO assignments (project_id, emp_id, function, end_date, salary) 
VALUES(3, 120, 'programmer', to_date('24/06/03','yy/mm/dd'), 3599);

INSERT INTO assignments (project_id, emp_id, function, end_date, salary) 
VALUES(2, 190, 'designer', to_date('25/12/24','yy/mm/dd'), 320);

INSERT INTO assignments (project_id, emp_id, function, end_date, salary) 
VALUES(3, 110, 'tester', to_date('29/02/01','yy/mm/dd'), 420);

--9
INSERT INTO assignments (project_id, emp_id, function, end_date, salary) 
VALUES(2, 150, 'tedter', to_date('29/02/01','yy/mm/dd'), 420);
-- there is a typo in the function name

--10
ALTER TABLE assignments
DROP CONSTRAINT chk_function;

INSERT INTO assignments (project_id, emp_id, function, end_date, salary) 
VALUES(2, 150, 'tedter', to_date('29/02/01','yy/mm/dd'), 420);
-- tnow it works even with a typo

--VIEWS PART--
--1
CREATE OR REPLACE VIEW Professors (name, surname, hire_date, salary, add_salary, add_percent) AS
SELECT name, surname, hire_date, salary, add_salary, ROUND(nvl(add_salary,0)/salary,4)*100
FROM employees WHERE job='PROFESSOR';

select * from Professors;

--2
CREATE OR REPLACE VIEW Departments_totals (dept_id, department, avg_salary, num_of_empls) AS
SELECT d.dept_id, dept_name, COALESCE(round(avg(salary),2), 0), count(emp_id)
FROM departments d left join employees e ON d.dept_id=e.dept_id
GROUP BY d.dept_id, dept_name;

SELECT * FROM Departments_totals;

--3
SELECT e.SURNAME, e.NAME, e.SALARY, d.department, d.avg_salary, e.SALARY - d.avg_salary AS difference
FROM EMPLOYEES e 
JOIN Departments_totals d ON d.dept_id = e.DEPT_ID
WHERE e.SALARY > d.avg_salary 
ORDER BY e.SURNAME;

--4
SELECT d.department, d.num_of_empls
FROM Departments_totals d
ORDER BY d.num_of_empls DESC 
FETCH FIRST 1 ROW ONLY;

--5
CREATE OR REPLACE VIEW Emps_and_bosses (employee, emp_salary, boss, boss_salary) AS 
SELECT e.SURNAME||' '||e.NAME, e.SALARY, e2.SURNAME||' '||e2.NAME, e2.SALARY
FROM EMPLOYEES e 
JOIN EMPLOYEES e2 ON e.BOSS_ID = e2.EMP_ID
WHERE e.SALARY < e2.SALARY;

SELECT * FROM Emps_and_bosses e ORDER BY e.employee;
