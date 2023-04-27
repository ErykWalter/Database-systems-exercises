--1
CREATE TABLE Projects (
    project_id integer GENERATED ALWAYS AS IDENTITY,
    project_name character varying(200),
    description character varying(1000),
    start_date date DEFAULT current_date,
    end_date date,
    budget numeric(10,2)
);

--2
INSERT INTO Projects (project_name, description, start_date, budget)
	VALUES('New Technologies Survey','A project aimed at reviewing the area of advanced database technologies.', 
	to_date('18/01/01', 'yy/mm/dd'), 1500000);

INSERT INTO Projects (project_name, description, start_date, end_date, budget) 
	VALUES('Advanced Data Analysis', 'Analyzing data obtained from various organizations.', 
	to_date('17/09/20', 'yy/mm/dd'), to_date('18/10/01', 'yy/mm/dd'), 2750000);

select * from projects;

--3
INSERT INTO Projects (project_id, project_name, description, start_date, end_date, budget) 
	VALUES(55, 'Creating backbone network',
	'Expanding the organization'||chr(39)||'s network infrastructure.', 
	to_date('19/06/01', 'yy/mm/dd'), to_date('20/05/31', 'yy/mm/dd'), 5000000);
-- it is impossible to set fields which are generated automaticly, that's why error occured

--4
INSERT INTO Projects (project_name, description, start_date, end_date, budget) 
	VALUES('Creating backbone network',
	'Expanding the organization'||chr(39)||'s network infrastructure.', 
	to_date('19/06/01', 'yy/mm/dd'), to_date('20/05/31', 'yy/mm/dd'), 5000000);
	
SELECT p.project_id, p.project_name
FROM Projects p

--5
UPDATE projects 
SET project_id=100 WHERE project_name='Creating backbone network';
-- the automaticly generated columns cannot be updated because it threatens the itegrity of the data

--6
CREATE TABLE Projects_Copy AS
SELECT * FROM projects;

SELECT *
FROM projects_copy;

--7
INSERT INTO projects_copy 
VALUES(100, 'Creating mobile network', 'Expanding the organization'||chr(39)||'s infrastructure - part 2.', 
to_date('20/06/01', 'yy/mm/dd'), to_date('21/05/31', 'yy/mm/dd'), 4000000);
select * from projects_copy;
--it is possible to add this row because during creation of a table it was not specified that the project_id should be "GENERATED ALWAYS AS IDENTITY"

--8
DELETE FROM PROJECTS_COPY 
WHERE project_name = 'Creating backbone network';

SELECT *
FROM PROJECTS
WHERE project_name = 'Creating backbone network';

--9
ALTER TABLE projects 
ADD number_of_emp numeric(3)
MODIFY description character varying(1500);

--10
SELECT max(length(project_name)) from projects;
ALTER TABLE projects 
MODIFY project_name character varying(22);
-- it cannot be done because it would be hard to predict what will happen to the data in the table if such operation would possible. This is probably
-- why it is forbidden

--11
ALTER TABLE PROJECTS
RENAME COLUMN budget TO project_budget;

--12
DROP TABLE PROJECTS_COPY;


