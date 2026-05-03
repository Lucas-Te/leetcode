
-- Solution 1 : (Runtime: 615ms | Beats 53%) 

select round((count(*)/(select count(distinct customer_id) from Delivery)*100),2) as immediate_percentage
from(select customer_id
from Delivery
group by customer_id
having min(order_date) = min(customer_pref_delivery_date)) as d

-- Complexity
--      Time complexity:O(n)
--      Space complexity:O(k)

-- Solution 2 : CTE  (Runtime: 630ms | Beats 43%) 

WITH first_order AS(
    SELECT
        customer_id,
        MIN(order_date) as first_order_date, 
        MIN(customer_pref_delivery_date) as first_customer_pref_delivery_date 
    FROM Delivery
    GROUP BY customer_id
)
SELECT
    ROUND(SUM(
        CASE WHEN
            first_order_date = first_customer_pref_delivery_date THEN 1
            ELSE 0 END
    ) * 100 / COUNT(*) , 2)
    AS immediate_percentage
FROM first_order

-- Solution 3 : Subquery + IN  (Runtime: 660ms | Beats 29%) 

SELECT ROUND(AVG(order_date = customer_pref_delivery_date)*100, 2) AS immediate_percentage
FROM Delivery
WHERE (customer_id, order_date) IN (
  SELECT customer_id, min(order_date) 
  FROM Delivery
  GROUP BY customer_id
);