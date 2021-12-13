-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
	AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
	
	-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;
DROP TABLE retirement_info; 

-- ######## NEW COPYPASTE FOR QUERIES.SQL STARTS HERE 

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT  d.dept_name,
		dm.emp_no,
		dm.from_date,
		dm.to_date
FROM departments AS d
INNER JOIN dept_manager AS dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT  ri.emp_no,
    	ri.first_name,
		ri.last_name,
    	ed.to_date
FROM retirement_info AS ri
LEFT JOIN employee_dept AS ed
ON ri.emp_no = ed.emp_no
WHERE ed.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(e.emp_no), de.dept_no
INTO count_by_dept
FROM employees AS e
LEFT JOIN employee_dept AS de
ON e.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

-- Create employee info temp table
SELECT  e.emp_no, 
		e.first_name, 
		e.last_name, 
		e.gender,
		s.salary,
		de.to_date
--INTO emp_info
FROM employees AS e
INNER JOIN salaries AS s 
ON (e.emp_no = s.emp_no)
INNER JOIN employee_dept AS de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

SELECT * FROM emp_info;

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        e.last_name,
        e.first_name,
        dm.from_date,
        dm.to_date
-- INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN employees AS e
        ON (dm.emp_no = e.emp_no);

-- List of Retirees by Department
SELECT e.emp_no,
e.first_name,
e.last_name,
d.dept_name
-- INTO dept_info
FROM employees AS e
INNER JOIN employee_dept AS de
ON (e.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

-- List of Retirees in Sales and Development
SELECT e.emp_no,
e.first_name,
e.last_name,
d.dept_name
-- INTO dept_info
FROM employees AS e
INNER JOIN employee_dept AS de
ON (e.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales', 'Development');

SELECT * FROM employees
-- Start of Challenge Code ******** 

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

-- Checking on output for new table before export
SELECT * FROM retirement_titles;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) 
	emp_no, 
	first_name, 
	last_name,
	title
INTO titles_unique
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

-- Checking on output for new table before export
SELECT * FROM titles_unique;

-- Retrieve the number of employees by their most recent job title who are about to retire.
SELECT COUNT(tu.emp_no),
	tu.title
INTO retirement_count_recent_titles
FROM titles_unique as tu
GROUP BY title
ORDER BY COUNT(title) DESC;

-- Checking on output for new table before export
SELECT * FROM retirement_count_recent_titles;

-- Creating list for mentorship program 
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

-- Checking on output for new table before export

SELECT * FROM mentorship_list;

-- Number of employees retirement eligible
SELECT DISTINCT ON(e.emp_no) 
		e.emp_no, 
		e.first_name, 
 		e.last_name, 
		e.birth_date,
		ed.from_date,
		ed.to_date,
		jt.title
INTO total_retirees
FROM employees AS e
LEFT OUTER JOIN employee_dept AS ed
ON (e.emp_no = ed.emp_no)
LEFT OUTER JOIN job_title AS jt
ON (e.emp_no = jt.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

SELECT * FROM total_retirees;

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
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1968-12-31')
ORDER BY e.emp_no;

SELECT * FROM mentorship_list_expanded;