SELECT * FROM hr;

ALTER TABLE hr
CHANGE COLUMN ï»¿id employee_id VARCHAR(20) NULL;

DESCRIBE hr;

SELECT birthdate FROM hr;

SET SQL_SAFE_UPDATES = 0;

UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE "%/%" THEN date_format(str_to_date(birthdate, "%m/%d/%Y"), "%Y-%m-%d")
    WHEN birthdate LIKE "%-%" THEN date_format(str_to_date(birthdate, "%m-%d-%Y"), "%Y-%m-%d")
    ELSE NULL
END;

ALTER TABLE hr
MODIFY birthdate DATE;

UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE "%/%" THEN date_format(str_to_date(hire_date, "%m/%d/%Y"), "%Y-%m-%d")
    WHEN hire_date LIKE "%-%" THEN date_format(str_to_date(hire_date, "%m-%d-%Y"), "%Y-%m-%d")
    ELSE NULL
END;

ALTER TABLE hr
MODIFY hire_date DATE;


UPDATE hr
SET termdate = NULL
WHERE termdate = "0000-00-00" OR termdate IS NULL;


UPDATE hr
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL;

ALTER TABLE hr
MODIFY termdate DATE;

ALTER TABLE hr ADD COLUMN age int; 

UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

SELECT
	min(age) as youngest,
    max(age) as oldest
FROM hr;

SELECT count(*) 
FROM hr
WHERE age < 18;