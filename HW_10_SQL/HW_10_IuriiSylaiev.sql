        -- USE [master]
        -- GO
        -- DROP DATABASE [BarberShop]
        -- GO
        -- EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'BarberShop'
        -- GO

--Створення бази даних
CREATE DATABASE BarberShop;
GO
USE BarberShop;
GO

-- Таблиця для збереження інформації про барберів
CREATE TABLE Barbers (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(25) NOT NULL CHECK (FirstName != ''),
    MiddleName NVARCHAR(25) NOT NULL DEFAULT '',
    LastName NVARCHAR(25) NOT NULL CHECK (LastName != ''),
    Gender NVARCHAR(7) NOT NULL CHECK (Gender IN ('Male', 'Female', 'Unknown')) DEFAULT 'Unknown',
    Phone NVARCHAR(20) NOT NULL UNIQUE CHECK (Phone LIKE '[0-9]%' AND LEN(Phone) BETWEEN 10 AND 15),
    Email NVARCHAR(50) NOT NULL UNIQUE CHECK (Email LIKE '%@%.%' AND Email NOT LIKE '% %'),
    DateOfBirth DATE NOT NULL,
    HireDate DATE NOT NULL,
    Position NVARCHAR(6) NOT NULL CHECK (Position IN ('Chief', 'Senior', 'Junior')),
    isDeleted BIT NOT NULL DEFAULT 0,
    isActive BIT NOT NULL DEFAULT 1,
    Created DATETIME NOT NULL DEFAULT GETDATE(),
    Updated DATETIME NOT NULL DEFAULT GETDATE()
);

GO  --DROP TABLE Barbers

-- Тригер для забезпечення одного головного барбера
CREATE TRIGGER trg_EnsureSingleChief
ON Barbers
AFTER INSERT, UPDATE
AS
BEGIN
    IF (SELECT COUNT(*) FROM Barbers WHERE Position = 'Chief' AND isDeleted = 0 AND isActive = 1) > 1
    BEGIN
        ROLLBACK TRANSACTION;
        -- THROW 50001, 'There can be ONLY ONE Chief Barber.', 1;  -- for error message
        PRINT 'There can be ONLY ONE Chief Barber!!!'
    END
END;
GO                                                              --DROP TRIGGER trg_EnsureSingleChief

-- Вставка тестових даних для барберів
INSERT INTO Barbers (FirstName, MiddleName, LastName, Gender, Phone, Email, DateOfBirth, HireDate, Position)
VALUES
    ('John', DEFAULT, 'Smith', 'Male', '1234567890', 'john.smith@example.com', '1985-01-01', '2020-01-01', 'Chief'),
    ('James', 'T.', 'Johnson', 'Male', '2345678901', 'james.johnson@example.com', '1990-02-02', '2021-03-15', 'Senior'),
    ('Emily', 'M.', 'Davis', 'Female', '3456789012', 'emily.davis@example.com', '1995-03-03', '2022-04-20', 'Junior'),
    ('Michael', DEFAULT, 'Brown', 'Male', '4567890123', 'michael.brown@example.com', '1988-04-10', '2018-05-22', 'Senior'),
    ('Sara', DEFAULT, 'Johnson', 'Female', '5678901234', 'sara.johnson@example.com', '1992-07-25', '2020-07-01', 'Junior');
GO

SELECT * FROM Barbers
--###############################################################################################
-- -- TESTING:
-- -- Вставте дані для перевірки тригера:
-- -- Вставляємо першого Chief (повинно пройти успішно)
-- INSERT INTO Barbers (FirstName, MiddleName, LastName, Gender, Phone, Email, DateOfBirth, HireDate, Position)
-- VALUES ('John', 'A.', 'Smith', 'Male', '1234567890', 'john.smith@example.com', '1985-01-01', '2020-01-01', 'Chief');
-- -- Вставляємо другого Chief (повинно викликати помилку)
-- INSERT INTO Barbers (FirstName, MiddleName, LastName, Gender, Phone, Email, DateOfBirth, HireDate, Position)
-- VALUES ('Jane', 'B.', 'Doe', 'Female', '0987654321', 'jane.doe@example.com', '1990-05-05', '2021-05-01', 'Chief');
--###############################################################################################

-- Таблиця для зберігання даних клієнтів
CREATE TABLE Clients (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(25) NOT NULL CHECK (FirstName != ''),
    MiddleName NVARCHAR(25) NOT NULL DEFAULT '',
    LastName NVARCHAR(25) NOT NULL CHECK (LastName != ''),
    Phone NVARCHAR(20) NOT NULL UNIQUE CHECK (Phone LIKE '[0-9]%' AND LEN(Phone) BETWEEN 10 AND 15),
    Email NVARCHAR(50) NOT NULL UNIQUE CHECK (Email LIKE '%@%.%' AND Email NOT LIKE '% %'),
    isDeleted BIT NOT NULL DEFAULT 0,
    isActive BIT NOT NULL DEFAULT 1,
    Created DATETIME NOT NULL DEFAULT GETDATE(),
    Updated DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Вставка тестових даних для клієнтів
INSERT INTO Clients (FirstName, MiddleName, LastName, Phone, Email)
VALUES
    ('Alice', DEFAULT, 'Brown', '4567890123', 'alice.brown@example.com'),
    ('Bob', 'N.', 'Wilson', '5678901234', 'bob.wilson@example.com'),
    ('Charlie', 'M.', 'Davis', '6789012345', 'charlie.davis@example.com'),
    ('David', DEFAULT, 'Smith', '7890123456', 'david.smith@example.com'),
    ('Eva', 'J.', 'Taylor', '8901234567', 'eva.taylor@example.com'),
    ('Fay', DEFAULT, 'Green', '9012345678', 'fay.green@example.com'),
    ('George', 'L.', 'Adams', '1234567890', 'george.adams@example.com'),
    ('Hannah', DEFAULT, 'Parker', '2345678901', 'hannah.parker@example.com'),
    ('Ian', 'C.', 'Roberts', '3456789012', 'ian.roberts@example.com'),
    ('Jill', 'A.', 'Morris', '4567890124', 'jill.morris@example.com'),
    ('Kevin', DEFAULT, 'Jackson', '5678901235', 'kevin.jackson@example.com'),
    ('Laura', 'B.', 'Walker', '6789012346', 'laura.walker@example.com'),
    ('Mia', DEFAULT, 'Scott', '7890123457', 'mia.scott@example.com'),
    ('Nathan', 'W.', 'Lewis', '8901234568', 'nathan.lewis@example.com'),
    ('Olivia', DEFAULT, 'Harris', '9012345679', 'olivia.harris@example.com'),
    ('Paul', 'S.', 'Carter', '0123456781', 'paul.carter@example.com'),
    ('Quinn', DEFAULT, 'Martinez', '1234567892', 'quinn.martinez@example.com'),
    ('Rachel', 'E.', 'Baker', '2345678903', 'rachel.baker@example.com'),
    ('Sam', 'F.', 'Davis', '3456789014', 'sam.davis@example.com');
GO

SELECT * FROM Clients

-- Таблиця для фідбеків та оцінок клієнтів
CREATE TABLE Feedbacks (
    Id INT PRIMARY KEY IDENTITY(1,1),
    ClientID INT NOT NULL,
    BarberID INT NOT NULL,
    FeedbackText NVARCHAR(1024),
    FeedbackDate DATETIME NOT NULL DEFAULT GETDATE(),
    Rating NVARCHAR(9) NOT NULL CHECK (Rating IN ('Very Bad', 'Bad', 'Normal', 'Good', 'Excellent')),
    isDeleted BIT NOT NULL DEFAULT 0,
    isActive BIT NOT NULL DEFAULT 1,
    Created DATETIME NOT NULL DEFAULT GETDATE(),
    Updated DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (ClientID) REFERENCES Clients(Id) ON DELETE CASCADE,
    FOREIGN KEY (BarberID) REFERENCES Barbers(Id) ON DELETE CASCADE
);
GO


-- Таблиця для послуг, які надають барбери
CREATE TABLE Services (
    Id INT PRIMARY KEY IDENTITY(1,1),
    ServiceName NVARCHAR(50) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL CHECK (Price > 0),
    Duration INT NOT NULL, -- тривалість у хвилинах
    isDeleted BIT NOT NULL DEFAULT 0,
    isActive BIT NOT NULL DEFAULT 1,
    Created DATETIME NOT NULL DEFAULT GETDATE(),
    Updated DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Вставка тестових даних для послуг
INSERT INTO Services (ServiceName, Price, Duration)
VALUES
    ('Haircut', 20.00, 30),
    ('Beard Trim', 15.00, 15),
    ('Shave', 25.00, 40),
    ('Full Styling', 30.00, 45),
    ('Hair Color', 50.00, 60);
GO

-- Таблиця для зв'язку барбера та його послуг
CREATE TABLE BarberServices (
    BarberID INT,
    ServiceID INT,
    isDeleted BIT NOT NULL DEFAULT 0,
    isActive BIT NOT NULL DEFAULT 1,
    Created DATETIME NOT NULL DEFAULT GETDATE(),
    Updated DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (BarberID, ServiceID),
    FOREIGN KEY (BarberID) REFERENCES Barbers(Id) ON DELETE CASCADE,
    FOREIGN KEY (ServiceID) REFERENCES Services(Id) ON DELETE CASCADE
);
GO

-- Вставка тестових даних для зв'язку барберів і послуг
INSERT INTO BarberServices (BarberID, ServiceID)
VALUES
    (1, 1), -- John Smith can do Haircut
    (2, 1), -- James Johnson can do Haircut
    (2, 2), -- James Johnson can do Beard Trim
    (3, 3), -- Emily Davis can do Shave
    (4, 4), -- Michael Brown can do Full Styling
    (5, 5); -- Sara Johnson can do Hair Color
GO

-- Таблиця для зберігання розкладу роботи барберів
CREATE TABLE BarberSchedule (
    Id INT PRIMARY KEY IDENTITY(1,1),
    BarberID INT NOT NULL,
    Date DATE NOT NULL,
    StartTime DATETIME NOT NULL,
    EndTime DATETIME NOT NULL,
    isDeleted BIT NOT NULL DEFAULT 0,
    isActive BIT NOT NULL DEFAULT 1,
    Created DATETIME NOT NULL DEFAULT GETDATE(),
    Updated DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (BarberID) REFERENCES Barbers(Id) ON DELETE CASCADE,
    CONSTRAINT UQ_Schedule UNIQUE (BarberID, Date, StartTime, EndTime)
);
GO

-- Вставка тестових даних для розкладу барберів
INSERT INTO BarberSchedule (BarberID, Date, StartTime, EndTime)
VALUES
    (1, '2023-11-01', '09:00', '13:00'),
    (2, '2023-11-01', '10:00', '14:00'),
    (3, '2023-11-02', '11:00', '15:00'),
    (4, '2023-11-03', '12:00', '16:00'),
    (5, '2023-11-04', '13:00', '17:00');
GO

-- Тригер для перевірки, щоб EndTime не був меншим за StartTime
CREATE TRIGGER trg_CheckEndTime
ON BarberSchedule
AFTER INSERT, UPDATE
AS
BEGIN
    -- Перевірка на те, що EndTime не менший за StartTime
    IF EXISTS (SELECT 1 FROM INSERTED I
               WHERE I.EndTime < I.StartTime)
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50001, 'EndTime cannot be earlier than StartTime.', 1;
    END
END;
GO

-- тригер для перевірки перетинів часу:
CREATE TRIGGER trg_ValidateScheduleOverlap
ON BarberSchedule
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM BarberSchedule BS
        JOIN INSERTED I ON BS.BarberID = I.BarberID
        WHERE I.Date = BS.Date
          AND I.StartTime < BS.EndTime
          AND I.EndTime > BS.StartTime
          AND BS.isDeleted = 0 AND BS.isActive = 1
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50005, 'Schedule overlaps detected.', 1;
    END;
END;
GO


-- Таблиця для записів клієнтів
CREATE TABLE Appointments (
    Id INT PRIMARY KEY IDENTITY(1,1),
    BarberID INT NOT NULL,
    ClientID INT NOT NULL,
    AppointmentDate DATETIME NOT NULL,
    TotalCost DECIMAL(10, 2) NOT NULL DEFAULT 0 CHECK (TotalCost >= 0),
    FeedbackID INT NULL,
    isDeleted BIT NOT NULL DEFAULT 0,
    isActive BIT NOT NULL DEFAULT 1,
    Created DATETIME NOT NULL DEFAULT GETDATE(),
    Updated DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (BarberID) REFERENCES Barbers(Id) ON DELETE CASCADE,
    FOREIGN KEY (ClientID) REFERENCES Clients(Id) ON DELETE CASCADE,
    FOREIGN KEY (FeedbackID) REFERENCES Feedbacks(Id) ON DELETE NO ACTION
);
GO

-- Вставка тестових даних для записів клієнтів
INSERT INTO Appointments (BarberID, ClientID, AppointmentDate)
VALUES
    (1, 1, '2023-11-20 10:00:00'), -- Alice with Barber John Smith
    (2, 2, '2023-11-20 11:00:00'), -- Bob with Barber James Johnson
    (3, 3, '2023-11-20 12:00:00'), -- Charlie with Barber Emily Davis
    (1, 4, '2023-11-21 09:00:00'), -- David with Barber John Smith
    (2, 5, '2023-11-21 10:00:00'), -- Eva with Barber James Johnson
    (3, 6, '2023-11-21 11:00:00'), -- Fay with Barber Emily Davis
    (1, 7, '2023-11-22 09:00:00'), -- George with Barber John Smith
    (2, 8, '2023-11-22 10:00:00'), -- Hannah with Barber James Johnson
    (3, 9, '2023-11-22 11:00:00'), -- Ian with Barber Emily Davis
    (1, 10, '2023-11-23 09:00:00'), -- Jill with Barber John Smith
    (2, 11, '2023-11-23 10:00:00'), -- Kevin with Barber James Johnson
    (3, 12, '2023-11-23 11:00:00'), -- Laura with Barber Emily Davis
    (1, 13, '2023-11-24 09:00:00'), -- Mia with Barber John Smith
    (2, 14, '2023-11-24 10:00:00'), -- Nathan with Barber James Johnson
    (3, 15, '2023-11-24 11:00:00'), -- Olivia with Barber Emily Davis
    (1, 16, '2023-11-25 09:00:00'), -- Paul with Barber John Smith
    (2, 17, '2023-11-25 10:00:00'), -- Quinn with Barber James Johnson
    (3, 18, '2023-11-25 11:00:00'); -- Rachel with Barber Emily Davis
GO

CREATE TABLE AppointmentServices (
    Id INT PRIMARY KEY IDENTITY(1,1),
    AppointmentID INT NOT NULL,
    ServiceID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1 CHECK (Quantity > 0),
    isDeleted BIT NOT NULL DEFAULT 0,
    isActive BIT NOT NULL DEFAULT 1,
    Created DATETIME NOT NULL DEFAULT GETDATE(),
    Updated DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(Id) ON DELETE CASCADE,
    FOREIGN KEY (ServiceID) REFERENCES Services(Id) ON DELETE CASCADE
);
GO


-- Таблиця архіву відвідувань
CREATE TABLE VisitHistory (
    Id INT PRIMARY KEY IDENTITY(1,1),
    BarberID INT NOT NULL,
    ClientID INT NOT NULL,
    ServiceID INT NOT NULL,
    VisitDate DATE NOT NULL,
    TotalCost DECIMAL(10, 2) NOT NULL,
    Feedback NVARCHAR(1024),
    Rating NVARCHAR(9) NOT NULL CHECK (Rating IN ('Very Bad', 'Bad', 'Normal', 'Good', 'Excellent')),
    isDeleted BIT NOT NULL DEFAULT 0,
    isActive BIT NOT NULL DEFAULT 1,
    Created DATETIME NOT NULL DEFAULT GETDATE(),
    Updated DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (BarberID) REFERENCES Barbers(Id) ON DELETE CASCADE,
    FOREIGN KEY (ClientID) REFERENCES Clients(Id) ON DELETE CASCADE,
    FOREIGN KEY (ServiceID) REFERENCES Services(Id) ON DELETE CASCADE
);
GO

-- Вставка тестовых данных для архіву відвідувань
INSERT INTO VisitHistory (BarberID, ClientID, ServiceID, VisitDate, TotalCost, Rating, Feedback)
VALUES
    (1, 1, 1, '2023-11-20', 20.00, 'Excellent', 'Great haircut, very professional!'),
    (2, 2, 2, '2023-11-20', 15.00, 'Good', 'Nice beard trim, but a bit rushed.'),
    (3, 3, 3, '2023-11-20', 25.00, 'Normal', 'Decent shave, but the atmosphere could be better.'),
    (1, 4, 1, '2023-11-21', 20.00, 'Very Bad', 'The haircut was uneven, not satisfied.'),
    (2, 5, 2, '2023-11-21', 15.00, 'Bad', 'The beard trim was fine, but not as expected.'),
    (3, 6, 3, '2023-11-21', 25.00, 'Good', 'Great shave, will come again!'),
    (1, 7, 1, '2023-11-22', 20.00, 'Excellent', 'A fantastic haircut, would highly recommend!'),
    (2, 8, 2, '2023-11-22', 15.00, 'Good', 'Beard trim was fine, but not the best experience.'),
    (3, 9, 3, '2023-11-22', 25.00, 'Excellent', 'Superb shave, I’ll definitely return!'),
    (1, 10, 1, '2023-11-23', 20.00, 'Good', 'Nice trim, but not exactly what I asked for.'),
    (2, 11, 2, '2023-11-23', 15.00, 'Normal', 'Beard trim was okay, could be a little more detailed.'),
    (3, 12, 3, '2023-11-23', 25.00, 'Very Bad', 'Not a great experience, hair was cut unevenly.'),
    (1, 13, 1, '2023-11-24', 20.00, 'Good', 'Great haircut, but a bit too rushed.'),
    (2, 14, 2, '2023-11-24', 15.00, 'Excellent', 'Fantastic trim, very happy with the result!'),
    (3, 15, 3, '2023-11-24', 25.00, 'Bad', 'Shave was too rough, and it didn’t look great.'),
    (1, 16, 1, '2023-11-25', 20.00, 'Excellent', 'Perfect haircut, will definitely return!'),
    (2, 17, 2, '2023-11-25', 15.00, 'Normal', 'Beard was trimmed well, but the service was slow.'),
    (3, 18, 3, '2023-11-25', 25.00, 'Good', 'Nice shave, but the chair was uncomfortable.'),
    -- Додаткові записи для деяких клієнтів (2-4 відвідувань):
    (1, 1, 1, '2023-11-26', 20.00, 'Excellent', 'Still amazing as the first visit!'),
    (3, 3, 3, '2023-11-27', 25.00, 'Normal', 'Shave was good, but could be a bit smoother.'),
    (2, 5, 2, '2023-11-27', 15.00, 'Good', 'The beard trim was better this time.'),
    (1, 7, 1, '2023-11-28', 20.00, 'Excellent', 'Love the haircut, as usual!'),
    (2, 8, 2, '2023-11-28', 15.00, 'Normal', 'Beard trim was fine, but could have been more detailed.'),
    (1, 10, 1, '2023-11-29', 20.00, 'Very Bad', 'Not happy with the haircut this time.'),
    (2, 17, 2, '2023-11-29', 15.00, 'Excellent', 'Fantastic beard trim, perfect shape!')
GO


-- Використовуючи тригери, функції користувача, збережені процедури реалізуйте наступну функціональність:

-- ■ 1. Повернути ПІБ всіх барберів салону.
-- Функція для повернення ПІБ всіх барберів
CREATE FUNCTION GetBarberFullNames()
RETURNS TABLE
AS
RETURN
    SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS FullName
    FROM Barbers
    WHERE isDeleted = 0 AND isActive = 1;
GO
-------------------- TEST:
SELECT * FROM GetBarberFullNames();                   --DROP FUNCTION GetBarberFullNames;
GO

-- ■ 2. Повернути інформацію про всіх синьйор-барберів.
-- Функція для отримання інформації про барберів по типу
CREATE FUNCTION GetBarbersByType(@BarberType NVARCHAR(50)) --@BarberType = 'Senior'
RETURNS TABLE
AS
RETURN
    SELECT *
    FROM Barbers
    WHERE Position = @BarberType AND isDeleted = 0 AND isActive = 1;
GO
-------------------- TEST:
SELECT * FROM GetBarbersByType('Senior');
GO

-- ■ 3. Повернути інформацію про всіх барберів, які можуть надати послугу традиційного гоління бороди.
-- Функція для отримання барберів для конкретної послуги
CREATE FUNCTION GetBarbersByService(@ServiceName NVARCHAR(50)) -- @ServiceName = 'Shave'
RETURNS TABLE
AS
RETURN
    SELECT B.ID, B.FirstName, B.LastName, B.Gender, B.Phone, B.Email, B.Position, B.DateOfBirth, B.HireDate
    FROM Barbers B
    JOIN BarberServices BS ON B.Id = BS.BarberID
    JOIN Services S ON BS.ServiceID = S.Id
    WHERE S.ServiceName = @ServiceName AND B.isDeleted = 0 AND B.isActive = 1;
GO
-------------------- TEST:
SELECT * FROM GetBarbersByService('Shave');
GO

-- ■ 4. Повернути інформацію про всіх барберів, які можуть надати конкретну послугу. Інформація про потрібну послугу надається як параметр.
-- Процедура для отримання барберів для конкретної послуги
CREATE PROCEDURE BarbersByService(@ServiceName NVARCHAR(50))  --@ServiceName = 'Haircut'
AS
BEGIN
    SELECT BS.ServiceID, S.ServiceName, BS.BarberID, B.FirstName, B.LastName, B.Gender, B.Position, B.Phone, B.Email, B.DateOfBirth, B.HireDate
    FROM Barbers B
    JOIN BarberServices BS ON B.ID = BS.BarberID
    JOIN Services S ON BS.ServiceID = S.ID
    WHERE S.ServiceName = @ServiceName AND B.isDeleted = 0 AND B.isActive = 1;
END;
GO
-------------------- TEST:
EXEC BarbersByService @ServiceName = 'Haircut';                         --DROP PROCEDURE BarbersByService;
GO

-- ■ 5. Повернути інформацію про всіх барберів, які працюють понад зазначену кількість років. Кількість років передається як параметр.
-- Процедура для отримання барберів, які працюють більше заданого часу
CREATE PROCEDURE GetBarbersByYears(@Years INT)
AS
BEGIN
    SELECT *
    FROM Barbers
    WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > @Years AND isDeleted = 0 AND isActive = 1;
END;
GO
-------------------- TEST:
EXECUTE GetBarbersByYears @Years = 3
GO

-- ■ 6. Повернути кількість синьйор-барберів та кількість джуніор-барберів.
-- Процедура для отримання кількості синьйор та джуніор барберів
CREATE PROCEDURE GetBarberCounts
AS
BEGIN
    SELECT
        (SELECT COUNT(*) FROM Barbers WHERE Position = 'Senior' AND isDeleted = 0 AND isActive = 1) AS SeniorBarberCount,
        (SELECT COUNT(*) FROM Barbers WHERE Position = 'Junior' AND isDeleted = 0 AND isActive = 1) AS JuniorBarberCount;
END;
GO
-------------------- TEST:
EXEC GetBarberCounts
GO

-- ■ 7. Повернути інформацію про постійних клієнтів. Критерій постійного клієнта: був у салоні задану кількість разів. Кількість передається як параметр.
CREATE PROCEDURE GetFrequentClients
    @VisitCount INT -- Параметр для кількості відвідувань
AS
BEGIN
    SELECT C.FirstName + ' ' + C.LastName AS ClientName, COUNT(V.Id) AS VisitCount
    FROM Clients C
    JOIN VisitHistory V ON C.Id = V.ClientID
    WHERE C.isDeleted = 0 AND C.isActive = 1
    GROUP BY C.FirstName, C.LastName
    HAVING COUNT(V.Id) >= @VisitCount;
END;
GO
-------------------- TEST:
EXEC GetFrequentClients @VisitCount = 2;
GO
SELECT COUNT(*) AS TotalClientsCount FROM Clients
GO

-- ■ 8. Заборонити можливість видалення інформації про чиф-барбер, якщо не додано другий чиф-барбер.
CREATE TRIGGER PreventChiefBarberDeletion
ON Barbers
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM Barbers WHERE Position = 'Chief' AND isDeleted = 0)
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50001, 'You cannot remove a chef barber unless you have added a second chef barber.', 1;
        PRINT 'You cannot remove a chef barber unless you have added a second chef barber.';
    END
    ELSE
    BEGIN
        DELETE FROM Barbers WHERE ID IN (SELECT ID FROM DELETED);
    END
END;
GO
-------------------- TEST:
-- Спочатку перевіримо кількість чиф-барберів
SELECT * FROM Barbers WHERE Position = 'Chief' AND isDeleted = 0;
GO
-- -- Спроба видалення чиф-барбера
-- DELETE FROM Barbers WHERE ID = 1;  -- Припустимо, що ID 1 — це чиф-барбер
-- GO

-- ■ 9. Заборонити додавати барберів молодше 21 року
CREATE TRIGGER PreventYoungBarberInsert
ON Barbers
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM INSERTED WHERE DATEDIFF(YEAR, DateOfBirth, GETDATE()) < 21)
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50001, 'Barber cannot be younger than 21.', 1;
        PRINT 'Barber cannot be younger than 21 !!!';
    END
    ELSE
    BEGIN
        INSERT INTO Barbers (FirstName, MiddleName, LastName, DateOfBirth, Position, Gender, Phone, Email, HireDate, isActive, isDeleted)
        SELECT FirstName, MiddleName, LastName, DateOfBirth, Position, Gender, Phone, Email, HireDate, isActive, isDeleted
        FROM INSERTED;
    END
END;
GO
-------------------- TEST:
-- -- Спроба вставити барбера молодше 21 року
-- INSERT INTO Barbers (FirstName, MiddleName, LastName, DateOfBirth, Position, Gender, Phone, Email, HireDate, isActive, isDeleted)
-- VALUES ('John', 'A', 'Doe', '2005-05-15', 'Junior', 'M', '123456789', 'john.doe@example.com', GETDATE(), 1, 0);
-- GO

-- Функції користувача:

-- Створіть наступні функції користувача:
-- ■ 10. Функція користувача повертає вітання в стилі «Hello, ІМ'Я!» Де ІМ'Я передається як параметр. Наприклад, якщо передали Nick, то буде Hello, Nick!
CREATE FUNCTION GetGreeting(@Name NVARCHAR(50))
RETURNS NVARCHAR(100)
AS
BEGIN
    RETURN 'Hello, ' + @Name + '!';
END;
GO
-- Викликаємо функцію GetGreeting для перевірки
SELECT dbo.GetGreeting('Nick');
GO

-- ■ 11. Функція користувача повертає інформацію про поточну кількість хвилин;
CREATE FUNCTION GetCurrentMinutes(@DateFrom DATETIME)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(MINUTE, @DateFrom, GETDATE());
END;
GO
-- Викликаємо функцію GetCurrentMinutes для перевірки 
SELECT dbo.GetCurrentMinutes('12/01/2024 23:59:59');
GO

-- ■ 12. Функція користувача повертає інформацію про поточний рік;
CREATE FUNCTION GetCurrentYear()
RETURNS INT
AS
BEGIN
    RETURN YEAR(GETDATE());
END;
GO
-- Викликаємо функцію GetCurrentYear для перевірки
SELECT dbo.GetCurrentYear();
GO

-- ■ 13. Функція користувача повертає інформацію про те: парний або непарний рік;
CREATE FUNCTION IsEvenYear()
RETURNS NVARCHAR(10)
AS
BEGIN
    DECLARE @result NVARCHAR(10);

    IF YEAR(GETDATE()) % 2 = 0
        SET @result = 'Even year';
    ELSE
        SET @result = 'Odd year';

    RETURN @result; -- Ensure this is the last statement
END;
GO

-- Викликаємо функцію IsEvenYear для перевірки
SELECT dbo.IsEvenYear();
GO

-- ■ 14. Функція користувача приймає число і повертає yes, якщо число просте і no, якщо число не просте;
CREATE FUNCTION IsPrime(@Number INT)
RETURNS NVARCHAR(3)
AS
BEGIN
    DECLARE @i INT, @isPrime BIT;
    DECLARE @result NVARCHAR(3);

    SET @isPrime = 1;

    -- Handle edge case for numbers less than or equal to 1
    IF @Number <= 1
        SET @isPrime = 0;

    -- Check for divisors starting from 2 up to the square root of @Number
    SET @i = 2;
    WHILE @i <= SQRT(@Number)
    BEGIN
        IF @Number % @i = 0
        BEGIN
            SET @isPrime = 0;
            BREAK;
        END
        SET @i = @i + 1;
    END

    -- Assign result based on @isPrime value
    IF @isPrime = 1
        SET @result = 'Yes';
    ELSE
        SET @result = 'No';

    RETURN @result; -- Ensure there is only one RETURN statement
END;
GO

-- Викликаємо функцію IsPrime для перевірки
SELECT dbo.IsPrime(7);  -- Очікуваний результат: 'Yes'
GO
SELECT dbo.IsPrime(10);  -- Очікуваний результат: 'No'
GO

-- ■ 15. Функція користувача приймає як параметри п'ять чисел. Повертає суму мінімального та максимального значення з переданих п'яти параметрів;
CREATE FUNCTION MinMaxSum(@Num1 INT, @Num2 INT, @Num3 INT, @Num4 INT, @Num5 INT)
RETURNS INT
AS
BEGIN
    DECLARE @Min INT, @Max INT;

    SET @Min = (SELECT MIN(Value) FROM (VALUES (@Num1), (@Num2), (@Num3), (@Num4), (@Num5)) AS Value(Value));
    SET @Max = (SELECT MAX(Value) FROM (VALUES (@Num1), (@Num2), (@Num3), (@Num4), (@Num5)) AS Value(Value));

    RETURN @Min + @Max;
END;
GO
-- Викликаємо функцію MinMaxSum для перевірки
SELECT dbo.MinMaxSum(1, 3, 5, 7, 9);  -- Очікуваний результат: 10 (1 + 9)
GO

-- ■ 16. Функція користувача показує всі парні або непарні числа в переданому діапазоні. Функція приймає три параметри: початок діапазону, кінець діапазону, парне чи непарне показувати.
CREATE FUNCTION GetEvenOddInRange(@Start INT, @End INT, @Type NVARCHAR(5))
RETURNS TABLE
AS
RETURN
    SELECT Number
    FROM (VALUES (@Start), (@Start + 1), (@Start + 2), (@Start + 3), (@Start + 4), (@Start + 5)) AS Numbers(Number)
    WHERE (@Type = 'Even' AND Number % 2 = 0) OR (@Type = 'Odd' AND Number % 2 != 0);
GO
-- Викликаємо функцію GetEvenOddInRange для перевірки
SELECT * FROM dbo.GetEvenOddInRange(1, 10, 'Even');  -- Очікуваний результат: 2, 4, 6, 8, 10
GO
SELECT * FROM dbo.GetEvenOddInRange(1, 10, 'Odd');  -- Очікуваний результат: 1, 3, 5, 7, 9
GO

-- Збережені процедури:

-- Створіть наступні збережені процедури:
-- ■ 17. Збережена процедура виводить «Hello, world!»;
CREATE PROCEDURE HelloWorld
AS
BEGIN
    PRINT 'Hello, world!';
END;
GO
-- Викликаємо процедуру HelloWorld
EXEC HelloWorld;
GO

-- ■ 18. Збережена процедура повертає інформацію про поточний час;
CREATE PROCEDURE GetCurrentTime
AS
BEGIN
    SELECT CONVERT(VARCHAR, GETDATE(), 108) AS CurrentTime;
END;
GO
-- Викликаємо процедуру GetCurrentTime
EXEC dbo.GetCurrentTime;
GO

-- ■ 19. Збережена процедура повертає інформацію про поточну дату;
CREATE PROCEDURE GetCurrentDate
AS
BEGIN
    SELECT CONVERT(VARCHAR, GETDATE(), 23) AS CurrentDate;
END;
GO
-- Викликаємо процедуру GetCurrentDate
EXEC dbo.GetCurrentDate;
GO

-- ■ 20. Збережена процедура приймає три числа і повертає їхню суму;
CREATE PROCEDURE SumOfThreeNumbers(@Num1 INT, @Num2 INT, @Num3 INT)
AS
BEGIN
    SELECT @Num1 + @Num2 + @Num3 AS Sum;
END;
GO
-- Викликаємо процедуру SumOfThreeNumbers
EXEC dbo.SumOfThreeNumbers @Num1 = 5, @Num2 = 10, @Num3 = 15;  -- Очікуваний результат: 30
GO

-- ■ 21. Збережена процедура приймає три числа і повертає середньоарифметичне трьох чисел;
CREATE PROCEDURE AverageOfThreeNumbers(@Num1 INT, @Num2 INT, @Num3 INT)
AS
BEGIN
    SELECT (@Num1 + @Num2 + @Num3) / 3.0 AS Average;
END;
GO
-- Викликаємо процедуру AverageOfThreeNumbers
EXEC dbo.AverageOfThreeNumbers @Num1 = 5, @Num2 = 10, @Num3 = 15;  -- Очікуваний результат: 10
GO

-- ■ 22. Збережена процедура приймає три числа і повертає максимальне значення;
CREATE PROCEDURE MaxOfThreeNumbers(@Num1 INT, @Num2 INT, @Num3 INT)
AS
BEGIN
    SELECT
        CASE
            WHEN @Num1 >= @Num2 AND @Num1 >= @Num3 THEN @Num1
            WHEN @Num2 >= @Num1 AND @Num2 >= @Num3 THEN @Num2
            ELSE @Num3
        END AS MaxValue;
END;
GO
-- Викликаємо процедуру MaxOfThreeNumbers
EXEC dbo.MaxOfThreeNumbers @Num1 = 5, @Num2 = 10, @Num3 = 15;  -- Очікуваний результат: 15
GO

-- ■ 23. Збережена процедура приймає три числа і повертає мінімальне значення;
CREATE PROCEDURE MinOfThreeNumbers(@Num1 INT, @Num2 INT, @Num3 INT)
AS
BEGIN
    SELECT
        CASE
            WHEN @Num1 <= @Num2 AND @Num1 <= @Num3 THEN @Num1
            WHEN @Num2 <= @Num1 AND @Num2 <= @Num3 THEN @Num2
            ELSE @Num3
        END AS MinValue;
END;
GO
-- Викликаємо процедуру MinOfThreeNumbers
EXEC dbo.MinOfThreeNumbers @Num1 = 5, @Num2 = 10, @Num3 = 15;  -- Очікуваний результат: 5
GO

-- ■ 24. Збережена процедура приймає число та символ. В результаті роботи збереженої процедури відображається  лінія довжиною, що дорівнює числу.
-- 	Лінія побудована ізсимволу, вказаного у другому параметрі.
-- 	Наприклад, якщо було передано 5 та #, ми отримаємо лінію такого виду #####;
CREATE PROCEDURE DrawLine(@Length INT, @Symbol CHAR(1))
AS
BEGIN
    DECLARE @Line NVARCHAR(100) = '';
    WHILE @Length > 0
    BEGIN
        SET @Line = @Line + @Symbol;
        SET @Length = @Length - 1;
    END
    PRINT @Line;
END;
GO
-- Викликаємо процедуру DrawLine
EXEC dbo.DrawLine @Length = 123, @Symbol = '#';  -- Очікуваний результат: #####
GO

-- ■ 25. Збережена процедура приймає як параметр число і повертає його факторіал. Формула розрахунку факторіалу: n! = 1 * 2 * ... n. Наприклад, 3! = 1 * 2 * 3 = 6;
CREATE PROCEDURE Factorial(@Number INT)
AS
BEGIN
    DECLARE @Result INT = 1, @i INT;
    SET @i = 1;

    WHILE @i <= @Number
    BEGIN
        SET @Result = @Result * @i;
        SET @i = @i + 1;
    END

    SELECT @Result AS Factorial;
END;
GO
-- Викликаємо процедуру Factorial
EXEC dbo.Factorial @Number = 5;  -- Очікуваний результат: 120 (5! = 5 * 4 * 3 * 2 * 1)
GO

-- ■ 26. Збережена процедура приймає два числові параметри. Перший параметр – це число. Другий параметр – це ступінь.
-- 	Процедура повертає число, зведене до ступеня.
-- 	Наприклад, якщо параметри дорівнюють 2 і 3, тоді повернеться 2 у третьому ступені, тобто 8.
CREATE PROCEDURE PowerOfNumber(@Base INT, @Exponent INT)
AS
BEGIN
    SELECT POWER(@Base, @Exponent) AS Result;
END;
GO
-- Викликаємо процедуру PowerOfNumber
EXEC dbo.PowerOfNumber @Base = 5, @Exponent = 3;  -- Очікуваний результат: 8 (2^3)
GO