

CREATE VIEW guest_details AS
SELECT 
    guestId, 
    CONCAT(firstName, ' ', lastName) AS fullName,
    phone,
    registrationDate,
    DATEDIFF(CURRENT_DATE, registrationDate) AS days_Since_Registration
FROM guest;


select * FROM guest_details;






-- create  procedure to insert data guest table 
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



---insert into guest using procedure 

call add_guest('abel','mek','0912345434')

call add_guest('alex','haile','02303434')