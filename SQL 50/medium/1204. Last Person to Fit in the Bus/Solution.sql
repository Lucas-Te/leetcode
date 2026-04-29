-- Solution 1 : Subquery + Window Function (Runtime: 859ms | Beats 39%) 

SELECT person_name
FROM (
    SELECT person_name, weight, turn,
           SUM(weight) OVER (ORDER BY turn) AS total_weight FROM Queue
) AS subquery 
WHERE total_weight <= 1000
ORDER BY turn DESC 
LIMIT 1;

-- Solution 2 : CTE + Window Function (Runtime: 1069ms | Beats 25%) 

WITH sum_weight_of_all_last_rows_to_the_current_row AS (
    SELECT *, 
        SUM(weight) OVER (ORDER BY turn) AS total_weight
    FROM Queue
    ORDER BY turn
)
SELECT 
    person_name
FROM sum_weight_of_all_last_rows_to_the_current_row
WHERE total_weight <= 1000
ORDER BY total_weight DESC
LIMIT 1

-- Solution 3 : SELF JOIN (Runtime: 1890ms | Beats 6%) 

SELECT 
    q1.person_name
FROM Queue q1 JOIN Queue q2 ON q1.turn >= q2.turn
GROUP BY q1.turn
HAVING SUM(q2.weight) <= 1000
ORDER BY SUM(q2.weight) DESC
LIMIT 1

-- Complexity
    -- Time complexity:
        -- The time complexity of this query is dependent on the number of rows in the Queue table. 
        -- Let's denote this number as 'n'. The join operation has a complexity of O(n²), as it pairs each row with all the rows that have a higher turn. 
        -- The grouping operation has a complexity of O(n), as it groups the rows by turn. Finally, ordering the result and limiting it to 1 row have a complexity of O(nlogn). 
        -- Therefore, the overall time complexity is O(n²).
    -- Space complexity:
        -- The space complexity is determined by the memory required to store the rows and the intermediate results of the query. 
        -- In this case, it is proportional to the number of rows in the Queue table, so the space complexity is O(n).
