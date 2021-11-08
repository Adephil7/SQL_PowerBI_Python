/*
Derived Columns
Creating a new column that is a combination of existing columns is known as a derived column
(or "calculated" or "computed" column).
Usually you want to give a name, or "alias," to your new column using the AS keyword.
*/

/*
1. Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order.
Limit the results to the first 10 orders, and include the id and account_id fields.
*/

SELECT id,
		account_id,
		standard_amt_usd/standard_qty AS standard_unitprice
FROM orders
LIMIT 10;

/*
2. Write a query that finds the percentage of revenue that comes from poster paper for each order.
You will need to use only the columns that end with _usd.
 (Try to do this without using the total column.) Display the id and account_id fields also.
*/

SELECT id,
			account_id,
			ROUND((poster_amt_usd/total_amt_usd)*100, 2) AS post_percent
FROM orders
LIMIT 10;
