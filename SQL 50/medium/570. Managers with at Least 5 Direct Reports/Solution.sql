
-- Solution 1 : CTE (Runtime: 343ms | Beats 94%) on 1st run, then 364ms | Beats 28% on 2nd run which is same runtime as Solution 2

WITH manager_with_more_than_5_reports AS (
    SELECT
        managerId,
        COUNT(managerId)
    FROM Employee
    GROUP BY managerId
    HAVING COUNT(managerId) > 4
)
SELECT 
    name
FROM Employee
INNER JOIN manager_with_more_than_5_reports
ON Employee.id = manager_with_more_than_5_reports.managerId

-- Solution 2 : Subquery with JOIN (Runtime: 364ms | Beats 28%)

-- This approach is often more optimized than a direct self-join, because it first reduces the number of rows to be joined.
-- It is better to filter/aggregate the eligible managers first, then retrieve their names afterward.
-- So the final JOIN is no longer done with the entire Employee table, but only with a small list of valid managerIds.

SELECT e.name  
FROM Employee e  
JOIN (
    SELECT managerId  
    FROM Employee  
    GROUP BY managerId  
    HAVING COUNT(*) >= 5  
) temp  
ON e.id = temp.managerId;

-- Solution 3 : Subquery with IN (Runtime: 380ms | Beats 18%)

-- IN is not necessarily bad. Depending on the SQL engine, the optimizer can transform a query with IN into an efficient plan. 
-- But the version with an aggregated subquery followed by a JOIN makes the intent more explicit.

SELECT
    name
FROM Employee
WHERE id IN (
    SELECT managerId
    FROM Employee
    GROUP BY managerId
    HAVING COUNT(*) >= 5
);

-- Solution 4 : Self-Join (Runtime: 382  ms | Beats 18%)

-- This query first performs a self-join between managers and their employees, then groups the result to count direct reports.
-- The problem is that the JOIN produces all manager-employee relationships before even knowing which managers have at least 5 direct reports. On a large table, this can generate many unnecessary intermediate rows.

SELECT e.name
FROM Employee AS e 
INNER JOIN Employee AS m ON e.id = m.managerId 
GROUP BY m.managerId 
HAVING COUNT(m.managerId) >= 5;

