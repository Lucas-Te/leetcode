-- Solution 1 : CTE + DENSE_RANK (Runtime: 975ms | Beats 49%) 

WITH ranking_salary AS(
    SELECT
        *,
        DENSE_RANK() OVER (
            PARTITION BY departmentId 
            ORDER BY salary DESC 
        ) AS top_salary
    -- use of DENSE_RANK to have the same index when several salaries are equal and to have 
    -- distinct index values ​​without skipping numbers because RANK skips numbers on the index when there is a duplicate
    FROM Employee
)
SELECT 
    d.name   AS Department,
    r.name   AS Employee,
    r.salary AS Salary
FROM Department d INNER JOIN ranking_salary r
ON d.id = r.departmentId 
WHERE top_salary <= 3
ORDER BY employee_id;

-- Solution 1 : CTE + DENSE_RANK (Runtime: 995ms | Beats 44%) 

WITH new_table AS (
    SELECT 
        d.name AS Department,
        e.name AS Employee,
        e.salary AS Salary,
        DENSE_RANK() OVER(PARTITION BY d.name ORDER BY e.salary DESC) AS ranking
    FROM Employee e
    LEFT JOIN Department d
    ON e.departmentId = d.id
)
SELECT Department, Employee, Salary
FROM new_table
WHERE ranking <= 3;

-- Complexity
    -- Time complexity: O(n log n) Sorting is done per department for ranking, where n is the number of employees.
    -- Space complexity: O(n) The query creates a temporary table (new_table) with the same size as the Employee table.

-- Solution 2 : Correlated Subquery (Runtime: 1350ms | Beats 14%) 

SELECT d.name AS 'Department', 
       e1.name AS 'Employee', 
       e1.salary AS 'Salary' 
FROM Employee e1
JOIN Department d
ON e1.departmentId = d.id 
WHERE
    3 > (SELECT COUNT(DISTINCT e2.salary)
        FROM Employee e2
        WHERE e2.salary > e1.salary AND e1.departmentId = e2.departmentId);