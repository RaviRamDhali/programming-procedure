-- ***************************************************
-- Azure SQL Server Command
-- This T-SQL script safely clears all data from user tables in an Azure SQL Database by first dropping all foreign key constraints. 
-- After truncating the tables for high-speed data deletion, it re-creates the foreign key constraints to restore referential integrity. 
-- ***************************************************

DECLARE @sql NVARCHAR(MAX) = N'';

-- Step 1: Generate script to drop all foreign key constraints
SELECT @sql += N'ALTER TABLE ' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) + 
              N' DROP CONSTRAINT ' + QUOTENAME(c.name) + N';' + CHAR(13) + CHAR(10)
FROM sys.foreign_keys AS c
INNER JOIN sys.tables AS t ON c.parent_object_id = t.object_id
INNER JOIN sys.schemas AS s ON t.schema_id = s.schema_id
WHERE t.is_ms_shipped = 0;

-- Execute the foreign key drop script
PRINT 'Dropping foreign key constraints...';
EXEC sp_executesql @sql;
SET @sql = N''; -- Reset variable

-- Step 2: Generate script to truncate all tables
-- Truncating in reverse dependency order is safest, though not strictly necessary after dropping FKs.
-- The following handles it correctly by truncating in reverse order of the table list.
DECLARE @ordered_tables TABLE (id INT IDENTITY(1,1), table_name NVARCHAR(256), schema_name NVARCHAR(256));

INSERT INTO @ordered_tables (schema_name, table_name)
SELECT s.name, t.name
FROM sys.tables AS t
INNER JOIN sys.schemas AS s ON t.schema_id = s.schema_id
WHERE t.is_ms_shipped = 0;

DECLARE @i INT = (SELECT COUNT(*) FROM @ordered_tables);
WHILE @i > 0
BEGIN
    SET @sql += N'TRUNCATE TABLE ' + QUOTENAME((SELECT schema_name FROM @ordered_tables WHERE id = @i)) + 
                N'.' + QUOTENAME((SELECT table_name FROM @ordered_tables WHERE id = @i)) + N';' + CHAR(13) + CHAR(10);
    SET @i -= 1;
END;

-- Execute the truncate script
PRINT 'Truncating tables...';
EXEC sp_executesql @sql;
SET @sql = N''; -- Reset variable

-- Step 3: Generate script to re-create all foreign key constraints
-- Use a separate query to build the recreation script to handle the lookup correctly.
SELECT @sql += N'ALTER TABLE ' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) + 
              N' ADD CONSTRAINT ' + QUOTENAME(fk.name) + 
              N' FOREIGN KEY (' + COL_NAME(fkc.parent_object_id, fkc.parent_column_id) + N')' + 
              N' REFERENCES ' + QUOTENAME(s_ref.name) + '.' + QUOTENAME(t_ref.name) + 
              N' (' + COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) + N');' + CHAR(13) + CHAR(10)
FROM sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.tables AS t ON fk.parent_object_id = t.object_id
INNER JOIN sys.schemas AS s ON t.schema_id = s.schema_id
INNER JOIN sys.tables AS t_ref ON fk.referenced_object_id = t_ref.object_id
INNER JOIN sys.schemas AS s_ref ON t_ref.schema_id = s_ref.schema_id
WHERE t.is_ms_shipped = 0;

-- Execute the foreign key re-create script
PRINT 'Re-creating foreign key constraints...';
EXEC sp_executesql @sql;

PRINT 'Completed.';



-- ***************************************************
-- SQL Server Command
-- ***************************************************

EXEC sp_MSForEachTable 'DISABLE TRIGGER ALL ON ?'
GO
EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
GO
EXEC sp_MSForEachTable 'SET QUOTED_IDENTIFIER ON; DELETE FROM ?'
GO
EXEC sp_MSForEachTable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL'
GO
EXEC sp_MSForEachTable 'ENABLE TRIGGER ALL ON ?'
GO
