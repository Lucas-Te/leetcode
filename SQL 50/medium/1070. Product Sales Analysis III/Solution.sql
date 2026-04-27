
-- Solution 1 : (Runtime: 750ms | Beats 33%) 

WITH first_year_per_product AS(
    SELECT 
        product_id,
        year,
        -- ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY year ASC)   AS rn,
        RANK() OVER (PARTITION BY product_id ORDER BY year ASC) AS rn,
        quantity,
        price
    FROM Sales
)
SELECT
    product_id,
    year AS first_year,
    quantity,
    price
FROM first_year_per_product
WHERE rn = 1

-- Solution 2 : JOIN on Subquery  (Runtime: 720ms | Beats 44%) 

SELECT 
    s.product_id, 
    s.year AS first_year, 
    s.quantity, 
    s.price
FROM Sales s
JOIN (
    SELECT product_id, MIN(year) AS myear 
    FROM Sales 
    GROUP BY product_id
) s2
ON s.product_id = s2.product_id 
AND s.year = s2.myear;

-- Complexity
    -- Time complexity: O(N)^2 where N is the number of rows satisfying the conditions.
    -- Space complexity: O(1)^2


-- Solution 3 : Subquery + IN  (Runtime: 690ms | Beats 62%) 

SELECT 
  product_id, 
  year AS first_year, 
  quantity, 
  price 
FROM 
  Sales 
WHERE 
  (product_id, year) IN (
    SELECT 
      product_id, 
      MIN(year) AS year 
    FROM 
      Sales 
    GROUP BY 
      product_id
  );