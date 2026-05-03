-- Solution 1 :  (Runtime: 1000ms | Beats 10%) 

SELECT
    p.product_id,
    IFNULL(ROUND(
        SUM(p.price * u.units) * 1 / SUM(u.units)
        ,2
        ) ,0) 
        AS average_price
FROM Prices as p 
    LEFT JOIN
UnitsSold as u
    ON p.product_id  = u.product_id 
    AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY p.product_id