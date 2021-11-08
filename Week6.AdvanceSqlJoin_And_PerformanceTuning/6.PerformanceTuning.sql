--EXPLAIN

--You can add explain at the beginning of any working query to get a sense of how long it will take.

EXPLAIN [WITH_RECOMMENDATIONS]
SQL_statement
[;]

--Returns the query plan without running the statement

--Use EXPLAIN to preview which operations will require data movement and to view the estimated costs
--of the query operations.

--The SQL statement on which EXPLAIN will run. SQL_statement can be any of these commands:
--SELECT, INSERT, UPDATE, DELETE, CREATE TABLE AS SELECT, CREATE REMOTE TABLE.

WITH_RECOMMENDATIONS

--Return the query plan with recommendations to optimize the SQL statement performance.



 
