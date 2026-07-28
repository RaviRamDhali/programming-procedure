CREATE OR ALTER PROCEDURE dbo.ExportDatabaseSchemaJson_Print
AS
BEGIN
    SET NOCOUNT ON;

    /* Build the raw tables JSON */
    DECLARE @tablesJson NVARCHAR(MAX);

    SELECT @tablesJson =
    (
        SELECT
            t.name AS TableName,
            s.name AS SchemaName,
            (
                SELECT
                    c.name AS ColumnName,
                    ty.name AS SqlType,
                    c.max_length AS MaxLength,
                    c.precision AS Precision,
                    c.scale AS Scale,
                    c.is_nullable AS IsNullable,
                    ic.seed_value AS IdentitySeed,
                    ic.increment_value AS IdentityIncrement,
                    dc.definition AS DefaultDefinition,
                    ep.value AS ExtendedProperty
                FROM sys.columns c
                JOIN sys.types ty ON c.user_type_id = ty.user_type_id
                LEFT JOIN sys.identity_columns ic 
                    ON c.object_id = ic.object_id AND c.column_id = ic.column_id
                LEFT JOIN sys.default_constraints dc 
                    ON c.default_object_id = dc.object_id
                LEFT JOIN sys.extended_properties ep 
                    ON ep.major_id = c.object_id 
                    AND ep.minor_id = c.column_id 
                    AND ep.name = 'MS_Description'
                WHERE c.object_id = t.object_id
                ORDER BY c.column_id
                FOR JSON PATH
            ) AS Columns,

            (
                SELECT
                    kc.name AS ConstraintName,
                    col.name AS ColumnName
                FROM sys.key_constraints kc
                JOIN sys.index_columns ic 
                    ON kc.parent_object_id = ic.object_id 
                    AND kc.unique_index_id = ic.index_id
                JOIN sys.columns col 
                    ON ic.object_id = col.object_id 
                    AND ic.column_id = col.column_id
                WHERE kc.parent_object_id = t.object_id
                FOR JSON PATH
            ) AS PrimaryKey,

            (
                SELECT
                    fk.name AS ForeignKeyName,
                    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ColumnName,
                    OBJECT_NAME(fkc.referenced_object_id) AS ReferencedTable,
                    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ReferencedColumn
                FROM sys.foreign_keys fk
                JOIN sys.foreign_key_columns fkc 
                    ON fk.object_id = fkc.constraint_object_id
                WHERE fk.parent_object_id = t.object_id
                FOR JSON PATH
            ) AS ForeignKeys

        FROM sys.tables t
        JOIN sys.schemas s ON t.schema_id = s.schema_id
        ORDER BY s.name, t.name
        FOR JSON PATH, INCLUDE_NULL_VALUES
    );

    /* Wrap with root object including run datetime */
    DECLARE @rootJson NVARCHAR(MAX);

    SET @rootJson = N'{"runDate":"' 
                    + CONVERT(VARCHAR(30), SYSDATETIME(), 126)
                    + N'","tables":' 
                    + @tablesJson 
                    + N'}';

    /* Ensure max text output */
    SET TEXTSIZE 2147483647;

    /* PRINT-style output using RAISERROR chunking (2000 chars) */
    DECLARE @pos INT = 1;
    DECLARE @chunk NVARCHAR(2000);
    DECLARE @len INT = LEN(@rootJson);

    WHILE @pos <= @len
    BEGIN
        SET @chunk = SUBSTRING(@rootJson, @pos, 2000);
        RAISERROR('%s', 0, 1, @chunk) WITH NOWAIT;
        SET @pos += 2000;
    END
END
GO
