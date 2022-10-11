-- Get ALL or Get by Id

SELECT * from Customer
WHERE (@id = 0 OR id = @id)


WHERE 1 = 1
AND (@clientId IS NULL OR c.clientID = @clientId)
