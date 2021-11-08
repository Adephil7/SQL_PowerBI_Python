/*
In this lesson, you will be learning a number of techniques to

i.   Clean and re-structure messy data.
ii.  Convert columns to different data types.
iii. Tricks for manipulating NULLs.
*/

--LEFT & RIGHT
--LEFT
--pull characters from the left side of the string and present them as a seperate string.
LEFT('string', NumberOfStringsToSelect)

/*
LEFT
pulls a specified number of characters for each row in a specified column starting at the beginning
(or from the left). As you saw here, you can pull the first three digits of a phone number using
LEFT(phone_number, 3)
*/

--RIGHT
--pull characters from the right side of the string and present them as a seperate string.
RIGHT('string', NumberOfStringsToSelect)

/*
RIGHT
pulls a specified number of characters for each row in a specified column starting at the end
(or from the right). As you saw here, you can pull the last eight digits of a phone number using
RIGHT(phone_number, 8).
*/

--LENGTH
--pulls the length of a string.

/*
LENGTH provides the number of characters for each row of a specified column. Here, you saw that we could
use this to get the length of each phone number as LENGTH(phone_number).
*/

--DOMAINs and web hosting
https://iwantmyname.com/domains

--LEFT & RIGHT Quizzes
--1.
/*
In the accounts table, there is a column holding the website for each company. The last three digits
specify what type of web address they are using. A list of extensions (and pricing) is provided here.
Pull these extensions and provide how many of each website type exist in the accounts table.
*/

SELECT RIGHT(website, 3) AS domain,
		   COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 1 DESC;

--2.
/*
There is much debate about how much the name (or even the first letter of a company name) matters.
Use the accounts table to pull the first letter of each company name to see the distribution of
company names that begin with each letter (or number).
*/
SELECT LEFT(name, 1),
		 COUNT(*)
FROM accounts
GROUP BY 1
ORDER BY 1;

--OR

SELECT LEFT(UPPER(name), 1) AS first_letter, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

--3.
/*
Use the accounts table and a CASE statement to create two groups: one group of company names that
start with a number and a second group of those company names that start with a letter. What proportion
of company names start with a letter?
*/
SELECT CASE WHEN LEFT(name,1) in ('0','1','2','3','4','5','6','7','8','9')
			      THEN 1
        	  ELSE 0
		   END AS num,
       CASE WHEN LEFT(name,1) NOT IN ('0','1','2','3','4','5','6','7','8','9')
			      THEN 1
          	ELSE 0
		   END AS letter
FROM accounts;


WITH datatype_check AS (
  SELECT CASE WHEN LEFT(name,1) in ('0','1','2','3','4','5','6','7','8','9')
  			      THEN 1
          	  ELSE 0
  		   END AS num,
         CASE WHEN LEFT(name,1) NOT IN ('0','1','2','3','4','5','6','7','8','9')
  			      THEN 1
            	ELSE 0
  		   END AS letter
  FROM accounts)

SELECT SUM(num) total_num,
       SUM(letter) total_letter
FROM datatype_check;

--4.
/*
Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel,
and what percent start with anything else?
*/

WITH t1 AS (
            SELECT
            CASE WHEN UPPER(LEFT(name, 1)) IN ('A', 'E', 'I', 'O', 'U') THEN 1 ELSE 0 END AS vowel,
            CASE WHEN UPPER(LEFT(name, 1)) IN ('A', 'E', 'I', 'O', 'U') THEN 0 ELSE 1 END AS other
            FROM accounts)

SELECT SUM(vowel) AS vowels, SUM(other) AS others
FROM t1
