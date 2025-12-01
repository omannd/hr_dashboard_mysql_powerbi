-- 	QUESTİONS

-- 1. What is the gender breakdown of employees in the company?
SELECT gender, count(*) as count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, count(*) as count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY race
ORDER BY count(*) DESC;

-- 3. What is the age distribution of employees in the company?
SELECT
	min(age) as youngest,
    max(age) as oldest
FROM hr
WHERE age >= 18 AND termdate IS NULL;

SELECT
	CASE
		WHEN age >= 18 AND age <= 24 THEN "18-24"
        WHEN age >= 25 AND age <= 34 THEN "25-34"
        WHEN age >= 35 AND age <= 44 THEN "35-44"
        WHEN age >= 45 AND age <= 54 THEN "45-54"
        WHEN age >= 55 AND age <= 64 THEN "55-64"
        ELSE "65+"
	END AS age_group,
    count(*) as count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY age_group
ORDER BY age_group;

SELECT
	CASE
		WHEN age >= 18 AND age <= 24 THEN "18-24"
        WHEN age >= 25 AND age <= 34 THEN "25-34"
        WHEN age >= 35 AND age <= 44 THEN "35-44"
        WHEN age >= 45 AND age <= 54 THEN "45-54"
        WHEN age >= 55 AND age <= 64 THEN "55-64"
        ELSE "65+"
	END AS age_group, gender,
    count(*) as count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. How many employees work at headquarters versus remote locations?
SELECT location, count(*) as count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY location;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT 
	round(avg(datediff(termdate, hire_date))/365,0) as avg_length_employment
FROM hr
WHERE termdate <= curdate() AND termdate IS NOT NULL AND age >= 18;

-- 6. How does the gender distribution vary across departments and job titles?
SELECT department, gender, count(*) as count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY department, gender
ORDER BY department;

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, count(*) as count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Which department has highest turnover rate?
SELECT department,
	total_count,
    terminated_count,
    terminated_count/total_count as termination_rate
FROM (
	SELECT department,
    count(*) as total_count,
    sum(CASE WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 ELSE 0 END) as terminated_count
    FROM hr
	WHERE age >= 18
    GROUP BY department
    ) as subquery
ORDER BY termination_rate DESC;

-- 9. What is the distribiton of employees across locations by city and state? 
SELECT location_state, count(*) as count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY location_state
ORDER BY count DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT 
	year,
    hires,
    terminations,
    hires - terminations as net_change,
	round((hires - terminations)/hires * 100, 2) net_change_percent
FROM (
	SELECT
		year(hire_date) as year,
        count(*) as hires,
        sum(CASE WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 ELSE 0 END) as terminations
        FROM hr 
        WHERE age >= 18
        GROUP BY year(hire_date)
        ) subquery
ORDER BY year ASC;
    
-- 11. What is the tenure distribution for each department?
SELECT department , round(avg(datediff(termdate, hire_date)/365), 0) as avg_tenure
FROM hr
WHERE age >= 18 AND termdate IS NOT NULL AND termdate <= curdate()
GROUP BY department;