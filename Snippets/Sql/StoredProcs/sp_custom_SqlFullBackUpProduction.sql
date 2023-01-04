USE [master]
GO
/****** Object:  StoredProcedure [dbo].[sp_custom_SqlFullBackUpProduction]    Script Date: 1/4/2023 4:29:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[sp_custom_SqlFullBackUpProduction]
	@directory VARCHAR(100)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @tblDbNames AS TABLE (stringValue VARCHAR(255));
	DECLARE @dbName VARCHAR(255);
	Declare @backupFile VARCHAR(100);

	INSERT INTO @tblDbNames (stringValue)
	VALUES('db1'),
	('db2'),
	('db3'),
	('db4'),
	('db5')
	
	DECLARE string_cursor CURSOR FOR
	SELECT stringValue FROM @tblDbNames;

    OPEN string_cursor;

    FETCH NEXT FROM string_cursor INTO @dbName;

    WHILE @@FETCH_STATUS = 0
    BEGIN

        Print @dbName
		Print @directory

		SET @backupFile = @directory + '\' +  @dbName + '.bak'
		Print @backupFile
		
		---- Create full backup with Copy Only option
		BACKUP DATABASE @dbName 
		TO DISK = @backupFile
		WITH COPY_ONLY
		
        FETCH NEXT FROM string_cursor
		INTO @dbName

	END

    CLOSE string_cursor;
    DEALLOCATE string_cursor;

END
