--Even though databases are powerful, you may still find yourselve running some queries that hours to return.

--In those cases, you want to take extra effort to write your queries in ways that will allow your database to execute them as fast as possible.

--Here, you will learn how your queries can be improved and how to improve them.

--How You Can and Can't Control Performance

--The database is a software that runs on the computer and it's subject to the same limitations as all software.
--It can only process as much information as the hardware is capable of handling.

--1.
--The way you can make your queries run faster is to reduce the number of calculations that need to be performed.
--To do this, you'll need some understanding of how SQL actually makes those calculations.

--Let us treat something at high level.
--That can affect the number of calculations a given query will make
--1. Table size
--2. Joins
--3. Aggregations
--1.
--Table size is incredibly important.
--e.g If your query hits one or more tables with millions of rows or more, It could affect performance.

--2.
--If your query joins two tables, in a way that substantially increases the row count of the result set,
--your query is likely to be slow.

--3. Aggregations can drammatically impact query runtime.
--combinig multiple rows to produce a result requires more computation than simply retrieving those rows.

--In particular, count distinct takess a very long time compared to the regular count, because it must check all rows against one another for duplicate values.


---Likewise, query performance are also dependent on somethings that you cannot control, that are related to the database itself.
--Query runtime is also dependent on some things that you can’t really control related to the database itself:
--The more queries running concurrently on a database,

--1. Other users running queries concurrently on the database
--2. Database software and optimization (e.g., Postgres is optimized differently than Redshift)
--Postgres good for DDL and Redshift good for Aggregations


------------------------------
--1. It is advisible to use limit on the subquery not the outer query to improve perfomance.

--But keep in mind that adding a limit to a subquery will dramatically alter your results.
--So, you can use it to check query logic but not to get actual results.
--Especially, use it for Exploratory Data Analysis(EDA)

--2. If you have time series data, limiting to a small time window can make your queries run more quickly.

--NOTE THAT
--Applying LIMIT 10 when aggregating data to one row (i.e with a GROUP BY) will speed up your queries.

--3. reduce the number of columns in ur join queries
SELECT a.name,
       sub.web_events
 FROM (
   SELECT account_id,
          COUNT(*) as web_events
      FROM web_events e
    GROUP BY 1
 ) sub
  JOIN accounts a
    ON a.id = sub.account_id
  ORDER BY 2 DESC;
