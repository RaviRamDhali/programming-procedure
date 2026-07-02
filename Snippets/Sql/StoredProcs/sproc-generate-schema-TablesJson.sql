-- LLM can use this JSON, and in fact this structure is ideal for an LLM to consume.
-- db-schema.json

ALTER PROCEDURE [dbo].[helper_CreatePocoFromTableName]    
    @tableName varchar(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH TableList AS (
        SELECT TABLE_NAME
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_TYPE = 'BASE TABLE'
          AND (@tableName IS NULL OR @tableName = '' OR TABLE_NAME = @tableName)
    ),
    ColumnData AS (
        SELECT 
            c.TABLE_NAME,
            c.COLUMN_NAME,
            c.DATA_TYPE,
            c.IS_NULLABLE,
            CASE 
                WHEN DATA_TYPE = 'uniqueidentifier' THEN 'Guid'
                WHEN DATA_TYPE IN ('varchar','nvarchar','char','xml') THEN 'string'
                WHEN DATA_TYPE IN ('datetime','smalldatetime','datetime2') 
                     AND IS_NULLABLE = 'NO' THEN 'DateTime'
                WHEN DATA_TYPE IN ('datetime','smalldatetime','datetime2') 
                     AND IS_NULLABLE = 'YES' THEN 'DateTime?'
                WHEN DATA_TYPE = 'int' AND IS_NULLABLE = 'NO' THEN 'int'
                WHEN DATA_TYPE = 'int' AND IS_NULLABLE = 'YES' THEN 'int?'
                WHEN DATA_TYPE = 'smallint' AND IS_NULLABLE = 'NO' THEN 'Int16'
                WHEN DATA_TYPE = 'smallint' AND IS_NULLABLE = 'YES' THEN 'Int16?'
                WHEN DATA_TYPE IN ('decimal','numeric','money') AND IS_NULLABLE = 'NO' THEN 'decimal'
                WHEN DATA_TYPE IN ('decimal','numeric','money') AND IS_NULLABLE = 'YES' THEN 'decimal?'
                WHEN DATA_TYPE = 'bigint' AND IS_NULLABLE = 'NO' THEN 'long'
                WHEN DATA_TYPE = 'bigint' AND IS_NULLABLE = 'YES' THEN 'long?'
                WHEN DATA_TYPE = 'tinyint' AND IS_NULLABLE = 'NO' THEN 'byte'
                WHEN DATA_TYPE = 'tinyint' AND IS_NULLABLE = 'YES' THEN 'byte?'
                WHEN DATA_TYPE IN ('timestamp','varbinary') THEN 'byte[]'
                WHEN DATA_TYPE = 'bit' AND IS_NULLABLE = 'NO' THEN 'bool'
                WHEN DATA_TYPE = 'bit' AND IS_NULLABLE = 'YES' THEN 'bool?'
            END AS NewType
        FROM INFORMATION_SCHEMA.COLUMNS c
        INNER JOIN TableList t ON c.TABLE_NAME = t.TABLE_NAME
    )

    SELECT (
        SELECT 
            'tables' AS [root],
            (
                SELECT 
                    t.TABLE_NAME AS [name],
                    (
                        SELECT 
                            COLUMN_NAME AS [name],
                            NewType AS [csharpType],
                            DATA_TYPE AS [sqlType],
                            IS_NULLABLE AS [nullable]
                        FROM ColumnData c
                        WHERE c.TABLE_NAME = t.TABLE_NAME
                        ORDER BY COLUMN_NAME
                        FOR JSON PATH
                    ) AS [columns]
                FROM TableList t
                ORDER BY t.TABLE_NAME
                FOR JSON PATH
            ) AS [tables]
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    ) AS JsonSchema;

END
