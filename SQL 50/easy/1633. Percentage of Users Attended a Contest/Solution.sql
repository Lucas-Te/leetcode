-- Solution 1 :  (Runtime: 927ms | Beats 62%) 

SELECT 
  contest_id, -- The ID of the contest
  ROUND(
    COUNT(DISTINCT user_id) * 100 / ( -- Calculate the percentage of users
      SELECT 
        COUNT(user_id) -- Total number of unique users
      FROM 
        Users
    ), 
    2
  ) AS percentage -- The percentage of users registered for each contest, rounded to 2 decimal places
FROM 
  Register -- The table containing registration information
GROUP BY 
  contest_id -- Group the data by contest ID
ORDER BY 
  percentage DESC, -- Order the results by percentage in descending order
  contest_id; -- Then order by contest ID for ties  

-- Complexity:
    -- Time: O(n + m) - where n is users, m is registrations (join + grouping)
    -- Space: O(k) - where k is number of contests


-- Solution 2 :  (Runtime: 968ms | Beats 46%) 

SELECT
    r.contest_id,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Users), 2) AS percentage
FROM Users as u
    INNER JOIN 
Register as r 
ON r.user_id = u.user_id
GROUP BY r.contest_id
ORDER BY percentage DESC, r.contest_id ASC

