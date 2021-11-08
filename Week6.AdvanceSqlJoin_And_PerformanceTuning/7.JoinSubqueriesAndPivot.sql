--FROM - Using PIVOT and UNPIVOT

--PIVOT rotates a table-valued expression by turning the unique values from one column in the expression
--into multiple columns in the output.

--And PIVOT runs aggregations where they're required on any remaining column values that are wanted in
--the final output.

SELECT <non-pivoted column>,
    [first pivoted column] AS <column name>,
    [second pivoted column] AS <column name>,
    ...
    [last pivoted column] AS <column name>
FROM
    (<SELECT query that produces the data>)
    AS <alias for the source query>
PIVOT
(
    <aggregation function>(<column being aggregated>)
FOR
[<column that contains the values that will become column headers>]
    IN ( [first pivoted column], [second pivoted column],
    ... [last pivoted column])
) AS <alias for the pivot table>
<optional ORDER BY clause>;

---------------------------------------------
--SUbqueries can be helpful in improving the perfomance of your queries.
--Imagine you are doing a high level reporting  for the PandP database
--and you'll like to see a bunch of metrics rolled up on a daily basis.
--Maybe to build a dashboard that will power the day-to-day business in quickly identifying anomalies.

--To do this, you'll need to join a few tables and then aggregate by day.
--but it is advisible to do the aggregating the tables individually in subqueries,
--then joining the pre-aggregated subqueries.

--we have to join date fields which causes what you might call a data explosion.

--Data Explosion =>
/*
The data explosion is the rapid increase in the amount of published information
 or data and the effects of this abundance. As the amount of available data grows,
 the problem of managing the information becomes more difficult, which can lead
 to information overload.
*/

/*
Basically, what happens is that you're joining every row in a given day from one table onto
every row with the same day in the other table.

This is multiplicative fact, you need to use count distinct instead of regular counts to
get accurate counts of the sales rep, the orders, and ultimately, the web visits.
*/
SELECT DATE_TRUNC('day')
 FROM accounts a
 JOIN orders o
  ON a.id = o.account_id
 JOIN web_events w
 ON DATE_TRUNC('day', w.occurred_at) = DATE_TRUNC('day', o.occurred_at)
GROUP BY 1
ORDER BY 1 DESC;


---------------better still
WITH orders as (
  SELECT DATE_TRUNC('day',o.occurred_at) as date,
         COUNT(a.sales_rep_id) as active_sales_reps,
         COUNT(o.id) as orders
   FROM accounts a
   JOIN orders o
     ON o.account_id = a.id
  GROUP BY 1
),
web_events as (
  SELECT DATE_TRUNC('day', w.occurred_at) as date,
         COUNT(w.id) as web_events
    FROM web_events w
      ON DATE_TRUNC('day', w.occurred_at) = DATE_TRUNC('day', o.occurred_at)
  GROUP BY 1
)
SELECT COALESCE(orders.date, web_events.date) as date,
       orders.active_sales_reps,
       orders.orders,
       web_events.web_visits
  FROM orders
  FULL JOIN web_events
         ON web_events.date = orders.date
ORDER BY 1 DESC
