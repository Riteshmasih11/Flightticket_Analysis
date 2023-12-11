# Identify the customer(s) who have paid the highest flightcharge for the travel class economy. 
# Write a SQL query to display id and name of the identified customers

use infosys;
show tables;
select * from booking;
select * from customer;
select * from flight;
select c.custid,custname,flightcharge from customer c join booking b using(custid) where travelclass="economy" order by flightcharge desc;
select c.custid,custname,flightcharge from customer c join booking b using(custid) where travelclass="business" order by flightcharge desc;
# subquery 
select custid,custname from (select *from customer c join booking b using(custid) ) a 
where travelclass="economy" 
order by flightcharge desc;
# ctes
with ctes as
( select *from customer c join booking b using(custid))
select custid,custname from ctes  where travelclass="economy" order by flightcharge desc;

# Identify the international flight(s) which are booked the maximum 
# number of times. Write a SQL query to display id and name of the identified flights

select f.flightid,flightname,count(f.flightid) from booking b join flight f using(flightid) where flighttype="international" 
group by f.flightid order by count(f.flightid) desc;
select f.flightid,flightname,count(f.flightid) from booking b join flight f using(flightid) where flighttype="domestic" 
group by f.flightid order by count(f.flightid) desc;
# subquery
select flightid,flightname,count(flightid) from (select * from booking b join flight f using(flightid)) a where flighttype="international" 
group by flightid order by count(flightid) desc;
#ctes
with ctes as
(select * from booking b join flight f using(flightid))
select flightid,flightname from ctes where flighttype="international" 
group by flightid order by count(flightid) desc;

# Identify the customer(s) who have paid overall total flightcharge less than the average flightcharge of all bookings belonging to travel class ‘Business’.
#  Write a SQL query to display id and name of the identified customers.

select c.custid,custname from customer c join booking b using(custid) group by c.custid having sum(flightcharge) < 
(select avg(flightcharge) from booking where travelclass="business");
# subquery
select custid,custname from (select * from customer c join booking b using(custid))a group by c.custid having sum(flightcharge)
 < 
(select avg(flightcharge) from booking where travelclass="business");
# ctes
with ctes as
(select * from customer c join booking b using(custid))
select custid,custname from ctes group by c.custid having sum(flightcharge) < 
(select avg(flightcharge) from booking where travelclass="business");

#Identify the booking(s) done for travel class ‘Business’ by the customers having 
#letter ‘e’ anywhere in their name, for the flights other than ‘Domestic’ flights.
# Write a SQL query to display booking id, flight’s id and customer’s id of the identified bookings.

select bookingid,f.flightid,c.custid from customer c join booking b using(custid) join flight f using(flightid) where custname like '%e%'
and travelclass="business" and flighttype="international";
# subquery
select bookingid,flightid,custid from (select * from  customer c join booking b using(custid)join flight f using(flightid))a  where custname like '%e%'
and travelclass="business" and flighttype="international";
# ctes
with ctes as
(select * from  customer c join booking b using(custid)join flight f using(flightid))
select bookingid,flightid,custid from ctes where custname like '%e%'
and travelclass="business" and flighttype="international";

#Identify the booking(s) which have flight charges paid is less than the average
# flight charge for all flight ticket bookings belonging to the same flight type.
# Write a SQL query to display booking id, source city, destination city and booking date of the identified bookings.

select bookingid,source,destination,bookingdate,flightcharge from customer c join booking b using(custid) join flight f using(flightid) having flightcharge <
(select avg(flightcharge) from booking b join flight f using(flightid) where flighttype="domestic")
union
select bookingid,source,destination,bookingdate,flightcharge from customer c join booking b using(custid) join flight f using(flightid) having flightcharge <
(select avg(flightcharge) from booking b join flight f using(flightid) where flighttype="international");

#subquery
select bookingid,source,destination,bookingdate,flightcharge from (select * from customer c join booking b using(custid) join flight f using(flightid) )a
having flightcharge <
(select avg(flightcharge) from booking b join flight f using(flightid) where flighttype="domestic")
union
select bookingid,source,destination,bookingdate,flightcharge from (select * from customer c join booking b using(custid) join flight f using(flightid) )a
having flightcharge <
(select avg(flightcharge) from booking b join flight f using(flightid) where flighttype="international");
# ctes
with ctes as
(select * from customer c join booking b using(custid) join flight f using(flightid))
select bookingid,source,destination,bookingdate,flightcharge from ctes having flightcharge <
(select avg(flightcharge) from booking b join flight f using(flightid) where flighttype="domestic")
union
select bookingid,source,destination,bookingdate,flightcharge from ctes having flightcharge <
(select avg(flightcharge) from booking b join flight f using(flightid) where flighttype="international");

# Find customers who spent more money 
select custname,sum(flightcharge) from customer c join booking b using(custid) group by custname order by sum(flightcharge) desc;





