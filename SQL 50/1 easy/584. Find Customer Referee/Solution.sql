SELECT 
    Customer.name as name
FROM Customer 
WHERE Customer.referee_id != 2 OR Customer.referee_id is NULL