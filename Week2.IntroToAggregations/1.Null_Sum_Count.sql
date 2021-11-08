--COUNT: counts how many rows in particular column

--SUM : add all the values in a particular column
      --SUM only works for colums with quantitative data

--MIN and MAX: returns the lowest and highest value in a particular column

--AVERAGE : returns the average of all the values in a particular column

--NULL : means no data not a zero or a space
        --NULL is not a value, its the property of the data
/*
When identifying NULLs in a WHERE clause, we write IS NULL or IS NOT NULL.
We don't use =, because NULL isn't considered a value in SQL.
Rather, it is a property of the data.

NULLs - Expert Tip

i. NULLs frequently occur when performing a LEFT or RIGHT JOIN.
ii.NULLs can also occur from simply missing data in our database.
*/

--COUNT === can help us identify null values in a particular column

--Aggregation Questions

--1.
--Find the total amount of poster_qty paper ordered in the orders table.
SELECT SUM(poster_qty) AS total_poster_sales
FROM orders;

--2.
--Find the total amount of standard_qty paper ordered in the orders table
SELECT SUM(standard_qty) total_standard_sales
FROM orders;

--3.
--Find the total dollar amount of sales using the total_amt_usd in the orders table.
SELECT SUM( total_amt_usd) total_dollar_sales
FROM orders;

--4.
--Find the total amount spent on standard_amt_usd and gloss_amt_usd paper
--for each order in the orders table.
--This should give a dollar amount for each order in the table.
SELECT SUM(standard_amt_usd) total_dollar_standard,
	     SUM(gloss_amt_usd) total_dollar_gloss
FROM orders;

--OR
SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;

--5.
--Find the standard_amt_usd per unit of standard_qty paper.
--Your solution should use both an aggregation and a mathematical operator.

SELECT  SUM(standard_amt_usd)/SUM(standard_qty) standard_unit_price
FROM orders;
