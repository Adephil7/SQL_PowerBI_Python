--GROUP BY
--allows creating segments that will aggregate independent from one another. That is
--The GROUP BY statement groups rows that have the same values into summary rows,
--like "find the number of customers in each country".

--The GROUP BY statement is often used with aggregate functions
--(COUNT(), MAX(), MIN(), SUM(), AVG()) to group the result-set by one or more columns.

--The key takeaways here:
--1.
--GROUP BY can be used to aggregate data within subsets of the data.
--For example, grouping for different accounts, different regions, or different sales representatives.

--2.
--Any column in the SELECT statement that is not within an aggregator must be in the GROUP BY clause.

--3.
--The GROUP BY always goes between WHERE and ORDER BY. i.e in between filtering and sorting

SELECT column_name(s)
FROM table_name
JOIN table_name
ON condition
WHERE condition
GROUP BY column_name(s)
ORDER BY column_name(s);

----------------------------------
--Questions: GROUP BY
--1.
--Which account (by name) placed the earliest order? Your solution should have the account name
-- and the date of the order.

SELECT a.name as  account,
       o.occurred_at as earliest_order_date
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY o.occurred_at
LIMIT 1;

--2.
--Find the total sales in usd for each account. You should include two columns - the total sales
--for each company's orders in usd and the company name.
SELECT a.name as  account,
       SUM(o.total_amt_usd) as total_sales
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name;

--3.
--Via what channel did the most recent (latest) web_event occur, which account was
--associated with this web_event?
--Your query should return only three values - the date, channel, and account name.

SELECT w.occurred_at occurred_at,
       w.channel channel,
       a.name account
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
ORDER BY w.occurred_at DESC
LIMIT 1;

--4.
--Find the total number of times each type of channel from the web_events was used. Your final
--table should have two columns - the channel and the number of times the channel was used.

SELECT channel, COUNT(*)
FROM web_events
GROUP BY channel
ORDER BY channel;

--OR

SELECT channel, COUNT(channel)
FROM web_events
GROUP BY channel
ORDER BY channel;

--5.
--Who was the primary contact associated with the earliest web_event?

SELECT w.occurred_at occurred_at,
       a.primary_poc primary_poc
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;

--6.
--What was the smallest order placed by each account in terms of total usd. Provide only two
--columns - the account name and the total usd. Order from smallest dollar amounts to largest.

SELECT a.name account,
      MIN(total_amt_usd) smallest_order_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order_usd;


--7.
--Find the number of sales reps in each region. Your final table should have
--two columns - the region and the number of sales_reps. Order from fewest reps to most reps.

SELECT r.name as region,
       COUNT(s.name) as number_of_sales_rep
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY number_of_sales_rep;

--OR

SELECT r.name, COUNT(*) num_reps
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY num_reps;


---------------------------------------------------
--Part II
SELECT account_id,
      channel,
      COUNT(id) as web_events
FROM web_events
GROUP by account_id, channel
ORDER by account_id, channel

--Key takeaways:

--i.
--You can GROUP BY multiple columns at once, as we showed here. This is often
--useful to aggregate across a number of different segments.

--ii.
--The order of columns listed in the ORDER BY clause does make a difference.
--You are ordering the columns from left to right.

--GROUP BY - Expert Tips
--i.
/*
The order of column names in your GROUP BY clause doesn’t matter—the results
will be the same regardless. If we run the same query and reverse the order in
the GROUP BY clause, you can see we get the same results.
*/

--ii.
/*
A reminder here that any column that is not within an aggregation must show up
in your GROUP BY statement. If you forget, you will likely get an error.
However, in the off chance that your query does work, you might not like the results!
*/

--iii.
/*
As with ORDER BY, you can substitute numbers for column names in the
GROUP BY clause. It’s generally recommended to do this only when you’re
grouping many columns, or if something else is causing the text in the
GROUP BY clause to be excessively long.
*/

--Questions: GROUP BY Part II

--1.
--For each account, determine the average amount of each type of paper they
--purchased across their orders. Your result should have four columns -
--one for the account name and one for the average quantity purchased for
--each of the paper types for each account.

SELECT a.name account,
       AVG(o.standard_qty) as mean_standard,
       AVG(o.gloss_qty) as mean_gloss,
       AVG(o.poster_qty) as mean_poster
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name;

--2.
/*
For each account, determine the average amount spent per order on each paper type.
Your result should have four columns - one for the account name and one for the average amount spent on each paper type.
*/

SELECT a.name account,
       AVG(o.standard_amt_usd) as mean_standard_usd,
       AVG(o.gloss_amt_usd) as mean_gloss_usd,
       AVG(o.poster_amt_usd) as mean_poster_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name;

--3.
/*
Determine the number of times a particular channel was used in the web_events
table for each sales rep. Your final table should have three columns -
the name of the sales rep, the channel, and the number of occurrences.
Order your table with the highest number of occurrences first.
*/

SELECT s.name sales_rep,
       w.channel channel,
       COUNT(w.*) number_of_occurences
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN web_events w
ON a.id = w.account_id
GROUP BY s.name, w.channel
ORDER BY number_of_occurences DESC;

--4.
/*
Determine the number of times a particular channel was used in the web_events
table for each region. Your final table should have three columns -
the region name, the channel, and the number of occurrences.
Order your table with the highest number of occurrences first.
*/

SELECT r.name region,
       w.channel channel,
       COUNT(w.*) number_of_occurences
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN web_events w
ON a.id = w.account_id
GROUP BY r.name, w.channel
ORDER BY number_of_occurences DESC;

--------------------------------------------------
--HAVING - Expert Tip

--HAVING is the “clean” way to filter a query that has been aggregated, but
--this is also commonly done using a subquery. Essentially, any time you want
--to perform a WHERE on an element of your query that was created by an aggregate,
--you need to use HAVING instead.

--HAVING occurs after GROUP BY but before the ORDER BY clause.

--Questions: HAVING
--1.
--How many of the sales reps have more than 5 accounts that they manage?
SELECT s.id sales_rep_id,
       s.name sales_rep_name,
       COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY num_accounts;

--OR

SELECT COUNT(*) num_reps_above5
FROM(SELECT s.id, s.name, COUNT(*) num_accounts
     FROM accounts a
     JOIN sales_reps s
     ON s.id = a.sales_rep_id
     GROUP BY s.id, s.name
     HAVING COUNT(*) > 5
     ORDER BY num_accounts) AS Table1;

--2.
--How many accounts have more than 20 orders?
SELECT  a.id as account_id,
        a.name as account,
        COUNT(*) num_orders
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20
ORDER By num_orders;

--3.
--Which account has the most orders?
SELECT  a.id as account_id,
        a.name as account,
        COUNT(*) num_orders
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER By num_orders DESC
LIMIT 1;

--4.
--Which accounts spent more than 30,000 usd total across all orders?
SELECT  a.id as account_id,
        a.name as account,
        SUM(o.total_amt_usd)  as total_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER By total_usd;

--5.
--Which accounts spent less than 1,000 usd total across all orders?
SELECT  a.id as account_id,
        a.name as account,
        SUM(o.total_amt_usd)  as total_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER By total_usd;

--6.
--Which account has spent the most with us?
SELECT  a.id as account_id,
        a.name as account,
        SUM(o.total_amt_usd)  as total_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER By total_usd DESC
LIMIT 1;

--7.
--Which account has spent the least with us?
SELECT  a.id as account_id,
        a.name as account,
        SUM(o.total_amt_usd)  as total_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER By total_usd
LIMIT 1;

--8.
--Which accounts used facebook as a channel to contact customers more than 6 times?
SELECT a.id as account_id,
       a.name as account,
        w.channel as channel,
       COUNT(w.channel) as use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING w.channel = 'facebook' and COUNT(w.channel) > 6
ORDER BY use_of_channel;

--9.
--Which account used facebook most as a channel?
SELECT a.id as account_id,
       a.name as account,
       w.channel as channel,
       COUNT(w.channel) as num_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING w.channel = 'facebook' and COUNT(w.channel) > 6
ORDER BY num_channel DESC
LIMIT 1;

--10.
--Which channel was most frequently used by most accounts?
SELECT a.id as account_id,
       a.name as account,
       w.channel as channel,
       COUNT(*) as num_accounts
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY  a.id, a.name, w.channel
ORDER BY num_accounts DESC
LIMIT 1;
