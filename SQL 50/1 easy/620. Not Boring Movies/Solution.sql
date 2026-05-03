-- Solution 1 :  (Runtime: 263ms | Beats 45%) 

SELECT 
    id,
    movie,
    description,
    rating
FROM Cinema
WHERE id % 2 = 1 AND description NOT LIKE "boring"
ORDER BY rating DESC

-- Complexity:
    -- Time: O(n log n) - due to sorting by rating
    -- Space: O(1) - no additional space required beyond result set