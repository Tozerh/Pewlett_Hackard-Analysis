# Pewlett-Hackard Analysis
Module 7 Work

## Project Overvew
This project focused on creating and querying data tables related to Pewlett-Hackard's staffing and retention efforts around the "Silver Tsunami," a mass retiring of many employees in a short period of time. Using SQL queries to clean, sort, and join data, our goal was to provide P-H data sets to help inform their decision-making around how to approach replacing these employees through both strategic hiring and upskilling their current workforce through a mentorship program. 


## Resources
- Data Source: P-H provided us with several sets of internal employee data, including names, titles, salaries, departments, etc. 
- Software: PGAdmin, Postgres, SQL, Excel

## Results

-   For Deliverable One, we were tasked with trying to create a table for P-H that contained all of the retirment-eligible employees at the organization. The data provided by P-H came in several different data sets, and required that we create an entity relationship diagram (ERD) to map out our plan. 

-   In our ERD, we can see that the relationship between employees and titles rests on the employee number, our primary key:  
![EmpTitle](https://github.com/Tozerh/Pewlett_Hackard-Analysis/blob/main/Schema%20EmpTitles.PNG)

In order to actually create this connection between our datasets. Using postgres and PGAdmin, we were able to create SQL tables and queries that joined these two datatables together: 
```SQL
-- Join Emp and Title tables to Retirement Titles table
SELECT em.emp_no,
       em.first_name,
       em.last_name,
       jt.title,
       jt.from_date,
       jt.to_date
INTO retirement_titles
FROM employees AS em
INNER JOIN job_title AS jt
ON (em.emp_no = jt.emp_no)
WHERE (em.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY em.emp_no;
```

-   Once we joined these table together into our new "retirement_titles" table, we still needed to be sure that employees would only be appearing once on our list. Since employees could have occupied multiple positions within P-H during their tenure, we needed to be sure we coded tables and queries with SQL to account for this: 
```SQL
-- Remove duplicate rows using DISTINCT ONf and ORDER BY
SELECT DISTINCT ON (emp_no) 
	emp_no, 
	first_name, 
	last_name,
	title
INTO titles_unique
FROM retirement_titles
ORDER BY emp_no, to_date DESC;
```
- This table, "titles_unique," contains each retirement-age employee once, along with their title, and is used to build a count of the titles that P-H will be losing. In total, there are 90,398 positions that need to be filled when retirement-eligible employees born between January 1, 1952 and December 31, 1955 decide to vacate their positions.  

-  For Deliverable Two, we were tasked with creating a list of employees who might be eligible for a mentorship program that would help train younger employees and prepare them for the jobs that the retirees would be vacating. The result of this code: 
```SQL
SELECT DISTINCT ON(e.emp_no) 
		e.emp_no, 
		e.first_name, 
 		e.last_name, 
		e.birth_date,
		ed.from_date,
		ed.to_date,
		jt.title
INTO mentorship_list
FROM employees AS e
LEFT OUTER JOIN employee_dept AS ed
ON (e.emp_no = ed.emp_no)
LEFT OUTER JOIN job_title AS jt
ON (e.emp_no = jt.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;
```
is that 1,940 employees are mentorship eligible. 

## Summary

How many roles will need to be filled as the "silver tsunami" begins to make an impact?
90,398 roles will need to be filled as the "silver tsunami" begins to make an impact. 

Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?
Yes, there are more than enough retirement-ready employees to mentor the next generation of P-H employees. 

In order to supply more useful data around the "silver tsunami," I would suggest two pieces of code: 
1) A query statment that outputs the number of mentorship eligible P-H employees by department. This will give P-H a better comparison point when looking at how to deploy mentors across departments. The code would be a modification of the Deliverable 1 code, as follows: 
```SQL

-- Mentorship unique by title count code
-- Join Emp and Title tables to Retirement Titles table
SELECT em.emp_no,
       em.first_name,
       em.last_name,
       jt.title,
       jt.from_date,
       jt.to_date
INTO mentorship_titles
FROM employees AS em
INNER JOIN job_title AS jt
ON (em.emp_no = jt.emp_no)
WHERE (em.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY em.emp_no;

-- Checking on output for new table before export
SELECT * FROM mentorship_titles;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) 
	emp_no, 
	first_name, 
	last_name,
	title
INTO mentorship_unique
FROM mentorship_titles
ORDER BY emp_no, to_date DESC;

-- Checking on output for new table before export
SELECT * FROM mentorship_unique;

-- Retrieve the number of employees by their most recent job title who are about to retire.
SELECT COUNT(mu.emp_no),
	mu.title
INTO mentorship_count_recent_titles
FROM mentorship_unique as mu
GROUP BY title
ORDER BY COUNT(title) DESC;

-- Checking on output for new table before export
SELECT * FROM mentorship_count_recent_titles;

```

2) Given the large number of potential retirees, I believe that P-H should expand mentorship eligibility beyond just those employees born in 1965, which can be done by expanding on the code both from the snippet above and Deliverable 2. The goal would be to expand the pool of mentees to more closely match the pool of mentors, which spans four total years. The code for such an expansion would be as follows: 
```SQL
-- Expanding Mentorship Program eligibility dates. 
SELECT DISTINCT ON(e.emp_no) 
		e.emp_no, 
		e.first_name, 
 		e.last_name, 
		e.birth_date,
		ed.from_date,
		ed.to_date,
		jt.title
INTO mentorship_list_expanded
FROM employees AS e
LEFT OUTER JOIN employee_dept AS ed
ON (e.emp_no = ed.emp_no)
LEFT OUTER JOIN job_title AS jt
ON (e.emp_no = jt.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1988-12-31')
ORDER BY e.emp_no;

SELECT * FROM mentorship_list_expanded;
```
