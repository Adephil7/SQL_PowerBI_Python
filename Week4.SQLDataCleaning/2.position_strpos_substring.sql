--POSITION
--provides the position of a string counting from the left
--and then it returns a numerical value equal to how far to the left that particular character appears.
POSITION('character' IN string)

--STRPOS
--also provides the postion of a string counting from the left.
STRPOS( string or column, 'character')

--Note, both POSITION and STRPOS are case sensitive, so looking for A is different than looking for a.

--Therefore, if you want to pull an index regardless of the case of a letter, you might want
--to use LOWER or UPPER to make all of the characters lower or uppercase.

--Quizzes POSITION & STRPOS
--You will need to use what you have learned about LEFT & RIGHT, as well as what you know about
--POSITION or STRPOS to do the following quizzes.

--1.
--Use the accounts table to create first and last name columns that hold the first and last names
--for the primary_poc

SELECT primary_poc,
       LEFT(primary_poc, POSITION(' ' IN primary_poc)) firstname,
       RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc) ) AS lastname
FROM accounts;

--OR

SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name,
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
FROM accounts;
--2.
--Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.
SELECT name,
       LEFT(name, POSITION(' ' IN name)) firstname,
       RIGHT(name, LENGTH(name) - POSITION(' ' IN name) ) AS lastname
FROM sales_reps;

--OR
SELECT LEFT(name, STRPOS(name, ' ') -1 ) first_name,
       RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) last_name
FROM sales_reps;
