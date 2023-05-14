--Creating the table named employees
CREATE TABLE employees (
				employee_id INT, 
				department VARCHAR(30),
				team VARCHAR(30),
				emp_location VARCHAR(20),
				hire_date DATE,
				termination_date DATE,
				termination_type VARCHAR(40)
				)
			
--Importing values and viewing employees table
SELECT *
FROM employees
ORDER BY hire_date ASC;

--Creating the table named leave
CREATE TABLE leave (
				employee_id INT,
				department VARCHAR(35),
				team VARCHAR(30),
				emp_location VARCHAR(15),
				leave_type VARCHAR(20),
				leave_month VARCHAR(15),
				length_of_days INT
				)
				
--Importing values and viewing leave table
SELECT *
FROM leave;

--Creating the table named application
CREATE TABLE Application (
				applicant_id INT,
				job_offered VARCHAR(3),
				hired VARCHAR(3),
				date_applied DATE,
				date_hired DATE,
				hire_source VARCHAR(20)
				)
				
--Importing values and viewing application table
SELECT *
FROM application;

/* Insights will be gotten from the three tables. 
From employee table, these three(3) insights will be derived: employeee headcount quartely for years, employee tenure and employee turnover.
From leave table, these three(3) insights will be derived: absence trend by department, leave type in percentage and count of leave by month
From application table, these three(3) insights will be derived: effective source of hire, average time of hire and offer acceptance rate*/

--Performing employee headcount 
--Checking wheather employees left the company at any point in time to ensure accurate headcount
SELECT COUNT(*)
FROM employees
WHERE termination_date IS NOT NULL;--Count of employees that left the count is 25.

--Count distinct employees
SELECT COUNT(DISTINCT employee_id)
FROM employees;

--Headcount by year
WITH year_column_added AS (
			SELECT *,
				   EXTRACT (YEAR FROM hire_date) AS hire_year,
				   EXTRACT (YEAR FROM termination_date) AS termination_year
			FROM employees)

SELECT hire_year, COUNT(employee_id) AS headcount
FROM year_column_added
GROUP BY hire_year
ORDER BY hire_year ASC;

--Skipping the above part, there has to be some thought process.


--For the second table.
--Absence trend by_department and team
WITH absence_trend AS (
	SELECT department,
	   team,
	   COUNT(employee_id) AS count_employees
	FROM leave
	GROUP BY department,team
	ORDER BY department ASC
	)
	
--Calculating the top 10 teams that  had the highest sum of employees who went on leave.
SELECT team,
	   SUM(count_employees) AS sum_employee
FROM absence_trend
GROUP BY team
ORDER BY sum_employee DESC
LIMIT 10;

--Percentage by leave type.
WITH count_leave AS (
	SELECT leave_type,
	   COUNT(*) AS count_leave_type
	FROM leave
	GROUP BY leave_type
	)
	   
SELECT leave_type, 
	   ROUND((count_leave_type/143.0)*100,1) AS perc_leave_type
FROM count_leave
GROUP BY 1,2
ORDER BY 2 DESC;

--Month with the highest leave
SElECT leave_month, 
	    COUNT(*) AS leave_count
FROM leave
GROUP BY leave_month
ORDER BY 2 DESC;


--For the third table
--Hire_source by percentage
WITH source_of_hire AS (
	SELECT *	
	FROM application
	WHERE date_hired IS NOT NULL
	)

SELECT hire_source,
	   COUNT(*) AS count_hire_source


