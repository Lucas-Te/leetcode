
-- Solution 1 : COALESCE + LEFT JOIN + CASE WHEN (Runtime: 1476ms | Beats 72%) 

SELECT c.category,
       COALESCE(t.accounts_count, 0) AS accounts_count
FROM (
    SELECT 'Low Salary' AS category
    UNION ALL
    SELECT 'Average Salary'
    UNION ALL
    SELECT 'High Salary'
) c
LEFT JOIN (
    SELECT
        CASE
            WHEN income < 20000 THEN 'Low Salary'
            WHEN income <= 50000 THEN 'Average Salary'
            ELSE 'High Salary'
        END AS category,
        COUNT(*) AS accounts_count
    FROM Accounts
    GROUP BY category
) t
ON c.category = t.category;

-- Solution 2 : UNION ALL (Runtime: 1516ms | Beats 58%) 

SELECT
    'Low Salary' As category
    ,COUNT(CASE WHEN income<20000 THEN 1 END) AS accounts_count
FROM accounts

UNION ALL

SELECT
    'Average Salary' AS category
    ,COUNT(CASE WHEN income BETWEEN 20000 AND 50000 THEN 1 END) AS accounts_count
FROM accounts

UNION ALL

SELECT 
    'High Salary' AS category
    ,COUNT(CASE WHEN income>50000 THEN 1 END) AS accounts_count
FROM accounts

-- Complexity
    -- Time complexity: O(n) - each query scans the table once
    -- Space complexity: O(1) - returns only 3 rows of output


-- Solution 3 : CTE + UNION ALL (Runtime: 1650ms | Beats 24%) 

WITH low_salary AS (
    SELECT
        "Low Salary" AS category,
        COUNT(*) AS accounts_count
    FROM Accounts
    WHERE income < 20000
),
average_salary AS (
    SELECT
        "Average Salary" AS category,
        COUNT(*) AS accounts_count
    FROM Accounts
    WHERE income >= 20000 and income <= 50000 
),
high_salary AS (
    SELECT
        "High Salary" AS category,
        COUNT(*) AS accounts_count
    FROM Accounts
    WHERE income > 50000
)
SELECT * FROM low_salary
UNION ALL
SELECT * FROM average_salary
UNION ALL
SELECT * FROM high_salary;

