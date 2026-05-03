-- Solution 1 :  (Runtime: 466ms | Beats 34%) 

SELECT
    sell_date,
    COUNT(DISTINCT product) AS num_sold,
    GROUP_CONCAT(DISTINCT product ORDER BY product SEPARATOR ',') AS products
FROM Activities
GROUP BY sell_date  
ORDER BY sell_date;

-- Complexity
    -- Time complexity: O(n)
    -- Space complexity: O(n)

-- Solution 2 :  (Runtime: 461ms | Beats 38%) 

SELECT  
	sell_date,
	(COUNT(sell_date ) ) as num_sold ,
	GROUP_CONCAT(distinct product  ORDER BY product) as products 
FROM 
	(SELECT DISTINCT sell_date,product FROM Activities) as Activities
GROUP BY sell_date;