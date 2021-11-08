/*
In the first subquery you wrote, you created a table that you could then query again in the
FROM statement. However, if you are only returning a single value, you might use that value in
a logical statement like WHERE, HAVING, or even SELECT - the value could be nested within a
CASE statement.

Expert Tip
Note that you should not include an alias when you write a subquery in a conditional statement.
This is because the subquery is treated as an individual value (or set of values in the IN case)
rather than as a table.

Also, notice the query here compared a single value. If we returned an entire column IN would
need to be used to perform a logical argument. If we are returning an entire table, then we must
use an ALIAS for the table, and perform additional logic on the entire table.
*/

SELECT DATE_TRUNC('month', min(occurred_at)) as year_month
FROM orders;


SELECT AVG(standard_qty) avg_standard,
		   AVG(gloss_qty) avg_gloss,
       AVG(poster_qty) avg_poster
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = (SELECT DATE_TRUNC('month', min(occurred_at)) as year_month
                                          FROM orders);


SELECT SUM(total_amt_usd) total
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =  (SELECT DATE_TRUNC('month', min(occurred_at)) as year_month
                                          FROM orders);

--More Subqueries Quizzes
/*
Above is the ERD for the database again - it might come in handy as you tackle the quizzes below.
You should write your solution as a subquery or subqueries, not by finding one solution and
copying the output. The importance of this is that it allows your query to be dynamic in
answering the question - even if the data changes, you still arrive at the right answer.
*/

--1.
--Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

--First, I wanted to find the total_amt_usd totals associated with each sales rep, and I also wanted
--the region in which they were located. The query below provided this information.

SELECT s.name sales_rep,
       r.name region,
       SUM(total_amt_usd) total_sales
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1,2
ORDER BY 3 DESC;

--Next, I pulled the max for each region, and then we can use this to pull those rows in our final result

SELECT t1.region,
       MAX(t1.total_sales)
FROM
      (SELECT s.name sales_rep,
             r.name region,
             SUM(total_amt_usd) total_sales
      FROM region r
      JOIN sales_reps s
      ON r.id = s.region_id
      JOIN accounts a
      ON s.id = a.sales_rep_id
      JOIN orders o
      ON a.id = o.account_id
      GROUP BY 1,2) t1
GROUP BY 1;

--Essentially, this is a JOIN of these two tables, where the region and amount match


SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM(SELECT t1.region region_name, MAX(t1.total_sales) total_amt
     FROM(SELECT s.name rep_name, r.name region, SUM(o.total_amt_usd) total_sales
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY 1, 2) t1
     GROUP BY 1) t2
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
     FROM sales_reps s
     JOIN accounts a
     ON a.sales_rep_id = s.id
     JOIN orders o
     ON o.account_id = a.id
     JOIN region r
     ON r.id = s.region_id
     GROUP BY 1,2
     ORDER BY 3 DESC) t3
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;

--2.
--For the region with the largest (sum) of sales total_amt_usd,
--how many total (count) orders were placed?

--firstly pull out regions and the sum of sales total_amt_usd associated with it
--likewise the count orders associated

SELECT r.name region,
       SUM(total_amt_usd) total_sales,
       COUNT(*) ord_count
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2,3 DESC;

--pull out the region with the largest (sum) of sales total_amt_usd
SELECT MAX(t1.total_sales)
FROM
      (SELECT r.name region,
             SUM(o.total_amt_usd) total_sales,
             COUNT(*) ord_count
      FROM region r
      JOIN sales_reps s
      ON r.id = s.region_id
      JOIN accounts a
      ON s.id = a.sales_rep_id
      JOIN orders o
      ON a.id = o.account_id
      GROUP BY 1
      ORDER BY 2,3 DESC) t1;

--Finally, we want to pull the total orders for the region with this amount:
SELECT r.name region_name,
			 COUNT(*) total_order
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total_amt_usd) = (SELECT MAX(t1.total_sales)
															FROM (SELECT r.name region,
																					 SUM(o.total_amt_usd) total_sales,
             								 							 COUNT(*) ord_count
      															 FROM region r
      												 			 JOIN sales_reps s
																		 ON r.id = s.region_id
																		 JOIN accounts a
																		 ON s.id = a.sales_rep_id
																		 JOIN orders o
																		 ON a.id = o.account_id
																		 GROUP BY 1
																		 ORDER BY 2,3 DESC) t1);

--3.
--How many accounts had more total purchases than the account name which has bought
--the most standard_qty paper throughout their lifetime as a customer?

--the account name which has bought
--the most standard_qty paper throughout their lifetime as a customer
SELECT a.name account_name,
			 SUM(o.standard_qty) total_standard_qty,
			 SUM(o.total) overall_total
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

--with most overall_total
SELECT t1.overall_total
FROM (SELECT a.name account_name,
			 			 SUM(o.standard_qty) total_standard_qty,
			 		 	 SUM(o.total) overall_total
			FROM accounts a
			JOIN orders o
			ON a.id = o.account_id
			GROUP BY 1
			ORDER BY 2 DESC
			LIMIT 1) t1;

--accounts had more total purchases than the account name which has bought
--the most standard_qty paper throughout their lifetime as a customer
SELECT a.name
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total) > (SELECT t1.overall_total
											 FROM (SELECT a.name account_name,
			 			 				 	 							SUM(o.standard_qty) total_standard_qty,
																		SUM(o.total) overall_total
															FROM accounts a
															JOIN orders o
															ON a.id = o.account_id
															GROUP BY 1
															ORDER BY 2 DESC
															LIMIT 1) t1);

--This is now a list of all the accounts with more total orders.
--We can get the count with just another simple subquery.
SELECT COUNT(*)
FROM (SELECT a.name
			FROM orders o
			JOIN accounts a
			ON a.id = o.account_id
			GROUP BY 1
			HAVING SUM(o.total) > (SELECT t1.overall_total
														 FROM (SELECT a.name account_name,
						 			 				 	 							SUM(o.standard_qty) total_standard_qty,
																					SUM(o.total) overall_total
																		FROM accounts a
																		JOIN orders o
																		ON a.id = o.account_id
																		GROUP BY 1
																		ORDER BY 2 DESC
																		LIMIT 1) t1)
															) t2;

--4.
--For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd,
--how many web_events did they have for each channel?

--solve the inner most query
--Here, we first want to pull the customer with the most spent in lifetime value.
SELECT a.id account_id,
			 a.name account_name,
			 SUM(o.total_amt_usd) tot_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY 3 DESC
LIMIT 1;

--select the id of the most spent customer
SELECT t1.account_id
FROM (SELECT a.id account_id,
			 			 a.name account_name,
			 		 	 SUM(o.total_amt_usd) tot_spent
			FROM accounts a
			JOIN orders o
			ON a.id = o.account_id
			GROUP BY a.id, a.name
			ORDER BY 3 DESC
			LIMIT 1) t1

--Now, we want to look at the number of events on each channel this company had,
--which we can match with just the id.
SELECT a.name account_name,
			 w.channel channel,
			 COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id = (SELECT t1.account_id
																	 FROM (SELECT a.id account_id,
																					 			a.name account_name,
																					 		 	SUM(o.total_amt_usd) tot_spent
																					FROM accounts a
																					JOIN orders o
																					ON a.id = o.account_id
																					GROUP BY a.id, a.name
																					ORDER BY 3 DESC
																					LIMIT 1) t1)
GROUP BY a.name, w.channel
ORDER BY 3 DESC;

--5.
--What is the lifetime average amount spent in terms of total_amt_usd for the
--top 10 total spending accounts?

--select the top 10 total spending accounts
SELECT a.id account_id,
			 a.name account_name,
			 SUM(total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY 3 DESC
LIMIT 10;

--lifetime average amount spent in terms of total_amt_usd for the
--top 10 total spending accounts
SELECT AVG(t1.total_spent)
FROM (SELECT a.id account_id,
						 a.name account_name,
						 SUM(total_amt_usd) total_spent
			FROM accounts a
			JOIN orders o
			ON a.id = o.account_id
			GROUP BY a.id, a.name
			ORDER BY 3 DESC
			LIMIT 10) t1

--6.
--What is the lifetime average amount spent in terms of total_amt_usd, including
--only the companies that spent more per order, on average, than the average of all orders.

--First, we want to pull the average of all accounts in terms of total_amt_usd:

SELECT AVG(o.total_amt_usd) avg_all
FROM orders o

--Then, we want to only pull the accounts with more than this average amount.
SELECT o.account_id,
			 AVG(o.total_amt_usd)
FROM orders o
GROUP BY 1
HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_all
                               FROM orders o);

--Finally, we just want the average of these values.
SELECT AVG(avg_amt)
FROM (SELECT o.account_id,
						 AVG(o.total_amt_usd) avg_amt
    	FROM orders o
    	GROUP BY 1
    	HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_all
                                   	 FROM orders o)) temp_table;
