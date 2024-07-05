--Create tables WITH appropriate data types and constraints

CREATE TABLE Customers (
   CustomerID           INT IDENTITY(1,1)    NOT NULL PRIMARY KEY,
   FirstName            VARCHAR(150)         NOT NULL,
   LastName             VARCHAR(150)         NOT NULL,
   BirthDate            DATE	             NULL,
   Email                VARCHAR(150)         NOT NULL UNIQUE,
   DateJoined           DATETIME             NOT NULL,
   CreatedAt			DATETIME			 DEFAULT GETDATE(),
   IsEnable				BIT					 NOT NULL DEFAULT 1
   )

   
CREATE TABLE Products (
   ProductID            INT IDENTITY(1,1)    NOT NULL PRIMARY KEY,
   ProductName          VARCHAR(150)         NOT NULL,
   Category             VARCHAR(150)         NOT NULL,
   Price                DECIMAL(10,2)        NOT NULL,
   StockQuantity        INT                  NOT NULL CHECK (StockQuantity >= 0),
   [Status]				BIT					 NOT NULL DEFAULT 1
)

CREATE TABLE Orders (
   OrderID              INT IDENTITY(1,1)    NOT NULL PRIMARY KEY,
   CustomerID           INT                  NOT NULL,
   OrderDate            DATETIME             NOT NULL,
   TotalAmount          DECIMAL(10,2)        NOT NULL,
   FOREIGN KEY(CustomerID) REFERENCES Customers (CustomerID)
)

CREATE TABLE Orderdetails (
   OrderDetailID        INT IDENTITY(1,1)    NOT NULL,
   OrderID              INT                  NOT NULL,
   ProductID            INT                  NOT NULL,
   Quantity             INT                  NOT NULL,
   UnitPrice            DECIMAL(10,2)        NOT NULL,
   PRIMARY KEY(OrderDetailID),
   FOREIGN KEY (OrderID) REFERENCES Orders (OrderID),
   FOREIGN KEY (ProductID) REFERENCES Products (ProductID)
)

CREATE TABLE Reviews (
   ReviewID             INT IDENTITY(1,1)    NOT NULL,
   ProductID            INT                  NOT NULL,
   CustomerID           INT                  NOT NULL,
   Rating               DECIMAL(3,2)         NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
   ReviewText           VARCHAR(1000)        Null,
   ReviewDate           DATETIME             DEFAULT GETDATE(),
   PRIMARY KEY(ReviewID),
   FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID) ,
   FOREIGN KEY (ProductID) REFERENCES Products (ProductID)
)

--ALTER / ADD COLUMN / ADD CONSTRAINT / ALTER COLUMN

--ALTER TABLE Customers ADD Age INT
--ALTER TABLE Customers DROP COLUMN Age
--ALTER TABLE Customers ADD CONSTRAINT Age_Chck Check(Age>18)
--ALTER TABLE Customers ALTER COLUMN Age INT NOT NULL
--ALTER TABLE Customers ADD CONSTRAINT Age_Fill DEFAULT 20 FOR Age
--ALTER TABLE Customers ADD CONSTRAINT unique_Email UNIQUE(Email)



--INSERT sample data into each table to allow for meaningful Queries.

--BUlK INSERT Customers
--FROM 'C:\Users\Asus\DeskTOP\Customers.csv'
--WITH(
--FIELDTERMINATOR =',',
--ROWTERMINATOR='\n',
--FIRSTROW=2);

--BUlK INSERT Products
--FROM 'C:\Users\Asus\DeskTOP\Products.csv'
--WITH(
--FIELDTERMINATOR =',',
--ROWTERMINATOR='\n',
--FIRSTROW=2);

--BUlK INSERT Orders
--FROM 'C:\Users\Asus\DeskTOP\Orders.csv'
--WITH(
--FIELDTERMINATOR =',',
--ROWTERMINATOR='\n',
--FIRSTROW=2);

--BUlK INSERT OrderDetails
--FROM 'C:\Users\Asus\DeskTOP\OrderDetails.csv'
--WITH(
--FIELDTERMINATOR =',',
--ROWTERMINATOR='\n',
--FIRSTROW=2);

--BUlK INSERT Reviews
--FROM 'C:\Users\Asus\DeskTOP\Review.csv'
--WITH(
--FIELDTERMINATOR =',',
--ROWTERMINATOR='\n',
--FIRSTROW=2);

INSERT INTO Customers(FirstName,LastName,BirthDate,Email,DateJoined)
			VALUES('Ehsan','Soroush','01/01/1990','ehsansorush@Yahoo.com','01/01/2010'),
				  ('Sepehr','Forouzesh','01/11/1990','sepehrforouzesh@Gmail.com','02/02/2010'),
				  ('Arad','Moshfegh','01/11/2000','aradmoshfegh@Gmail.com','02/03/2010'),
				  ('Parsa','Pirouz Far','05/11/1995','parsapirouzfar@.com','03/03/2010'),
				  ('Hoda','Vafa','11/03/1993','hodavafa@Gmail.com','02/04/2010')

INSERT INTO Products(ProductName,Category,Price,StockQuantity)
			VALUES('Road Bottle Cage','Accessories',8.99,20),
				  ('Fender Set - Mountain','Accessories',21.98,30),
				  ('Touring Tire','Accessories',28.99,25),
				  ('Road-250 Red, 44','Bikes',2443.35,30),
				  ('Touring-3000 Blue, 58','Bikes',743.35,20),
				  ('Road-750 Black, 52','Bikes',539.99,10),
				  ('AWC Logo Cap','Clothing',8.64,15),
				  ('Men''s Sports Shorts -L','Clothing',21.98,30),
				  ('Racing Socks, L','Clothing',8.99,50),
				  ('Blade','Components',33.64,30)


INSERT INTO Orders(CustomerID,OrderDate,TotalAmount)
			VALUES(1,'02/01/2011',818.28),
				  (2,'02/02/2011',30.97),
				  (3,'03/03/2012',2501.33),
				  (4,'04/04/2013',574.55)

INSERT INTO Orders (CustomerID,OrderDate,TotalAmount)
			Values(1,'04/04/2013',539.99)

INSERT INTO Orderdetails(OrderID,ProductID,Quantity,UnitPrice)
			VALUES(1,1,1,8.99),
				  (1,5,1,743.35),
				  (1,8,3,21.98),
				  (2,2,1,21.98),
				  (2,9,1,8.99),
				  (3,3,2,28.99),
				  (3,4,1,2443.35),
				  (4,6,1,539.99),
				  (4,7,4,8.64)

INSERT INTO Orderdetails(OrderID,ProductID,Quantity,UnitPrice)
			Values(5,6,1,539.99)


INSERT INTO Reviews (ProductID,CustomerID,Rating,ReviewText,ReviewDate) 
			VALUES(1,1,5,'Fantsatic Bottle','03/03/2011'),
				  (5,1,2,'Problem in Right Pedals','03/03/2011'),
				  (8,1,3,NULL,NULL),
				  (3,3,4,'GOOD','04/04/2012'),
				  (6,4,1,'Bad','05/05/2013')

INSERT INTO Reviews (ProductID,CustomerID,Rating) 
			VALUES(7,4,5),(8,2,4)

--Part 2: Data ManipulatiON

--Data Update and DeletiON

DELETE FROM Customers
	WHERE CustomerID=4

UPDATE Customers 
	SET IsEnable=0
	WHERE CustomerID=1

--Part 3: Complex Queries


--3.1. JOIN

--3.1.1 List all orders along with customer and product details.

SELECT o.OrderID,c.*,p.*
FROM Orders o
JOIN Customers c	ON o.CustomerID=c.CustomerID
JOIN Reviews r		ON r.CustomerID=c.CustomerID
JOIN Products p	    ON p.ProductID=r.ProductID

--3.1.2 Show Customers who haven't placed any orders.

SELECT c.* 
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID=o.CustomerID 
WHERE OrderID IS NULL



SELECT c.* 
FROM Customers c
WHERE NOT EXISTS(SELECT 1 FROM Orders o WHERE o.CustomerID=c.CustomerID)

--3.2 AggregatiON

--3.2.1 Total sales per month.

SELECT YEAR(OrderDate)OrderYear,MONTH(OrderDate)OrderMonth,SUM(TotalAmount)TotalSales
FROM Orders
GROUP BY YEAR(OrderDate),MONTH(OrderDate)
Order by 1

--3.2.2 Average rating of each product.

SELECT ProductID,AVG(Rating) AVG_Rating 
FROM Reviews
GROUP BY(ProductID)

--3.2.3 Number of orders placed by each customer.

Select CustomerID,COUNT(OrderID)TotalNumOrder
FROM Orders
GROUP BY CustomerID
ORDER BY 1


-- 3.3 Subqueries and CTEs

--3.3.1-Find products that have never been ordered.

SELECT ProductID,productName
FROM(
	SELECT p.* 
	FROM Products p 
	LEFT JOIN Orderdetails o ON p.ProductID=o.ProductID
	WHERE OrderID is NULL
)a


--3.3.2-Identify customers who have spent more than a certain amount // Quantity

--3.3.2.1-certain amount

SELECT * 
FROM(
	SELECT c.* FROM Customers c
	JOIN Orders o ON c.CustomerID=o.CustomerID
	WHERE TotalAmount>1000
)a


--3.3.2.2 QUANTITY

Select DISTINCT c.* 
FROM Customers c
JOIN orders o ON c.CustomerID=o.CustomerID
JOIN Orderdetails od ON od.OrderID=o.OrderID
WHERE Quantity>2

--3.3.2.3 QUANTITY

WITH quantity AS (
	SELECT o.CustomerID FROM orders o
	JOIN Orderdetails od ON o.OrderID=od.OrderID
	WHERE Quantity>2
	)
SELECT DISTINCT * 
FROM Customers c 
JOIN quantity q
ON c.CustomerID=q.CustomerID

--3.3.3 List the TOP 5 most reviewed products.

WITH TOPN AS(
	SELECT ProductID,COUNT(Reviewid) Rv_Cnt FROM Reviews
	GROUP BY ProductID
	)
SELECT TOP 5 *
FROM TOPN
ORDER BY Rv_Cnt DESC,ProductID


--3.4- Window Functioss

--3.4.1 Rank products by total sales.

WITH RNK AS(
	SELECT p.ProductID,p.ProductName,SUM(od.UnitPrice*od.Quantity)TotalSales 
	FROM Orderdetails od
	JOIN Products p ON p.ProductID=od.ProductID
	GROUP BY p.ProductID,p.ProductName
	)
SELECT *,RANK()OVER(ORDER BY TotalSales DESC)Rnk_TotalSales 
FROM RNK

--3.4.2 Calculate running totals of sales per DAY.

GO
WITH RUNNING_TOTALS AS(
	SELECT OrderDate, SUM(TotalAmount)TotalSales 
	FROM Orders
	GROUP BY OrderDate
	)
SELECT *,SUM(TotalSales) OVER (ORDER BY OrderDate)CumulativeSum  
FROM RUNNING_TOTALS



--3.4.3 Show customer order COUNTs along WITH their RANKs.

SELECT *, DENSE_RANK()OVER(ORDER BY Order_CNT DESC)Rnk 
FROM(
	SELECT c.CustomerID,c.FirstName,c.LastName,COUNT(o.OrderID)Order_CNT 
	FROM Customers c
	JOIN orders o ON c.CustomerID=o.CustomerID
	GROUP BY c.CustomerID,c.FirstName,c.LastName
	)a


--Part 4: Advanced Functions and Optimization

--4.1 Built-In FunctiON

--4.1.1 - CONcatenate customer names into a single string.

Select CONCAT(FirstName,' ',LAStName) [Full Name]
FROM Customers


SELECT FirstName + ' ' + LAStName AS [Full Name] 
FROM Customers

--4.1.2 Extract YEAR and month FROM order dates.

SELECT OrderDate,YEAR(OrderDate)[OrderYear],MONTH(OrderDate)[OrderMonth],DAY(OrderDate)[OrderDay] 
FROM Orders

--4.2 JSON and Regular ExpressiONs

--4.2.1 Store and query product attributes stored in a JSON format

BEGIN TRANSACTION

		ALTER TABLE Products
		ADD Attributes NVARCHAR(MAX);
		
		UPDATE Products
		SET Attributes = '{"color": "Black", "size": "Medium"}'
		WHERE ProductID = 1;

		UPDATE Products
		SET Attributes = '{"color": "White", "size": "Large"}'
		WHERE ProductID = 2;

		UPDATE Products
		SET Attributes = '{"color": "Red", "size": "Small"}'
		WHERE ProductID = 3;

		UPDATE Products
		SET Attributes = '{"color": "Red", "size": "large"}'
		WHERE ProductID = 4;

		UPDATE Products
		SET Attributes = '{"color": "Blue", "size": "Medium"}'
		WHERE ProductID = 5;

		UPDATE Products
		SET Attributes = '{"color": "Black", "size": "Small"}'
		WHERE ProductID = 6;

		UPDATE Products
		SET Attributes = '{"color": "Yellow", "size": "Medium"}'
		WHERE ProductID = 7;

		UPDATE Products
		SET Attributes = '{"color": "white", "size": "large"}'
		WHERE ProductID = 8;
		
		UPDATE Products
		SET Attributes = '{"color": "white", "size": "Small"}'
		WHERE ProductID = 9;

		UPDATE Products
		SET Attributes = '{"color": "Black", "size": "Mini-Size"}'
		WHERE ProductID = 10;

		SELECT ProductID, ProductName,
		JSON_VALUE(Attributes, '$.color') AS Color, JSON_VALUE(Attributes, '$.size') AS Size
		FROM Products;

ROLLBACK

COMMIT







--4.2.2 Extract Different Email Parts

SELECT Email,SUBSTRING(Email,1,CHARINDEX('@',Email)-1) EmailName,
			 SUBSTRING(Email,CHARINDEX('@',Email)+1,LEN(Email)) Domain
FROM Customers


--4.2.2.1 Use regex to validate email formats. COMPLEX

SELECT
    Email,
    CASE
        WHEN (
            ( NOT Email LIKE '%@%@%' )    -- 1
            AND ( Email LIKE '%.%' )      -- 2
            AND ( Email LIKE '%@%.%' )    -- 3
            AND ( Email LIKE '______%' )  -- 4
            AND ( NOT (                          -- 5
                ( Email LIKE '%@.%' )
                OR ( Email LIKE '%.@%' )
            ) )
            AND ( NOT (                          -- 6(a)
                ( Email LIKE '@%' )
                OR ( Email LIKE '.%' )
                OR ( Email LIKE '%@' )
                OR ( Email LIKE '%.' )
            ) )
            AND ( NOT (                          -- 6(b)
                ( Email LIKE '%=%' )
                OR ( Email LIKE '%\_%' ESCAPE '\' )
                OR ( Email LIKE '%-%' )
                OR ( Email LIKE '%+%' )
                OR ( Email LIKE '%&%' )
                OR ( Email LIKE '%<%' )
                OR ( Email LIKE '%>%' )
                OR ( Email LIKE '%,%' )
            ) )
        ) THEN 'Valid'
        ELSE 'Invalid'
    END
    AS valid_Email
FROM Customers
WHERE Email IS NOT NULL


--4.2.2.2 Use regex to validate email formats. SIMPLE

SELECT * FROM(
			SELECT Email,
			CASE 
				WHEN Email like '%_@_%.__%' THEN 'Valid'
				ELSE 'Invalid' 
			END Validate_Email
			FROM Customers)A
WHERE Validate_Email='Invalid'


--4.3 Indexing and Performance Tuning

--4.3.1 Create indexes to optimize query performance

GO  
-- Find an existing index named IX_tblCustomers_IsEnable and delete it if found.   
IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'IX_tblCustomers_IsEnable')   
    DROP INDEX IX_tblCustomers_IsEnable ON Customers;   
GO

CREATE NONCLUSTERED INDEX IX_tblCustomers_IsEnable ON Customers(IsEnable)


GO  
-- Find an existing index named IX_tblProducts_Status and delete it if found.   
IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'IX_tblProducts_Status')   
    DROP INDEX IX_tblProducts_Status ON Products;   
GO

CREATE NONCLUSTERED INDEX IX_tblProducts_Status ON Products([Status])


--4.3.2 Optimize subquery performance 

--Instead of this…

SELECT c.* 
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID=o.CustomerID 
WHERE OrderID IS NULL

----

SELECT c.* 
FROM Customers c WHERE CustomerID NOT IN (
SELECT CustomerID FROM Orders o
)

--Do this… 

SELECT c.* 
FROM Customers c
WHERE NOT EXISTS(SELECT 1 FROM Orders o WHERE o.CustomerID=c.CustomerID)


--2

WITH RNK AS(
	SELECT p.ProductID,p.ProductName,SUM(od.UnitPrice*od.Quantity)TotalSales 
	FROM Orderdetails od
	JOIN (SELECT * FROM Products  WHERE [Status]=1)p ON p.ProductID=od.ProductID
	GROUP BY p.ProductID,p.ProductName
	)
SELECT *,RANK()OVER(ORDER BY TotalSales DESC)Rnk_TotalSales 
FROM RNK

--5 Stored Procedures and Transactions

--5.1 Stored Procedures:

-- Placing a new order (inserting into `Orders` and `OrderDetails`) AND Updating Product stock after an order is placed.

SELECT * 
FROM sys.types
WHERE name = 'OrderDetailsType';

DROP TYPE OrderDetailsType;

CREATE TYPE OrderDetailsType AS TABLE (
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10, 2)
);


CREATE PROCEDURE PlaceNewOrder
    @CustomerID INT,
    @OrderDetails OrderDetailsType READONLY
AS
BEGIN
    DECLARE @OrderID INT;

    -- Insert into Orders
    INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
    VALUES (@CustomerID, GETDATE(), 
            (SELECT SUM(Quantity * UnitPrice) FROM @OrderDetails));

    -- Get the newly created OrderID
    SET @OrderID = SCOPE_IDENTITY();

    -- Insert into OrderDetails
    INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
    SELECT @OrderID, ProductID, Quantity, UnitPrice
    FROM @OrderDetails;

    -- Update product stock
    UPDATE p
    SET p.StockQuantity = p.StockQuantity - od.Quantity
    FROM Products p
    JOIN @OrderDetails od ON p.ProductID = od.ProductID;
END;


--Step 3: Create the Stored Procedure for Updating Product Stock


CREATE PROCEDURE UpdateProductStockAfterOrder
    @OrderID INT
AS
BEGIN
    -- Update product stock
    UPDATE p
    SET p.StockQuantity = p.StockQuantity - od.Quantity
    FROM Products p
    JOIN OrderDetails od ON p.ProductID = od.ProductID
    WHERE od.OrderID = @OrderID;
END;



DECLARE @NewOrderDetails OrderDetailsType;

INSERT INTO @NewOrderDetails (ProductID, Quantity, UnitPrice)
VALUES (1, 2, 1000.00), (2, 1, 500.00);

EXEC PlaceNewOrder @CustomerID = 1, @OrderDetails = @NewOrderDetails;

SELECT  * FROM Orderdetails
SELECT * FROM Orders
SELECT * FROM Products



--5.2 Transaction Management

--5.2.1 Ensure that placing an order updates all relevant tables atomically AND Handle errors and rollbacks appropriately.

CREATE TYPE OrderDetailsType AS TABLE (
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10, 2)
);

-- Step 2: Create the stored procedure for placing a new order with transaction management
CREATE PROCEDURE PlaceNewOrder1
    @CustomerID INT,
    @OrderDetails OrderDetailsType READONLY
AS
BEGIN
    DECLARE @OrderID INT;
    DECLARE @TotalAmount DECIMAL(10, 2);

    -- Start a transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Calculate total amount for the order
        SELECT @TotalAmount = SUM(Quantity * UnitPrice) FROM @OrderDetails;

        -- Insert into Orders
        INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
        VALUES (@CustomerID, GETDATE(), @TotalAmount);

        -- Get the newly created OrderID
        SET @OrderID = SCOPE_IDENTITY();

        -- Insert into OrderDetails
        INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
        SELECT @OrderID, ProductID, Quantity, UnitPrice
        FROM @OrderDetails;

        -- Update product stock
        UPDATE p
        SET p.StockQuantity = p.StockQuantity - od.Quantity
        FROM Products p
        JOIN @OrderDetails od ON p.ProductID = od.ProductID;

        -- Commit the transaction
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction if an error occurs
        ROLLBACK TRANSACTION;

						SELECT 
								ERROR_NUMBER()		AS ErrorNumber,
								ERROR_SEVERITY()    AS ErrorSeverity,
								ERROR_STATE()		AS ErrorState,
								ERROR_PROCEDURE()	AS ErrorProcedure,
								ERROR_LINE()		AS ErrorLine,
								ERROR_MESSAGE()		AS ErrorMessage
												

			END CATCH

END

GO

-- Example 
DECLARE @NewOrderDetails OrderDetailsType;

INSERT INTO @NewOrderDetails (ProductID, Quantity, UnitPrice)
VALUES (1, 20, 1000.00), (2, 1, 500.00);

EXEC PlaceNewOrder1 @CustomerID = 1, @OrderDetails = @NewOrderDetails;


--EXTRA QUERIES

--PIVOT

SELECT [Accessories],[Bikes],[Clothing],[Components] FROM(
SELECT ProductCategoryName=p.Category,TotalAmount FROM Products p
JOIN Orderdetails od ON p.ProductID=od.ProductID
JOIN orders o ON o.OrderID=od.OrderID
)a
PIVOT(
SUM(TotalAmount) FOR ProductCategoryName IN ([Accessories],[Bikes],[Clothing],[Components])
)b


--------------

SELECT
c.CustomerID,c.FirstName+' '+c.LastName AS FullName,
YEAR(OrderDate)[OrderYear],SUM(TotalAmount)TotalAmount

FROM orders o JOIN Customers c ON o.CustomerID=c.CustomerID
GROUP BY c.CustomerID,c.FirstName+' '+c.LastName,YEAR(OrderDate)
ORDER BY 3


---------------

SELECT Category,SUM(TotalAmount)TotalAmount FROM Products p
JOIN Orderdetails od ON p.ProductID=od.ProductID
JOIN Orders o ON od.OrderID=o.OrderID
GROUP BY Category