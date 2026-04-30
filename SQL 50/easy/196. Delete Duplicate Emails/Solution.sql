
DELETE p1 FROM Person p1
JOIN Person p2 
ON p1.email = p2.email AND p1.id > p2.id;

-- Complexity
    -- Time Complexity:
        -- ( O(n^2) ) in the worst case due to the self join.
    -- Space Complexity:
        -- ( O(1) ) — the operation is in-place using SQL joins.