--Join => accessing data from two or more tables

/*
What to Notice
We are able to pull data from two tables:
1. orders
2. accounts
Above, we are only pulling data from the orders table since in the SELECT statement we only reference columns from the orders table.

The ON statement holds the two columns that get linked across the two tables. This will be the focus in the next concepts.
*/

--1. Try pulling all the data from the accounts table, and all the data from the orders table.
Select *
from accounts
join orders
on accounts.id = orders.account_id;

--OR

SELECT orders.*, accounts.*
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;

--2. Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.
Select orders.standard_qty,
      orders.gloss_qty,
      orders.poster_qty,
      accounts.website,
      accounts.primary_poc
from orders
join accounts
on orders.account_id = accounts.id;

--NOTICE
--Our SQL query has the two tables we would like to join - one in the FROM and the other in the JOIN.
--Then in the ON, we will ALWAYs have the PK equal to the FK:


--Aliases for Columns in Resulting Table
--While aliasing tables is the most common use case. It can also be used to alias the columns selected to have the resulting table reflect a more readable name.

--Example:

Select t1.column1 aliasname, t2.column2 aliasname2
FROM tablename AS t1
JOIN tablename2 AS t2

--Questions
--1.
/*Provide a table for all web_events associated with account name of Walmart.
There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. Additionally,
you might choose to add a fourth column to assure only Walmart events were chosen.*/

select a.primary_poc, w.occurred_at, w.channel
from web_events w
Join accounts a
on a.id = w.account_id
where a.name = 'Walmart';

--NOTE:
--when working with multiple tables try and start your join from the innermost table

--2.
/*
Provide a table that provides the region for each sales_rep along with their associated accounts.
Your final table should include three columns: the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name.
*/

SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;

--3.
/*
Provide the name for each region for every order, as well as the account name and the unit price
they paid (total_amt_usd/total) for the order. Your final table should have 3 columns:
region name, account name, and unit price. A few accounts have 0 for total,
so I divided by (total + 0.01) to assure not dividing by zero.
*/

SELECT r.name region, a.name account,
       o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;
