--Aggregates in Window Functions

--when using Windows functions, you can apply the same aggregates that you would under
--normal circumstances: sum,count, average, min and max

SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders;

SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month',occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id) AS max_std_qty
FROM orders;

/*
Reflect
What is happening when you omit the ORDER BY clause when doing aggregates with window functions?
Use the results from the queries above to guide your thoughts then jot these thoughts down in a
few sentences in the text box below.
*/

--Solution
--The window function worked just like GROUP BY giving a single row value.

/*
Aggregates in Window Functions with and without ORDER BY

The ORDER BY clause is one of two clauses integral to window functions.
The ORDER and PARTITION define what is referred to as the “window”—the ordered subset of data over which
calculations are made. Removing ORDER BY just leaves an unordered partition; in our query's case, each
column's value is simply an aggregation (e.g., sum, count, average, minimum, or maximum) of all the
standard_qty values in its respective account_id.

As Stack Overflow user mathguy explains:

The easiest way to think about this - leaving the ORDER BY out is equivalent to "ordering" in a way that
all rows in the partition are "equal" to each other. Indeed, you can get the same effect by explicitly
adding the ORDER BY clause like this: ORDER BY 0 (or "order by" any constant expression), or even, more
emphatically, ORDER BY NULL.

*/


--In addition to these functions, any built-in or user-defined aggregate function can be used as a window function
-- (see Section 9.18 for a list of the built-in aggregates). Aggregate functions act as window functions only when
--an OVER clause follows the call; otherwise they act as regular aggregates.

--https://www.postgresql.org/docs/8.4/functions-window.html

--Aliases for Multiple Window
SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER main-window  AS dense_rank,
       SUM(standard_qty) OVER main-window AS sum_std_qty,
       COUNT(standard_qty) OVER main-window AS count_std_qty,
       AVG(standard_qty) OVER main-window AS avg_std_qty,
       MIN(standard_qty) OVER main-window AS min_std_qty,
       MAX(standard_qty) OVER main-window AS max_std_qty
FROM orders;
WINDOW main-window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at))

--QUESTION
/*
Now, create and use an alias to shorten the following query (which is different than the one in
Derek's previous video) that has multiple window functions. Name the alias account_year_window,
which is more descriptive than main_window in the example above.
*/

SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))
