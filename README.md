# Airline Reservation System

## Objective
Design and build a SQL-based airline reservation system that manages flights, customers, seat availability, and bookings — including automatic seat status updates through triggers.

## Schema
- **Customers** — passenger details (name, age, passport number, phone, email)
- **Flights** — flight details (flight number, route, departure time, total seats)
- **Seats** — individual seats per flight, with an `is_booked` status
- **Bookings** — links a customer to a flight and a specific seat, with a booking status (Confirmed/Cancelled)

## Key Features
- **Seat-level booking** — prevents double-booking by tracking each individual seat's status
- **Automatic booking trigger** — when a new booking is added, the corresponding seat is automatically marked as booked
- **Automatic cancellation trigger** — when a booking's status is changed to 'Cancelled', the seat is automatically freed up again
- **AvailableSeats view** — a saved query for quickly checking open seats across all flights
- **Flight search** — query by departure and arrival city
- **Booking summary report** — a joined view combining customer, flight, and seat details into one readable report

## Tools Used
- MySQL
- DB Fiddle (browser-based, no installation required)
- GitHub

## SQL Concepts Applied
- Schema design and normalization
- Primary keys, foreign keys, constraints
- Triggers (AFTER INSERT, AFTER UPDATE)
- Views
- Multi-table JOINs
- Filtering (WHERE)

## Learning Outcome
This project extended what I learned during the daily SQL tasks into a complete, realistic system. Building the triggers was the most valuable part — understanding how a database can react automatically to changes (a new booking or a cancellation) without needing a separate manual update each time. It also reinforced why breaking data into properly normalized tables (like a separate Seats table) prevents real problems like double-booking.

