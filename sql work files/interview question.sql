use apple;
create table city(source varchar(20), destination varchar(20), distance int);
insert into city values('Mumbai','Bangalore',500),
						('Bangalore','Mumbai',500),
                        ('Delhi','Mathura',150),
                        ('Mathura','Delhi',150),
                        ('Nagpur','Pune',500),
                        ('Pune','Nagpur',500);
 
 with my_tab as(select *,
lag(destination) over() as c
 from city)
 select source,destination,distance
 from my_tab
 where source <> c or c is null;
 
 select 
	greatest(source,destination) as 'source',
    least(source,destination) as 'destination',
    max(distance) as distance
 from city
 group by greatest(source,destination),least(source,destination);
 
 CREATE TABLE matchs ( team varchar(20) ) ;
INSERT INTO matchs (team) VALUES ('India'), ('Pak'), ('Aus'), ('Eng');

with cte as
(
select * ,
row_number() over() as id
from matchs
)
select a.team as 'team A',b.team as 'team B' from cte a
join cte b
on a.team<>b.team
where a.id<b.id
order by a.team;

CREATE TABLE employee ( ID int, NAME varchar(10) ); 
INSERT INTO employee (ID, NAME) 
VALUES (1,'Emp1'), (2,'Emp2'), (3,'Emp3'), (4,'Emp4'), 
(5,'Emp5'), (6,'Emp6'), (7,'Emp7'), (8,'Emp8');

select 
	result,
    row_number() over() as 'groups'
from
(with cte as
(
select *,
concat(ID," ",NAME) as id_name,
lead(concat(ID," ",NAME)) over() as 'leads'
from employee
)
select *,
	concat(id_name,",",leads) as result
 from cte
where id not in (2,4,6,8)) t;

with cte as
(
select *,
concat(ID," ",NAME) as con,
ntile(4) over(order by id) as grup
 from employee
 )
 select 
    group_concat(con,'') as result,
    grup
 from cte
 group by grup;
 use apple;
 
 CREATE TABLE Products (
Order_date date,
Sales int );

INSERT INTO Products(Order_date,Sales)
VALUES
('2021-01-01',20), ('2021-01-02',32), ('2021-02-08',45), ('2021-02-04',31),
('2021-03-21',33), ('2021-03-06',19), ('2021-04-07',21), ('2021-04-22',10);

select 
	year(Order_date) as years ,
    monthname(Order_date) as month_name,
    sum(sales)
from Products
group by year(Order_date),monthname(Order_date)
order by sum(sales) desc;

 CREATE TABLE Applications (
candidate_id int,
skills varchar (15));

INSERT INTO Applications(candidate_id,skills)
VALUES
(101, 'Power BI'), (101, 'Python'), (101, 'SQL'), (102, 'Tableau'), (102, 'SQL'),
(108, 'Python'), (108, 'SQL'), (108, 'Power BI'), (104, 'Python'), (104, 'Excel');

with cte as
(
select 	
	candidate_id ,
    count(*) as 'skill count'
from Applications
group by candidate_id
)
select * from cte
where `skill count`=(select max(`skill count`) from cte);
select 	
	candidate_id,
    count(*) as 'skills counts'
from Applications
where skills in ("Python","SQL","Power BI")
group by candidate_id
having count(*)=3;
rename table employee to employee_1;

CREATE TABLE Employee (
EmpID int NOT NULL,
EmpName Varchar(20),
Gender varchar(20),
Salary int,
City varchar(20) );
INSERT INTO Employee
VALUES (1, 'Arjun', 'M', 75000, 'Pune'),
(2, 'Ekadanta', 'M', 125000, 'Bangalore'),
(3, 'Lalita', 'F', 150000 , 'Mathura'),
(4, 'Madhav', 'M', 250000 , 'Delhi'),
(5, 'Visakha', 'F', 120000 , 'Mathura');

CREATE TABLE EmployeeDetail (
EmpID int NOT NULL,
Project Varchar(20),
EmpPosition varchar(20),
DOJ date );
INSERT INTO EmployeeDetail
VALUES (1, 'P1', 'Executive', '2019-01-26'),
       (2, 'P2', 'Executive', '2020-05-04'),
       (3, 'P1', 'Lead', '2021-10-21'),
       (4, 'P3', 'Manager', '2019-11-29'),
       (5, 'P2', 'Manager', '2020-08-01');

select * from employee;
select * from employeeDetail;
--  Find the list of employees whose salary ranges between 2L to 3L
select *
from employee
where Salary between 200000 and 300000;

-- Write a query to retrieve the list of employees from the same city.
select
	a.EmpID,
	a.EmpName,
    a.City
from employee a
join(
select 
	city, 
	count(*)
from employee
group by city
having count(*)>1) b
on a.city=b.city;
-- 2nd solution
SELECT E1.EmpID, E1.EmpName, E1.City
FROM Employee E1, Employee E2
WHERE E1.City = E2.City AND E1.EmpID != E2.EmpID;

-- Query to find the null values in the Employee table.
select * from employee
where EmpID is null;

-- Query to find the cumulative sum of employee’s salary.
select EmpID,
	Salary,
	sum(Salary) over(ORDER BY EmpID) AS 'cumulative sum'
from employee;

-- What’s the male and female employees ratio.
select
    (sum(Gender='M'))*100/count(*) as MalePct,
    (sum(Gender='F')*100/count(*)) as FemalePct
from employee;

-- Write a query to fetch 50% records from the Employee table.
select * from employee
where EmpID<=(select count(EmpID)/2 from employee);

/* Query to fetch the employee’s salary but replace the LAST 2 digits with ‘XX’
i.e 12345 will be 123XX */
select salary,
	CONCAT(SUBSTRING(CAST(Salary AS CHAR), 1, LENGTH(Salary) - 2), 'XX') AS ModifiedSalary
from employee;
-- 2nd method
select 
	Salary,
	concat(left(salary,length(salary)-2),"XX") as 'Raplace Employee Salary'
from employee;

-- Write a query to fetch even and odd rows from Employee table.
-- fetch even rows
select * from employee
where mod(EmpID,2)=0;
-- fetch odd rows
select * from employee
where mod(EmpID,2)=1;
-- 2nd method
-- even rows
with cte as
(
select *,
row_number() over() AS NUMBER
from employee
)
select 
	EmpID,EmpName,Gender,Salary,City
from cte
where NUMBER % 2=0;
-- odd rows
with cte as
(
select *,
row_number() over() AS NUMBER
from employee
)
select 
	EmpID,EmpName,Gender,Salary,City
from cte
where NUMBER % 2=1;

--  Write a query to find all the Employee names whose name:
-- Begin with ‘A’
select * 
from employee
where EmpName like 'A%';

-- Contains ‘A’ alphabet at second place
select * 
from employee
where EmpName like '_A%';

-- Contains ‘Y’ alphabet at second last place
select * 
from employee
where EmpName like '%Y_';

-- Ends with ‘L’ and contains 4 alphabets
select * 
from employee
where EmpName like '___L';

-- Begins with ‘V’ and ends with ‘A’
select * 
from employee
where EmpName like 'V%A';

--  Write a query to find the list of Employee names which is:
-- starting with vowels (a, e, i, o, or u), without duplicates
select distinct EmpName from employee
where lower(SUBSTRING(EmpName, 1, 1)) IN ('a', 'e', 'i', 'o', 'u');
-- or
SELECT DISTINCT EmpName
FROM Employee
WHERE LOWER(EmpName) REGEXP '^[aeiou]';

-- ending with vowels (a, e, i, o, or u), without duplicates
select distinct EmpName
from Employee
where lower(EmpName) regexp '[aeiou]$';
-- or 
select distinct EmpName from employee
where lower(right(EmpName, 1)) IN ('a', 'e', 'i', 'o', 'u');

-- starting & ending with vowels (a, e, i, o, or u), without duplicates
select distinct EmpName 
from employee
where lower(left(EmpName,1)) in ('a', 'e', 'i', 'o', 'u')
and lower(right(EmpName,1)) in ('a', 'e', 'i', 'o', 'u');

/* Find Nth highest salary from employee table with and without using the
TOP/LIMIT keywords. */
select 
	EmpID,Salary
from employee e1
where 1-1=(select count(distinct Salary) 
			from employee e2
            where e2.salary>e1.salary);
-- or LIMIT keywords
select salary
from employee
order by salary desc 
limit 1
offset 0;

-- Write a query to find and remove duplicate records from a table.
select 
EmpID,EmpName,Gender,Salary,City,count(*)
 from employee
 group by EmpID,EmpName,Gender,Salary,City
 having count(*) >1;
 DELETE FROM Employee
WHERE EmpID IN 
(SELECT EmpID FROM Employee
GROUP BY EmpID
HAVING COUNT(*) > 1);

-- Query to retrieve the list of employees working in same project
with cte as
(
select 
	e.empid,
	e.EmpName,
	ed.Project	
 from employee e
 join employeedetail ed
 on ed.EmpID=e.EmpID
 )
 select c1.EmpName,c1.Project
 from cte c1,cte c2
 where c1.Project=c2.Project and c1.empid<>c2.empid;
 
 -- Show the employee with the highest salary for each project
with cte as
(select 
	e.empid, e.EmpName, ed.Project, e.salary,
    rank() over(partition by ed.Project order by e.salary desc) as 'rank'
 from employee e
 join employeedetail ed
 on ed.EmpID=e.EmpID
 )
 select empid,EmpName,Project,salary 
 from cte
 where `rank`=1;
 
 -- Query to find the total count of employees joined each year

 select 
	year(DOJ) as 'year',
	count(*) as 'join employee each year'
 from employeedetail ed
 group by year(DOJ);
 
 /* Create 3 groups based on salary col, salary less than 1L is low, between 1 -
2L is medium and above 2L is High */
select 
	Salary,
    case
		when salary<100000 then 'Low Salary'
        when salary between 100000 and 200000 then 'Medium Salary'
        else 'High Salary'
        end 'Salary Group Level'
        from employee;

/* Query to pivot the data in the Employee table and retrieve the total 
salary for each city. 
The result should display the EmpID, EmpName, and separate columns for each city 
(Mathura, Pune, Delhi), containing the corresponding total salary */
select
	EmpID,
    EmpName,
	sum(case when city='Mathura' then salary end) as 'Mathura',
	sum(case when city='Pune' then salary end) as 'Pune',
	sum(case when city='Delhi' then salary end) as 'Delhi'
from employee
group by EmpID,EmpName;