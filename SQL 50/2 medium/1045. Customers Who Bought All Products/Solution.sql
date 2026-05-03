
-- Solution 1 : (Runtime: 577ms | Beats 40%) 

SELECT
    Customer.customer_id 
FROM Customer
GROUP BY customer_id
HAVING Count(DISTINCT product_key) = (
    SELECT COUNT(DISTINCT product_key) FROM Product
);

-- Complexity
  -- Time complexity:
    -- The time complexity of this solution depends on the size of the Customer and Product tables. 
    -- Let's assume there are n customers and m products. The counting of distinct product keys for each customer takes O(n) time, 
    -- and the subquery to count the total number of products takes O(m) time. Therefore, the overall time complexity can be approximated as O(n+m).
  -- Space complexity:
    -- The space complexity of this solution is considered O(1) or constant. 
    -- It only requires a constant amount of additional space for storing intermediate results and the subquery. 
    -- The space usage does not depend on the size of the input tables.