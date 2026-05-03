-- Solution 1 : CTE + Subquery (Runtime: 357ms | Beats 48%) 

WITH valid_days_to_compute_moving_average AS(
    SELECT *
    FROM Customer
    WHERE DATE_SUB(visited_on, INTERVAL 6 DAY) >= (
        SELECT
            MIN(c1.visited_on)
        FROM Customer c1
    )
)
SELECT
    v.visited_on,
    (
        SELECT SUM(c2.amount) 
        FROM Customer c2 
        WHERE c2.visited_on >= DATE_SUB(v.visited_on, INTERVAL 6 DAY)
        AND   c2.visited_on <= v.visited_on 
    ) AS amount,
    ROUND(
        (
        SELECT SUM(c2.amount) 
        FROM Customer c2 
        WHERE c2.visited_on >= DATE_SUB(v.visited_on, INTERVAL 6 DAY)
        AND   c2.visited_on <= v.visited_on 
        )
    / 7 ,
    2 ) AS average_amount
FROM valid_days_to_compute_moving_average v
GROUP BY v.visited_on

-- Solution 2 : Subquery (Runtime: 356ms | Beats 49%) 

SELECT
    visited_on,

    (SELECT 
        SUM(amount)
     FROM Customer
     WHERE visited_on BETWEEN DATE_SUB(c.visited_on, INTERVAL 6 DAY)  AND c.visited_on
    ) AS amount,

    (SELECT 
        -- ROUND(AVG(amount) , 2)   -- corresponds to average per customer  
        ROUND(SUM(amount) / 7 , 2)  -- corresponds to average per day   
     FROM Customer
     WHERE visited_on BETWEEN DATE_SUB(c.visited_on, INTERVAL 6 DAY)  AND c.visited_on
    ) AS average_amount

FROM Customer c
WHERE c.visited_on >= (
    SELECT
        DATE_ADD( MIN(c2.visited_on) , INTERVAL 6 DAY)
    FROM Customer c2
)
GROUP BY c.visited_on

-- Solution 3 : Window Function (Runtime: 410ms | Beats 9%) 

-- No need to check that there are indeed 7 days prior to the current day, 
-- as the window function will automatically handle cases where there are fewer than 7 days of data available.

WITH cte AS (
    SELECT visited_on, SUM(amount) AS daily_amount
    FROM Customer
    GROUP BY visited_on
)
SELECT visited_on, 
    SUM(daily_amount) OVER(
        ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) as amount,
    ROUND(AVG(daily_amount) OVER(
        ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ), 2) as average_amount
FROM cte
limit 1000 offset 6

-- Solution 4 : Window Function (Runtime: 380ms | Beats 22%) 

WITH daily_amount AS (
    SELECT
        visited_on,
        SUM(amount) AS amount
    FROM Customer
    GROUP BY visited_on
),
moving_sum AS (
    SELECT
        visited_on,
        SUM(amount) OVER (
            ORDER BY visited_on
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS amount
    FROM daily_amount
)
SELECT
    visited_on,
    amount,
    ROUND(amount / 7, 2) AS average_amount
FROM moving_sum
WHERE visited_on >= (
    SELECT DATE_ADD(MIN(visited_on), INTERVAL 6 DAY)
    FROM Customer
)
ORDER BY visited_on;