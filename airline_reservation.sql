-- =========================================================
-- Project: Airline Reservation System
-- SQL Developer Internship - Project Phase
-- =========================================================

-- ---------------------------------------------------------
-- SCHEMA: Customers, Flights, Seats, Bookings
-- ---------------------------------------------------------

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT,
    passport_number VARCHAR(20) UNIQUE NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE Flights (
    flight_id INT AUTO_INCREMENT PRIMARY KEY,
    flight_number VARCHAR(10) NOT NULL,
    departure_city VARCHAR(50) NOT NULL,
    arrival_city VARCHAR(50) NOT NULL,
    departure_time DATETIME NOT NULL,
    total_seats INT NOT NULL
);

CREATE TABLE Seats (
    seat_id INT AUTO_INCREMENT PRIMARY KEY,
    flight_id INT,
    seat_number VARCHAR(5) NOT NULL,
    is_booked BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

CREATE TABLE Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    flight_id INT,
    seat_id INT,
    booking_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Confirmed',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
    FOREIGN KEY (seat_id) REFERENCES Seats(seat_id)
);

-- ---------------------------------------------------------
-- SAMPLE DATA
-- ---------------------------------------------------------

INSERT INTO Customers (name, age, passport_number, phone, email) VALUES
('Ravi Kumar', 28, 'P1234567', '9876543210', 'ravi@email.com'),
('Meena Rao', 34, 'P7654321', '9123456789', 'meena@email.com'),
('Arjun Reddy', 25, 'P9988776', '9090909090', 'arjun@email.com');

INSERT INTO Flights (flight_number, departure_city, arrival_city, departure_time, total_seats) VALUES
('AI202', 'Hyderabad', 'Delhi', '2026-08-10 10:00:00', 3),
('6E345', 'Mumbai', 'Bangalore', '2026-08-11 14:30:00', 3);

INSERT INTO Seats (flight_id, seat_number, is_booked) VALUES
(1, '1A', FALSE),
(1, '1B', FALSE),
(1, '1C', FALSE),
(2, '2A', FALSE),
(2, '2B', FALSE),
(2, '2C', FALSE);

-- ---------------------------------------------------------
-- TRIGGERS
-- ---------------------------------------------------------

-- Automatically marks a seat as booked when a new booking is inserted
CREATE TRIGGER after_booking_insert
AFTER INSERT ON Bookings
FOR EACH ROW
BEGIN
    UPDATE Seats SET is_booked = TRUE WHERE seat_id = NEW.seat_id;
END;

-- Automatically frees the seat when a booking's status changes to 'Cancelled'
CREATE TRIGGER after_booking_cancel
AFTER UPDATE ON Bookings
FOR EACH ROW
UPDATE Seats SET is_booked = (NEW.status != 'Cancelled') WHERE seat_id = NEW.seat_id;

-- ---------------------------------------------------------
-- Sample bookings (seats get marked automatically by the trigger above)
-- ---------------------------------------------------------
INSERT INTO Bookings (customer_id, flight_id, seat_id, booking_date, status) VALUES
(1, 1, 1, '2026-08-01', 'Confirmed'),
(2, 2, 4, '2026-08-02', 'Confirmed'),
(3, 1, 2, '2026-08-03', 'Confirmed');

-- ---------------------------------------------------------
-- VIEW: flight seat availability
-- ---------------------------------------------------------
CREATE VIEW AvailableSeats AS
SELECT Flights.flight_number, Flights.departure_city, Flights.arrival_city, Seats.seat_number
FROM Seats
JOIN Flights ON Seats.flight_id = Flights.flight_id
WHERE Seats.is_booked = FALSE;

-- ---------------------------------------------------------
-- QUERIES
-- ---------------------------------------------------------

-- 1. Available seats for a specific flight
SELECT seat_number FROM Seats WHERE flight_id = 1 AND is_booked = FALSE;

-- 2. Using the AvailableSeats view
SELECT * FROM AvailableSeats;

-- 3. Flight search by route
SELECT * FROM Flights WHERE departure_city = 'Hyderabad' AND arrival_city = 'Delhi';

-- 4. Booking summary report (joins Customers, Flights, Seats, Bookings)
SELECT
    Bookings.booking_id,
    Customers.name AS customer_name,
    Flights.flight_number,
    Flights.departure_city,
    Flights.arrival_city,
    Seats.seat_number,
    Bookings.booking_date,
    Bookings.status
FROM Bookings
JOIN Customers ON Bookings.customer_id = Customers.customer_id
JOIN Flights ON Bookings.flight_id = Flights.flight_id
JOIN Seats ON Bookings.seat_id = Seats.seat_id;

-- ---------------------------------------------------------
-- DEMO: Cancelling a booking (trigger automatically frees the seat)
-- ---------------------------------------------------------
UPDATE Bookings SET status = 'Cancelled' WHERE booking_id = 3;

-- Verify: seat_id 2 should now show is_booked = FALSE again
SELECT * FROM Seats WHERE seat_id = 2;
