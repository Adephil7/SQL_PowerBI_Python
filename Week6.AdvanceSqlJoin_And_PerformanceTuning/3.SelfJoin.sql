--orders that happened after the original one has happened
--and when the occurred_at is greater than the initial occurred_at
--and when the occurred_at is less or equal to the occurred_at + '28 days'

SELECT o1.id as o1_id,
       o1.account_id as o1_account_id,
       o1.occurred_at as o1_occurred_at,
       o2.id as o2_id,
       o2.account_id as o2_account_id,
       o2.occurred_at as o2_occurred_at
FROM orders o1
LEFT JOIN orders o2
  ON o1.account_id = o2.account_id
      AND 02.occurred_at > o1.occurred_at
      AND o2.occurred_at <= o1.occurred_at + INTERVAL '28 days'
ORDER BY o1.account_id, o1.occurred_at;

-----------
/*--Self JOINs
One of the most common use cases for self JOINs is in cases where two events occurred, one after another.
As you may have noticed in the previous video, using inequalities in conjunction with self JOINs is common.

Modify the query from the previous video, which is pre-populated in the SQL Explorer below, to perform the
same interval analysis except for the web_events table. Also:

--change the interval to 1 day to find those web events that occurred after, but not more than 1 day after,
  another web event
--add a column for the channel variable in both instances of the table in your query
*/

SELECT w1.id AS w1_id,
       w1.account_id AS w1_account_id,
       w1.occurred_at AS w1_occurred_at,
       w1.channel AS w1_channel
       w2.id AS w2_id,
       w2.account_id AS w2_account_id,
       w2.occurred_at AS w2_occurred_at,
       w2.channel AS w2_channel
  FROM web_events w1
 LEFT JOIN oweb_events w2
   ON w1.account_id = w2.account_id
  AND w2.occurred_at > w1.occurred_at
  AND w2.occurred_at <= w1.occurred_at + INTERVAL '1 days'
ORDER BY w1.account_id, w1.occurred_at;
