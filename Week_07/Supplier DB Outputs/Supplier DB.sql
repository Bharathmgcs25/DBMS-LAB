CREATE DATABASE SupplierDB;
USE SupplierDB;

CREATE TABLE Supplier (
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    address VARCHAR(100)
);

CREATE TABLE Part (
    pid INT PRIMARY KEY,
    pname VARCHAR(50),
    color VARCHAR(20)
);

CREATE TABLE Catalog (
    sid INT,
    pid INT,
    cost DECIMAL(10,2),
    PRIMARY KEY (sid, pid),
    FOREIGN KEY (sid) REFERENCES Supplier(sid),
    FOREIGN KEY (pid) REFERENCES Part(pid)
);

INSERT INTO Supplier VALUES
(10001, 'Acme Widget', 'Bengaluru'),
(10002, 'Johns', 'Mysuru'),
(10003, 'Reliance', 'Hyderabad'),
(10004, 'VisionTech', 'Bengaluru');

INSERT INTO Part VALUES
(20001, 'Book', 'Red'),
(20002, 'Charger', 'Black'),
(20003, 'Mobile', 'Red'),
(20004, 'Pen', 'Blue'),
(20005, 'Pencil', 'Red');

INSERT INTO Catalog VALUES
(10001, 20001, 120.00),
(10001, 20002, 200.00),
(10001, 20003, 300.00),
(10001, 20004, 150.00),
(10001, 20005, 180.00),

(10002, 20001, 130.00),
(10002, 20003, 320.00),
(10002, 20005, 190.00),

(10003, 20002, 210.00),
(10003, 20003, 250.00),

(10004, 20001, 140.00),
(10004, 20003, 280.00),
(10004, 20005, 170.00);

SELECT DISTINCT p.pname
FROM Part p
JOIN Catalog c ON p.pid = c.pid;

SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
    SELECT *
    FROM Part p
    WHERE NOT EXISTS (
        SELECT *
        FROM Catalog c
        WHERE c.sid = s.sid AND c.pid = p.pid
    )
);

SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
    SELECT *
    FROM Part p
    WHERE p.color = 'Red' AND NOT EXISTS (
        SELECT *
        FROM Catalog c
        WHERE c.sid = s.sid AND c.pid = p.pid
    )
);

SELECT p.pname
FROM Part p
WHERE p.pid IN (
    SELECT c.pid
    FROM Catalog c
    JOIN Supplier s ON c.sid = s.sid
    WHERE s.sname = 'Acme Widget'
)
AND p.pid NOT IN (
    SELECT c.pid
    FROM Catalog c
    JOIN Supplier s ON c.sid = s.sid
    WHERE s.sname <> 'Acme Widget'
);

SELECT DISTINCT c1.sid
FROM Catalog c1
WHERE c1.cost > (
    SELECT AVG(c2.cost)
    FROM Catalog c2
    WHERE c2.pid = c1.pid
);

SELECT p.pid, s.sname
FROM Supplier s
JOIN Catalog c ON s.sid = c.sid
JOIN Part p ON p.pid = c.pid
WHERE c.cost = (
    SELECT MAX(c2.cost)
    FROM Catalog c2
    WHERE c2.pid = p.pid);
    
    