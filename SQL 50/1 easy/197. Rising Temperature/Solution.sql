
-- Solution 1 : self-join (Runtime: 520ms | Beats 22%)

SELECT 
    w1.id
FROM 
    Weather w1
JOIN 
    Weather w2
ON 
    DATEDIFF(w1.recordDate, w2.recordDate) = 1
WHERE 
    w1.temperature > w2.temperature;

-- Solution 2 : CTE (Runtime: 400ms | Beats 77%)

WITH PreviousWeatherData AS
(
    SELECT 
        id,
        recordDate,
        temperature, 
        LAG(temperature, 1) OVER (ORDER BY recordDate) AS PreviousTemperature,
        LAG(recordDate, 1) OVER (ORDER BY recordDate) AS PreviousRecordDate
    FROM 
        Weather
)
SELECT 
    id 
FROM 
    PreviousWeatherData
WHERE 
    temperature > PreviousTemperature
AND 
    recordDate = DATE_ADD(PreviousRecordDate, INTERVAL 1 DAY);

-- Solution 3 : Subquery (Runtime: 400ms | Beats 77%)

SELECT 
    id
FROM (
    SELECT
        id,
        temperature,
        recordDate,
        LAG(temperature, 1) OVER (ORDER BY recordDate) as prev_temp,
        LAG(recordDate, 1) OVER (ORDER BY recordDate) as prev_date
    FROM Weather
) as W
WHERE w.prev_temp < temperature and recordDate = DATE_ADD(prev_date, INTERVAL 1 DAY)

-- Solution 4 : Subquery (Runtime: 979ms | Beats 5%)

SELECT 
    w1.id
FROM 
    Weather w1
WHERE 
    w1.temperature > (
        SELECT 
            w2.temperature
        FROM 
            Weather w2
        WHERE 
            w2.recordDate = DATE_SUB(w1.recordDate, INTERVAL 1 DAY)
    );

