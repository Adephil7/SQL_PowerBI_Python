--DATE_TRUNC function
--Use the DATE_TRUNC() function to round off a timestamp.
--By aggregating data usind rounded timestamps you can find time-based trends
--like daily purchases or messages sent per second.

--This function requires two components,
--the unit of time and the timestamp column name.
--DATE_TRUNC('[interval]', timr-column);

--the unit of time such as the following microsecond, millisecond, second, minute,
--hour, day, week, month, quarter, year, decade, century and millennium

--e.g
SELECT occurred_at,
       DATE_TRUNC('day', occurred_at) as day,
       DATE_TRUNC('minute', occurred_at) as minute
FROM accounts;

--If the above timestamp were rounded down to 'day', the result is:

2015-10-06T00:00:00.000Z

--If it were rounded down to 'minute', it would look like this:

2015-10-06T11:54:00.000Z

--Likewise, ‘second’ rounds down to the nearest second, 'hour' down to the nearest hour, and so on.
--'week' rounds down to that Monday's date.

--DATE_TRUNC() is particularly useful when you want to aggregate information over an interval of time.

---Creating a time-series with truncated timestamps

--A time series is a sequence of data points that occur in successive order over some period of time.
--That is, a data set that tracks a sample over time

SELECT occurred_at,
       COUNT(id)
  FROM benn.fake_fact_events
 WHERE event_name = 'complete_signup'
   AND occurred_at >= '2014-03-10'
   AND occurred_at <= '2014-05-26'
 GROUP BY 1
 ORDER BY 1 DESC

/*
In particular, a time series allows one to see what factors influence certain variables from period to period.

Time series analysis can be useful to see how a given asset, security, or economic variable changes over time.
*/

--To learn more, visit https://mode.com/blog/date-trunc-sql-timestamp-function-count-on/


--DATE_PART

--DATE_PART can be useful for pulling a specific portion of a date
--but notice pulling month or day of the week (dow) means that you are no longer keeping the years in order.

--Rather you are grouping for certain components regardless of which year they belonged in.

DATE_PART(text, timestamp) or simply DATE_PART('field', source)

--visit https://www.postgresql.org/docs/9.1/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT

--text 'day' to extract day == returns  the day (of the month) field (1 - 31)
--text 'dow' to extract day == returns The day of the week as Sunday (0) to Saturday (6)
--text 'doy' to extract day == returns The day of the year (1 - 365/366)
--text 'hour' ==returns The hour field (0 - 23)
--text 'isodow' ==returns The day of the week as Monday (1) to Sunday (7)
--text 'isoyear' == The ISO 8601 week-numbering year that the date falls in (not applicable to intervals)
--text 'month' == returns  the number of the month within the year (1 - 12)
--text 'quarter' == returns The quarter of the year (1 - 4) that the date is in
--text 'week' == returns The number of the ISO 8601 week-numbering week of the year. By definition, ISO weeks start on Mondays and the first week of a year contains January 4 of that year. In other words, the first Thursday of a year is in week 1 of that year.
--text 'year' ==returns The year field. Keep in mind there is no 0 AD, so subtracting BC years from AD years should be done with care.

--OTHER DATE/TIME FUNCTIONS
age(timestamp, timestamp) --	Subtract arguments, producing a "symbolic" result that uses years and months
age(timestamp) -- Subtract from current_date (at midnight)
current_date -- returns the current date
current_time -- returns the current time of the day
current_timestamp -- returns the current timestamp
now() -- returns Current date and time (start of current transaction

--For example
--1. which day has the must sale in patch and porch database
SELECT DATE_PART('dow', occurred_at) as day_of_week,
       SUM(total) as total_qty
FROM orders
GROUP BY 1
ORDER BY 2;

-- 1 => first column in the select statements
-- 2 => second column in the select statement and so on.

--QUESTIONS
--1.
--Find the sales in terms of total dollars for all orders in each year, ordered from
--greatest to least. Do you notice any trends in the yearly sales totals?
SELECT DATE_PART('year', occurred_at) as ord_year,
       SUM(total_amt_usd) as total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

--2.
--Which month did Parch & Posey have the greatest sales in terms of total dollars?
--Are all months evenly represented by the dataset?
SELECT DATE_PART('month', occurred_at) as ord_month,
       SUM(total_amt_usd) as total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

--AND
-- ==> all months evenly represented by the dataset
SELECT DATE_PART('month', occurred_at) as month,
       SUM(total_amt_usd) as total_sales
FROM orders
GROUP BY 1
ORDER BY 1, 2;

--OR

SELECT DATE_PART('month', occurred_at) ord_month, SUM(total_amt_usd) total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;

--3.
--Which year did Parch & Posey have the greatest sales in terms of total number of orders?
--Are all years evenly represented by the dataset?
SELECT DATE_PART('year', occurred_at) ord_year,  COUNT(*) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

--AND
-- ===> all years evenly represented by the dataset

--4.
--Which month did Parch & Posey have the greatest sales in terms of total number of orders?
--Are all months evenly represented by the dataset?

SELECT DATE_PART('month', occurred_at) as ord_month,
       COUNT(total) as total_sales
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;

--5.
--In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
SELECT DATE_PART('month', o.occurred_at) as month,
       SUM(o.gloss_amt_usd) as total_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1, a.name
HAVING a.name ='Walmart'
ORDER BY 2 DESC
LIMIT 1;

--OR

SELECT DATE_TRUNC('month', o.occurred_at) ord_date, SUM(o.gloss_amt_usd) tot_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
