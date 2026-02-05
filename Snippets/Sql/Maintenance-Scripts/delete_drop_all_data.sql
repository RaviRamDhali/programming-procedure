-- ***************************************************
-- Azure SQL Server Command
-- This T-SQL script safely clears data from user tables while preserving specific tables (e.g. Security.Users).
-- It:
--  1) Builds DROP scripts for all foreign keys (only for existing, accessible tables),
--  2) Drops the FKs (with error handling),
--  3) Truncates all tables except those listed in the exclusion list.
-- Note: Step E (automatic re-creation of foreign keys) has been removed per request.
-- ***************************************************

SET NOCOUNT ON;

DECLARE @dropSql  NVARCHAR(MAX) = N'';
DECLARE @createSql NVARCHAR(MAX) = N''; -- retained for reference but not executed

-- === Exclusion list: add schema/table pairs you DON'T want touched ===
-- By default we exclude Security.Users so that DB security accounts remain unchanged.
DECLARE @exclude TABLE (
    schema_name NVARCHAR(256) NOT NULL,
    table_name  NVARCHAR(256) NOT NULL
);

INSERT INTO @exclude (schema_name, table_name) VALUES
    ('Security', 'Users'); -- add more rows here if you want to exclude more tables

-- === Step A: Get list of ACTUAL existing tables (exclude ledger history tables) ===
DECLARE @existing_tables TABLE (
    schema_name NVARCHAR(256),
    table_name NVARCHAR(256),
    object_id INT
);

INSERT INTO @existing_tables (schema_name, table_name, object_id)
SELECT s.name, t.name, t.object_id
FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.is_ms_shipped = 0
  AND t.temporal_type <> 1  -- Exclude history tables
  AND t.name NOT LIKE 'xx_%' -- Exclude ledger dropped tables
  AND OBJECTPROPERTY(t.object_id, 'TableHasIdentity') IS NOT NULL; -- Additional existence check

-- === Step B: Build CREATE statements for FK recreation (for existing tables only) ===
SELECT @createSql = (
    SELECT
        'ALTER TABLE ' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) +
        ' ADD CONSTRAINT ' + QUOTENAME(fk.name) +
        ' FOREIGN KEY (' +
            STUFF((
                SELECT ',' + QUOTENAME(pc2.name)
                FROM sys.foreign_key_columns fkc2
                JOIN sys.columns pc2 ON pc2.object_id = fkc2.parent_object_id AND pc2.column_id = fkc2.parent_column_id
                WHERE fkc2.constraint_object_id = fk.object_id
                ORDER BY fkc2.constraint_column_id
                FOR XML PATH(''), TYPE).value('.','nvarchar(max)'), 1, 1, ''
            ) +
        ')' +
        ' REFERENCES ' + QUOTENAME(s_ref.name) + '.' + QUOTENAME(t_ref.name) +
        ' (' +
            STUFF((
                SELECT ',' + QUOTENAME(rc2.name)
                FROM sys.foreign_key_columns fkc2
                JOIN sys.columns rc2 ON rc2.object_id = fkc2.referenced_object_id AND rc2.column_id = fkc2.referenced_column_id
                WHERE fkc2.constraint_object_id = fk.object_id
                ORDER BY fkc2.constraint_column_id
                FOR XML PATH(''), TYPE).value('.','nvarchar(max)'), 1, 1, ''
            ) +
        ');' + CHAR(13) + CHAR(10)
    FROM sys.foreign_keys fk
    INNER JOIN @existing_tables et ON fk.parent_object_id = et.object_id
    INNER JOIN sys.schemas s ON et.schema_name = s.name
    INNER JOIN sys.tables t ON et.object_id = t.object_id
    INNER JOIN @existing_tables et_ref ON fk.referenced_object_id = et_ref.object_id
    INNER JOIN sys.schemas s_ref ON et_ref.schema_name = s_ref.name
    INNER JOIN sys.tables t_ref ON et_ref.object_id = t_ref.object_id
    FOR XML PATH(''), TYPE
).value('.','NVARCHAR(MAX)');

SET @createSql = ISNULL(@createSql, N'');

-- === Step C: Drop foreign keys (ONLY for existing tables) ===
PRINT 'Dropping foreign key constraints from existing tables...';

DECLARE @fkSchema NVARCHAR(256);
DECLARE @fkTable NVARCHAR(256);
DECLARE @fkName NVARCHAR(256);
DECLARE @singleDropSql NVARCHAR(MAX);
DECLARE @fkDropCount INT = 0;
DECLARE @fkSkipCount INT = 0;

DECLARE fk_cursor CURSOR FOR
SELECT s.name, t.name, fk.name
FROM sys.foreign_keys fk
INNER JOIN @existing_tables et ON fk.parent_object_id = et.object_id
INNER JOIN sys.schemas s ON et.schema_name = s.name
INNER JOIN sys.tables t ON et.object_id = t.object_id;

OPEN fk_cursor;
FETCH NEXT FROM fk_cursor INTO @fkSchema, @fkTable, @fkName;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Double-check the table exists before attempting drop
    IF OBJECT_ID(QUOTENAME(@fkSchema) + '.' + QUOTENAME(@fkTable), 'U') IS NOT NULL
    BEGIN
        SET @singleDropSql = 'ALTER TABLE ' + QUOTENAME(@fkSchema) + '.' + QUOTENAME(@fkTable) + 
                             ' DROP CONSTRAINT ' + QUOTENAME(@fkName) + ';';
        BEGIN TRY
            EXEC sp_executesql @singleDropSql;
            SET @fkDropCount += 1;
        END TRY
        BEGIN CATCH
            PRINT 'Warning: Failed to drop ' + @fkName + ' on ' + @fkSchema + '.' + @fkTable + ': ' + ERROR_MESSAGE();
        END CATCH
    END
    ELSE
    BEGIN
        SET @fkSkipCount += 1;
    END
    
    FETCH NEXT FROM fk_cursor INTO @fkSchema, @fkTable, @fkName;
END

CLOSE fk_cursor;
DEALLOCATE fk_cursor;

PRINT 'Foreign keys dropped: ' + CAST(@fkDropCount AS VARCHAR(10));
PRINT 'Foreign keys skipped (table not found): ' + CAST(@fkSkipCount AS VARCHAR(10));

-- === Step D: Build ordered list of user tables to truncate (exclude non-existent and excluded tables) ===
DECLARE @ordered_tables TABLE (
    id INT IDENTITY(1,1), 
    schema_name NVARCHAR(256), 
    table_name NVARCHAR(256)
);

INSERT INTO @ordered_tables (schema_name, table_name)
SELECT et.schema_name, et.table_name
FROM @existing_tables et
WHERE NOT EXISTS (
    SELECT 1 FROM @exclude e
    WHERE e.schema_name = et.schema_name AND e.table_name = et.table_name
)
ORDER BY et.schema_name, et.table_name;

-- === Step E: Truncate tables in reverse order (with individual error handling) ===
PRINT 'Truncating tables (excluded list applied)...';

DECLARE @i INT = (SELECT COUNT(*) FROM @ordered_tables);
DECLARE @sch NVARCHAR(256);
DECLARE @tbl NVARCHAR(256);
DECLARE @truncateSql NVARCHAR(MAX);
DECLARE @truncateCount INT = 0;
DECLARE @truncateFailCount INT = 0;

WHILE @i > 0
BEGIN
    SELECT @sch = schema_name, @tbl = table_name 
    FROM @ordered_tables 
    WHERE id = @i;

    -- Triple-check table exists and is accessible
    IF OBJECT_ID(QUOTENAME(@sch) + '.' + QUOTENAME(@tbl), 'U') IS NOT NULL
    BEGIN
        SET @truncateSql = N'TRUNCATE TABLE ' + QUOTENAME(@sch) + N'.' + QUOTENAME(@tbl) + N';';
        
        BEGIN TRY
            EXEC sp_executesql @truncateSql;
            SET @truncateCount += 1;
        END TRY
        BEGIN CATCH
            PRINT 'Warning: Failed to truncate ' + @sch + '.' + @tbl + ': ' + ERROR_MESSAGE();
            SET @truncateFailCount += 1;
        END CATCH
    END
    ELSE
    BEGIN
        PRINT 'Skipping ' + @sch + '.' + @tbl + ' (table not found or not accessible)';
        SET @truncateFailCount += 1;
    END

    SET @i -= 1;
END;

PRINT 'Tables truncated: ' + CAST(@truncateCount AS VARCHAR(10));
PRINT 'Tables skipped/failed: ' + CAST(@truncateFailCount AS VARCHAR(10));

-- Step F: Summary
PRINT '';
PRINT '=== COMPLETION SUMMARY ===';
PRINT 'Excluded tables (not truncated):';
SELECT schema_name, table_name FROM @exclude;

PRINT '';
PRINT 'If you need to recreate foreign keys, the CREATE statements are stored in @createSql variable.';
PRINT 'Script completed successfully.';
