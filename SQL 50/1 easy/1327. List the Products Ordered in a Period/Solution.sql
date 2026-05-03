-- Solution 1 :   (Runtime: 737ms | Beats 40%) 

SELECT
    product_name,
    SUM(unit) as unit
FROM Products p INNER JOIN Orders o 
ON p.product_id = o.product_id  
WHERE YEAR(o.order_date)=2020 AND MONTH(order_date) = 2
GROUP BY product_name       
HAVING SUM(unit) >= 100
    -- AND MONTH(order_date) = 2

-- SELECT p.product_name AS product_name, sum(o.unit) AS unit FROM Products p
-- JOIN Orders o USING (product_id)
-- WHERE YEAR(o.order_date)='2020' AND MONTH(o.order_date)='02'
-- GROUP BY p.product_name
-- HAVING SUM(o.unit)>=100

-- Complexity
    -- Time complexity:
        -- The time complexity of your solution depends on the size of the Orders table and how efficiently the database can process the query. 
        -- However, in general, your solution has a time complexity of O(n), where n is the number of rows in the Orders table that satisfy the specified conditions.

    -- Space complexity:
        -- The space complexity of your solution is determined by the number of distinct product_ids in the specified period. 
        -- This is because we need to store and process the aggregated results for each distinct product_id. So the space complexity is O(m), where m is the number of distinct product_ids.

-- Solution 2 : CTE  (Runtime: 788ms | Beats 23%) 

WITH unit_sold_per_product_in_february AS(
    SELECT
        product_id,
        SUM(unit) as unit
    FROM Orders
    WHERE order_date BETWEEN '2020-02-01' and '2020-02-29'
    GROUP BY product_id
)
SELECT
    p.product_name as product_name,
    u.unit as unit
FROM Products p INNER JOIN unit_sold_per_product_in_february u
    ON p.product_id = u.product_id
WHERE u.unit >= 100
