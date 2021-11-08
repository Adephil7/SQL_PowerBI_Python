--WHERE Clause comes before ORDER BY Clause
--WHERE command as filtering the data

/*
> (greater than)

< (less than)

>= (greater than or equal to)

<= (less than or equal to)

= (equal to)

!= (not equal to)
*/

--1.
/*
Pulls the first 5 rows and all columns from the orders table
that have a dollar amount of gloss_amt_usd greater than or equal to 1000.
*/

SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000;

--2.
/*
Pulls the first 10 rows and all columns from the orders table that have a total_amt_usd less than 500.
*/

SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

/*
The WHERE statement can also be used with non-numeric data. We can use the = and != operators here.
You need to be sure to use single quotes (just be careful if you have quotes in the original text) with
the text data, not double quotes.

Commonly when we are using WHERE with non-numeric data fields, we use the LIKE, NOT, or IN operators.
We will see those before the end of this lesson!
*/

--3.
/*
Filter the accounts table to include the company name, website, and the primary point of contact (primary_poc)
 just for the Exxon Mobil company in the accounts table.
*/
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';
