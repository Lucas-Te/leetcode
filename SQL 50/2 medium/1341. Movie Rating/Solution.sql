-- Solution 1 : CTE + UNION ALL (Runtime: 1438ms | Beats 22%) 

WITH top_user AS (
    SELECT u.name AS results
    FROM MovieRating mr
    JOIN Users u
        ON mr.user_id = u.user_id
    GROUP BY u.user_id, u.name
    ORDER BY COUNT(*) DESC, u.name ASC
    LIMIT 1
),
top_movie AS (
    SELECT m.title AS results
    FROM MovieRating mr
    JOIN Movies m
        ON mr.movie_id = m.movie_id
    WHERE mr.created_at >= '2020-02-01'
      AND mr.created_at < '2020-03-01'
    GROUP BY m.movie_id, m.title
    ORDER BY AVG(mr.rating) DESC, m.title ASC
    LIMIT 1
)
SELECT results FROM top_user
UNION ALL
SELECT results FROM top_movie;

-- Complexity
    -- Time complexity:
        -- The time complexity of the first query is influenced by the JOIN, GROUP BY, and ORDER BY operations, typically O(m + n log n), 
        -- where m is the number of rows in the MovieRating table, and n is the number of distinct users. 
        -- The time complexity of the second query is similarly influenced by JOIN, GROUP BY, and ORDER BY operations, typically O(p + q log q), 
        -- where p is the number of rows in the MovieRating table for February 2020, and q is the number of distinct movies.
    -- Space complexity:
        -- The space complexity is primarily influenced by the result sets of the two queries. For the first query, 
        -- it is O(n), where n is the number of distinct users. For the second query, it is O(q), where q is the number of distinct movies.