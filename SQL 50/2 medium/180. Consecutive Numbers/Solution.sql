
-- Solution 1 : SELF JOIN (Runtime: 550ms | Beats 48%) 

SELECT DISTINCT
    l1.Num AS ConsecutiveNums
FROM
    Logs l1,
    Logs l2,
    Logs l3
WHERE
    l1.Id = l2.Id - 1
    AND l2.Id = l3.Id - 1
    AND l1.Num = l2.Num
    AND l2.Num = l3.Num
;

    -- The same solution with a different syntax : SELF JOIN (Runtime: 690ms | Beats 12%) 

    SELECT DISTINCT l1.num AS ConsecutiveNums
    FROM Logs l1
    JOIN Logs l2 ON l1.id=l2.id-1
    JOIN Logs l3 ON l2.id=l3.id-1
    WHERE l1.num=l2.num
    AND l2.num=l3.num

    -- The performance difference likely comes from LeetCode’s runtime variability, caching, server load, or measurement noise rather than the SQL query itself.
    -- Both queries are logically equivalent and should usually produce the same execution plan.

-- Complexity
  -- Time Complexity:
    -- (O(n)) — since we perform constant-time comparisons over n records.
  -- Space Complexity:
    -- (O(n)) — required for intermediate join buffers.

-- Solution 2 : CTE (Runtime: 579ms | Beats 30%) 

WITH last_three_num AS(
    SELECT
        num,
        LAG(num , 1) OVER (ORDER BY id) AS last_two,
        LAG(num , 2) OVER (ORDER BY id) AS last_three
    FROM Logs
)
SELECT 
    DISTINCT num AS ConsecutiveNums
FROM last_three_num
-- -- WHERE num = last_two = last_three     -- Does not work as expected
WHERE num = last_two AND num = last_three

