/*
If you have two or more columns in your SELECT that have the same name after the table name
such as accounts.name and sales_reps.name you will need to alias them. Otherwise it will only show one of the columns.
You can alias them like accounts.name AS AcountName, sales_rep.name AS SalesRepName
*/

--1.
/*
Provide a table that provides the region for each sales_rep along with their associated
-- accounts.
This time only for the Midwest region. Your final table should include three columns:
the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name.
*/

SELECT r.name region, s.name sales_rep, a.name account
FROM region r
INNER JOIN sales_reps s
ON r.id = s.region_id
INNER JOIN accounts a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest'
ORDER BY a.name;

--2.
/*
Provide a table that provides the region for each sales_rep along with their associated
accounts. This time only for accounts where the sales rep has a first name
starting with S and in the Midwest region. Your final table should include three
columns: the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name.
*/

SELECT r.name region, s.name sales_rep, a.name account
FROM region r
INNER JOIN sales_reps s
ON r.id = s.region_id
INNER JOIN accounts a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name ASC;

--3.
/*
Provide a table that provides the region for each sales_rep along with their associated
accounts. This time only for accounts where the sales rep has a last name
starting with K and in the Midwest region. Your final table should include three
columns: the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name.
*/
--to split fullname into firstname and lastname
SELECT regexp_replace(name,'\s\S+','') as firstname,
        regexp_replace(name,'.+[\s]','') as lastname
from sales_reps;
--
SELECT r.name region, s.name sales_rep, a.name account
FROM region r
INNER JOIN sales_reps s
ON r.id = s.region_id
INNER JOIN accounts a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest' and regexp_replace(s.name,'.+[\s]','') LIKE 'K%'
ORDER BY a.name ASC;

--OR
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name;

--4.
/*
Provide the name for each region for every order, as well as the account name
and the unit price they paid (total_amt_usd/total) for the order.
However, you should only provide the results if the standard order quantity
exceeds 100. Your final table should have 3 columns:
region name, account name, and unit price. In order to avoid a division by zero error,
adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).
*/

SELECT r.name region, a.name account,
       round(o.total_amt_usd / (o.total + 0.01), 2) unit_price
FROM region r
INNER JOIN sales_reps s
ON r.id = s.region_id
INNER JOIN accounts a
ON s.id = a.sales_rep_id
INNER JOIN orders o
ON a.id = o.account_id
WHERE standard_qty > 100;

--5.
/*
Provide the name for each region for every order, as well as the account name and
the unit price they paid (total_amt_usd/total) for the order. However,
you should only provide the results if the standard order quantity exceeds 100 and
the poster order quantity exceeds 50. Your final table should have 3 columns:
region name, account name, and unit price. Sort for the smallest unit price first.
In order to avoid a division by zero error, adding .01 to the denominator here is
helpful (total_amt_usd/(total+0.01).
*/

SELECT r.name region, a.name account,
        round(o.total_amt_usd / (o.total + 0.01), 2) unit_price
FROM region r
INNER JOIN sales_reps s
ON r.id = s.region_id
INNER JOIN accounts a
ON s.id = a.sales_rep_id
INNER JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100 and o.poster_qty > 50
ORDER BY unit_price;

--6.
/*
Provide the name for each region for every order, as well as the account name and
the unit price they paid (total_amt_usd/total) for the order. However, you should
only provide the results if the standard order quantity exceeds 100 and the poster
 order quantity exceeds 50. Your final table should have 3 columns:
 region name, account name, and unit price. Sort for the largest unit price first.
 In order to avoid a division by zero error, adding .01 to the denominator here is
 helpful (total_amt_usd/(total+0.01).
*/

SELECT r.name region, a.name account,
       round(o.total_amt_usd / (o.total + 0.01), 2) unit_price
FROM region r
INNER JOIN sales_reps s
ON r.id = s.region_id
INNER JOIN accounts a
ON s.id = a.sales_rep_id
INNER JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100 and o.poster_qty > 50
ORDER BY unit_price DESC;

--7.
/*
What are the different channels used by account id 1001? Your final table should
have only 2 columns: account name and the different channels.
You can try SELECT DISTINCT to narrow down the results to only the unique values.
*/

SELECT DISTINCT a.name account, w.channel
FROM accounts a
INNER JOIN web_events w
ON a.id = w.account_id
WHERE a.id = 1001;

--8.
/*
Find all the orders that occurred in 2015. Your final table should
have 4 columns: occurred_at, account name, order total, and order total_amt_usd.
*/

SELECT o.occurred_at occurred_at,
       a.name account,
       o.total total,
       o.total_amt_usd total_amt_usd
FROM accounts a
INNER JOIN orders o
ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '2015-01-01' and '2016-01-01'
ORDER BY o.occurred_at DESC;
