--MIN and MAX functions
--here we were simultaneously obtaining the MIN and MAX number of value in a particular column.
--Notice that MIN and MAX are aggregators that again ignore NULL values.
/*
Expert Tip
Functionally, MIN and MAX are similar to COUNT in that they can be used on non-numerical columns.
Depending on the column type, MIN will return the lowest number, earliest date, or
non-numerical value as early in the alphabet as possible. As you might suspect, MAX does
the opposite—it returns the highest number, the latest date, or the non-numerical value
closest alphabetically to “Z.”
*/

--AVG functions
--AVG returns the mean of the data - that is the sum of all of the values in the column
--divided by the number of values in a column.
--This aggregate function again ignores the NULL values in both the numerator and the denominator.
/*
MEDIAN - Expert Tip
One quick note that a median might be a more appropriate measure of center for this data,
but finding the median happens to be a pretty difficult thing to get using SQL alone
— so difficult that finding a median is occasionally asked as an interview question.
*/

--Calculate the median by using PERCENTILE_COUNT (SQL Server 2012 and later versions)
/*
An analytic function called PERCENTILE_CONT was introduced in SQL Server 2012.
It is capable of calculating the median within a partitioned set.
It calculates the median when we pass 0.5 as an argument and specify the order within that dataset.
*/
SELECT INVOICENUMBER,
       PRICE,
       PERCENTILE_CONT(0.5)
         WITHIN GROUP (ORDER BY PRICE) OVER (
           PARTITION BY INVOICENUMBER) AS MEDIANCONT
FROM   INVOICE
ORDER  BY INVOICENUMBER DESC


--Questions: MIN, MAX, & AVERAGE

--1.
--When was the earliest order ever placed? You only need to return the date.
SELECT MIN(occurred_at) as first_order_date
FROM orders;

2013-12-04T04:22:44.000Z
--2.
--Try performing the same query as in question 1 without using an aggregation function.
SELECT occurred_at as first_order_date
FROM orders
ORDER BY occurred_at
LIMIT 1;

2013-12-04T04:22:44.000Z

--3.
--When did the most recent (latest) web_event occur?
SELECT MAX(occurred_at) as latest_order_date
FROM web_events;

--4.
--Try to perform the result of the previous query without using an aggregation function.
SELECT occurred_at as latest_date
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

--5.
--
--Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount
--of each paper type purchased per order. Your final answer should have 6 values - one for
--each paper type for the average number of sales, as well as the average amount.

SELECT  AVG(standard_qty) standard_mean,
		    AVG(gloss_qty) gloss_mean,
        AVG(poster_qty) poster_mean,
        AVG(standard_amt_usd) mean_standard_usd,
        AVG(gloss_amt_usd) mean_gloss_usd,
        AVG(poster_amt_usd) mean_poster_usd
FROM orders;

--6.
--Via the video, you might be interested in how to calculate the MEDIAN.
--Though this is more advanced than
--what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders?
SELECT PERCENTILE_CONT(0.5)
       WITHIN GROUP (ORDER BY total_amt_usd) AS median_total_usd
FROM orders;

--OR
/*
Since there are 6912 orders - we want the average of the 3457 and 3456 order amounts when ordered.
This is the average of 2483.16 and 2482.55. This gives the median of 2482.855.
This obviously isn't an ideal way to compute. If we obtain new orders, we would have to change
the limit. SQL didn't even calculate the median for us. The above used a SUBQUERY, but you
could use any method to find the two necessary values, and then you just need the average of them.
*/
SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;



--divide the result by 2
