
-- Solution 1 : (Runtime: 455ms | Beats 22%) 

SELECT
   MAX(num) as num
FROM (
    SELECT 
        num
    FROM MyNumbers 
    GROUP BY num
    HAVING Count(*) = 1
) as max_num

-- Solution 2 : (Runtime: 620ms | Beats 6%) 

SELECT MAX(num) as num
FROM mynumbers n
where num IN (
    SELECT num
    FROM mynumbers
    GROUP BY num
    HAVING COUNT(*)=1
)

-- Complexity:
  -- Time complexity: O(n log n) due to GROUP BY operation
  -- Space complexity: O(n) for storing grouped results