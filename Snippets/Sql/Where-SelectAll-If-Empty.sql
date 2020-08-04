GO
/****** Object:  StoredProcedure [dbo].[EntityCards]    Script Date: 8/4/2020 3:56:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		rram
-- Create date: 08/04/2020
-- Description:	Get Directory Cards for Case
-- Usage: exec DirectoryCards NULL Return ALL
-- Usage: exec DirectoryCards '5ab6716b-6278-4545-8c42-856fb56c2de9'
-- =============================================
ALTER PROCEDURE [dbo].[DirectoryCards]
	@caseGuid UNIQUEIDENTIFIER NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
SELECT c.Id AS CaseDirectoryId,
       c.CaseGuid,
       -- c.DirectoryId,
       -- c.Modified,
       -- d.Id AS DirectoryId,
       d.Guid AS DirectoryGuid,
       d.FirstName,
       d.LastName,
       d.Title,
       d.CompanyName,
       d.Address1,
       d.Address2,
       d.City,
       d.State,
       d.Zip,
       d.Phone,
       d.Fax,
       d.Email,
       e.Name AS EntityName
       FROM dbo.Case_Directory AS c 
		LEFT JOIN dbo.Directory AS d ON c.DirectoryId = d.Id
		LEFT JOIN	dbo.EntityTypes AS e ON d.EntityType = e.Id
	
-- Or IIF() function SQL Server 2012:	
-- WHERE c.CaseGuid =IIF(@caseGuid IS NULL, c.CaseGuid, @caseGuid )

	WHERE c.CaseGuid = CASE WHEN @caseGuid IS NULL THEN c.CaseGuid ELSE @caseGuid END


				   		
	ORDER BY d.LastName

END
