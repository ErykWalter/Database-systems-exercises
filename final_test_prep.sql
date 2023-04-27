drop synonym STUDY_FORMS;
drop synonym FIELDS_OF_STUDIES;
drop synonym CITIES;
drop synonym GRADES;
drop synonym COURSES;
drop synonym STUDY_TYPES;
drop synonym BENEFIT_TYPES;
drop synonym CLASS_TYPES;
drop synonym PASSING_TYPES;
drop synonym ACADEMIC_SEMESTERS;
drop synonym STUDENTS;
drop synonym BENEFITS;

create synonym STUDY_FORMS for sphd_dane.STUDY_FORMS;
create synonym FIELDS_OF_STUDIES for sphd_dane.FIELDS_OF_STUDIES;
create synonym CITIES for sphd_dane.CITIES;
create synonym GRADES for sphd_dane.GRADES;
create synonym COURSES for sphd_dane.COURSES;
create synonym STUDY_TYPES for sphd_dane.STUDY_TYPES;
create synonym BENEFIT_TYPES for sphd_dane.BENEFIT_TYPES;
create synonym CLASS_TYPES for sphd_dane.CLASS_TYPES;
create synonym PASSING_TYPES for sphd_dane.PASSING_TYPES;
create synonym ACADEMIC_SEMESTERS for sphd_dane.ACADEMIC_SEMESTERS;
create synonym STUDENTS for sphd_dane.STUDENTS;
create synonym BENEFITS for sphd_dane.BENEFITS;

--1
SELECT COUNT(*) AS num_of_students
FROM STUDENTS;

--2
SELECT f.NAME, f.SYMBOL 
FROM FIELDS_OF_STUDIES f
ORDER BY f.NAME;

--3
SELECT f.NAME, f.SYMBOL, COUNT(*) AS num_of_students
FROM FIELDS_OF_STUDIES f
JOIN STUDENTS s ON s.FIELD_OF_STUDY = f.SYMBOL 
GROUP BY f.NAME, f.SYMBOL
ORDER BY f.NAME;

--4
SELECT f.NAME, f.SYMBOL, COUNT(*) AS num_of_students
FROM FIELDS_OF_STUDIES f
JOIN STUDENTS s ON s.FIELD_OF_STUDY = f.SYMBOL 
GROUP BY f.NAME, f.SYMBOL
ORDER BY COUNT(*) DESC
FETCH FIRST 3 ROWS ONLY;

--5a
SELECT 
	CASE 
		WHEN (f.STUDY_TYPE = 'FTG') THEN 'full-time graduate'
		WHEN f.STUDY_TYPE = 'FTU' THEN 'full-time undergraduate'
		WHEN f.STUDY_TYPE = 'PTG' THEN 'part-time graduate'
		WHEN f.STUDY_TYPE = 'PTU' THEN 'part-time undergraduate'
	END AS "type",
	f.STUDY_TYPE AS SYMBOL, COUNT(*) AS num_of_students
FROM FIELDS_OF_STUDIES f
JOIN STUDENTS s ON s.FIELD_OF_STUDY = f.SYMBOL 
GROUP BY f.STUDY_TYPE
ORDER BY f.Study_type;

--5b
WITH 
	types(study_type, sym, symbol) AS 
	(SELECT UNIQUE 
		CASE 
			WHEN (f.STUDY_TYPE LIKE 'FT_') THEN 'full-time'
			WHEN f.STUDY_TYPE LIKE 'PT_' THEN 'part-time'
		END AS study_type,
		CASE 
			WHEN (f.STUDY_TYPE LIKE 'FT_') THEN 'FT'
			WHEN f.STUDY_TYPE LIKE 'PT_' THEN 'PT'
		END AS sym,
		f.SYMBOL AS symbol
	FROM FIELDS_OF_STUDIES f)

SELECT t.study_type, t.sym, COUNT(*)  AS num_of_students 
FROM types t
JOIN students s ON s.FIELD_OF_STUDY = t.symbol
GROUP BY t.study_type, t.sym;

SELECT 
	CASE 
		WHEN (f.STUDY_TYPE LIKE 'FT_') THEN 'full-time'
		WHEN f.STUDY_TYPE LIKE 'PT_' THEN 'part-time'
	END AS name,
	CASE 
		WHEN (f.STUDY_TYPE LIKE 'FT_') THEN 'FT'
		WHEN f.STUDY_TYPE LIKE 'PT_' THEN 'PT'
	END AS symbol,
	'form' AS descr,
	count(*) AS num_of_students
FROM fields_of_studies f
JOIN students s ON s.FIELD_OF_STUDY = f.SYMBOL 
GROUP BY 
	CASE 
		WHEN (f.STUDY_TYPE LIKE 'FT_') THEN 'full-time'
		WHEN f.STUDY_TYPE LIKE 'PT_' THEN 'part-time'
	END,
	CASE 
		WHEN (f.STUDY_TYPE LIKE 'FT_') THEN 'FT'
		WHEN f.STUDY_TYPE LIKE 'PT_' THEN 'PT'
	END
;
	
	
	

--6
WITH 
	forms(name, symbol, descr, num) AS 
	(SELECT 
		CASE 
			WHEN (f.STUDY_TYPE LIKE 'FT_') THEN 'full-time'
			WHEN f.STUDY_TYPE LIKE 'PT_' THEN 'part-time'
		END AS name,
		CASE 
			WHEN (f.STUDY_TYPE LIKE 'FT_') THEN 'FT'
			WHEN f.STUDY_TYPE LIKE 'PT_' THEN 'PT'
		END AS symbol,
		'form' AS descr,
		count(*) AS num_of_students
	FROM fields_of_studies f
	JOIN students s ON s.FIELD_OF_STUDY = f.SYMBOL 
	GROUP BY 
		CASE 
			WHEN (f.STUDY_TYPE LIKE 'FT_') THEN 'full-time'
			WHEN f.STUDY_TYPE LIKE 'PT_' THEN 'part-time'
		END,
		CASE 
			WHEN (f.STUDY_TYPE LIKE 'FT_') THEN 'FT'
			WHEN f.STUDY_TYPE LIKE 'PT_' THEN 'PT'
		END),
	
	types(name, symbol, descr, num) AS 
	(SELECT 
		CASE 
			WHEN (f.STUDY_TYPE = 'FTG') THEN 'full-time graduate'
			WHEN f.STUDY_TYPE = 'FTU' THEN 'full-time undergraduate'
			WHEN f.STUDY_TYPE = 'PTG' THEN 'part-time graduate'
			WHEN f.STUDY_TYPE = 'PTU' THEN 'part-time undergraduate'
		END AS name,
		f.STUDY_TYPE AS SYMBOL, 'type' AS descr, COUNT(*) AS num_of_students
	FROM FIELDS_OF_STUDIES f
	JOIN STUDENTS s ON s.FIELD_OF_STUDY = f.SYMBOL 
	GROUP BY f.STUDY_TYPE
	ORDER BY f.Study_type),
	
	fields(name, symbol, descr, typeof, num) AS 
	(SELECT f.NAME, f.SYMBOL, 'field' AS descr, f.STUDY_TYPE AS typeof, COUNT(*) AS num_of_students
	FROM FIELDS_OF_STUDIES f
	JOIN STUDENTS s ON s.FIELD_OF_STUDY = f.SYMBOL 
	GROUP BY f.NAME, f.SYMBOL, f.STUDY_TYPE
	ORDER BY f.NAME),
	
	short_paths(name, paths, descr, symbol, num) AS 
	(SELECT 
		'-'||t.name AS name,
		f.symbol || '-' || t.symbol AS paths,
		t.descr,
		t.symbol,
		t.num
	FROM types t
	JOIN forms f ON f.symbol = SUBSTR(t.symbol, 0, 2)),
	
	full_paths(name, paths, descr, num) AS 
	(SELECT 
		f.name, 
		f.symbol, 
		f.descr, 
		f.num
	FROM forms f
	UNION
	SELECT s.name, s.paths, s.descr, s.num
	FROM short_paths s
	UNION
	SELECT '--'||f.name, s.paths||'-'||f.symbol, f.descr, f.num
	FROM fields f
	JOIN short_paths s ON s.symbol = f.typeof)
	
SELECT *
FROM full_paths fp
ORDER BY fp.paths;

--DEMOGRAPHY
--1
SELECT c.PROVINCE, COUNT(*) AS num
FROM students s
JOIN cities c ON c.CITY_ID = s.CITY_ID 
GROUP BY c.PROVINCE
ORDER BY c.PROVINCE;

--2
SELECT c.PROVINCE, COUNT(*) AS num
FROM students s
JOIN cities c ON c.CITY_ID = s.CITY_ID 
GROUP BY c.PROVINCE
ORDER BY COUNT(*) DESC 
FETCH FIRST 5 ROWS ONLY;

--3
SELECT c.PROVINCE, c.NAME, COUNT(*) AS num
FROM students s
JOIN cities c ON c.CITY_ID = s.CITY_ID 
WHERE c.PROVINCE IN 
	(SELECT c.PROVINCE
	FROM students s
	JOIN cities c ON c.CITY_ID = s.CITY_ID 
	GROUP BY c.PROVINCE
	ORDER BY COUNT(*) DESC 
	FETCH FIRST 5 ROWS ONLY)
GROUP BY c.PROVINCE, c.NAME 
ORDER BY c.PROVINCE;

--4
WITH 
	cities_counts(province, city, num) AS 
	(SELECT c.PROVINCE, c.NAME, COUNT(*) AS num
	FROM students s
	JOIN cities c ON c.CITY_ID = s.CITY_ID 
	WHERE c.PROVINCE IN 
		(SELECT c.PROVINCE
		FROM students s
		JOIN cities c ON c.CITY_ID = s.CITY_ID 
		GROUP BY c.PROVINCE
		ORDER BY COUNT(*) DESC 
		FETCH FIRST 5 ROWS ONLY)
	GROUP BY c.PROVINCE, c.NAME 
	ORDER BY c.PROVINCE),
	
	provinces_counts(province, num) AS 
	(SELECT c.PROVINCE, COUNT(*) AS num
	FROM students s
	JOIN cities c ON c.CITY_ID = s.CITY_ID 
	GROUP BY c.PROVINCE
	ORDER BY COUNT(*) DESC 
	FETCH FIRST 5 ROWS ONLY)
	
SELECT c.province, c.city, c.num AS students_in_city, p.num AS students_in_province, round(c.num / p.num * 100, 2) AS percent
FROM cities_counts c
JOIN provinces_counts p ON p.province = c.province
ORDER BY c.province, c.city;

--5
SELECT c.province, s.SEX, count(*) AS num_of_students
FROM students s
JOIN cities c ON c.CITY_ID  = s.city_id
GROUP BY c.PROVINCE, s.sex
ORDER BY c.PROVINCE, s.SEX;

--6
WITH 
	provinces AS 
	(SELECT UNIQUE province FROM cities),
	genders AS 
	(SELECT UNIQUE sex FROM students),
	prev AS 
	(SELECT c.province, s.SEX, count(*) AS num_of_students
	FROM students s
	JOIN cities c ON c.CITY_ID  = s.city_id
	GROUP BY c.PROVINCE, s.sex
	ORDER BY c.PROVINCE, s.SEX)


SELECT PROVINCE, sex, 0 AS number_of_students
FROM provinces CROSS JOIN genders
WHERE (province, sex) NOT IN (SELECT province, sex FROM prev);

--7
WITH
	females AS 
	(SELECT c.province, count(s.STUDENT_ID) AS num
	FROM cities c LEFT JOIN students s ON s.CITY_ID = c.CITY_ID
	WHERE s.Sex LIKE 'female' OR s.sex IS null GROUP BY c.PROVINCE),
	males AS 
	(SELECT c.province, count(s.STUDENT_ID) AS num
	FROM cities c LEFT JOIN students s ON s.CITY_ID = c.CITY_ID
	WHERE s.Sex LIKE 'male' OR s.SEX IS NULL GROUP BY c.PROVINCE),
	provinces AS 
	(SELECT UNIQUE province AS province FROM cities)
	
SELECT p.province, f.num, m.num, f.num + m.num
FROM provinces p
JOIN females f ON f.province = p.province
JOIN males m ON m.province = p.province
ORDER BY p.province;

--GRADES
--1
SELECT count(g.GRADE) AS grades
FROM grades g;

--2
SELECT g.ACADEMIC_YEAR , count(g.grade)
FROM grades g
GROUP BY g.ACADEMIC_YEAR;

--3a
SELECT g.ACADEMIC_YEAR , count(g.grade)
FROM grades g
GROUP BY g.ACADEMIC_YEAR
ORDER BY count(g.grade) DESC 
FETCH FIRST 1 ROW ONLY;

--3b
SELECT g.semester_type, count(g.grade)
FROM grades g
WHERE g.ACADEMIC_YEAR = '2006/07'
GROUP BY g.SEMESTER_TYPE;

--4
WITH
	grade_categories AS 
	(SELECT 
		CASE 
			WHEN g.grade >= 4.5 THEN 'GRADES excellent'
			WHEN g.GRADE IN (3.5, 4) THEN 'GRADES average'
			WHEN g.grade <= 3.0 THEN 'GRADES weak'
		END AS category
	FROM grades g WHERE g.ACADEMIC_YEAR = '2006/07' AND g.SEMESTER_TYPE = 'winter')
	
SELECT category, count(category)
FROM grade_categories
WHERE category IS NOT NULL 
GROUP BY category;

--5
SELECT g.STUDENT_ID, round(avg(g.grade), 2)
FROM grades g
WHERE g.grade IS NOT NULL
GROUP BY g.STUDENT_ID 
HAVING (SELECT count(grade) FROM grades WHERE g.STUDENT_ID = STUDENT_ID) >= 1
ORDER BY round(avg(g.grade), 2) DESC 
FETCH FIRST 10 ROWS ONLY
