
-- Solution 1 : CTE (Runtime: 633ms | Beats 47%) 

WITH manager_stats AS(
    SELECT
        reports_to,
        COUNT(*) AS reports_count,
        ROUND(AVG(age),0) AS average_age
    FROM Employees
    GROUP BY reports_to
)
SELECT
    M.reports_to AS employee_id,
    E.name,
    M.reports_count,
    M.average_age
FROM Employees E INNER JOIN manager_stats M
    ON E.employee_id = M.reports_to
ORDER BY M.reports_to

-- Solution 2 : Self-join (Runtime: 669ms | Beats 28%) 

SELECT 
  mgr.employee_id, 
  mgr.name, 
  COUNT(emp.employee_id) AS reports_count, 
  ROUND(
    AVG(emp.age)
  ) AS average_age 
FROM 
  employees emp 
  JOIN employees mgr ON emp.reports_to = mgr.employee_id 
GROUP BY 
  employee_id 
ORDER BY 
  employee_id

-- Complexity:
--   Time: O(n²) in worst case for self-join, but optimized with indexes
--   Space: O(k) where k is number of managers

-- Solution 3 : Correlated Sub-Query (Runtime: 870ms | Beats 9%) 

  SELECT 
  reports_to AS employee_id, 
  (
    SELECT 
      name 
    FROM 
      employees e1 
    WHERE 
      e.reports_to = e1.employee_id 
  ) AS name, 
  COUNT(reports_to) AS reports_count, 
  ROUND(
    AVG(age)
  ) AS average_age 
FROM 
  employees e 
GROUP BY 
  reports_to 
HAVING 
  reports_count > 0 
ORDER BY 
  employee_id