--INNER JOIN

--Only returns rows that appear in both tables
--just like intersection works in set theory

--LEFT and RIGHT OUTER JOINS

--Join statement are always like This

SELECT *
FROM left table
[inner or left or right] JOIN right table
ON ----
[filtering]
[sorting]


--Notice each of these new JOIN statements pulls all the same rows as an INNER JOIN,
--That is, we have always pulled rows only if they exist as a match across two tables.
--which you saw by just using INNER JOIN, but they also potentially pull some additional rows.

--Our new JOINs allow us to pull rows that might only exist in one of the two tables.
--This will introduce a new data type called NULL.

 --If its LEFT JOIN also called LEFT OUTER JOIN
 --additional rows from the left table which are without match on the right table will be included
--in set theory say set A and B; (A U B) - B

 --Meanwhile

 --If its RIGHT JOIN alsp called RIGHT OUTER JOIN
 --additional rows from the right table which are without match on the left table will be included
--in set theory say set A and B; (A U B) - A

--OUTER JOINS also called FULL OUTER JOINS
--The last type of join is a full outer join. This will return the inner join result set,
--as well as any unmatched rows from either of the two tables being joined.

--in set theory, work just like Union  (A U B)

--and similarly saying left outer join UNION right outer join


--NOTICEs
--A simple rule to remember this is that, when the database executes this query,
--it executes the join and everything in the ON clause first.

--JOINs and filtering
--Think of JOINS as building the new result set.
--That result set is then filtered using the WHERE clause.

--Because inner joins only return the rows for which the two tables match,
--moving this filter to the ON clause of an inner join will produce the same result as keeping it in the WHERE clause.
