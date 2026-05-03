-- Solution 1 :  (Runtime: 271ms | Beats 54%) 

SELECT
  (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
  ) AS SecondHighestSalary;

-- We wrap the query in an outer SELECT (...) AS SecondHighestSalary. This is a crucial trick. 
-- If the inner query finds no rows (because no 2nd salary exists), it returns an empty set. 
-- The outer SELECT catches this and correctly outputs a single row with NULL, as required.

-- Complexity:
--     Time: O(NlogN) to sort the distinct salaries.
--     Space: O(N) to store the distinct salaries for sorting.

-- Solution 2 : Subquery (Runtime: 275ms | Beats 47%) 

SELECT
    MAX(salary) AS SecondHighestSalary
FROM Employee
WHERE salary < (SELECT MAX(salary) FROM Employee);

-- The MAX() aggregate function is perfect here. If the WHERE clause finds no rows (e.g., only one salary exists, so no salary is < MAX), MAX() automatically returns NULL. 
-- This elegantly handles the edge case without extra tricks.

-- Complexity:
    -- Time: O(N) + O(N) = O(N). The DB scans the table (or index) twice.
    -- Space: O(1).

-- Solution 3 : CTE + Window Function (Runtime: 310ms | Beats 15%) 

WITH ranked_salary AS(
    SELECT
        *, 
        DENSE_RANK() OVER (ORDER BY salary DESC) as rn_salary
    FROM Employee
)
SELECT
    MAX(salary) AS SecondHighestSalary 
    -- MAX() sur un ensemble vide retourne NULL
FROM ranked_salary
WHERE rn_salary = 2

-- This method also needs the outer SELECT (...) trick from Method 1. 
-- A simple ...WHERE rnk = 2 query will return an empty set if no 2nd rank exists, but LeetCode wants NULL.

-- Complexity:
    -- Time: O(NlogN) due to the ORDER BY in the window function's partition.
    -- Space: O(N) to store intermediate ranked data.