--So far in this course, we've only performed joins by exactly matching values from one table to another.

--There are pretty a number of scenario where you dont wanna join this way

--For example
--We want to look at how effective our campaigns are, we wanna look at all the action all our customer took
--prior to making their first paper purchase from Parch and Posey.

--That is,
--we ant to look at all web traffic events that occurred before that account's first order.
--Inequality operators in JOIN || Inequality operators (a.k.a. comparison operators)
--don't only need to be date times or numbers, they also work on strings! You'll see how this works by completing
--the following quiz, which will also reinforce the concept of joining with comparison operators.

--even if you are using inequality operator, you must use at least one equality
SELECT *
FROM orders o
LEFT JOIN web_events e
  ON e.account_id = o.account_id
    AND e.occurred_at < o.occurred_at
WHERE DATE_TRUNC('month', o.occurred_at) = (SELECT DATE_TRUNC('month', MIN(o.occurred_at))
                                            FROM orders
                                          )
ORDER BY o.account_id, o.occurred_at;

--QUESTIONS

/*
In the following SQL Explorer, write a query that left joins the accounts table and the sales_reps tables on each
sale rep's ID number and joins it using the < comparison operator on accounts.primary_poc
and sales_reps.name, like so:

accounts.primary_poc < sales_reps.name
The query results should be a table with three columns: the account name
(e.g. Johnson Controls), the primary contact name (e.g. Cammy Sosnowski), and the
sales representative's name (e.g. Samuel Racine). Then answer the subsequent multiple
choice question.
*/
SELECT a.name account_name,
	   a.primary_poc primary_poc_name,
       s.name sales_rep
FROM accounts a
LEFT JOIN sales_reps s
ON s.id = a.sales_rep_id AND a.primary_poc < s.name;
