--ROW_NUMBER
--this function counts
--Numbers the output of a result set.
--More specifically, returns the sequential number of a row within a partition of a result set,
--starting at 1 for the first row in each partition.

--ROW_NUMBER and RANK are similar.
--ROW_NUMBER numbers all rows sequentially (for example 1, 2, 3, 4, 5).
--RANK provides the same numeric value for ties (for example 1, 2, 2, 4, 5).

ROW_NUMBER ( )
    OVER ( [ PARTITION BY value_expression , ... [ n ] ] order_by_clause )

--For example
--1.
--The following query returns the four system tables in alphabetic order.
--To add a row number column in front of each row, add a column with the ROW_NUMBER function, in this case named Row#.
--You must move the ORDER BY clause up to the OVER clause.
SELECT
  ROW_NUMBER() OVER(PARTITION BY recovery_model_desc ORDER BY name ASC)
    AS Row#,
  name, recovery_model_desc
FROM sys.databases WHERE database_id < 5;

--2.
-- Returning the row number for salespeople
--The following example calculates a row number for the salespeople in Adventure Works Cycles based on their
--year-to-date sales ranking.

USE AdventureWorks2012;
GO
SELECT ROW_NUMBER() OVER(ORDER BY SalesYTD DESC) AS Row,
    FirstName, LastName, ROUND(SalesYTD,2,1) AS "Sales YTD"
FROM Sales.vSalesPerson
WHERE TerritoryName IS NOT NULL AND SalesYTD <> 0;
USE AdventureWorks2012;
GO

--3.
--Returning a subset of rows
--The following example calculates row numbers for all rows in the SalesOrderHeader table in the order
--of the OrderDate and returns only rows 50 to 60 inclusive.

WITH OrderedOrders AS
(
    SELECT SalesOrderID, OrderDate,
    ROW_NUMBER() OVER (ORDER BY OrderDate) AS RowNumber
    FROM Sales.SalesOrderHeader
)
SELECT SalesOrderID, OrderDate, RowNumber
FROM OrderedOrders
WHERE RowNumber BETWEEN 50 AND 60;

--4.
--Using ROW_NUMBER() with PARTITION
--The following example uses the PARTITION BY argument to partition the query result set by the column TerritoryName.
--The ORDER BY clause specified in the OVER clause orders the rows in each partition by the column SalesYTD.
--The ORDER BY clause in the SELECT statement orders the entire query result set by TerritoryName.
USE AdventureWorks2012;
GO
SELECT FirstName, LastName, TerritoryName,
       ROUND(SalesYTD,2,1) AS SalesYTD,
       ROW_NUMBER() OVER(PARTITION BY TerritoryName ORDER BY SalesYTD DESC) AS Row
FROM Sales.vSalesPerson
WHERE TerritoryName IS NOT NULL AND SalesYTD <> 0
ORDER BY TerritoryName;

--------------------------------------------------------------------------------
--Example in class

SELECT id,
       account_id,
       DATE_TRUNC('month', occurred_at) as month,
       ROW_NUMBER() OVER(PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) as row_num
FROM orders;

--Ranking Total Paper Ordered by Account
--Select the id, account_id, and total variable from the orders table, then create a column called
--total_rank that ranks this total amount of paper ordered (from highest to lowest) for each account using a partition. Your final table should have these four columns.
SELECT id,
       account_id,
       total,
       RANK() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders;
