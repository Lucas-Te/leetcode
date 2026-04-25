
-- Solution 1 : CASE WHEN (Runtime: 226ms | Beats 91%)

SELECT 
    machine_id,
    ROUND(SUM(CASE WHEN activity_type='start' THEN timestamp*-1 ELSE timestamp END)*1.0
    / (SELECT COUNT(DISTINCT process_id)),3) AS processing_time
FROM 
    Activity
GROUP BY machine_id

-- Complexity
-- Time Complexity: O(n)
    -- We scan and group the table once.
-- Space Complexity: O(n)

-- Solution 2 : Self join (Runtime: 257ms | Beats 29%)

SELECT
    a1.machine_id,
    ROUND(AVG(a2.timestamp - a1.timestamp) , 3) as processing_time
FROM
Activity a1 JOIN Activity a2 
ON a1.machine_id = a2.machine_id
AND a1.process_id  = a2.process_id 
AND a1.activity_type  = 'start' AND a2.activity_type = 'end'
GROUP BY a1.machine_id 

-- Complexity :

-- Time complexity:
--      The time complexity of this query depends on the size of the "Activity" table and the efficiency of the database engine. 
--      For a well-indexed table, the time complexity is usually efficient. We can say that it will take O(nlogn) or O(n) time, 
--      where n is the number of rows in the "Activity" table. The database engine uses techniques like indexing and joining algorithms to quickly process the query.
--      Without index : O(n²)

-- Space complexity:
--      The space complexity of this query is determined by the size of the result set. In other words, it depends on the number of machines 
--      for which there are start and end activities. We can say the space complexity is O(n), where n is the number of machines. 
--      The memory required to store the result set grows with the number of machines.

-- Solution 3 : Self join  (Runtime: 383ms | Beats 7%)

SELECT
    a1.machine_id,
    ROUND(AVG(a2.timestamp - a1.timestamp) , 3) as processing_time
FROM
    Activity a1,  
    Activity a2 
WHERE a1.machine_id = a2.machine_id
    AND a1.process_id  = a2.process_id 
    AND a1.activity_type  = 'start' AND a2.activity_type = 'end'
GROUP BY a1.machine_id 

-- Solution 4 : CTE and LAG (Runtime: 245ms | Beats 50%)

WITH cte AS (
    SELECT 
        machine_id,
        timestamp - LAG(timestamp) OVER (
            PARTITION BY machine_id, process_id
            ORDER BY timestamp
        ) AS t,
        activity_type
    FROM Activity
)

SELECT 
    machine_id,
    ROUND(AVG(t),3) AS processing_time
FROM cte
WHERE activity_type = 'end'
GROUP BY machine_id
ORDER BY processing_time DESC;

