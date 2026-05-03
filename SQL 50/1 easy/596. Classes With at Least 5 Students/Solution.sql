SELECT
    class
FROM Courses
GROUP BY class
HAVING Count(*) > 4
