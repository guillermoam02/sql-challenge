--Data Engineering
	--1) Use the information you have to create a table schema for each of the 
		--six CSV files. Remember to specify data types, primary keys, foreign keys, 
		--and other constraints.
	--2) Import each CSV file into the corresponding SQL table.
	-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "gender" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

CREATE TABLE "titles" (
    "emp_no" INT   NOT NULL,
    "title" VARCHAR   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" VARCHAR   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

COPY departments
from '/Library/PostgreSQL/12/CSVs/HW/departments.csv'
with (format csv, header);

COPY employees
from '/Library/PostgreSQL/12/CSVs/HW/employees.csv'
with (format csv, header);

COPY dept_manager
from '/Library/PostgreSQL/12/CSVs/HW/dept_manager.csv'
with (format csv, header);

COPY salaries
from '/Library/PostgreSQL/12/CSVs/HW/salaries.csv'
with (format csv, header);

COPY titles
from '/Library/PostgreSQL/12/CSVs/HW/titles.csv'
with (format csv, header);

COPY dept_emp
from '/Library/PostgreSQL/12/CSVs/HW/dept_emp.csv'
with (format csv, header);

--Data Analysis: Once you have a complete database, do the following:
-- 1) List the following details of each employee: employee number, last name, first name, gender, and salary.
Select employees.emp_no, employees.last_name, employees.first_name, employees.gender, salaries.salary
From employees
Join salaries
On employees.emp_no = salaries.emp_no;

--2) List employees who were hired in 1986.
Select first_name, last_name, hire_date
From employees
Where hire_date between '1986-01-01' AND '1987-01-01';

--3) List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
Select departments.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name, dept_manager.from_date, dept_manager.to_date
From departments
Join dept_manager
On departments.dept_no = dept_manager.dept_no
Join employees
On dept_manager.emp_no = employees.emp_no;

--4) List the department of each employee with the following information: employee number, last name, first name, and department name.
Select dept_emp.emp_no , employees.last_name , employees.first_name , departments.dept_name
From dept_emp
Join employees
On dept_emp.emp_no = employees.emp_no
Join departments
On dept_emp.dept_no = departments.dept_no;

--5) List all employees whose first name is "Hercules" and last names begin with "B."
Select first_name, last_name
From employees
Where first_name='Hercules'
And last_name LIKE 'B%';

--6) List all employees in the Sales department, including their employee number, last name, first name, and department name.
Select dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
From dept_emp
Join employees
On dept_emp.emp_no = employees.emp_no
Join departments
On dept_emp.dept_no = departments.dept_no
Where departments.dept_name= 'Sales';

--7) List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
Select dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
From dept_emp
Join employees
On dept_emp.emp_no = employees.emp_no
Join departments
On dept_emp.dept_no = departments.dept_no
Where departments.dept_name='Sales'
Or departments.dept_name='Development';

--8) In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
Select last_name,
count(last_name) as "LN Frequency"
From employees
Group by last_name
Order by
Count (last_name) desc;