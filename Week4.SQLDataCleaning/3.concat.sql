--CONCAT
--combines values from several column into one column
SELECT *
FROM customer_data

/*
CONCAT
Piping ||
Each of these will allow you to combine columns together across rows. In this video, you saw how
first and last names stored in separate columns could be combined together to create a full name:
CONCAT(first_name, ' ', last_name) or with piping as first_name || ' ' || last_name
*/

--Quizzes CONCAT
--1.
--Each company in the accounts table wants to create an email address for each primary_poc.
--The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.

WITH t1 AS (SELECT
                   LOWER(LEFT(primary_poc, POSITION(' ' IN primary_poc))) as firstname,
                   LOWER(RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc) )) AS lastname,
                   LOWER(name) as company_name
                   FROM accounts
            )

SELECT CONCAT(firstname,'.',lastname,'@',company_name,'.com' ) as email
FROM t1;

--2.
/*
You may have noticed that in the previous solution some of the company names include spaces,
which will certainly not work in an email address. See if you can create an email address that
will work by removing all of the spaces in the account name, but otherwise your solution should be
just as in question 1. Some helpful documentation is: https://www.postgresql.org/docs/8.1/functions-string.html
*/

--REPLACE string function
--REPLACE(string, old_string, new_string)
--The REPLACE() function replaces all occurrences of a substring within a string, with a new substring.
--Note: The search is case-insensitive.
WITH t1 AS (SELECT
                   LOWER(LEFT(primary_poc, POSITION(' ' IN primary_poc))) as firstname,
                   LOWER(RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc) )) AS lastname,
                   REPLACE(LOWER(name), ' ', '') as company_name
            FROM accounts
            )

SELECT CONCAT(firstname,'.',lastname,'@',company_name,'.com' ) as email
FROM t1;

--3.
/*
We would also like to create an initial password, which they will change after their first log in.
The first password will be the first letter of the primary_poc's first name (lowercase),
then the last letter of their first name (lowercase), the first letter of their last name (lowercase),
the last letter of their last name (lowercase), the number of letters in their first name,
the number of letters in their last name, and then the name of the company they are working with,
all capitalized with no spaces.
*/

WITH t1 AS (SELECT

                   LOWER(LEFT(primary_poc, POSITION(' ' IN primary_poc) - 1)) as firstname,
                   LOWER(RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc) )) AS lastname,
                   REPLACE(LOWER(name), ' ', '') as company_name
            FROM accounts
            )

SELECT firstname, lastname,
       CONCAT(firstname,'.',lastname,'@',company_name,'.com' ) as email,
       CONCAT(LEFT(firstname, 1),
              RIGHT(firstname, 1),
              LEFT(lastname, 1),
              RIGHT(lastname, 1),
              LENGTH(firstname),
              LENGTH(lastname),
              UPPER(company_name)) as password
FROM t1;
