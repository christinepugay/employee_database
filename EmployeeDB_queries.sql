-- Data Analysis using Filtering Commands

-- Using the database that we created, we are able to answer various business questions to create reports
-- Here we are asked to return all employees where salary us less than $40,000 who work in the Clothing or Pharmacy department in the company
SELECT * 
FROM employees
WHERE salary < 40000
AND (department = 'Clothing' OR department = 'Pharmacy')

-- Report the employees first name and emails whom salary is greater than $110,000, female, and works in the Tools department
SELECT first_name, email 
FROM  employees
WHERE salary > 110000 
AND gender = 'F' 
AND department = 'Tools'
		
-- Return all employees that makes more than $ 165,000 or employees who works in the Sports department and are males		
SELECT first_name, hire_date
FROM employees
WHERE salary > 165000 
OR (department = 'Sports' AND gender = 'M')

-- Can you give a report of the employees that we hired in years 2002 until 2004?
SELECT first_name, hire_date
FROM employees
WHERE hire_date BETWEEN '2002-01-01' AND '2004-01-01'

-- Return all unique employee's email domain and its count
SELECT SUBSTRING(email, POSITION('@' IN email)+1) AS email_domain, COUNT(*) AS "Number of Employees"
FROM employees
WHERE email IS NOT NULL
GROUP BY email_domain
ORDER BY "Number of Employees" desc

--Create a category that returns whether an employee is being under pay, pay well, or excutive pay
--along with the employee's first_name and salary
--Requirements
-- salary less than $100,000 are under paid
-- salary greater than $100,000 are well paid
--salary greater than $160,000 have executive pay

SELECT first_name, salary,
CASE 
	WHEN salary < 100000 THEN 'UNDER PAY'
	WHEN salary > 100000 AND salary < 160000 THEN 'PAY WELL'
	WHEN salary > 160000 THEN 'EXECUTIVE PAY'
	ELSE 'UNPAID'
END AS category
FROM employees
order by salary desc

--Return all departments that have more than 38 employees working
SELECT department 
FROM departments 
WHERE (SELECT COUNT(*) 
	   FROM employees e1 
   WHERE e1.department = departments.department) >38 
   
--Return the department, first name and the salary of the employees that makes the least and the most
--in each department. Then flag each record as 'Highest Salary' and 'Lowest Salary'

SELECT department, first_name, salary,
	CASE 
		WHEN salary = max_salary THEN 'HIGHEST PAID'
		WHEN salary = min_salary THEN 'LOWEST PAID'
		ELSE 'UNPAID'
	END AS salary_paid_text
FROM (SELECT department, first_name, salary,
	 (SELECT MAX(salary) FROM employees e2 WHERE e2.department = e1.department) as max_salary,
	 (SELECT MIN(salary) FROM employees e2 WHERE e2.department = e1.department) as min_salary
	FROM employees e1
GROUP BY department,first_name, salary) A
WHERE salary = max_salary OR salary= min_salary
ORDER BY 1

--Return the first name, department, hire date, and country of the first and last employees that were hired in the company
(SELECT first_name, department, hire_date, country
FROM employees e INNER JOIN regions r
ON e.region_id = r.region_id
WHERE hire_date = (SELECT MIN(hire_date) FROM employees e2)
LIMIT 1)
UNION ALL
SELECT first_name, department, hire_date, country
FROM employees e INNER JOIN regions r
ON e.region_id = r.region_id
WHERE hire_date = (SELECT MAX(hire_date) FROM employees e2)

-- Report the name, email, division, and country of the employees
SELECT first_name, email, division, country
FROM employees INNER JOIN departments -- first and second joined tables
ON employees.department = departments.department
INNER JOIN regions ON employees.region_id= regions.region_id -- third join, joined to the RESULTS of previous join

--Aggregated functions are a great way to perform statistical analysis on your data
-- Here we are returning the maximum, minimum, and average salaries of the employees 

--MAX()
SELECT MAX(salary)
FROM employees
		
--MIN()
SELECT MIN(salary)
FROM employees
		
--AVG()
SELECT ROUND(AVG(salary))
FROM employees

-- Report the sum of the salary by department 
SELECT department, SUM(salary)
FROM employees
GROUP BY department
		
