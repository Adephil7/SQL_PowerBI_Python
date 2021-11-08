--CASE
--This is used to add a conditional statement to a select statement
CASE
  WHEN conditions
    THEN statement
  ELSE statement
END

--The CASE statement always goes in the SELECT clause

--CASE must include the following components: WHEN, THEN, and END. ELSE is an optional
--component to catch cases that didn’t meet any of the other previous CASE conditions.

SELECT id,
       account_id,
       occurred_at,
       channel,
       CASE WHEN channel = 'facebook' THEN 'yes' END AS is_facebook
FROM web_events
ORDER BY occurred_at;

--You can make any conditional statement using any conditional operator (like WHERE)
--between WHEN and THEN. This includes stringing together multiple conditional statements using AND and OR.

--You can include multiple WHEN statements, as well as an ELSE statement again, to deal
--with any unaddressed conditions.

--Example
--1.
/*
Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for
standard paper for each order. Limit the results to the first 10 orders, and include the id and
account_id fields. NOTE - you will be thrown an error with the correct solution to this question. This is for a division by zero. You will learn how to get a solution without an error to this query when you learn about CASE statements in a later section.
*/
SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price
FROM orders
LIMIT 10;

--Now, let's use a CASE statement. This way any time the standard_qty is zero, we will return 0, and otherwise we will return the unit_price.
SELECT account_id, CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
                        ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders
LIMIT 10;

--CASE & Aggregation
--a group is to create a column that groups the way you want it to, then create another column to count by that group.

SELECT CASE WHEN total > 500 THEN 'Over 500'
            ELSE '500 or under'
       END AS total_group,
       COUNT(*) AS order_count
FROM orders
GROUP BY 1;

--why wouldn't I just use a WHERE clause to filter out rows I don't want to count?
--Unfortunately, using the WHERE clause only allows you to count one condition at a time.

SELECT COUNT(1) AS orders_over_500_units
FROM orders
WHERE total > 500;

--Questions: CASE
--1.
--Write a query to display for each order, the account ID, total amount of the order,
--and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 '
--or more, or smaller than $3000.
SELECT account_id, total_amt_usd,
       CASE WHEN total_amt_usd > 3000 THEN 'Large'
            ELSE 'Small'
       END as order_level
FROM orders;

--2.
--Write a query to display the number of orders in each of three categories, based on the
--total number of items in each order. The three categories are:
--'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
SELECT CASE WHEN total >= 2000 THEN 'At Least 2000'
            WHEN total BETWEEN 1000 and 2000 THEN 'Between 1000 and 2000'
            ELSE 'Less than 1000'
       END AS order_category,
       COUNT(*) as ord_num
FROM orders
GROUP BY 1
ORDER BY 1;

--3.
/*
We would like to understand 3 different levels of customers based on the amount associated
with their purchases. The top level includes anyone with a Lifetime Value (total sales of
all orders) greater than 200,000 usd. The second level is between 200,000 and 100,000 usd.
The lowest level is anyone under 100,000 usd. Provide a table that includes the level
associated with each account. You should provide the account name, the total sales of all
orders for the customer, and the level. Order with the top spending customers listed first.
*/
SELECT a.name account, SUM(total_amt_usd) as total_sales,
       CASE WHEN SUM(total_amt_usd) > 200000 THEN 'Top Level'
            WHEN SUM(total_amt_usd) BETWEEN 100000 and 200000 THEN 'Second Level'
            ELSE 'Lowest Level'
       END AS customer_level
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;

--4.
/*
We would now like to perform a similar calculation to the first, but we want to obtain the
total amount spent by customers only in 2016 and 2017. Keep the same levels as in the
previous question. Order with the top spending customers listed first.
*/

SELECT a.name, SUM(total_amt_usd) total_spent,
     CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
     WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
     ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE occurred_at > '2015-12-31'
GROUP BY 1
ORDER BY 2 DESC;


--5.
/*
We would like to identify top performing sales reps, which are sales reps associated with
more than 200 orders. Create a table with the sales rep name, the total number of orders,
and a column with top or not depending on if they have more than 200 orders.
Place the top sales people first in your final table.
*/

SELECT s.name sales_rep,
       COUNT(*) total_ord,
       CASE WHEN COUNT(*) > 200 THEN 'Top'
            ELSE 'Low'
       END AS sales_rep_level
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;

--6.
/*
The previous didn't account for the middle, nor the dollar amount associated with the sales.
Management decides they want to see these characteristics represented as well. We would
like to identify top performing sales reps, which are sales reps associated with
more than 200 orders or more than 750000 in total sales. The middle group has any rep with
more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total
number of orders, total sales across all orders, and a column with top, middle, or low
depending on this criteria. Place the top sales people based on dollar amount of sales
first in your final table. You might see a few upset sales people by this criteria!
*/

SELECT s.name sales_rep,
       COUNT(*) total_ord,
       SUM(o.total_amt_usd) revenue_usd,
       CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000  THEN 'Top'
       		  WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000  THEN 'Middle'
            ELSE 'Low'
       END AS sales_rep_level
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC;
