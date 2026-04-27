-- Solution 1 :  (Runtime: 521ms | Beats 40%) 

SELECT
    p.project_id
    , ROUND(AVG(e.experience_years),2) AS average_years
FROM Project as p
INNER JOIN Employee as e
ON p.employee_id = e.employee_id
GROUP BY p.project_id  

-- Complexity
--      Time complexity: O(n+m) where n is the number of projects and m is the number of employees. The JOIN operation and subsequent grouping scale with the combined table sizes.