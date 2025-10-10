-- ***************************************************
-- Azure SQL Server Command
-- This T-SQL script safely clears data from user tables while preserving specific tables (e.g. Security.Users).
-- It:
--  1) Builds DROP scripts for all foreign keys,
--  2) Drops the FKs,
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

-- === Step A: Optionally build CREATE statements for FK recreation (saved for manual use) ===
-- This builds the CREATE statements but will NOT be executed by this script.
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
    INNER JOIN sys.tables t ON fk.parent_object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    INNER JOIN sys.tables t_ref ON fk.referenced_object_id = t_ref.object_id
    INNER JOIN sys.schemas s_ref ON t_ref.schema_id = s_ref.schema_id
    WHERE t.is_ms_shipped = 0
    FOR XML PATH(''), TYPE
).value('.','NVARCHAR(MAX)');

SET @createSql = ISNULL(@createSql, N'');

-- === Step B: Build and execute DROP scripts for foreign keys ===
SELECT @dropSql = (
    SELECT
        'ALTER TABLE ' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) +
        ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';' + CHAR(13) + CHAR(10)
    FROM sys.foreign_keys fk
    INNER JOIN sys.tables t ON fk.parent_object_id = t.object_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE t.is_ms_shipped = 0
    FOR XML PATH(''), TYPE
).value('.','NVARCHAR(MAX)');

SET @dropSql = ISNULL(@dropSql, N'');

IF LEN(@dropSql) > 0
BEGIN
    PRINT 'Dropping foreign key constraints...';
    EXEC sp_executesql @dropSql;
END
ELSE
    PRINT 'No foreign key constraints found to drop.';

-- === Step C: Build ordered list of user tables excluding any in the exclusion list ===
DECLARE @ordered_tables TABLE (id INT IDENTITY(1,1), schema_name NVARCHAR(256), table_name NVARCHAR(256));

INSERT INTO @ordered_tables (schema_name, table_name)
SELECT s.name, t.name
FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.is_ms_shipped = 0
  AND NOT EXISTS (
      SELECT 1 FROM @exclude e
      WHERE e.schema_name = s.name AND e.table_name = t.name
  )
ORDER BY s.name, t.name; -- deterministic order; we'll truncate in reverse

-- === Step D: Truncate tables in reverse order (safe for dependencies) ===
DECLARE @sql NVARCHAR(MAX) = N'';
DECLARE @i INT = (SELECT COUNT(*) FROM @ordered_tables);

WHILE @i > 0
BEGIN
    DECLARE @sch NVARCHAR(256) = (SELECT schema_name FROM @ordered_tables WHERE id = @i);
    DECLARE @tbl NVARCHAR(256) = (SELECT table_name FROM @ordered_tables WHERE id = @i);

    -- Use QUOTENAME to avoid SQL injection / special names
    SET @sql += N'TRUNCATE TABLE ' + QUOTENAME(@sch) + N'.' + QUOTENAME(@tbl) + N';' + CHAR(13) + CHAR(10);

    SET @i -= 1;
END;

IF LEN(@sql) > 0
BEGIN
    PRINT 'Truncating tables (excluded list applied)...';
    EXEC sp_executesql @sql;
END
ELSE
    PRINT 'No tables to truncate (all user tables were excluded?).';

-- Step E (automatic FK re-creation) intentionally removed.
-- If you want to re-create FKs later, the @createSql variable contains the CREATE statements
-- (inspect or save its contents before running the script).

PRINT 'Completed. Excluded tables were not truncated:';
SELECT schema_name, table_name FROM @exclude;
