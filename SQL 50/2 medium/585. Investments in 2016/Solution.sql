-- Solution 1 : Window Function (Runtime: 582ms | Beats 42%) 

WITH uniq_coords AS (
 SELECT *, 
   COUNT(*) OVER (PARTITION BY lat, lon) AS attempts,
   COUNT(*) OVER (PARTITION BY tiv_2015) AS tivs
 FROM Insurance
) 
SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM uniq_coords
WHERE attempts = 1 AND tivs > 1;

-- Solution 2 : Subquery (Runtime: 554ms | Beats 64%) 

SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance
WHERE tiv_2015 IN (
    SELECT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1
)
AND (lat, lon) IN (
    SELECT lat, lon
    FROM Insurance
    GROUP BY lat, lon
    HAVING COUNT(*) = 1
)

-- Solution 3 : CTE (Runtime: 580ms | Beats 42%) 

WITH same_unique_lat_lon AS(
    SELECT
        *   -- recupere toutes les colonnes malgre group by car count = 1
    FROM Insurance
    GROUP BY lat,lon
    HAVING COUNT(*) = 1
),
same_tiv2015 AS(
    SELECT
        *  
    FROM same_unique_lat_lon INNER JOIN (
        SELECT
            Insurance.tiv_2015 AS duplicate_tiv2015
        FROM Insurance
        GROUP BY tiv_2015
        HAVING COUNT(*) > 1
    ) AS multiple_same_tiv2015
    ON same_unique_lat_lon.tiv_2015 = multiple_same_tiv2015.duplicate_tiv2015 
)
SELECT 
    ROUND(SUM(tiv_2016) , 2) AS tiv_2016 
FROM same_tiv2015

-- Solution 4 : CTE (Runtime: 608ms | Beats 29%) 

WITH duplicate_lat_lon AS (
    SELECT
        lat,lon
    FROM Insurance
    GROUP BY lat,lon
    HAVING COUNT(*) > 1
),
same_tiv2015 AS (
    SELECT
        tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1
)
SELECT
    ROUND(SUM(tiv_2016),2) AS tiv_2016 
FROM Insurance I

-- Avoid tuple NOT IN here: some SQL engines handle multi-column NOT IN
-- inconsistently in edge cases, especially with row-value comparisons.
-- NOT EXISTS is safer because it checks each matching location explicitly.
-- While using IN as in Solution 2 worked
-- WHERE (I.lat,I.lon) NOT IN ( 
--     SELECT lat, lon
--     FROM duplicate_lat_lon
-- )
WHERE NOT EXISTS (
    SELECT 1
    FROM Insurance j
    WHERE j.lat = I.lat
      AND j.lon = I.lon
      AND j.pid <> I.pid
)
AND I.tiv_2015 IN (
    SELECT tiv_2015
    FROM same_tiv2015
);



