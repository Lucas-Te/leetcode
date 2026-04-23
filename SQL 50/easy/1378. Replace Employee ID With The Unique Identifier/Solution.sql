SELECT 
    EmployeeUNI.unique_id,
    Employees.name
FROM EmployeeUNI RIGHT JOIN Employees on Employees.id = EmployeeUNI.id  