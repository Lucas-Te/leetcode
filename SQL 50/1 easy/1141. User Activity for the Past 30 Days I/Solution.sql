
-- Solution 1 : (Runtime: 510ms | Beats 26%)

SELECT activity_date as day, COUNT(DISTINCT user_id) AS active_users
FROM Activity 
WHERE activity_date > "2019-06-27" AND activity_date <= "2019-07-27"
GROUP BY activity_date

-- Solution 2 : (Runtime: 530ms | Beats 21%)

SELECT
    activity_date AS day
    , COUNT(DISTINCT user_id) AS active_users 
FROM Activity
WHERE activity_date BETWEEN DATE_SUB('2019-07-27', INTERVAL 29 DAY) AND '2019-07-27'
GROUP BY  activity_date 