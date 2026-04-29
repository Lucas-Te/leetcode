
-- Solution 1 : if (Runtime: 336ms | Beats 13%) 

SELECT *,
    IF(x+y>z and y+z>x and z+x>y, "Yes", "No") as triangle 
FROM Triangle

-- Solution 2 : CASE WHEN (Runtime: 370ms | Beats 9%) 

SELECT
    *,
    CASE 
        WHEN x + y > z AND x + z > y AND y + z > x THEN 'Yes'
        ELSE 'No'
        END
    AS triangle
FROM Triangle

