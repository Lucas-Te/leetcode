
-- Solution 1 : UNION and Window Function (Runtime: 480ms | Beats 50%) 

WITH price_before_16_august AS (
    SELECT
        product_id,
        new_price,
        change_date,
        ROW_NUMBER() OVER (
            PARTITION BY product_id
            ORDER BY change_date DESC
        ) AS rn
    FROM Products
    WHERE change_date <= '2019-08-16'
)
SELECT
    product_id,
    new_price AS price
FROM price_before_16_august
WHERE rn = 1

UNION   

SELECT
    product_id,
    10 AS price
FROM Products
GROUP BY product_id
HAVING MIN(change_date) > '2019-08-16';

-- Solution 2 : LEFT JOIN and Window function FIRST_VALUE (Runtime: 520ms | Beats 38%) 

SELECT
  product_id,
  IFNULL (price, 10) AS price
FROM
  (
    SELECT DISTINCT
      product_id
    FROM
      Products
  ) AS UniqueProducts
  LEFT JOIN (
    SELECT DISTINCT
      product_id,
      FIRST_VALUE (new_price) OVER (
        PARTITION BY
          product_id
        ORDER BY
          change_date DESC
      ) AS price
    FROM
      Products
    WHERE
      change_date <= '2019-08-16'
  ) AS LastChangedPrice USING (product_id);

-- Solution 3 : COALESCE + Subquery (Runtime: 700ms | Beats 16%) 

SELECT 
    p.product_id
    ,COALESCE((
        SELECT pr.new_price
        FROM products pr
        WHERE p.product_id=pr.product_id
            AND pr.change_date<='2019-08-16'
        ORDER BY pr.change_date DESC LIMIT 1
    ),10) AS price
FROM (
    SELECT DISTINCT product_id
    FROM products 
) AS p

-- Time complexity: O(n log n)
  -- The subquery runs per product and sorts by change_date.

-- Space complexity: O(1)
  -- No extra storage apart from query operations.

-- Solution 4 : UNION ALL and Subquery (Runtime: 480ms | Beats 50%) 

SELECT
  product_id,
  10 AS price
FROM
  Products
GROUP BY
  product_id
HAVING
  MIN(change_date) > '2019-08-16'
UNION ALL
SELECT
  product_id,
  new_price AS price
FROM
  Products
WHERE
  (product_id, change_date) IN (
    SELECT
      product_id,
      MAX(change_date)
    FROM
      Products
    WHERE
      change_date <= '2019-08-16'
    GROUP BY
      product_id
  )
