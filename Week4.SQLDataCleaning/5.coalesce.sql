--COALESCE function
--returns the first non-null value passed for each row.

--you might be working with a dataset that contains some null values,
--which you'd prefer to contain actual values.

--Most especially, while working with some numerical values and you want to display nulls as zero
--Also, while performing outer joins that result in some unmatched rows

--FOR Example
--you might want to create nulls in a primary_poc as 'no_poc'

SELECT *,
       COALESCE(primary_poc, 'no_poc') as primary_poc_modified
  FROM accounts;

  SELECT COUNT(primary_poc) as regular_count,
         COUNT(COALESCE(primary_poc, 'no_poc')) as modified_count
    FROM accounts;
