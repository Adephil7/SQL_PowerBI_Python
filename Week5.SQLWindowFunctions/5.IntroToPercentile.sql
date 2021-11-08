--NTILE function

--The SQL Server NTILE() is a window function that distributes rows of an ordered
--partition into a specified number of approximately equal groups, or buckets.

NTILE (integer_expression) OVER ( [ <partition_by_clause> ] < order_by_clause > )

--window functions to identify what percentile (or quartile, or any other subdivision)
--a given row falls into.

--the number specified in the NTILE function is the number of parts into which you'll divide the window
--one hundred means percentiles
--five means quintiles
--four means quartiles

--In this case, ORDER BY determines which column to use to determine the quartiles
--(or whatever number of ‘tiles you specify).

NTILE(4) OVER(ORDER BY standard_qty) as quartiles

--Here,
--For each row, the NTILE(4) function will look at the value of standard quantity in that row compared to all other rows
-- in the window and then print the quartile that the value falls into.

--So, a standard quantity of zero would fall in the first quartile,
--and the highest value will be 4th quartile.

SELECT id,
        account_id,
        occurred_at,
        standard_qty,
        NTILE(4) OVER (ORDER BY standard_qty) as quartile,
        NTILE(5) OVER (ORDER BY standard_qty) as quintile,
        NTILE(100) OVER (ORDER BY standard_qty) as percentile
  FROM orders
ORDER BY standard_qty DESC

--let me try and know the number of id in each quartile
WITH sub as (
  SELECT id,
        account_id,
        occurred_at,
        standard_qty,
        NTILE(4) OVER (ORDER BY standard_qty) as quartile,
        NTILE(5) OVER (ORDER BY standard_qty) as quintile,
        NTILE(100) OVER (ORDER BY standard_qty) as percentile
  FROM orders
ORDER BY standard_qty DESC
)
SELECT percentile,
        COUNT(*) as num_per_percent
  FROM sub;


/*
Expert Tip
In cases with relatively few rows in a window, the NTILE function doesn’t calculate exactly as you might expect.
For example, If you only had two records and you were measuring percentiles, you’d expect one record to define
the 1st percentile, and the other record to define the 100th percentile. Using the NTILE function, what you’d
actually see is one record in the 1st percentile, and one in the 2nd percentile.

In other words, when you use a NTILE function but the number of rows in the partition is less than the
NTILE(number of groups), then NTILE will divide the rows into as many groups as there are members (rows) in the
set but then stop short of the requested number of groups. If you’re working with very small windows, keep this
in mind and consider using quartiles or similarly small bands.
*/

--QUESTIONS

--1.
--Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of standard_qty for their
--orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of
--standard_qty paper purchased, and one of four levels in a standard_quartile column.

SELECT account_id,
       occurred_at,
       standard_qty,
       NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty) as standard_quartile
  FROM orders
ORDER BY account_id DESC;

--2.
--Use the NTILE functionality to divide the accounts into two levels in terms of the amount of gloss_qty for their
--orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of
--gloss_qty paper purchased, and one of two levels in a gloss_half column.
SELECT account_id,
       occurred_at,
       gloss_qty,
       NTILE(2) OVER (PARTITION BY account_id ORDER BY gloss_qty) as gloss_half
  FROM orders
ORDER BY account_id DESC;

--Use the NTILE functionality to divide the orders for each account into 100 levels in terms of the amount of
--total_amt_usd for their orders. Your resulting table should have the account_id, the occurred_at time for each
--order, the total amount of total_amt_usd paper purchased, and one of 100 levels in a total_percentile column.
SELECT account_id,
       occurred_at,
       total_amt_usd,
       NTILE(100) OVER (PARTITION BY account_id ORDER BY total_amt_usd) as total_percentile
  FROM orders
ORDER BY account_id DESC;
