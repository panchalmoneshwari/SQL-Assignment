create database sql_test2;
use sql_test2;
---------Employee------------
--Emp_Id, name, age, requestsCompleted , emp_rating ( 1 is topmost rating)
--1.	Write a query to create Employee table.
create table EMPLOYEE
(
emp_id int primary key,
emp_name varchar(100),
emp_age int,
requests_completed varchar(10),
emp_rating int
);
----------Service_Status-------
--Status_Id, desc - values of id and desc are (1-OPEN, 2- IN_PROGRESS, 3-CLOSED,4-Cancelled)--
create table Service_Status(status_id int primary key,desc_id int,service_desc varchar(20));

------Service_Request--------
--Service_Id, cust_id, service_desc, request_open_date,status_id, Emp_id, request_closed_date, charges--

create table service_request
(
service_id int,
cust_id int primary key,
service_desc varchar(20),
request_open_date date,
status_id int,
constraint fkstatusid foreign key (status_id) references Service_Status(status_id),
emp_id int,
constraint fkempid foreign key (emp_id) references EMPLOYEE(emp_id),
request_closed_date date,
charges bigint
);
exec sp_rename 'Service_Status.service_desc', 'status_desc'

----------------Customer----------
--Cust_Id, name, address_line1, address_line2, city, pin_code, totalRequests
create table customer (cust_id int,constraint fkcustid foreign key (cust_id) references service_request(cust_id),cust_name varchar(10),cust_addr varchar(10),cust_city varchar(10),pin_code varchar(10))
alter table customer alter column pin_code int;
--2.	Write a query to add column totalRequests (integer) to customer table (Assume it was not present earlier)
ALTER TABLE customer add totalrequests int;  
--3.	Write single query to create ReqCopy table which will have same structure and data of service_request table.
select * into service_table_new from service_request
select * from service_table_new
--4.	Show customer name, service description, charges	of requests served by employees older than age 30. (make use of sub query)
select cust_name,service_desc,charges from EMPLOYEE e,customer c,service_request r where e.emp_id=r.emp_id and emp_age>30;

--5.	Write a query to select customer names for whom employee ‘John’ has not served any request.(make use of sub query)
select cust_name from customer where cust_id=(select cust_id from service_request where status_id=
(select status_id from service_request where emp_id=
(select emp_id from EMPLOYEE where emp_name='john' and requests_completed='no')));
--6.	Show employee name, total charges of all the requests served by that employee. Consider only ‘closed’ requests.
select emp_name,charges from EMPLOYEE,service_request where service_desc='closed';
--7.	Show service description, customer name of request having third highest charges.
select service_desc,cust_name from service_request r1,customer c1 where 2
=(select count(distinct charges) from service_request r2,customer c2 where r2.charges>r1.charges)
--8.	Delete all requests served by ‘Sam’ as he has left the company.
delete from service_request where service_id=(select service_id from customer where cust_name='sam')
--9.	Delete all cancelled requests from request table.
delete from service_request where status_id=(select status_id from Service_Status where service_desc='cancelled' )
--10.	Update charges of request raised by customer ‘Sony’. Add 10% to the charges if charges are less than 100.
update service_request  set charges=(select charges *(select charges +charges*.1)) from customer  
where service_request.cust_id=customer.cust_id and charges<100 and cust_name='sony'
--11.	Update totalRequests of customer table. TotalRequests should be total requests given by that customer.
update dbo.customer  set totalrequests =(select count(*) from dbo.service_request s where s.cust_id=customer.cust_id)
--12.	Create a view which will show customer name, service desc , employee name, service charges , status desc of requests which are not closed.
create view rview as select c.cust_name,e.emp_name,sr.service_desc,sr.charges,ss.status_desc 
from dbo.service_request  as sr inner join dbo.EMPLOYEE as e on sr.emp_id=e.emp_id inner join dbo.customer as c 
on sr.cust_id=c.cust_id inner join dbo.Service_Status as ss on sr.status_id=ss.status_id where not service_desc='closed'


--13.	Create a view to which shows city, total charges collected in that city.
create view rrview as 
select c.cust_city,sum(c.totalrequests)'totalcharges' from dbo.customer as c group by cust_city,totalrequests
--14.	Give one example of left outer join using above database.
select * from EMPLOYEE e left outer join service_request r on e.emp_id=r.cust_id;

