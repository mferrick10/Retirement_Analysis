-- Query of all eligible retiring employees
Select ce.emp_no,
	ce.first_name,
	ce.last_name,
	tt.title,
	sa.from_date,
	sa.salary
	into number_employees_retiring
	from current_emp as ce
inner join titles as tt
on tt.emp_no = ce.emp_no
inner join salaries as sa
on sa.emp_no = ce.emp_no;

-- Removes duplicates and leaves employee with their most recent title
select emp_no,
	first_name,
	last_name,
	title,
	from_date,
	salary
	into employees_retiring_no_dups
	from
	(Select ce.emp_no,
	ce.first_name,
	ce.last_name,
	tt.title,
	sa.from_date,
	sa.salary, row_number() over
	(Partition by (ce.first_name, ce.last_name) order by sa.from_date desc) rn
from current_emp as ce
inner join titles as tt
on tt.emp_no = ce.emp_no
inner join salaries as sa
on sa.emp_no = ce.emp_no) tmp where rn = 1 order by from_date desc;

-- count of number of employees by title in the company
select count(emp_no), title into count_employees_title from titles_retiring_no_dups group by title;



--List of employees eligible for mentorship (with dups)
select e.emp_no,
	e.first_name,
	e.last_name,
	tt.title,
	tt.from_date,
	tt.to_date
	into
	from employees as e
	inner join titles as tt
	on tt.emp_no = e.emp_no
	inner join salaries as ss
	on ss.emp_no = e.emp_no
	where birth_date between '1965-01-01' and '1965-12-31' order by emp_no;
	
-- List of employees eligible for mentorship (no dups)
select emp_no,
	first_name,
	last_name,
	title,
	from_date,
	to_date
	from (select e.emp_no,
	e.first_name,
	e.last_name,
	tt.title,
	tt.from_date,
	tt.to_date,
		row_number() over
		(partition by(e.first_name, e.last_name) order by tt.from_date desc) rn
	from employees as e
	inner join titles as tt
	on tt.emp_no = e.emp_no
	inner join salaries as ss
	on ss.emp_no = e.emp_no
	where birth_date between '1965-01-01' and '1965-12-31') tmp where rn= 1 order by emp_no;