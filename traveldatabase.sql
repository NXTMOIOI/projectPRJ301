/*CREATE DATABASE Travel_Company;
GO

USE Travel_Company;
GO*/

--------------------------
-- CUSTOMERS
--------------------------

CREATE TABLE Customers(
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Gender NVARCHAR(10),
    DateOfBirth DATE,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Address NVARCHAR(200),
    CCCD VARCHAR(20)
);

--------------------------
-- EMPLOYEES
--------------------------

CREATE TABLE Employees(
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Position NVARCHAR(50),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Salary DECIMAL(18,2)
);

--------------------------
-- USERS (LOGIN)
--------------------------

CREATE TABLE Users(
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(100) NOT NULL,
    Role VARCHAR(20) NOT NULL,

    CustomerID INT NULL,
    EmployeeID INT NULL,

    FOREIGN KEY(CustomerID)
    REFERENCES Customers(CustomerID),

    FOREIGN KEY(EmployeeID)
    REFERENCES Employees(EmployeeID)
);

--------------------------
-- TOURS
--------------------------

CREATE TABLE Tours(
    TourID INT PRIMARY KEY IDENTITY(1,1),
    TourName NVARCHAR(150) NOT NULL,
    Destination NVARCHAR(100),
    Duration INT,
    Price DECIMAL(18,2),
    MaxPeople INT,
    StartDate DATE,
    EndDate DATE,
    ImageURL NVARCHAR(300)
);

--------------------------
-- TOUR GUIDES
--------------------------

CREATE TABLE TourGuides(
    GuideID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100),
    Phone VARCHAR(15),
    Experience INT,
    Language NVARCHAR(100)
);

--------------------------
-- TOUR ASSIGNMENT
--------------------------

CREATE TABLE TourAssignments(
    AssignmentID INT PRIMARY KEY IDENTITY(1,1),

    TourID INT,
    GuideID INT,

    FOREIGN KEY(TourID)
    REFERENCES Tours(TourID),

    FOREIGN KEY(GuideID)
    REFERENCES TourGuides(GuideID)
);

--------------------------
-- VEHICLES
--------------------------

CREATE TABLE Vehicles(
    VehicleID INT PRIMARY KEY IDENTITY(1,1),
    VehicleType NVARCHAR(50),
    Capacity INT,
    LicensePlate VARCHAR(20)
);

--------------------------
-- TOUR VEHICLES
--------------------------

CREATE TABLE TourVehicles(
    TourVehicleID INT PRIMARY KEY IDENTITY(1,1),

    TourID INT,
    VehicleID INT,

    FOREIGN KEY(TourID)
    REFERENCES Tours(TourID),

    FOREIGN KEY(VehicleID)
    REFERENCES Vehicles(VehicleID)
);

--------------------------
-- HOTELS
--------------------------

CREATE TABLE Hotels(
    HotelID INT PRIMARY KEY IDENTITY(1,1),
    HotelName NVARCHAR(100),
    Address NVARCHAR(200),
    Phone VARCHAR(15),
    StarRating INT
);

--------------------------
-- TOUR HOTELS
--------------------------

CREATE TABLE TourHotels(
    TourHotelID INT PRIMARY KEY IDENTITY(1,1),

    TourID INT,
    HotelID INT,

    FOREIGN KEY(TourID)
    REFERENCES Tours(TourID),

    FOREIGN KEY(HotelID)
    REFERENCES Hotels(HotelID)
);

--------------------------
-- ITINERARIES
--------------------------

CREATE TABLE Itineraries(
    ItineraryID INT PRIMARY KEY IDENTITY(1,1),

    TourID INT,

    DayNumber INT,

    Activities NVARCHAR(500),

    FOREIGN KEY(TourID)
    REFERENCES Tours(TourID)
);

--------------------------
-- BOOKINGS
--------------------------

CREATE TABLE Bookings(
    BookingID INT PRIMARY KEY IDENTITY(1,1),

    CustomerID INT,
    TourID INT,

    BookingDate DATE,

    NumberOfPeople INT,

    TotalAmount DECIMAL(18,2),

    Status NVARCHAR(30),

    FOREIGN KEY(CustomerID)
    REFERENCES Customers(CustomerID),

    FOREIGN KEY(TourID)
    REFERENCES Tours(TourID)
);

--------------------------
-- PAYMENTS
--------------------------

CREATE TABLE Payments(
    PaymentID INT PRIMARY KEY IDENTITY(1,1),

    BookingID INT,

    PaymentDate DATE,

    Amount DECIMAL(18,2),

    PaymentMethod NVARCHAR(50),

    Status NVARCHAR(30),

    FOREIGN KEY(BookingID)
    REFERENCES Bookings(BookingID)
);
USE Travel_Company;
GO

------------------------
-- Customers
------------------------
INSERT INTO Customers(FullName,Gender,DateOfBirth,Phone,Email,Address,CCCD)
VALUES
(N'Nguyễn Văn An',N'Nam','1998-05-10','0912345678','an@gmail.com',N'Hà Nội','001111111111'),
(N'Trần Thị Bình',N'Nữ','1999-08-15','0923456789','binh@gmail.com',N'Đà Nẵng','002222222222'),
(N'Lê Minh Cường',N'Nam','1997-03-20','0934567890','cuong@gmail.com',N'TP.HCM','003333333333'),
(N'Phạm Thu Hà',N'Nữ','2000-11-11','0945678901','ha@gmail.com',N'Hải Phòng','004444444444'),
(N'Hoàng Đức Long',N'Nam','1996-01-30','0956789012','long@gmail.com',N'Cần Thơ','005555555555');

------------------------
-- Employees
------------------------
INSERT INTO Employees(FullName,Position,Phone,Email,Salary)
VALUES
(N'Nguyễn Quốc Bảo',N'Quản lý','0901111111','bao@travel.com',25000000),
(N'Lê Thị Mai',N'Nhân viên Sale','0902222222','mai@travel.com',15000000),
(N'Trần Minh Đức',N'Điều hành Tour','0903333333','duc@travel.com',18000000);

------------------------
-- Users
------------------------
INSERT INTO Users(Username,Password,Role,CustomerID,EmployeeID)
VALUES
('admin','123456','ADMIN',NULL,1),
('sale01','123456','EMPLOYEE',NULL,2),
('staff01','123456','EMPLOYEE',NULL,3),
('customer01','123456','CUSTOMER',1,NULL),
('customer02','123456','CUSTOMER',2,NULL),
('customer03','123456','CUSTOMER',3,NULL);

------------------------
-- Tours
------------------------
INSERT INTO Tours(TourName,Destination,Duration,Price,MaxPeople,StartDate,EndDate,ImageURL)
VALUES
(N'Hà Nội - Sapa',N'Sapa',3,3500000,30,'2026-07-01','2026-07-03','sapa.jpg'),
(N'Đà Nẵng - Hội An',N'Đà Nẵng',4,4500000,25,'2026-07-10','2026-07-13','danang.jpg'),
(N'TP.HCM - Phú Quốc',N'Phú Quốc',5,7000000,20,'2026-08-01','2026-08-05','phuquoc.jpg'),
(N'Hà Nội - Hạ Long',N'Quảng Ninh',2,2800000,35,'2026-08-10','2026-08-11','halong.jpg'),
(N'Nha Trang Nghỉ Dưỡng',N'Khánh Hòa',4,5500000,25,'2026-09-01','2026-09-04','nhatrang.jpg');

------------------------
-- Tour Guides
------------------------
INSERT INTO TourGuides(FullName,Phone,Experience,Language)
VALUES
(N'Nguyễn Văn Hải','0971111111',5,N'Tiếng Anh'),
(N'Lê Thu Trang','0972222222',3,N'Tiếng Trung'),
(N'Phạm Đức Anh','0973333333',4,N'Tiếng Nhật');

------------------------
-- Tour Assignments
------------------------
INSERT INTO TourAssignments(TourID,GuideID)
VALUES
(1,1),
(2,2),
(3,3),
(4,1),
(5,2);

------------------------
-- Vehicles
------------------------
INSERT INTO Vehicles(VehicleType,Capacity,LicensePlate)
VALUES
(N'Xe 45 chỗ',45,'30A-12345'),
(N'Xe 29 chỗ',29,'43B-56789'),
(N'Limousine',9,'51C-88888');

------------------------
-- Tour Vehicles
------------------------
INSERT INTO TourVehicles(TourID,VehicleID)
VALUES
(1,1),
(2,2),
(3,3),
(4,1),
(5,2);

------------------------
-- Hotels
------------------------
INSERT INTO Hotels(HotelName,Address,Phone,StarRating)
VALUES
(N'Mường Thanh Hà Nội',N'Hà Nội','0241234567',4),
(N'Vinpearl Đà Nẵng',N'Đà Nẵng','0236123456',5),
(N'Sài Gòn Hotel',N'TP.HCM','0281234567',4);

------------------------
-- Tour Hotels
------------------------
INSERT INTO TourHotels(TourID,HotelID)
VALUES
(1,1),
(2,2),
(3,3),
(4,1),
(5,2);

------------------------
-- Itineraries
------------------------
INSERT INTO Itineraries(TourID,DayNumber,Activities)
VALUES
(1,1,N'Tham quan Hà Nội'),
(1,2,N'Di chuyển đến Sapa'),
(1,3,N'Khám phá bản Cát Cát'),
(2,1,N'Tham quan Bà Nà Hills'),
(2,2,N'Phố cổ Hội An'),
(3,1,N'Tắm biển Phú Quốc'),
(4,1,N'Tham quan Vịnh Hạ Long'),
(5,1,N'Nghỉ dưỡng Nha Trang');

------------------------
-- Bookings
------------------------
INSERT INTO Bookings(CustomerID,TourID,BookingDate,NumberOfPeople,TotalAmount,Status)
VALUES
(1,1,'2026-06-20',2,7000000,N'Đã xác nhận'),
(2,2,'2026-06-21',3,13500000,N'Đã xác nhận'),
(3,3,'2026-06-22',1,7000000,N'Chờ thanh toán'),
(4,4,'2026-06-23',2,5600000,N'Đã xác nhận'),
(5,5,'2026-06-24',4,22000000,N'Đã hủy');

------------------------
-- Payments
------------------------
INSERT INTO Payments(BookingID,PaymentDate,Amount,PaymentMethod,Status)
VALUES
(1,'2026-06-20',7000000,N'Chuyển khoản',N'Đã thanh toán'),
(2,'2026-06-21',13500000,N'Tiền mặt',N'Đã thanh toán'),
(3,'2026-06-22',7000000,N'Thẻ tín dụng',N'Chờ thanh toán'),
(4,'2026-06-23',5600000,N'Chuyển khoản',N'Đã thanh toán'),
(5,'2026-06-24',22000000,N'Tiền mặt',N'Đã hoàn tiền');

CREATE TABLE Promotions(
    PromotionID INT PRIMARY KEY IDENTITY(1,1),
    PromotionName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(300),
    DiscountPercent INT CHECK(DiscountPercent BETWEEN 0 AND 100),
    StartDate DATE,
    EndDate DATE,
    Status NVARCHAR(30)
);
CREATE TABLE TourPromotions(
    TourPromotionID INT PRIMARY KEY IDENTITY(1,1),

    TourID INT NOT NULL,

    PromotionID INT NOT NULL,

    FOREIGN KEY(TourID)
    REFERENCES Tours(TourID),

    FOREIGN KEY(PromotionID)
    REFERENCES Promotions(PromotionID)
);

INSERT INTO Promotions
(PromotionName,Description,DiscountPercent,StartDate,EndDate,Status)
VALUES
(N'Hè Rực Rỡ',
 N'Giảm giá tour mùa hè',
 10,
 '2026-06-01',
 '2026-08-31',
 N'Đang áp dụng'),

(N'Lễ Quốc Khánh',
 N'Khuyến mãi dịp 2/9',
 15,
 '2026-08-25',
 '2026-09-05',
 N'Sắp diễn ra'),

(N'Black Friday',
 N'Giảm giá cuối năm',
 20,
 '2026-11-20',
 '2026-11-30',
 N'Chưa diễn ra');
 INSERT INTO TourPromotions(TourID,PromotionID)
VALUES
(1,1),
(2,1),
(4,2),
(5,2);

