
CREATE DATABASE hotel;

use hotel;

CREATE table  guest (
    guestId int PRIMARY KEY AUTO_INCREMENT,
    firstName VARCHAR(40),
    lastName VARCHAR(40),
    phone VARCHAR(30),
    registrationDate DATETIME DEFAULT CURRENT_TIMESTAMP
)


create table rooms(
    roomid int PRIMARY KEY AUTO_INCREMENT ,
    capacity TINYINT ,
    floorNumber int not NULL ,
    availablityStatus ENUM('available', 'occupied', 'maintenance', 'reserved') DEFAULT 'available',
    lastMaintianceDate DATE,
    price DECIMAL(10,2) NOT NULL 
)



create TABLE reservation (
    reservationid int PRIMARY key AUTO_INCREMENT,
    guestsId  int not NULL,
    room_id int NOT NULL,
    checkInDate DATE NOT null,
    checkOutDate DATE NOT NULL,
    reservationStatus ENUM('confirmed', 'checked-in', 'checked-out', 'cancelled', 'no-show') DEFAULT 'confirmed',
    Foreign Key (room_id) REFERENCES rooms(roomid),
    Foreign Key (guestsId) REFERENCES guest(guestId)
)



create table payment (
    paymentId int PRIMARY KEY AUTO_INCREMENT,
    reservationsId int NOT NULL,
    paymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL ,
    paymentMethod ENUM('cash', 'credit card', 'debit card', 'bank transfer', 'online payment'),
    paymentStatus ENUM('completed', 'failed', 'refunded') DEFAULT 'completed',
    Foreign Key (reservationsId) REFERENCES reservation (reservationid)
)





create table staff (
    staffId int PRIMARY KEY AUTO_INCREMENT,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) ,
    position VARCHAR(50) NOT NULL ,
    phoneNumber VARCHAR(60),
    hireDate DATE,
    salary DECIMAL(10,2),
    _status ENUM('active', 'on leave', 'terminated' ) DEFAULT 'active'
)


create TABLE services(
    serviceId int PRIMARY KEY AUTO_INCREMENT,
    inventory_id int,
    serviceName VARCHAR(100) NOT NULL,
    price DECIMAL(10,2),
    availablity ENUM('24/7', 'daytime', 'on-request'),
    Foreign Key (inventory_id) REFERENCES inventory(inventoryId)
)



create table inventory(
    inventoryId int PRIMARY key  AUTO_INCREMENT,
    intemName VARCHAR(100) NOT NULL ,
    quantiyInStock int ,
    unitOfMeasure VARCHAR(10),
    suplierInfo TEXT 
)


create TABLE guestServices(
    guestServiceId int PRIMARY key AUTO_INCREMENT,
    reservation_Id int NOT NULL,
    service_id int NOT NULL,
    requestDate DATE DEFAULT CURRENT_TIMESTAMP,
    quantity int DEFAULT 1,
    guestServiceStatus ENUM('requested', 'in-progress', 'completed', 'cancelled'),
    totatlCharge DECIMAL(10,2),
    Foreign Key (reservation_Id) REFERENCES reservation(reservationid),
    Foreign key (service_id) REFERENCES services(serviceId)
)



 
create table  maintenance (
  maintenance_id int PRIMARY KEY AUTO_INCREMENT,
  room_id int NOT NULL , 
  staff_Id int NOT NULL  ,
  issueType VARCHAR(100) NOT NULL,
  reportDate date ,
  startDate DATETIME,
  completionDate DATETIME,
  maintenanceStatus ENUM('reported','in-progress','completed'),
  maintenanceCost DECIMAL(10,2) , 
  Foreign Key (room_id) REFERENCES rooms(roomid),
  Foreign Key (staff_Id) REFERENCES staff(staffId)
)







