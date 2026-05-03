
SELECT user_id, name, mail
FROM Users
WHERE mail REGEXP '^[A-Za-z][A-Za-z0-9_.-]*@leetcode\\.com$'
AND mail LIKE BINARY '%@leetcode.com';

-- Intuition
-- Looking at this problem, I need to validate email addresses based on specific rules. The prefix must start with a letter, 
-- can contain letters/digits/underscore/period/dash, and must end with @leetcode.com. Regular expressions are perfect for this kind of pattern matching, 
-- combined with a domain check.

-- Approach : 
-- I'm using REGEXP with additional validation:

-- Use WHERE clause with REGEXP to validate the email pattern:
-- ^ ensures pattern starts at beginning
-- [A-Za-z] requires first character to be a letter
-- [A-Za-z0-9_.-]* allows letters, digits, underscore, period, dash (0 or more)
-- @leetcode\\.com matches the required domain (escape the dot)
-- $ ensures pattern ends here
-- Add LIKE BINARY '%@leetcode.com' as extra check:
-- Ensures case-sensitive domain matching
-- BINARY keyword makes comparison case-sensitive
-- Select user_id, name, and mail for matching records
-- The combination of REGEXP for pattern and LIKE BINARY for case-sensitivity ensures strict validation.

-- Complexity
-- Time complexity: O(n⋅m)
-- where n is the number of users and m is the average length of email addresses. REGEXP matching processes each email character-by-character.

-- Space complexity: O(k)
-- where k is the number of users with valid emails. The result set stores matching records.