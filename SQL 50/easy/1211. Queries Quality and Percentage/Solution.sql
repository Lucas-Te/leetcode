-- Solution 1 :  (Runtime: 400ms | Beats 15%) 

SELECT 
    query_name
    , ROUND(SUM( rating / position ) / COUNT(*) , 2) AS quality
    , ROUND(100 * SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END) / COUNT(*) , 2) AS poor_query_percentage
FROM Queries
GROUP BY query_name

-- Complexity:
    -- Time: O(n) - where n is number of queries (single table scan with grouping)
    -- Space: O(k) - where k is number of distinct query names