-- Active: 1743323324909@@127.0.0.1@3306@hotel

-- view for guest table 
CREATE VIEW guest_details AS
SELECT 
    guestId, 
    CONCAT(firstName, ' ', lastName) AS fullName,
    phone,
    registrationDate,
    DATEDIFF(CURRENT_DATE, registrationDate) AS Registration_Day
FROM guest;


select * from guest_details;



-- create procudre to insert data guest table 
DELIMITER //
CREATE PROCEDURE add_guest(
    IN p_firstName VARCHAR(40),
    IN p_lastName VARCHAR(40),
    IN p_phone VARCHAR(30)
)
BEGIN
    INSERT INTO guest (firstName, lastName, phone)
    VALUES (p_firstName, p_lastName, p_phone);
END //
DELIMITER ;

---calling procedure  to insert data 

 CALL add_guest('gech','ethio','034034');