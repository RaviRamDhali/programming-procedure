
CREATE TABLE #TempSchema
(
    [TABLE_NAME] nvarchar(max),
    [COLUMN_NAME] nvarchar(max),
    [SQL_TYPE] nvarchar(max),
    [NULLABLE] nvarchar(max),
    [PRIMITIVE_TYPE] nvarchar(max),
);



DECLARE @tableName nvarchar(max)
DECLARE curTable CURSOR LOCAL FOR 
select TABLE_NAME from INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
Order by TABLE_NAME

OPEN curTable
FETCH NEXT FROM curTable into @tableName
WHILE @@FETCH_STATUS = 0
BEGIN

INSERT INTO #TempSchema
SELECT TOP 100 PERCENT
        @tableName as 'TABLE',
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE,
        CASE 
			WHEN DATA_TYPE = 'uniqueidentifier' THEN 'Guid'
			WHEN DATA_TYPE = 'text' THEN 'string'
            WHEN DATA_TYPE = 'varchar' THEN 'string'
            WHEN DATA_TYPE = 'nvarchar' THEN 'string' 
            WHEN DATA_TYPE = 'nchar' THEN 'string' 
			WHEN DATA_TYPE = 'date' AND IS_NULLABLE = 'NO' THEN 'DateTime'
            WHEN DATA_TYPE = 'date' AND IS_NULLABLE = 'YES' THEN 'DateTime?'
            WHEN DATA_TYPE = 'datetime' AND IS_NULLABLE = 'NO' THEN 'DateTime'
            WHEN DATA_TYPE = 'datetime' AND IS_NULLABLE = 'YES' THEN 'DateTime?'
            WHEN DATA_TYPE = 'smalldatetime' AND IS_NULLABLE = 'NO' THEN 'DateTime'
            WHEN DATA_TYPE = 'datetime2' AND IS_NULLABLE = 'NO' THEN 'DateTime'
            WHEN DATA_TYPE = 'smalldatetime' AND IS_NULLABLE = 'YES' THEN 'DateTime?'
            WHEN DATA_TYPE = 'datetime2' AND IS_NULLABLE = 'YES' THEN 'DateTime?'
            WHEN DATA_TYPE = 'int' AND IS_NULLABLE = 'YES' THEN 'int?'
            WHEN DATA_TYPE = 'int' AND IS_NULLABLE = 'NO' THEN 'int'
            WHEN DATA_TYPE = 'smallint' AND IS_NULLABLE = 'NO' THEN 'Int16'
            WHEN DATA_TYPE = 'smallint' AND IS_NULLABLE = 'YES' THEN 'Int16?'
            WHEN DATA_TYPE = 'decimal' AND IS_NULLABLE = 'NO' THEN 'decimal'
            WHEN DATA_TYPE = 'decimal' AND IS_NULLABLE = 'YES' THEN 'decimal?'
            WHEN DATA_TYPE = 'numeric' AND IS_NULLABLE = 'NO' THEN 'decimal'
            WHEN DATA_TYPE = 'numeric' AND IS_NULLABLE = 'YES' THEN 'decimal?'
            WHEN DATA_TYPE = 'money' AND IS_NULLABLE = 'NO' THEN 'decimal'
            WHEN DATA_TYPE = 'money' AND IS_NULLABLE = 'YES' THEN 'decimal?'
            WHEN DATA_TYPE = 'bigint' AND IS_NULLABLE = 'NO' THEN 'long'
            WHEN DATA_TYPE = 'bigint' AND IS_NULLABLE = 'YES' THEN 'long?'
            WHEN DATA_TYPE = 'tinyint' AND IS_NULLABLE = 'NO' THEN 'byte'
            WHEN DATA_TYPE = 'tinyint' AND IS_NULLABLE = 'YES' THEN 'byte?'
            WHEN DATA_TYPE = 'char' THEN 'string'                       
            WHEN DATA_TYPE = 'timestamp' THEN 'byte[]'
            WHEN DATA_TYPE = 'varbinary' THEN 'byte[]'
            WHEN DATA_TYPE = 'bit' AND IS_NULLABLE = 'NO' THEN 'bool'
            WHEN DATA_TYPE = 'bit' AND IS_NULLABLE = 'YES' THEN 'bool?'
            WHEN DATA_TYPE = 'xml' THEN 'string'
        END AS NewType

        -- Inserts data into the newly created table
        

        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = @tableName
        ORDER BY COLUMN_NAME

     FETCH NEXT FROM curTable into @tableName
    
END
CLOSE curTable
DEALLOCATE curTable


Select * from #TempSchema
DROP TABLE IF EXISTS #TempSchema
