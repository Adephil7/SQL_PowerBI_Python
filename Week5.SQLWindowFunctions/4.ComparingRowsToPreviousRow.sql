--OFFSET and LAG functions

--OFFSET specifies how many rows to skip within the result

--LAG function is an analytic function that lets you query more than one row in a table
--at a time without having to join the table to itself.
--It returns values from a previous row in the table.

LAG ( expression [, offset [, default] ] )
OVER ( [ query_partition_clause ] order_by_clause )

--eg
SELECT dept_id, last_name, salary,
LAG (salary,1) OVER (ORDER BY salary) AS lower_salary
FROM employees;

--The LAG function creates a new column called lag as part of the outer query:
--LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag.
--This new column named lag uses the values from the ordered standard_sum (Part A within Step 3).

SELECT account_id,
       standard_sum,
       LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag
FROM   (
        SELECT   account_id,
                 SUM(standard_qty) AS standard_sum
        FROM     demo.orders
        GROUP BY 1
       ) sub

--Step 4:
--To compare the values between the rows, we need to use both columns (standard_sum and lag).
--We add a new column named lag_difference, which subtracts the lag value from the value in
--standard_sum for each row in the table:
--standard_sum - LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag_difference

SELECT account_id,
       standard_sum,
       LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag,
       standard_sum - LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag_difference
FROM (
       SELECT account_id,
       SUM(standard_qty) AS standard_sum
       FROM orders
       GROUP BY 1
      ) sub

-- LEAD function is an analytic function that lets you query more than one row in a table
--at a time without having to join the table to itself.
--It returns values from the next row in the table.

LEAD ( expression [, offset [, default] ] )
OVER ( [ query_partition_clause ] order_by_clause )

--eg
SELECT dept_id, last_name, salary,
LEAD (salary,1) OVER (ORDER BY salary) AS next_highest_salary
FROM employees;

--LEAD function
--Purpose:
--Return the value from the row following the current row in the table.

--Step 1:
--Let’s first look at the inner query and see what this creates.

SELECT     account_id,
           SUM(standard_qty) AS standard_sum
FROM       demo.orders
GROUP BY   1

--Step 3 (Part A):
--We add the Window Function (OVER BY standard_sum) in the outer query that will create a result set ordered in ascending order of the standard_sum column.

SELECT account_id,
       standard_sum,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead
FROM   (
        SELECT   account_id,
                 SUM(standard_qty) AS standard_sum
        FROM     demo.orders
        GROUP BY 1
       ) sub

--Step 3 (Part B):
--The LEAD function in the Window Function statement creates a new column called lead as part of the outer query:
--LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead
SELECT account_id,
       standard_sum,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead
FROM   (
        SELECT   account_id,
                 SUM(standard_qty) AS standard_sum
        FROM     demo.orders
        GROUP BY 1
       ) sub

--Step 4: To compare the values between the rows, we need to use both columns
--(standard_sum and lag). We add a column named lead_difference, which subtracts the value
--in standard_sum from lead for each row in the table:
SELECT account_id,
       standard_sum,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) - standard_sum AS lead_difference
FROM (
SELECT account_id,
       SUM(standard_qty) AS standard_sum
       FROM orders
       GROUP BY 1
     ) sub

--Scenarios for using LAG and LEAD functions
--You can use LAG and LEAD functions whenever you are trying to compare the values in adjacent
--rows or rows that are offset by a certain number.

--Example 1: You have a sales dataset with the following data and need to compare how the market segments fare against each other on profits earned.

Market Segment	Profits earned by each market segment
    A	                          $550
    B	                          $500
    C	                          $670
    D	                          $730
    E	                          $982

--Example 2: You have an inventory dataset with the following data and need to compare the number of days elapsed between each subsequent order placed for Item A.

    Inventory	Order_id	Dates when orders were placed
          Item A	           001	11/2/2017
          Item A	           002	11/5/2017
          Item A	           003	11/8/2017
          Item A	           004	11/15/2017
          Item A	           005	11/28/2017

--Comparing a Row to Previous Row
--In the previous video, Derek outlines how to compare a row to a previous or subsequent row.
--This technique can be useful when analyzing time-based events. Imagine you're an analyst at
--Parch & Posey and you want to determine how the current order's total revenue ("total" meaning
--from sales of all types of paper) compares to the next order's total revenue.

/*
Modify Derek's query from the previous video in the SQL Explorer below to perform this analysis.
You'll need to use occurred_at and total_amt_usd in the orders table along with LEAD to do so.
In your query results, there should be four columns: occurred_at, total_amt_usd, lead, and lead_difference.
*/

SELECT account_id,
       total_amt_usd,
       LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead,
       standard_sum - LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag_difference,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) - standard_sum AS lead_difference
FROM (
SELECT account_id,
       SUM(standard_qty) AS standard_sum
  FROM orders
 GROUP BY 1
 ) sub

 ----
 SELECT occurred_at,
       total_sales,
       LEAD(total_sales) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_sales) OVER (ORDER BY occurred_at) - total_sales AS lead_difference
 FROM (
SELECT occurred_at,
       SUM(total_amt_usd) AS total_sales
  FROM orders
 GROUP BY 1
 ) sub

--OR
WITH sub AS (
  SELECT occurred_at,
         SUM(total_amt_usd) AS total_sales
    FROM orders
   GROUP BY 1
)
SELECT occurred_at,
      total_sales,
      LEAD(total_sales) OVER (ORDER BY occurred_at) AS lead,
      LEAD(total_sales) OVER (ORDER BY occurred_at) - total_sales AS lead_difference
FROM sub;
