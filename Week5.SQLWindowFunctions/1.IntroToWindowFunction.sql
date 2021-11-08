--SQL window functions

--It allows you to compare one row to another without doing any joints.

--For example,
--i. to do a simple things like create a running total,
--ii. determine whether one row was greater than the previous row, and classify it based on your finding.

--In short
/*a window function performs a calculation across a set of table rows that are somehow related to the current row.
just like join but no join statement needed here.
This is comparable to the type of calculation that can be done with an aggregate function. But unlike regular
aggregate functions, use of a window function does not cause rows to become grouped into a single output row
— the rows retain their separate identities. Behind the scenes, the window function is able to access more
  than just the current row of the query result.

Through introducing window functions, we have also introduced two statements that you may not be familiar with:
OVER and PARTITION BY. These are key to window functions. Not every window function uses PARTITION BY;
we can also use ORDER BY or no statement at all depending on the query we want to run.

Note: You can’t use window functions and standard aggregations in the same query.
      More specifically, you can’t include window functions in a GROUP BY clause.
*/

--The OVER Clause
--https://blog.sqlauthority.com/2015/11/04/sql-server-what-is-the-over-clause-notes-from-the-field-101/
--The OVER clause has three components:
--i.   partitioning,
--ii.  ordering, and
--iii. framing.

--Partitioning is always supported, but support for ordering and framing depends on which type of window function you are using.
/*
The partitioning component, expressed as PARTITION BY, is optional and is supported for all types of window functions.
Partitioning divides up the rows.

 It’s kind of like a physical window that is divided up into panes. The entire window is a window.
 The panes are also windows. Say that I partition by CustomerID. The partition for CustomerID 1000 is
 restricted to rows for CustomerID 1000.

 For the calculation on any given row, the window consists of rows from that partition only.

 Partitioning is not the same as grouping with the GROUP BY clause.
 When you use the GROUP BY clause, only one row is returned for each group.
 Partitioning is just a way to divide the data in order to perform the calculations;
 the detail columns are returned.
*/

SELECT standard_qty,
       DATE_TRUNC('month', occurred_at) as month,
       SUM(standard_qty) OVER (PARTITION BY DATE_TRUNC('month', occurred_at) ORDER BY occurred_at ) as running_total

FROM orders;

--Creating a Running Total Using Window Functions
--1.
--Using Derek's previous video as an example, create another running total. This time, create a running
--total of standard_amt_usd (in the orders table) over order time with no date truncation. Your final
--table should have two columns: one with the amount being added for each new row, and a second with
--the running total.

SELECT  standard_amt_usd,
		    SUM(standard_amt_usd) OVER (ORDER BY occurred_at) as running_total
FROM orders;

--2.
/*
Now, modify your query from the previous quiz to include partitions. Still create a running total of
standard_amt_usd (in the orders table) over order time, but this time, date truncate occurred_at by
year and partition by that same year-truncated occurred_at variable. Your final table should have three
columns: One with the amount being added for each row, one for the truncated date, and a final column
with the running total within each year.
*/
SELECT  standard_amt_usd,
        DATE_TRUNC('year', occurred_at) as year,
		    SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) as running_total
FROM orders;
