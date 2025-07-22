
### ✅ **Database Name:**


create database airline_reservation;
use airline_reservation;
### ✅ **Tables**

#### 1. `airport`


create table airport (
    airport_id int primary key auto_increment,
    name varchar(100) not null,
    city varchar(50),
    country varchar(50)
);


#### 2. `airplane`


create table airplane (
    airplane_id int primary key auto_increment,
    model varchar(50),
    total_seats int
);

#### 3. `flight`


create table flight (
    flight_id int primary key auto_increment,
    flight_number varchar(10) not null,
    departure_airport_id int,
    arrival_airport_id int,
    departure_time datetime,
    arrival_time datetime,
    airplane_id int,
    foreign key (departure_airport_id) references airport(airport_id),
    foreign key (arrival_airport_id) references airport(airport_id),
    foreign key (airplane_id) references airplane(airplane_id)
);


#### 4. `passenger`


create table passenger (
    passenger_id int primary key auto_increment,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100) unique,
    phone varchar(20)
);


#### 5. `booking`


create table booking (
    booking_id int primary key auto_increment,
    booking_date datetime default current_timestamp,
    passenger_id int,
    flight_id int,
    seat_number varchar(5),
    status varchar(20) default 'confirmed',
    foreign key (passenger_id) references passenger(passenger_id),
    foreign key (flight_id) references flight(flight_id)
);


#### Insert into `airport`


insert into airport (name, city, country) values
('john f. kennedy international', 'new york', 'usa'),
('heathrow', 'london', 'uk'),
('haneda', 'tokyo', 'japan');

#### Insert into `airplane`

insert into airplane (model, total_seats) values
('boeing 737', 180),
('airbus a320', 150);

#### Insert into `flight`


insert into flight (flight_number, departure_airport_id, arrival_airport_id, departure_time, arrival_time, airplane_id) values
('aa101', 1, 2, '2025-08-01 08:00:00', '2025-08-01 20:00:00', 1),
('ba202', 2, 3, '2025-08-02 10:00:00', '2025-08-02 22:00:00', 2);

#### Insert into `passenger`


insert into passenger (first_name, last_name, email, phone) values
('john', 'doe', 'john@example.com', '1234567890'),
('jane', 'smith', 'jane@example.com', '0987654321');

#### Insert into `booking`


insert into booking (passenger_id, flight_id, seat_number) values
(1, 1, '12A'),
(2, 2, '14B');



#### 1. List all flights with airport names


select 
    f.flight_number,
    da.name as departure_airport,
    aa.name as arrival_airport,
    f.departure_time,
    f.arrival_time
from flight f
join airport da on f.departure_airport_id = da.airport_id
join airport aa on f.arrival_airport_id = aa.airport_id;

#### 2. List bookings with passenger name and flight number


select 
    b.booking_id,
    p.first_name,
    p.last_name,
    f.flight_number,
    b.seat_number,
    b.status
from booking b
join passenger p on b.passenger_id = p.passenger_id
join flight f on b.flight_id = f.flight_id;

#### 3. Count of bookings per flight


select 
    f.flight_number,
    count(b.booking_id) as total_bookings
from flight f
left join booking b on f.flight_id = b.flight_id
group by f.flight_number;



### **4. List all passengers on a specific flight**


select 
    p.passenger_id,
    p.first_name,
    p.last_name,
    b.seat_number
from booking b
join passenger p on b.passenger_id = p.passenger_id
where b.flight_id = 1;


###  **5. Find available seats on a flight**

# Assuming you know the total number of seats from the airplane:


select 
    f.flight_id,
    a.total_seats - count(b.booking_id) as available_seats
from flight f
join airplane a on f.airplane_id = a.airplane_id
left join booking b on f.flight_id = b.flight_id
where f.flight_id = 1
group by f.flight_id, a.total_seats;


###  **6. List flights scheduled between two dates**


select 
    flight_number,
    departure_time,
    arrival_time
from flight
where departure_time between '2025-08-01' and '2025-08-10';


---

###  **7. Show number of flights departing from each airport**


select 
    a.name as airport_name,
    count(f.flight_id) as total_departures
from airport a
join flight f on a.airport_id = f.departure_airport_id
group by a.name;


###  **8. Show booking status summary**

select 
    status,
    count(*) as total_bookings
from booking
group by status;

###  **9. Find flights with no bookings**


select 
    f.flight_id,
    f.flight_number
from flight f
left join booking b on f.flight_id = b.flight_id
where b.booking_id is null;

###  **10. List frequent flyers (more than 1 booking)**


select 
    p.passenger_id,
    p.first_name,
    p.last_name,
    count(b.booking_id) as bookings_count
from passenger p
join booking b on p.passenger_id = b.passenger_id
group by p.passenger_id, p.first_name, p.last_name
having count(b.booking_id) > 1;

###  **11. Show full booking details with airport info**


select 
    b.booking_id,
    p.first_name,
    p.last_name,
    f.flight_number,
    da.name as departure_airport,
    aa.name as arrival_airport,
    f.departure_time,
    b.seat_number,
    b.status
from booking b
join passenger p on b.passenger_id = p.passenger_id
join flight f on b.flight_id = f.flight_id
join airport da on f.departure_airport_id = da.airport_id
join airport aa on f.arrival_airport_id = aa.airport_id;




###  **12. Flights and how full they are (percentage filled)**


select 
    f.flight_number,
    count(b.booking_id) as booked_seats,
    a.total_seats,
    round((count(b.booking_id) * 100.0 / a.total_seats), 2) as percent_filled
from flight f
join airplane a on f.airplane_id = a.airplane_id
left join booking b on f.flight_id = b.flight_id
group by f.flight_number, a.total_seats;
