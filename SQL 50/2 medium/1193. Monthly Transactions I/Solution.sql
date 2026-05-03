
-- Solution 1 :  (Runtime: 578ms | Beats 53%) 

SELECT
    DATE_FORMAT(trans_date , '%Y-%m') as month    
    , country
    , COUNT(*) AS trans_count
    , SUM(CASE WHEN state LIKE 'approved' THEN 1 ELSE 0 END) AS approved_count
    , SUM(amount) AS trans_total_amount 
    , SUM(CASE WHEN state LIKE 'approved' THEN amount ELSE 0 END) AS approved_total_amount 
FROM Transactions 
GROUP BY month, country
