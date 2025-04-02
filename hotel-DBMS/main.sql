

CREATE VIEW guest_details AS
SELECT 
    guestId, 
    CONCAT(firstName, ' ', lastName) AS fullName,
    phone,
    registrationDate,
    DATEDIFF(CURRENT_DATE, registrationDate) AS days_Since_Registration
FROM guest;


select * FROM guest_details;



DROP Procedure add_guest;


-- create  procedure to insert data guest table 

DELIMITER //
CREATE PROCEDURE add_guest(
    IN p_firstName VARCHAR(40),
    IN p_lastName VARCHAR(40),
    IN p_phone VARCHAR(30),
    IN re_date DATETIME
)
BEGIN
    INSERT INTO guest (firstName, lastName, phone, registrationDate)
    VALUES (p_firstName, p_lastName, p_phone, re_date);
END //
DELIMITER ;





DELIMITER //
CREATE TRIGGER update_room_status_after_checkout
AFTER UPDATE ON reservation
FOR EACH ROW
BEGIN
    IF NEW.reservationStatus = 'checked-out' AND OLD.reservationStatus != 'checked-out' THEN
        UPDATE rooms 
        SET availablityStatus = 'available' 
        WHERE roomid = NEW.room_id;
    END IF;
END //
DELIMITER ;


create TRIGGER urdd AFTER udate 



DELIMITER //
CREATE TRIGGER calculate_service_charge
BEFORE INSERT ON guestServices
FOR EACH ROW
BEGIN
    DECLARE service_price DECIMAL(10,2);
    
    SELECT price INTO service_price FROM services WHERE serviceId = NEW.service_id;
    
    SET NEW.totatlCharge = service_price * NEW.quantity;
END //
DELIMITER ;





DELIMITER //
CREATE FUNCTION calculate_revenue(start_date DATE, end_date DATE) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    
    SELECT SUM(amount) INTO total 
    FROM payment 
    WHERE paymentDate BETWEEN start_date AND end_date;
    
    RETURN IFNULL(total, 0);
END //
DELIMITER ;





DELIMITER //
CREATE FUNCTION is_room_available(room_id INT, check_date DATE) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE available BOOLEAN;
    
    SELECT COUNT(*) = 0 INTO available
    FROM reservation
    WHERE room_id = room_id 
    AND check_date BETWEEN checkInDate AND checkOutDate
    AND reservationStatus IN ('confirmed', 'checked-in');
    
    RETURN available;
END //
DELIMITER ;



DELIMITER //
CREATE PROCEDURE check_in_guest(IN res_id INT)
BEGIN
    UPDATE reservation 
    SET reservationStatus = 'checked-in' 
    WHERE reservationid = res_id;
    
    SELECT CONCAT('Guest checked in successfully for reservation ID: ', res_id) AS message;
END //
DELIMITER ;




DELIMITER //
CREATE PROCEDURE check_out_guest(IN res_id INT)
BEGIN
    DECLARE room_id INT;
    
    -- Get room ID from reservation
    SELECT room_id INTO room_id FROM reservation WHERE reservationid = res_id;
    
    -- Update reservation status
    UPDATE reservation 
    SET reservationStatus = 'checked-out' 
    WHERE reservationid = res_id;
    
    -- Update room status
    UPDATE rooms 
    SET availablityStatus = 'available' 
    WHERE roomid = room_id;
    
    SELECT CONCAT('Guest checked out successfully for reservation ID: ', res_id) AS message;
END //
DELIMITER ;



DELIMITER //
CREATE PROCEDURE make_reservation(
    IN guest_id INT,
    IN room_id INT,
    IN check_in DATE,
    IN check_out DATE
)
BEGIN
    DECLARE room_available BOOLEAN;
    
    -- Check if room is available
    SELECT COUNT(*) = 0 INTO room_available
    FROM reservation
    WHERE room_id = room_id 
    AND (
        (check_in BETWEEN checkInDate AND checkOutDate) OR
        (check_out BETWEEN checkInDate AND checkOutDate) OR
        (checkInDate BETWEEN check_in AND check_out)
    )
    AND reservationStatus IN ('confirmed', 'checked-in');
    
    IF room_available THEN
        INSERT INTO reservation (guestsId, room_id, checkInDate, checkOutDate)
        VALUES (guest_id, room_id, check_in, check_out);
        
        SELECT CONCAT('Reservation created successfully. ID: ', LAST_INSERT_ID()) AS message;
    ELSE
        SELECT 'Room is not available for the selected dates' AS message;
    END IF;
END //
DELIMITER ;



CREATE VIEW current_guests AS
SELECT 
    g.guestId, 
    CONCAT(g.firstName, ' ', g.lastName) AS guestName,
    r.roomid AS roomNumber,
    res.checkInDate,
    res.checkOutDate
FROM guest g
JOIN reservation res ON g.guestId = res.guestsId
JOIN rooms r ON res.room_id = r.roomid
WHERE res.reservationStatus IN ('confirmed', 'checked-in');




DELIMITER //
CREATE TRIGGER update_room_status_after_reservation
AFTER INSERT ON reservation
FOR EACH ROW
BEGIN
    UPDATE rooms 
    SET availablityStatus = 'occupied' 
    WHERE roomid = NEW.room_id;
END //
DELIMITER ;





---list of current guest reserves in hotel

CREATE VIEW current_guests AS
SELECT 
    g.guestId, 
    CONCAT(g.firstName, ' ', g.lastName) AS guestName,
    r.roomid AS roomNumber,
    res.checkInDate,
    res.checkOutDate
FROM guest g
JOIN reservation res ON g.guestId = res.guestsId
JOIN rooms r ON res.room_id = r.roomid
WHERE res.reservationStatus IN ('confirmed', 'checked-in');



---insert into guest using procedure 

call add_guest('abel','mek','0912345434')

call add_guest('alex','haile','02303434')


---select all available rooms 

CREATE VIEW available_rooms AS
SELECT 
    roomid,
    capacity,
    floorNumber,
    price
FROM rooms
WHERE availablityStatus = 'available';


--guest services request 


CREATE VIEW guest_service_requests AS
SELECT 
    gs.guestServiceId,
    CONCAT(g.firstName, ' ', g.lastName) AS guestName,
    r.roomid AS roomNumber,
    s.serviceName,
    gs.requestDate,
    gs.quantity,
    gs.totatlCharge,
    gs.guestServiceStatus
FROM guestServices gs
JOIN reservation res ON gs.reservation_Id = res.reservationid
JOIN guest g ON res.guestsId = g.guestId
JOIN rooms r ON res.room_id = r.roomid
JOIN services s ON gs.service_id = s.serviceId;



--rooms maintenace history
CREATE VIEW room_maintenance_history AS
SELECT 
    r.roomid AS roomNumber,
    m.issueType,
    m.reportDate,
    m.completionDate,
    m.maintenanceStatus,
    m.maintenanceCost,
    CONCAT(s.firstName, ' ', s.lastName) AS staffMember
FROM maintenance m
JOIN rooms r ON m.room_id = r.roomid
JOIN staff s ON m.staff_Id = s.staffId
ORDER BY m.reportDate DESC;


---to calculate total revnue of hotel



CREATE VIEW revenue_by_payment_method AS
SELECT 
    paymentMethod,
    SUM(amount) AS totalRevenue,
    COUNT(*) AS transactionCount
FROM payment
GROUP BY paymentMethod;