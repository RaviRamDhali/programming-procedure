USE [TestEncrypt]
GO

-- To allow advanced options to be changed.
EXEC sp_configure 'show advanced options', 1
GO
-- To update the currently configured value for advanced options.
RECONFIGURE
GO
-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 1
GO
-- To update the currently configured value for this feature.
RECONFIGURE
GO
	
CREATE TABLE #temp_files(
	ID int IDENTITY,
	FileName varchar(100)
) ON [PRIMARY]

GO

	declare @directory nvarchar(400)
	declare @command varchar(400)
	set @directory = 'C:\_temp\target\'
	set @command = 'dir "'+ @directory +'" /s/o/b'
	insert into #temp_files execute xp_cmdshell @command
	
	delete from #temp_files where FileName is null
	select * from #temp_files 


-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 0
GO
-- To update the currently configured value for this feature.
RECONFIGURE
GO

-- *********************************************************
-- *********************************************************

CREATE TABLE #temp_mylife(
	[AffiliateName] [varchar](250) NULL, 
	[Column1] [varchar](250) NULL,
	[LastName] [varchar](250) NULL, 
	[FirstName] [varchar](250) NULL, 
	[Middleinitial] [varchar](250) NULL, 
	[SSN] [varchar](250) NULL, 
	[Column6] [varchar](250) NULL,
	[CompanyCustomerID] [varchar](250) NULL, 
	[StateAbbr] [varchar](250) NULL, 
	[Email] [varchar](250) NULL 
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


DECLARE @filename NVARCHAR(50)
DECLARE cur CURSOR FOR

SELECT FileName from #temp_files

OPEN cur
FETCH NEXT FROM cur
INTO @filename
WHILE @@FETCH_STATUS = 0
   BEGIN

		DECLARE @bulkCommand varchar(1000)
		SET @bulkCommand = 'BULK INSERT #temp_mylife FROM ''' + @filename + ''' WITH ( FIELDTERMINATOR ='','', ROWTERMINATOR =''\n'' )';
		-- PRINT @bulkCommand
		EXEC(@bulkCommand);	
		
      FETCH NEXT FROM cur
      INTO @filename
      
   END
CLOSE cur
DEALLOCATE cur
GO


-- *********************************************************
-- *********************************************************



select * from #temp_mylife


DROP TABLE #temp_files
DROP TABLE #temp_mylife

GO
