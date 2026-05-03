-- Solution 1 :  (Runtime: 176ms | Beats 63%) 

WITH all_ids AS (
   SELECT requester_id AS id 
   FROM RequestAccepted
   UNION ALL
   SELECT accepter_id AS id
   FROM RequestAccepted)
SELECT id, 
   COUNT(id) AS num
FROM all_ids
GROUP BY id
ORDER BY COUNT(id) DESC
LIMIT 1

-- Solution 2 : RANK (Runtime: 176ms | Beats 63%) 

-- The main difference between this approach and the first one is that this approach 
-- can include multiple ids if there is more than one person who has the most number of friends.

WITH all_ids AS (
   SELECT requester_id AS id 
   FROM RequestAccepted
   UNION ALL
   SELECT accepter_id AS id
   FROM RequestAccepted)
SELECT id, num
FROM 
   (
   SELECT id, 
      COUNT(id) AS num, 
      RANK () OVER(ORDER BY COUNT(id) DESC) AS rnk
   FROM all_ids
   GROUP BY id
   )t0
WHERE rnk=1

-- Solution 3 : Count the number of friends for each column (number of IDs per column) and use FULL JOIN to add them together. (Runtime: 190ms | Beats 30%) 

WITH count_friend_from_requester AS(
    SELECT
        requester_id,
        COUNT(*) AS nb_friend_request
    FROM RequestAccepted 
    WHERE accept_date  IS NOT NULL
    GROUP BY requester_id
),
count_friend_from_accepter_id AS(
    SELECT
        accepter_id ,
        COUNT(*) AS nb_friend_accepted
    FROM RequestAccepted 
    WHERE accept_date  IS NOT NULL
    GROUP BY accepter_id
)
SELECT 
    CASE
        WHEN cr.requester_id IS NULL THEN ca.accepter_id
        ELSE cr.requester_id END
    AS id,
    SUM(
        CASE
            WHEN cr.requester_id = ca.accepter_id THEN nb_friend_request + nb_friend_accepted 
            WHEN cr.requester_id IS NULL THEN nb_friend_accepted
            WHEN ca.accepter_id IS NULL THEN nb_friend_request
            ELSE 0 END
    ) AS num 
FROM count_friend_from_requester cr FULL JOIN count_friend_from_accepter_id ca
ON cr.requester_id = ca.accepter_id
GROUP BY cr.requester_id, ca.accepter_id    -- not necessary because already group by id in the CTE
ORDER BY num DESC
LIMIT 1

-- simpler and without a CASE WHEN

WITH count_friend_from_requester AS(
    SELECT
        requester_id,
        COUNT(*) AS nb_friend_request
    FROM RequestAccepted 
    WHERE accept_date  IS NOT NULL
    GROUP BY requester_id
),
count_friend_from_accepter_id AS(
    SELECT
        accepter_id ,
        COUNT(*) AS nb_friend_accepted
    FROM RequestAccepted 
    WHERE accept_date  IS NOT NULL
    GROUP BY accepter_id
)
SELECT 
    COALESCE(cr.requester_id, ca.accepter_id) AS id, 
    COALESCE(cr.nb_friend_request, 0::BIGINT) + COALESCE(ca.nb_friend_accepted, 0::BIGINT) as num
FROM count_friend_from_requester cr FULL JOIN count_friend_from_accepter_id ca
ON cr.requester_id = ca.accepter_id
ORDER BY num DESC
LIMIT 1

