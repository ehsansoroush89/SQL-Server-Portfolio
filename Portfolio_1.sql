--WINDOW FUNCTION



--Ranking all records within each group of sales order IDs

SELECT SalesOrderID,SalesOrderDetailID,LineTotal,
		SUM(LineTotal)OVER(PARTITION BY SalesOrderID)SumLineTotal,
		ROW_NUMBER()OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC)RNK
FROM AdventureWorks2022.Sales.SalesOrderDetail
ORDER BY 1



	
--Rank / Dense_Rank

SELECT SalesOrderID,SalesOrderDetailID,LineTotal,
		RANK()OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC)RNK_RANK,
		DENSE_RANK()OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC)RNK_DenseRANK
FROM AdventureWorks2022.Sales.SalesOrderDetail
ORDER BY 1


	
--LEAD / LAG

SELECT SalesOrderID,OrderDate,CustomerID,TotalDue,
		LEAD(TotalDue,1)OVER(PARTITION BY CustomerID ORDER BY SalesOrderID)NextTotalDue,
		LAG(TotalDue,1)OVER(PARTITION BY CustomerID ORDER BY SalesOrderID)PrevTotalDue
FROM AdventureWorks2022.Sales.SalesOrderHeader
ORDER BY CustomerID,SalesOrderID

--SubQueries

SELECT *
FROM(
SELECT SalesOrderID,SalesOrderDetailID,LineTotal,
	   ROW_NUMBER()OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC)RNK
FROM AdventureWorks2022.Sales.SalesOrderDetail
)a
WHERE RNK<=3
ORDER BY 1



	
--Scalar Subqueries

SELECT ProductID,[Name],StandardCost,ListPrice,
	   (SELECT AVG(ListPrice)FROM AdventureWorks2022.Production.Product)AvgListPrice,
	   ListPrice-(SELECT AVG(ListPrice)FROM AdventureWorks2022.Production.Product)AvgListPriceDiff
FROM AdventureWorks2022.Production.Product
WHERE ListPrice>(SELECT AVG(ListPrice)FROM Production.Product)
ORDER BY ListPrice



	
--Corrolated Subqueries

SELECT SalesOrderID,OrderDate,SubTotal,TaxAmt,Freight,TotalDue,
MultiOrderCount=
(
	SELECT COUNT(*)
	FROM AdventureWorks2022.Sales.SalesOrderDetail b
	WHERE b.SalesOrderID=a.SalesOrderID
	AND b.OrderQty>1
)

FROM Sales.SalesOrderHeader a



	
--EXISTS / NOT EXISTS

SELECT a.SalesOrderID,a.OrderDate,a.TotalDue
FROM AdventureWorks2022.Sales.SalesOrderHeader a
WHERE EXISTS /*--NOT EXISTS*/(
	SELECT  1
	FROM AdventureWorks2022.Sales.SalesOrderDetail b
	WHERE b.LineTotal>10000
	AND a.SalesOrderID=b.SalesOrderID
)
ORDER BY 1



	
--Pivot

SELECT *
FROM(
SELECT ProductCategoryName=d.[Name],a.LineTotal,
		a.OrderQty
FROM AdventureWorks2022.Sales.SalesOrderDetail a
	JOIN AdventureWorks2022.Production.Product b
		ON a.ProductID=b.ProductID
	JOIN AdventureWorks2022.Production.ProductSubcategory c
		ON c.ProductSubcategoryID=b.ProductSubcategoryID
	JOIN AdventureWorks2022.Production.ProductCategory d
		ON d.ProductCategoryID=c.ProductCategoryID
)a
PIVOT(
SUM(LineTotal) FOR ProductCategoryName IN ([Accessories],[Bikes],[Clothing],[Components])
)b
ORDER BY OrderQty



	
---CTE(Common Table Expression)

--INSTEAD OF THIS ...

SELECT a.OrderMonth,a.Top10Total,
		b.Top10Total PrevTop10Total
FROM
(
SELECT OrderMonth,SUM(TotalDue)Top10Total
FROM(

SELECT OrderDate,TotalDue,
		DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) OrderMonth,
		ROW_NUMBER()OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)OrderRank
FROM AdventureWorks2022.Sales.SalesOrderHeader
)x
WHERE OrderRank<=10
GROUP BY OrderMonth
)a
LEFT JOIN
(
SELECT OrderMonth,SUM(TotalDue)Top10Total
FROM(

SELECT OrderDate,TotalDue,
		DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) OrderMonth,
		ROW_NUMBER()OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)OrderRank
FROM AdventureWorks2022.Sales.SalesOrderHeader
)x
WHERE OrderRank<=10
GROUP BY OrderMonth
)b ON a.OrderMonth=DATEADD(MONTH,1,b.OrderMonth)
ORDER BY 1

--DO THIS ...

WITH Sales AS
(
		SELECT OrderDate,TotalDue,
				DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) OrderMonth,
				ROW_NUMBER()OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)OrderRank
		FROM AdventureWorks2022.Sales.SalesOrderHeader
),Top10 AS
(
		SELECT OrderMonth,SUM(TotalDue)Top10Total
		FROM Sales
		WHERE OrderRank<=10
		GROUP BY OrderMonth
)
SELECT a.OrderMonth,a.Top10Total,
		b.Top10Total PrevTop10Total
FROM Top10 a
LEFT JOIN Top10 b ON a.OrderMonth=DATEADD(MONTH,1,b.OrderMonth)
ORDER BY 1

	

--Recursive CTEs To Create A Calendar Table Then INSERT AND UPDATE IT 

WITH DateSeires AS
(
	SELECT CAST('01-01-2010' AS DATE)MyDate

	UNION ALL

	SELECT DATEADD(DAY,1,MyDate)
	FROM DateSeires
	WHERE MyDate<CAST('12-31-2030' AS DATE)
)
INSERT INTO AdventureWorks2022..Calendar (DateValue)
SELECT MyDate FROM DateSeires
OPTION(MAXRECURSION 10000)

UPDATE Calendar
SET
	DayOfWeekNumber = DATEPART(WEEKDAY,DateValue),
	DayOfWeekName = FORMAT(DateValue,'dddd'),
	DayOfMonthNumber=DAY(DateValue),
	MonthNumber=MONTH(DateValue),
	YearNumber=YEAR(DateValue),
	WeekendFlag	=
	CASE
		WHEN DayOfWeekName IN ('Saturday','Sunday') THEN 1
		ELSE 0
	END,
	HolidayFlag=
	CASE
		WHEN DayOfMonthNumber=1 AND MonthNumber=1 THEN 1
		ELSE 0
	END


	
--Temp Table

SELECT OrderDate,TotalDue,
		DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) OrderMonth,
		ROW_NUMBER()OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)OrderRank
	INTO #Sales
FROM AdventureWorks2022.Sales.SalesOrderHeader


SELECT OrderMonth,SUM(TotalDue)Top10Total
	INTO #Top10Sales
FROM #Sales
WHERE OrderRank<=10
GROUP BY OrderMonth


SELECT a.OrderMonth,a.Top10Total,
		b.Top10Total PrevTop10Total
FROM #Top10Sales a
LEFT JOIN #Top10Sales b ON a.OrderMonth=DATEADD(MONTH,1,b.OrderMonth)
ORDER BY 1

DROP TABLE IF EXISTS #Sales
DROP TABLE IF EXISTS #Top10Sales


 --CREATE / INSERT / TRUNCATE TEMO TABLE

DROP TABLE #Orders
DROP TABLE #TOP10Orders

--1- Create and insert into temp table #orders

 CREATE TABLE #Orders(
		 OrderDate DATE,
		 OrderMonth DATE,
		 TotalDue MONEY,
		 OrderRank INT
 )

INSERT INTO #Orders(
	OrderDate,
	OrderMonth,
	TotalDue,
	OrderRank 
)
SELECT 
		OrderDate,
		DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) OrderMonth,
		TotalDue,
		ROW_NUMBER()OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)OrderRank
	
FROM AdventureWorks2022.Sales.SalesOrderHeader

--2- Create and insert into temp table #TOP10Orders from #Orders 

CREATE TABLE #TOP10Orders(
	OrderMonth DATE,
	OrderType VARCHAR(32),
	Top10Total MONEY
)

INSERT INTO #TOP10Orders(
	OrderMonth ,
	OrderType ,
	Top10Total 
)
SELECT 
		OrderMonth,
		OrderType='Sales',
		Top10Total=SUM(TotalDue)
FROM #Orders
WHERE OrderRank<=10
GROUP BY OrderMonth

--3-Truncate #order and insert data into it from PurchaseOrderHeader table

TRUNCATE TABLE #Orders

INSERT INTO #Orders(
	OrderDate,
	OrderMonth,
	TotalDue,
	OrderRank 
)
SELECT 
		OrderDate,
		DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) OrderMonth,
		TotalDue,
		ROW_NUMBER()OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)OrderRank
	
FROM AdventureWorks2022.Purchasing.PurchaseOrderHeader

--4-populate #TOP10Orders table with data from #Orders table 

INSERT INTO #TOP10Orders(
	OrderMonth ,
	OrderType ,
	Top10Total 
)
SELECT 
		OrderMonth,
		OrderType='Purchase',
		Top10Total=SUM(TotalDue)
FROM #Orders
WHERE OrderRank<=10
GROUP BY OrderMonth

---
SELECT 
		a.OrderMonth,a.OrderType,a.Top10Total,b.Top10Total PrevTop10Total
FROM #TOP10Orders a
	LEFT JOIN #TOP10Orders b 
		ON a.OrderMonth=DATEADD(MONTH,1,b.OrderMonth)
			AND a.OrderType=b.OrderType
ORDER BY 1,2
