--query a query
--A subquery is also called an inner query or inner select, while the statement containing
--a subquery is also called an outer query or outer select

--The inner query executes first before its parent query so that the results of an inner query
--can be passed to the outer query

--Allow you to answer more complex questions than you can with a single database table.

--also known as inner queries or nested queries

--A subquery is a SQL query nested inside a larger query.

/*
A subquery may occur in :
- A SELECT clause
- A FROM clause
- A WHERE clause
*/

--The subquery can be nested inside a SELECT, INSERT, UPDATE, or DELETE statement or
--inside another subquery.

/*
You can use a subquery in a SELECT, INSERT, DELETE, or UPDATE statement to perform the following tasks:

- Compare an expression to the result of the query.
- Determine if an expression is included in the results of the query.
- Check whether the query selects any rows.
*/

--A subquery is usually added within the WHERE Clause of another SQL SELECT statement.
--You can use the comparison operators, such as >, <, or =.
--The comparison operator can also be a multiple-row operator, such as IN, ANY, or ALL.



--Whenever we need to use existing tables to create a new table that we then want to query again,
--this is an indication that we will need to use some sort of subquery.

--Subquery General Rules
SELECT [DISTINCT] select_argument
FROM
    (SELECT [DISTINCT] subquery_select_argument
    FROM {table_name | view_name}
    {table_name | view_name} ...
    [WHERE search_conditions]
    [GROUP BY aggregate_expression [, aggregate_expression] ...]
    [HAVING search_conditions])
[WHERE search_conditions]
[GROUP BY aggregate_expression [, aggregate_expression] ...]
[HAVING search_conditions]
[ORDER BY ]


SELECT *
FROM
(SELECT DATE_TRUNC('day', occurred_at) as day,
       channel,
       COUNT(*) as event_count
FROM web_events
GROUP BY 1,2
ORDER BY 1
) sub

--also

SELECT channel,
       AVG(event_count) as avg_event_count
FROM
(SELECT DATE_TRUNC('day', occurred_at) as day,
       channel,
       COUNT(*) as event_count
FROM web_events
GROUP BY 1,2
) sub
 GROUP BY 1
 ORDER BY 2 DESC;

 --mine
 SELECT channel,
        AVG(event_count) as avg_event_count
FROM
    (SELECT DATE_TRUNC('day', occurred_at) as day,
            channel,
            COUNT(*) as event_count
    FROM web_events
    GROUP BY 1,2) sub1
GROUP BY 1
ORDER BY 2 DESC;
