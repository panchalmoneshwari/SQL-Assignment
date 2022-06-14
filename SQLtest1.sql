create database sql_test1;
use sql_test1;
--1.	Write a queries to create all tables with primary key ,foreign key
create table doctor
(
did int primary key,
dname varchar(100),
daddress varchar(100),
qualification varchar(100),
noofpatient_handle int
);
--9.	write a query to insert 5 records into the Doctor table
insert into doctor (did,dname,daddress,qualification,noofpatient_handle) 
                   values(101,'Dr.A.D.Patil','Pune','MBBS',10),
                          (102,'Dr.D.P.Sarma','Pune','BDS',17),
						  (103,'Dr.R.U.Pandit','Pune','MBBS',18),
						  (104,'Dr.P.H.Gramatil','Pune','MD',13),
						  (105,'Dr.v.D.Pavale','Pune','MBBS',10),
						  (106,'Dr.s.s.Pal','Pune','MD',12),
						  (107,'Dr.A.M.Pille','Pune','BDS',11);
--10.	write a query find the no. of doctors as per qualification
select count(*) from doctor where qualification='BDS';
--11.	find the doctors whose qualification is MD or MBBS
SELECT * from doctor where qualification='MBBS'OR qualification='MD';
--13.	Find the doctors whose address is Mumbai and no_of_patient_handle are 10
select * from doctor where daddress='pune'and noofpatient_handle=10;
--14.	Find the count of patient as per the blood group//////error
select pname,count(bloodgroup) from dbo.patient_master group by bloodgroup;   
--16.	find the doctors who has no_of_patient_handle are more than 10;
select dname from doctor where noofpatient_handle>10;
sp_help doctor;
select * from doctor;
create table patient_master
(
pcode int primary key,
pname varchar(100),
paddr varchar(100),
age int,
gender varchar(10),
bloodgroup varchar(10)
);
insert into patient_master (pcode,Pname,paddr,age,gender,bloodgroup) 
                   values(11,'A.D.Patil','Pune',20,'M','A+'),
                          (12,'D.P.Sarma','kolhapur',27,'F','AB+'),
						  (13,'R.U.Pandit','Satara',28,'M','B+'),
						  (14,'P.H.Gramatil','Pune',23,'F','A-'),
						  (15,'v.D.Pavale','Pune',20,'M','O+'),
						  (16,'s.s.Pal','Pune',22,'M','A+'),
						  (17,'A.M.Pille','Pune',24,'F','B+');
select * from patient_master;
--12.	find patients  whose age is between 21to 27    with blood group A+ 
SELECT * FROM patient_master WHERE age between 21 and 27 AND bloodgroup='A+';
--17.	find the number of patients who live in pune;
select * from patient_master where paddr='pune';
--18.	find the patients whose blood group is AB+ and gender is the female
select * from patient_master where bloodgroup='AB+' AND  gender='F'; 
create table admitted_patient
(
pcode int,
constraint fkpcode foreign key(pcode) references patient_master(pcode),
entry_date date,
discharge_date date,
ward_no int,
disease varchar(20),
did int,
constraint fkdid foreign key(did) references doctor(did),
);
insert into admitted_patient(pcode,entry_date,discharge_date,ward_no,disease,did)
values(11,'2016-12-2','2016-12-22',111,'dengue',102),
(13,'2016-6-2','2016-6-22',121,'Chikungunya',105),
(14,'2016-1-2','2016-1-20',131,'dengue',107),
(12,'2016-2-2','2016-2-22',141,'covid-19',102),
(15,'2016-1-9','2016-1-12',151,'dengue',103),
(17,'2016-2-9','2016-2-12',161,'Chikungunya',101),
(16,'2016-12-9','2016-12-22',171,'dengue',104);

select * from admitted_patient;
create table bill
(
pcode int,
constraint fkpcodebill foreign key(pcode) references patient_master(pcode),
bill_amount bigint
);
select * from bill;
insert into bill(pcode,bill_amount)values(12,12000),(13,32000),(15,23000),(14,4000),(16,6000);
--15.	find the maximum bill amount and find the minimum bill amount 
select max(bill_amount) as max_amont,min(bill_amount) as min_amount from bill;
--19.	delete the patient whose ward no is 4 or 6 and Disease is covid 19 
delete from admitted_patient where (ward_no=121 or ward_no=151) and disease='covid-19';
update admitted_patient set disease='covid-19'where ward_no=121;

--2.	Write a query to describe above tables;
sp_help doctor;
sp_help patient_master;
sp_help admitted_patient;
sp_help bill;
--3.	write a query to drop primary key from patientMaster
alter table dbo.admitted_patient drop constraint fkpcode;--error
alter table dbo.bill drop constraint fkpcodebill;
alter table patient_Master drop constraint "PK__patient___293812AA802A7D52";
--4.	Suppose Discharge _date is not present into AdmittedPatient write query to add Discharge_date column into the AdmittedPatient
alter table AdmittedPatient add  Discharge_date date;
--5.	write a query to change the data type ward no int to varchar(10)
alter table admitted_patient alter column ward_no varchar(10);
--6.	write a query to drop one foreign key from AdmittedPatient
alter table dbo.admitted_patient drop constraint fkdid;
--7.	write a query to add foreign key such that if parent is delete or update child also delete or update 
alter table admitted_patient
add constraint fkpcode
foreign key (pcode)
references patient_master(pcode)
on delete cascade;
--8.	write a query to add primary key to patientMaster///////error
alter table patientMaster add constraint pkkpcode primary key(pcode);
--20.	remove all records from bill table
delete from bill;
--21.	find the details of doctor who are treating the patient of wardno3
select * from doctor where did=(select did from admitted_patient where ward_no=131);
--22.	find the patient who are suffered from dengue and having age less than 30and bloodgroup is'A'
select * from patient_master p inner join admitted_patient d on p.pcode=d.pcode and age<30 and bloodgroup='A+' and disease='dengue';
--23.	find the patient who recover from dengue and  bill amount is greater than 10000
select * from admitted_patient a inner join bill b on a.pcode=b.pcode and  disease='dengue' and bill_amount>10000;
--24.	find Patient whose doctors qualification is M.B.B.S 
select * from patient_master p INNER JOIN admitted_patient a on p.pcode=a.pcode inner join doctor d on a.did=d.did and d.qualification='MBBS';