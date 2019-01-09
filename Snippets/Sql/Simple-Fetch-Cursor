DECLARE @id NVARCHAR(50)
DECLARE cur CURSOR FOR

SELECT p.caseID FROM dbo.Cases AS p

OPEN cur
FETCH NEXT FROM cur
INTO @id
WHILE @@FETCH_STATUS = 0
   BEGIN
   
	PRINT @id + '_spec.pdf'
	
		--UPDATE dbo.Product
		--SET prodSpecSheet = @id + '_spec.pdf'
		--WHERE prodStyleID = @id
		
		--INSERT INTO option1 (option1Code,option1Desc,option1Other)
		--VALUES (@skuV,@skuV + '_sm.jpg','goText')
		
		
      FETCH NEXT FROM cur
      INTO @id
      
   END
CLOSE cur
DEALLOCATE cur
GO
