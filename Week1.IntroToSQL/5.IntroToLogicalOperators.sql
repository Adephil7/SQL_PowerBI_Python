/*
Introduction to Logical Operators

In the next concepts, you will be learning about Logical Operators. Logical Operators include:

1. LIKE This allows you to perform operations similar to using WHERE and =, but for cases when you might not know exactly what you are looking for.
2. IN This allows you to perform operations similar to using WHERE and =, but for more than one condition.
3. NOT This is used with IN and LIKE to select all of the rows NOT LIKE or NOT IN a certain condition.
4. AND & BETWEEN These allow you to combine operations where all combined conditions must be true.
5. OR This allows you to combine operations where at least one of the combined conditions must be true.

*/

--LIKE
--The LIKE operator is extremely useful for working with text.
--You will use LIKE within a WHERE clause. The LIKE operator is frequently used with %.
--used for one value filtering

--Questions using the LIKE operator
--Use the accounts table to find

--1. All the companies whose names start with 'C'.
SELECT *
FROM accounts
WHERE name LIKE 'C%';

--2. All companies whose names contain the string 'one' somewhere in the name.

SELECT *
FROM accounts
WHERE name LIKE '%one%';

--3. All companies whose names end with 's'.
SELECT *
FROM accounts
WHERE name LIKE '%s';

--4. Use the accounts table to
  --find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.
select name,
		primary_poc,
        sales_rep_id
from accounts
where name IN ('Walmart','Target','Nordstrom');

--5. Use the web_events table to find all information
  --regarding individuals who were contacted via the channel of organic or adwords

  select *
  from web_events
  where channel IN ('organic','adwords');

  /*
NOT

The NOT operator is an extremely useful operator for working with the previous two operators we introduced:
 IN and LIKE. By specifying NOT LIKE or NOT IN,
we can grab all of the rows that do not meet a particular criteria.
*/

--Use the accounts table to find the account name, primary poc, and sales rep id for all stores except Walmart, Target, and Nordstrom.
select name,
		primary_poc,
        sales_rep_id
from accounts
where name NOT IN ('Walmart','Target','Nordstrom');

--Use the web_events table to find all information regarding individuals who were contacted via any method except using organic or adwords methods.
select *
 from web_events
 where channel NOT IN ('organic','adwords');

 --All the companies whose names do not start with 'C'.
 SELECT *
FROM accounts
WHERE name NOT LIKE 'C%';

--All companies whose names do not contain the string 'one' somewhere in the name.
SELECT *
FROM accounts
WHERE name NOT LIKE '%one%';

--All companies whose names do not end with 's'.
SELECT *
FROM accounts
WHERE name NOT LIKE '%s';

--Questions using AND and BETWEEN operators

--1. Write a query that returns all the orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0.
SELECT *
FROM orders
where standard_qty > 1000 and (poster_qty = 0 and gloss_qty = 0);

--2. Using the accounts table, find all the companies whose names do not start with 'C' and end with 's'.
SELECT *
FROM accounts
where name NOT LIKE 'C%' and name NOT LIKE '%s';

--3.When you use the BETWEEN operator in SQL, do the results include the values of your endpoints, or not?
  --Figure out the answer to this important question by writing a query that displays the order date and gloss_qty data for all orders where gloss_qty is between 24 and 29. Then look at your output to see if the BETWEEN operator included the begin and end values or not.
SELECT occurred_at,
		gloss_qty
FROM orders
where gloss_qty BETWEEN 24 AND 29
ORDER BY occurred_at DESC;

--4. Use the web_events table to find all information regarding individuals who were contacted via the organic or adwords channels, and started their account at any point in 2016, sorted from newest to oldest.
SELECT *
FROM web_events
where channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;


--OR

--Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table.

select id
from orders
where gloss_qty > 4000 or poster_qty > 4000;

--Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.
select *
from orders
where standard_qty = 0 and (gloss_qty > 1000 or poster_qty > 1000);

--Find all the company names that start with a 'C' or 'W', and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.
select *
from accounts
where (name like 'C%' or name like 'W%')
      and ((primary_poc like '%ana%' or primary_poc like '%Ana%') and primary_poc not like '%eana%'); 
