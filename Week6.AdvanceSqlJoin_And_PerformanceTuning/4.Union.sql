--UNION Use Case

--The UNION operator is used to combine the result sets of 2 or more SELECT statements.

--It removes duplicate rows between the various SELECT statements.

--SQL's two strict rules for appending data:
--1. Both tables must have the same number of columns.
--2. Those columns must have the same data types in the same order as the first table.

--While the column names don't necessarily have to be the same, you will find that they typically are.

--SQL joins allow you to combine two datasets side-by-side, but UNION allows you to stack
--one dataset on top of the other.

--Syntax
SELECT [column names...]
  FROM Table1

 UNION

 SELECT [column names...]
   FROM table2

--Note that UNION only appends distinct values.

--More specifically, when you use UNION, the dataset is appended, and any rows in the appended
--table that are exactly identical to rows in the first table are dropped

--BUT

--If you'd like to append all the values from the second table, use UNION ALL
SELECT [column names...]
  FROM Table1

 UNION ALL

 SELECT [column names...]
   FROM table2
--Generally, Since you are writing two separate SELECT statements, you can treat them differently
--before appending. For example, you can filter them differently using different WHERE clauses.

--Performing Operations on a Combined Dataset
--Write your union statment as subquery

WITH t3 as (
  SELECT [column names...]
    FROM Table1
  [WHERE conditions]

   UNION ALL

   SELECT [column names...]
     FROM table2
   [WHERE conditions]
)
SELECT [column names]
  FROM t3
WHERE conditions
GROUP BY col
ORDER BY col


--Appending Data via UNION
--Write a query that uses UNION ALL on two instances (and selecting all columns) of the accounts
--table. Then inspect the results and answer the subsequent quiz.
SELECT *
 FROM accounts

UNION ALL

SELECT *
 FROM accounts;

 --Without rewriting and running the query, how many results would be returned if you used UNION
 --instead of UNION ALL in the above query?
--ANSwer
--351


--------------
--Pretreating Tables before doing a UNION
--Add a WHERE clause to each of the tables that you unioned in the query above, filtering the
--first table where name equals Walmart and filtering the second table where name equals Disney.
--Inspect the results then answer the subsequent quiz.

--result
--2

SELECT *
 FROM accounts
WHERE name = 'Walmart'

UNION

SELECT *
 FROM accounts
WHERE name = 'Disney';

--------------------
--Performing Operations on a Combined Dataset
--Perform the union in your first query (under the Appending Data via UNION header) in a common
--table expression and name it double_accounts. Then do a COUNT the number of times a name
--appears in the double_accounts table. If you do this correctly, your query results should have
--a count of 2 for each name.

WITH double_accounts as (
    SELECT *
     FROM accounts

    UNION ALL

    SELECT *
     FROM accounts
)
SELECT name,
	   COUNT(*) AS name_count
FROM double_accounts
GROUP BY 1
ORDER BY 2 DESC;
