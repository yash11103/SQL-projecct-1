#query 1 - detect duplicate records

select cutomer_name, email, city, order_date, amount, count(*)
from orders_cleaned
group by cutomer_name, email, city, order_date, amount
having count(*)>1;

--2.  delete duplicate records

delete from orders_cleaned where order_id not in(

select order_id from (
    select min(order_id) as order_id
    from orders_cleaned
    GROUP BY cutomer_name, email, city, order_date, amount) as temp

);


--3 find null emails

select * 
from orders_cleaned 
where email is null;

--4. fill null emails as unknown@email.com
-- replacing null values

update orders_cleaned
set email = 'unknown@gmail.com'
where email is null;

--5 detect invalid emails

select * from orders_cleaned
where email not like '%@%.%';

--6 fix invalid emails

update orders_cleaned set email = 'rohit@gmail.com'
where order_id=10;

--7. fix extra spaces in customer name column

update orders_cleaned 
set cutomer_name = trim(cutomer_name);

--8 fixing the spelling mistakes in city

update orders_cleaned
set city = 'Mumbai'
where city = 'Mum bai' ;

--9 removing extra spaces in city
update orders_cleaned
set cutomer_name = trim(cutomer_name);

--10 fix date format(yyyy-dd-mm)

update orders_cleaned 
set order_date = STR_TO_DATE(order_date, '%Y-%d-%m')
where order_date REGEXP'^[0-9]{4}-' ;

--11 fix date format(mm-dd-yyyy)

update orders_cleaned
set order_date = STR_TO_DATE(order_date, '%m-%d-%Y')
where order_date REGEXP '^[0-9]{2}-[1-3][0-9]-[0-9]{4}';

-- 12 fix date format (dd-mm-yyyy)

update orders_cleaned
set order_date = STR_TO_DATE(order_date, '%d-%m-%Y')
where order_date REGEXP'^[0-9]{2}-[0-9]{2}-[0-9]{4}';

-- 13 find missing dates
select *
from orders_cleaned
where order_date is null;

-- 14  replace misiing date as 2024-01-01
update orders_cleaned
set order_date='2024-01-01'
where order_date is null;

--15 fixing negative amount 
update orders_cleaned
set amount = ABS(amount)
where amount <0;

--16 fix null value with 0

update orders_cleaned
set amount = 0
where amount is null;

DESCRIBE orders_cleaned;

-- change the datatype

alter table orders_cleaned
modify order_id int,
modify cutomer_name varchar(100),
modify email varchar(100),
modify city varchar(50),
modify order_date  DATE,
modify amount int;