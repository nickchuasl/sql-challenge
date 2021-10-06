--Create departments table
CREATE TABLE departments (
    dept_no VARCHAR   NOT NULL,
    dept_name VARCHAR   NOT NULL,
    CONSTRAINT pk_departments PRIMARY KEY (
        dept_no
     )
);

--Create employee department table
CREATE TABLE dept_emp (
    emp_no INT   NOT NULL,
    dept_no VARCHAR   NOT NULL,
    CONSTRAINT pk_dept_emp PRIMARY KEY (
        emp_no,dept_no
     )
);

--Create manager department table
CREATE TABLE dept_manager (
    dept_no VARCHAR   NOT NULL,
    emp_no INT   NOT NULL,
    CONSTRAINT pk_dept_manager PRIMARY KEY (
        dept_no,emp_no
     )
);

--Create employees data table
CREATE TABLE employees (
    emp_no INT   NOT NULL,
    emp_title_id VARCHAR   NOT NULL,
    birth_date DATE   NOT NULL,
    first_name VARCHAR   NOT NULL,
    last_name VARCHAR   NOT NULL,
    sex VARCHAR   NOT NULL,
    hire_date DATE   NOT NULL,
    CONSTRAINT pk_employees PRIMARY KEY (
        emp_no
     )
);
-- Alter the data type before importing CSV
ALTER TABLE employees
ALTER COLUMN birth_date TYPE VARCHAR,
ALTER COLUMN hire_date TYPE VARCHAR;


-- Set the date style to month, date and year
SET datestyle = mdy;

-- Alter the data type back to date
ALTER TABLE employees
ALTER COLUMN birth_date TYPE DATE USING birth_date::DATE,
ALTER COLUMN hire_date TYPE DATE USING hire_date::DATE;

--Create salaries table
CREATE TABLE salaries (
    emp_no INT   NOT NULL,
    salary INT   NOT NULL,
    CONSTRAINT pk_salaries PRIMARY KEY (
        emp_no
     )
);

--Create titles table
CREATE TABLE titles (
    title_id VARCHAR   NOT NULL,
    title VARCHAR   NOT NULL,
    CONSTRAINT pk_titles PRIMARY KEY (
        title_id
     )
);

-- Create foreign key
ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE employees ADD CONSTRAINT fk_employees_emp_title_id FOREIGN KEY(emp_title_id)
REFERENCES titles (title_id);

ALTER TABLE salaries ADD CONSTRAINT fk_salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);


--DATA ANALYSIS

-- Task 1: List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees e
INNER JOIN salaries s 
ON
e.emp_no = s.emp_no;

-- Task 2: List first name, last name, and hire date for employees who were hired in 1986.
--FIND OUT HOW TO DO
SELECT first_name, last_name, hire_date
FROM employees
WHERE date_part('year', hire_date) = 1986;

-- Task 3: List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
SELECT dept_manager.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM dept_manager
INNER JOIN employees
ON dept_manager.emp_no = employees.emp_no
INNER JOIN departments
ON dept_manager.dept_no = departments.dept_no;

-- Task 4: List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
LEFT JOIN dept_manager
ON employees.emp_no = dept_manager.emp_no
LEFT JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no
LEFT JOIN departments
ON dept_emp.dept_no = departments.dept_no
OR dept_manager.dept_no = departments.dept_no;


-- Task 5: List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT e.first_name, e.last_name, e.sex
FROM employees e
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%'

-- Task 6: List all employees in the Sales department, including their employee number, last name, first name, and department name.
CREATE VIEW employees_department AS
	SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
		FROM employees
		LEFT JOIN dept_manager
		ON employees.emp_no = dept_manager.emp_no
		LEFT JOIN dept_emp
		ON employees.emp_no = dept_emp.emp_no
		LEFT JOIN departments
		ON dept_emp.dept_no = departments.dept_no
		OR dept_manager.dept_no = departments.dept_no;

SELECT emp_no, last_name, first_name, dept_name
FROM employees_department
WHERE dept_name = 'Sales'

-- Task 7: List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
-- Please run Create View code from Task 6 before running this code

SELECT emp_no, last_name, first_name, dept_name
FROM employees_department
WHERE dept_name = 'Sales'
OR dept_name = 'Development'

-- Task 8: In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

SELECT last_name, count(last_name) AS "last_name_count"
FROM employees
GROUP BY last_name
ORDER BY "last_name_count" DESC;

-- BONUS
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary, t.title
FROM employees e
LEFT JOIN salaries s 
ON e.emp_no = s.emp_no
LEFT JOIN titles t
ON e.emp_title_id = t.title_id;




