
-- Solution 1 : CTE (Runtime: 610ms | Beats 27%) 

WITH first_logins AS (
  SELECT
    A.player_id,
    MIN(A.event_date) AS first_login
  FROM
    Activity A
  GROUP BY
    A.player_id
), consec_logins AS (
  SELECT
    COUNT(A.player_id) AS num_logins
  FROM
    first_logins F
    INNER JOIN Activity A ON F.player_id = A.player_id
    AND F.first_login = DATE_SUB(A.event_date, INTERVAL 1 DAY)
)
SELECT
  ROUND(
    (SELECT C.num_logins FROM consec_logins C)
    / (SELECT COUNT(F.player_id) FROM first_logins F)
  , 2) AS fraction;

-- Solution 2 : Subquery  (Runtime: 615ms | Beats 25%) 

SELECT
  ROUND(
    COUNT(A1.player_id)
    / (SELECT COUNT(DISTINCT A3.player_id) FROM Activity A3)
  , 2) AS fraction
FROM
  Activity A1
WHERE
  (A1.player_id, DATE_SUB(A1.event_date, INTERVAL 1 DAY)) IN (
    SELECT
      A2.player_id,
      MIN(A2.event_date)
    FROM
      Activity A2
    GROUP BY
      A2.player_id
  );

-- Complexity
    -- Time complexity:
        -- The subquery (SELECT player_id, MIN(event_date) as first_login FROM Activity GROUP BY player_id) has a time complexity of O(n), where n is the number of records in the Activity table.
        -- The main query involves a nested subquery with a comparison (player_id, DATE_SUB(event_date, INTERVAL 1 DAY)) IN (...). 
        -- This comparison has a time complexity of O(n), resulting in an overall time complexity of O(n²).
    -- Space complexity:
        -- The subquery (SELECT player_id, MIN(event_date) as first_login FROM Activity GROUP BY player_id) creates a temporary table that stores player_id and their respective minimum event_date for each player. 
        -- The space complexity is O(n) as it depends on the number of distinct players in the Activity table.

-- Solution 3 : Subquery  (Runtime: 4100ms | Beats 5%) 

SELECT
    ROUND( COUNT(*) * 1 / (SELECT COUNT(DISTINCT player_id)  FROM Activity) , 2 )
        AS fraction
FROM Activity Activity1
WHERE DATE_SUB(Activity1.event_date, INTERVAL 1 DAY) = ( 
    SELECT
        MIN(Activity2.event_date) as first_login
    FROM Activity Activity2
    WHERE Activity2.player_id = Activity1.player_id
    GROUP BY player_id
)

