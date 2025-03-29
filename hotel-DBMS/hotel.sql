CREATE table IF NOT EXISTS guest(
    guestId int PRIMARY KEY AUTO_INCREMENT,
    firstName VARCHAR(40),
    lastName VARCHAR(40),
    phone VARCHAR(30),
    registrationDate DATETIME DEFAULT CURRENT_TIMESTAMP
)

create table  if NOT exists roomType  (
    roomTypeId int PRIMARY KEY AUTO_INCREMENT ,
    capacity TINYINT ,
    price DECIMAL(10,2) NOT NULL ,
    description TEXT
)

create table rooms(
    roomid int PRIMARY KEY AUTO_INCREMENT ,
    roomnumber VARCHAR(10) NOT NULL UNIQUE,
    roomsTypeId int ,
    floorNumber int not NULL ,
    availablityStatus ENUM('available', 'occupied', 'maintenance', 'reserved') DEFAULT 'available',
    lastMaintianceDate DATE,
    FOREIGN KEY (roomsTypeId) REFERENCES roomType(roomTypeId)
)


create TABLE reservation (
    reservationid int PRIMARY key AUTO_INCREMENT,
    guestsId  int not NULL,
    room_id int NOT NULL,
    checkInDate DATE NOT null,
    checkOutDate DATE NOT NULL,
    reservationStatus ENUM('confirmed', 'checked-in', 'checked-out', 'cancelled', 'no-show') DEFAULT 'confirmed',
    totalAmount DECIMAL(10,3),
    payementStatus ENUM('paid', 'unpaid', 'partial') DEFAULT 'unpaid',
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



