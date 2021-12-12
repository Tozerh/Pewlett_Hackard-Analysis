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