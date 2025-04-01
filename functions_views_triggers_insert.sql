use hotel;
-- Using the add_guest procedure to insert guests
CALL add_guest('John', 'Smith', '555-123-4567');
select *from guest;
select *from guest_details;
-- Inserting 30 rooms with varying capacities, floors, and prices
INSERT INTO rooms (capacity, floorNumber, price) VALUES
(1, 1, 99.99),  (2, 6, 199.99);
select *from rooms;
-- Set some rooms to maintenancerooms
UPDATE rooms SET availablityStatus = 'maintenance', lastMaintianceDate = CURRENT_DATE 
WHERE roomid IN (3, 12, 21);


INSERT INTO staff (firstName, lastName, position, phoneNumber, hireDate, salary) VALUES
('Michael', 'Scott', 'General Manager', '555-111-2222', '2020-01-15', 75000.00);
select*from staff;





INSERT INTO inventory (intemName, quantiyInStock, unitOfMeasure, suplierInfo) VALUES
('Towels', 500, 'pieces', 'CleanLinens Inc., contact: sales@cleanlinens.com');
select*from inventory ;

INSERT INTO services (serviceName, price, availablity, inventory_id) VALUES
('Room Service - Breakfast', 15.99, 'daytime', 7),
('Extra Pillows', 3.00, '24/7', 2);
select*from services ;
select *from available_rooms;


-- Using the make_reservation procedure
-- Current reservations (check-in today or in the past, check-out in the future)
CALL make_reservation(1, 5, '2023-11-01', '2023-11-05');
CALL make_reservation(2, 2, '2023-11-02', '2023-11-07');
CALL make_reservation(3, 10, '2023-11-03', '2023-11-08');
CALL make_reservation(4, 15, '2023-11-04', '2023-11-09');
CALL make_reservation(5, 18, '2023-11-05', '2023-11-10');
CALL make_reservation(6, 20, '2023-11-01', '2023-11-06');
CALL make_reservation(7, 22, '2023-11-02', '2023-11-07');
CALL make_reservation(8, 25, '2023-11-03', '2023-11-08');
CALL make_reservation(9, 28, '2023-11-04', '2023-11-09');
CALL make_reservation(10, 30, '2023-11-05', '2023-11-10');
select *from reservation;
desc make_reservation;

-- Future reservations
CALL make_reservation(11, 1, '2023-11-15', '2023-11-20');
CALL make_reservation(12, 2, '2023-11-16', '2023-11-21');
CALL make_reservation(13, 4, '2023-11-17', '2023-11-22');
CALL make_reservation(14, 6, '2023-11-18', '2023-11-23');
CALL make_reservation(15, 7, '2023-11-19', '2023-11-24');

-- Check in some guests
CALL check_in_guest(1);
CALL check_in_guest(2);
CALL check_in_guest(3);
CALL check_in_guest(4);
CALL check_in_guest(5);


-- These will use the calculate_service_charge trigger
INSERT INTO guestServices (reservation_Id, service_id, quantity, guestServiceStatus) VALUES
(1, 1, 2, 'completed'),-- Breakfast for 2
(1, 4, 1, 'completed'), -- Laundry service
(2, 1, 1, 'completed'), -- Breakfast for 1
(2, 6, 1, 'completed'), -- Spa treatment
(3, 3, 2, 'completed'), -- Dinner for 2
(3, 7, 1, 'completed'), -- Massage
(4, 2, 2, 'completed'), -- Lunch for 2
(4, 8, 1, 'completed'), -- Airport shuttle
(5, 1, 1, 'completed'),-- Breakfast for 1
(5, 11, 3, 'completed'); -- Extra towels


select*from guestservices;
select*from guest_service_requests;


select*from staff;
select * from staff_with_bonus ;
INSERT INTO maintenance (room_id, staff_Id, issueType, reportDate, startDate, completionDate, maintenanceStatus, maintenanceCost) VALUES
(3, 7, 'Plumbing leak', '2023-10-28', '2023-10-28', '2023-10-29', 'completed', 250.00);
(12, 7, 'AC not working', '2023-10-30', '2023-10-30', NULL, 'in-progress', 150.00),
(21, 7, 'Broken window', '2023-11-01', '2023-11-02', NULL, 'reported', 0.00),
(5, 7, 'TV malfunction', '2023-10-25', '2023-10-25', '2023-10-26', 'completed', 75.00),
(15, 7, 'Furniture repair', '2023-10-27', '2023-10-27', '2023-10-28', 'completed', 120.00);

select *from maintenance;

select  is_room_available(3,'2023-10-28');

-- For completed reservations and services
INSERT INTO payment (reservationsId, paymentDate, amount, paymentMethod, paymentStatus) VALUES
(1, '2023-11-01 14:30:00', 599.96, 'credit card', 'completed'), -- Room charge
(1, '2023-11-03 10:15:00', 44.48, 'credit card', 'completed'), -- Services
(2, '2023-11-02 15:45:00', 749.95, 'debit card', 'completed'),-- Room charge
(2, '2023-11-04 11:20:00', 104.99, 'debit card', 'completed'), -- Services
(3, '2023-11-03 16:20:00', 799.96, 'credit card', 'completed'), -- Room charge
(3, '2023-11-05 09:30:00', 154.98, 'credit card', 'completed'), -- Services
(4, '2023-11-04 13:10:00', 899.95, 'online payment', 'completed'), -- Room charge
(4, '2023-11-06 14:45:00', 59.99, 'online payment', 'completed'), -- Services
(5, '2023-11-05 12:30:00', 949.95, 'credit card', 'completed'), -- Room charge
(5, '2023-11-07 16:20:00', 30.99, 'credit card', 'completed'); -- Services


