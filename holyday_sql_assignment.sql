create database holyday_sql_assignment
use holyday_sql_assignment
--Customer-----------Cust_id,cust_name,ph_no,age,gender
create table customer(cust_id smallint primary key,cust_name varchar(50),ph_no bigint,age smallint,gender char)


--Rating-------------Rating_id,rating_detail(1-very good,2-good,3-average,4-poor)
create table rating(rating_id smallint primary key,rating_detail varchar(50))

--Hotel--------------Hotel_id,Hotel_name,city,pin_code,rating_id
create table hotel(hotel_id smallint primary key,hotel_name varchar(50),city varchar(50),pin_code bigint,rating_id smallint,
                    constraint fk_hotel_rating foreign key (rating_id) references rating(rating_id))
--Booking_app--------App_id,app_name
create table booking_app(app_id smallint primary key,appp_name varchar(50))
--Booking_details----Booking_id, cust_id, App_id, Hotel_id, Booking_id,Check_in_date, Check_out_date,
---------------------charges, No_of_People, Ispaid

create table booking_details
(booking_id smallint primary key,
cust_id smallint,
constraint fk_booking_details_customer foreign key(cust_id)references customer(cust_id),
app_id smallint,
constraint fk_booking_details_booking_app foreign key(app_id)references booking_app(app_id),
hotel_id smallint,
constraint fk_booking_details_hotel foreign key(hotel_id)references hotel(hotel_id),
constraint fk_booking_details foreign key(booking_id)references booking_details(booking_id),
Check_in_date date,
Check_out_date date,
charges bigint,
no_of_people int,
ispaid varchar(50)
)
----------------------------------------------------------------------
--1.	Show customer name who booked hotel maximum no of times as cnt for all online hotel booking app arrange the cnt desc.--
SELECT cust_name from customer c inner join booking_details b on c.cust_id=b.cust_id  group by cust_name order by count(*)desc 
--2.	WAQ to get the all booking details for December 2018--
select * from booking_details where Check_in_date between '2018-12-01' and '2018-12-31'
--3.	WAQ to get the top 3 ranging hotel in the may 2018--
select hotel_name from hotel h inner join booking_details b on h.hotel_id=b.hotel_id 
having Check_in_date between '2018-5-1' and '2018-5-31' and max(3)=rating_id
--4.	WAQ to get the customer_id who has done maximum no of booking
--select max()from customer c inner join booking_details b on c.cust_id=b.cust_id
select cust_id from customer c inner join booking_details b on c.cust_id=b.cust_id group by cust_id order by count(*)desc
--5.	WAQ to get top three hotel who have rating as very good
select top 3 * from hotel h,rating r where h.rating_id=r.rating_id and rating_detail='very good'

--6.	WAQ to get the customer name who have longest stayed in hotel olive--remaining
select cust_name from customer where cust_id in(select cust_id from booking_details where hotel_id in
(select hotel_id from hotel where hotel_name='olive'))
--7.	WAQ to get the hotel name from a city name start with p and whose rating is ‘very good’ and arrange hotel names in asc--
select hotel_name from hotel,rating where city like 'p%' and rating_detail='very good' order by hotel_name asc
--8.	Create index for faster retrieval of data on charges.--
create index chargeindex on booking_details(charges)
--9.	WAQ to update remark as very good to that hotel who had maximum booking 
--update rating set rating_detail='very good' from rating r inner join hotel h on r.rating_id=h.rating_id and cust_name order by count(*)desc 
--inner join booking_details b on h.hotel_id=b.hotel_id and 
--10.	Delete the booking id of customer who have paid the bill and he already checked out --
delete from booking_details  where booking_id in(select booking_id from booking_details where ispaid='paid')
select * from booking_details;
--11.	WAQ to get the total family members of ‘Mr amol’ who visited hotel ‘orchid’ in the month of june
select no_of_people from booking_details b,hotel h,customer c where h.hotel_id=b.hotel_id and cust_name='mr amol' and hotel_name='orchid' and month(Check_in_date)=6





