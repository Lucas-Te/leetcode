
```md
> Note : Very clear diagrams explaining the query.
> Source : https://leetcode.com/problems/confirmation-rate/solutions/6543578/step-by-step-breakdown-visualized-sql-gu-vmbg/?envType=study-plan-v2&envId=top-sql-50
```

-- Solution 1 : CASE WHEN (Runtime: 700ms | Beats 26%) 

SELECT
    S.user_id,
    ROUND(
        SUM(
            CASE WHEN C.action = 'confirmed' THEN 1 ELSE 0 END
            ) * 1/COUNT(*) , 2 ) 
        AS confirmation_rate
FROM Signups as S
    LEFT JOIN
Confirmations as C 
ON S.user_id = C.user_id  
GROUP BY S.user_id

-- Solution 1 : IF + AVG instead of CASE WHEN + SUM (Runtime: 700ms | Beats 26%) 

SELECT
    s.user_id,
    ROUND(
        AVG(
            IF(c.action = 'confirmed', 1.00, 0)
        ), 
        2
    ) confirmation_rate
FROM
    Signups s
LEFT JOIN
    Confirmations c
    ON
    s.user_id = c.user_id
GROUP BY
    s.user_id


