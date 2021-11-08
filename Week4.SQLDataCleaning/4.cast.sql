--CAST
--allow us to change from one data type to another.
 CAST(date_column AS DATE)
--both CAST and '::' allows us to change from one datatype to another

--CAST is usually used to change strings into number and date.

SELECT *,
       DATE_PART('month', TO_DATE(month, 'month')) as clean_month,
       year || '-' || DATE_PART('month', TO_DATE(month, 'month')) || '-' || day as concatenated_date,
       CAST(year || '-' || DATE_PART('month', TO_DATE(month, 'month')) || '-' || day AS date) AS formatted_date,
       (year || '-' || DATE_PART('month', TO_DATE(month, 'month')) || '-' || day) :: date AS formatted_date_alt

FROM ad.clicks

--DATE_PART('month', TO_DATE(month, 'month')) here changed a month name into the number associated with that particular month.
https://www.postgresqltutorial.com/postgresql-cast/

/*
Expert Tip
Most of the functions presented in this lesson are specific to strings.
They won’t work with dates, integers or floating-point numbers.
However, using any of these functions will automatically change the data to the
appropriate type.

LEFT, RIGHT, and TRIM are all used to select only certain elements of strings,
but using them to select elements of a number or date will treat them as strings for
the purpose of the function. Though we didn't cover TRIM in this lesson explicitly,
it can be used to remove characters from the beginning and end of a string.
This can remove unwanted spaces at the beginning or end of a row that often happen
with data being moved from Excel or other storage systems.

There are a number of variations of these functions, as well as several other string
functions not covered here. Different databases use subtle variations on these functions,
 so be sure to look up the appropriate database’s syntax if you’re connected to a
 private database.The Postgres literature (https://www.postgresql.org/docs/9.1/functions-string.html) contains a lot of the related functions.
*/

--SUBSTR() ==> Extract a substring from a string (start at position 5, extract 3 characters)

SELECT date orig_date,
       (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2)) new_date
FROM sf_crime_data;

--Notice, this new date can be operated on using DATE_TRUNC and DATE_PART in the same way as earlier lessons
SELECT date orig_date,
       (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE new_date
FROM sf_crime_data;
