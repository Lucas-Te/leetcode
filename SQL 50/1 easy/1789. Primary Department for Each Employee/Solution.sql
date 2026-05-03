
-- Solution 1 : UNION ALL (Runtime: 529ms | Beats 63%) 

SELECT 
    employee_id,
    department_id   -- Selecting department_id with GROUP BY employee_id works here because HAVING COUNT(*) = 1 ensures there is only one row per employee_id group.
    -- MAX(department_id) -- Use MAX(department_id) for portability: some SQL engines reject selecting a non-grouped column, even though HAVING COUNT(*) = 1 guarantees only one row per employee_id group.
FROM Employee
GROUP BY employee_id
HAVING COUNT(employee_id) = 1

UNION ALL

SELECT 
    employee_id,
    department_id
FROM Employee
WHERE primary_flag = 'Y'

-- Solution 2 : CTE + UNION ALL (Runtime: 598ms | Beats 20%) 

WITH employee_with_only_one_department AS (
    SELECT
        employee_id  
    FROM Employee
    GROUP BY employee_id
    HAVING COUNT(employee_id) = 1
)
SELECT
    e1.employee_id, 
    Employee.department_id 
FROM employee_with_only_one_department e1 INNER JOIN Employee
ON e1.employee_id = Employee.employee_id 

UNION ALL

SELECT
    employee_id, 
    department_id 
FROM Employee 
WHERE primary_flag = 'Y'

-- Solution 3 : Window Function + Subquery (Runtime: 570ms | Beats 30%) 

SELECT 
  employee_id, 
  department_id 
FROM 
  (
    SELECT 
      *, 
      COUNT(employee_id) OVER(PARTITION BY employee_id) AS EmployeeCount
    FROM 
      Employee
  ) EmployeePartition 
WHERE 
  EmployeeCount = 1 
  OR primary_flag = 'Y';

-- Solution 4 : Subquery (Runtime: 678ms | Beats 11%) 

SELECT employee_id, department_id
FROM Employee
WHERE primary_flag='Y' OR 
    employee_id in
    (SELECT employee_id
    FROM Employee
    Group by employee_id
    having count(employee_id)=1)