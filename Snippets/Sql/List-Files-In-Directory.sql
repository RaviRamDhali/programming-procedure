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
	
	declare @files table (ID int IDENTITY, FileName varchar(100))
	declare @directory nvarchar(400)
	declare @command varchar(400)
	set @directory = 'C:\_temp\target\'
	set @command = 'dir "'+ @directory +'" /s/o/b'
	insert into @files execute xp_cmdshell @command
	
	delete from @files where FileName is null
	select * from @files 


-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 0
GO
-- To update the currently configured value for this feature.
RECONFIGURE
GO
