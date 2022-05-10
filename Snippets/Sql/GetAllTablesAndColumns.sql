DECLARE @tableName nvarchar(200)
DECLARE @colName nvarchar(200)

DECLARE tableNames CURSOR LOCAL FOR 
select TABLE_NAME from INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
Order by TABLE_NAME

OPEN tableNames
FETCH NEXT FROM tableNames into @tableName
WHILE @@FETCH_STATUS = 0
BEGIN
-- PRINT 'Select * from ' + @tableName

		DECLARE colName CURSOR LOCAL FOR 
		-- SELECT Column_name FROM antitheftdots.INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @tableName

		-- PRINT 'Col: ' + @tableName

		SELECT name FROM sys.columns WHERE object_id = OBJECT_ID(@tableName)

		OPEN colName
		FETCH NEXT FROM colName into @colName
		WHILE @@FETCH_STATUS = 0
		BEGIN
		--//////////////////////////////////////

			PRINT '' + @tableName + ' ' + @colName
			
		--//////////////////////////////////////
		FETCH NEXT FROM colName into @colName
		END
		CLOSE colName
		DEALLOCATE colName
    
        
    FETCH NEXT FROM tableNames into @tableName
    
END
CLOSE tableNames
DEALLOCATE tableNames
