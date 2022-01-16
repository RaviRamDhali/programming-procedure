-- check the size of the files.
SELECT size / 128.0 as sizeMB, name
FROM sys.database_files;
 
GO
-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE dbname SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (dbname_log, 1);
GO
-- Reset the database recovery model.
ALTER DATABASE dbname SET RECOVERY FULL;
GO
-- Be sure to do a full backup, then kick off transaction log backups
 
-- check the size of the files.
SELECT size / 128.0 as sizeMB, name
FROM sys.database_files;
