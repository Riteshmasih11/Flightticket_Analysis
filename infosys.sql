use infosys;
select * from booking;
select * from customer;
select * from flight;
/* Identify the customer(s) who have paid the highest flightcharge for the 
travel class economy. Write a SQL query to display id and name of the identified customers.*/

select c.custid,custname from customer c join booking b on c.custid=b.custid where
 travelclass="economy"  order by flightcharge desc limit 1;

select custid,custname from (select c.custid,c.custname from customer c join booking b on c.custid=b.custid  where travelclass="economy"
 order by flightcharge desc limit 1) a ;
 
 with ctes as
 (select c.custid,c.custname from customer c join booking b on c.custid=b.custid  where travelclass="economy"
 order by flightcharge desc limit 1)
 select custid,custname from ctes;
 
 /*Identify the international flight(s) which are booked the maximum number of times.
 Write a SQL query to display id and name of the identified flights.*/
 select * from flight;
select f.flightid,flightname from customer c join booking b on c.custid=b.custid join flight f on f.flightid=b.flightid
 where flighttype="international" 
 group by flightid
 order by count(f.flightid) desc;
 
 select f.flightid,flightname,count(f.flightid)as max_booked from customer c join booking b on c.custid=b.custid join flight f on f.flightid=b.flightid
 where flighttype="international" 
 group by flightid
 order by max_booked desc;
 
 select flightid,flightname from (select f.flightid,flightname from customer c join booking
 b on c.custid=b.custid join flight f on f.flightid=b.flightid where flighttype="international")a  group by flightid
 order by count(flightid) desc;

  select flightid,flightname from (select f.flightid,flightname from customer c join booking
 b on c.custid=b.custid join flight f on f.flightid=b.flightid where flighttype="international"group by flightid
 order by count(f.flightid) desc)a 
 ;
 
 with ft as
 (select f.flightid,flightname from customer c join booking
 b on c.custid=b.custid join flight f on f.flightid=b.flightid where flighttype="international")
 select flightid,flightname from ft  group by flightid
 order by count(flightid) desc;
 
 /*Identify the customer(s) who have paid overall total flightcharge less than the average flightcharge of all bookings belonging to
 travel class ‘Business’. Write a SQL query to display id and name of the identified customers*/
 
 select * from booking;
select * from customer;
select * from flight;    
select c.custid,custname,sum(flightcharge) as total_flightcharge from customer c join booking b on c.custid=b.custid group by custid having total_flightcharge <
(select avg(flightcharge) from customer c join booking b on c.custid=b.custid where travelclass="business"  );

# subquery
select custid,custname,sum(flightcharge) as total_flightcharge from (select c.custid,c.custname,flightcharge from customer c join booking
 b on c.custid=b.custid )a group by custid having total_flightcharge <
(select avg(flightcharge) from customer c join booking b on c.custid=b.custid where travelclass="business"  );

# ctes
with ics as
(select c.custid,c.custname,flightcharge from customer c join booking
 b on c.custid=b.custid )
select custid,custname,sum(flightcharge) as total_flightcharge from ics group by custid having total_flightcharge <
(select avg(flightcharge) from customer c join booking b on c.custid=b.custid where travelclass="business"  );

/*Identify the booking(s) done for travel class ‘Business’ by the customers having letter ‘e’ anywhere in their name, for the flights other than ‘Domestic’ flights.
 Write a SQL query to display booking id, flight’s id and customer’s id of the identified bookings.*/
 
 select * from booking;
select * from customer;
select * from flight;
 select custname,bookingid,f.flightid,c.custid from customer c join booking b on c.custid=b.custid join flight f on f.flightid=b.flightid 
 where travelclass="economy" and custname like "%e%" and flighttype!="domestic";
 # subquery
 select custname,bookingid,flightid,custid from ( select c.custname,bookingid,f.flightid,c.custid from customer c join booking b on 
 c.custid=b.custid join flight f on f.flightid=b.flightid where travelclass="economy" and  flighttype!="domestic"
 )a  where custname like "%e%" ;
 
# ctes
with ctes as
(select c.custname,bookingid,f.flightid,c.custid from  customer c join booking b on c.custid=b.custid 
join flight f on f.flightid=b.flightid  where travelclass="economy" and custname like "%e%" and flighttype!="domestic")
select custname,bookingid,flightid,custid from ctes;

/*Identify the booking(s) which have flight charges paid is less than the average flight charge for all flight ticket bookings belonging to the same flight type.
 Write a SQL query to display booking id, source city, destination city and booking date of the identified bookings.*/
 
 select bookingid,source,destination,flightcharge,bookingdate from customer c join booking b  join flight f on f.flightid=b.flightid 
 having flightcharge <(select 
 avg(flightcharge) from booking b join flight f on b.flightid=f.flightid where flighttype="domestic")
union
 select bookingid,source,destination,flightcharge,bookingdate from customer c join booking b  join flight f on f.flightid=b.flightid 
 having flightcharge <(select 
 avg(flightcharge) from booking b join flight f on b.flightid=f.flightid where flighttype="international");

# subquery 
select bookingid,source,destination,flightcharge,bookingdate from ( select bookingid,source,destination,flightcharge,bookingdate
 from customer c join booking b  join flight f on f.flightid=b.flightid )a
 having flightcharge <(select 
 avg(flightcharge) from booking b join flight f on b.flightid=f.flightid where flighttype="domestic")
 union
 select bookingid,source,destination,flightcharge,bookingdate from ( select bookingid,source,destination,flightcharge,bookingdate
 from customer c join booking b  join flight f on f.flightid=b.flightid )a
 having flightcharge <(select 
 avg(flightcharge) from booking b join flight f on b.flightid=f.flightid where flighttype="international");
 
 # ctes
 with avg as
 ( select bookingid,source,destination,flightcharge,bookingdate
 from customer c join booking b  join flight f on f.flightid=b.flightid )
select bookingid,source,destination,flightcharge,bookingdate from avg having flightcharge <(select 
 avg(flightcharge) from booking b join flight f on b.flightid=f.flightid where flighttype="domestic")
 union
 select bookingid,source,destination,flightcharge,bookingdate from avg having flightcharge <(select 
 avg(flightcharge) from booking b join flight f on b.flightid=f.flightid where flighttype="international");
 
 
 

  
