-- Solution 1 : Subquery (Runtime: 313ms | Beats 94%) 

    select case when id % 2 =1 and id+1 in (select id from Seat) then id+1
                when id % 2 =0 then id-1
                else id
            end as id, student
            from Seat
            order by id;

-- Complexity
--     Time complexity: O(n) — We scan all rows and perform constant-time operations for each.
--     Space complexity: O(1) — No extra data structures beyond temporary query constructs.

-- Solution 2 : CASE WHEN + COALESCE (Runtime: 338ms | Beats 60%) 

SELECT 
    id,
    CASE
        WHEN id % 2 = 0 THEN LAG(student) OVER(ORDER BY id)
        ELSE COALESCE(LEAD(student) OVER(ORDER BY id), student)
    END AS student
FROM Seat

-- for the last record with an odd ID, there will be no subsequent name to fetch. 
-- In such cases, ensure the student's name remains unchanged by using the COALESCE function to default to the original value 
-- in the student column when the window function returns null.
