-- =============================================
-- Author:		rram
-- Create date: 01/24/2021
-- Description:	Search CustomFields with Json
-- =============================================
ALTER PROCEDURE SearchPersonCustomFields
@clientId int,
@searchJson nvarchar(max)
AS
BEGIN

	-- SELECT * FROM CasePerson WHERE CustomFieldGroupGUID = '3DA03A80-915C-46D4-A725-8577A6422AA9'
	-- CustomFieldGroupGUID > Json GUID, Value passed in. Use CustomFieldGroupGUID with GUID 

	--DECLARE @json NVARCHAR(MAX);
	--SET @json = '[{"Guid":"ad5aa3f4-7b44-4985-b1ab-40080d719d09","Value":"86f01bf5-e739-40ff-9e89-ab5d860b498a"},{"Guid":"ad5aa3f4-7b44-4985-b1ab-40080d719d09","Value":"898a9d4b-afff-4258-9b4a-7f299a1f327a"},{"Guid":"5df40649-1c4e-4595-8771-610bd74327c6","Value":"0a2113f6-dc50-4ad0-9765-e4c8624236b9"},{"Guid":"3da03a80-915c-46d4-a725-8577a6422aa9","Value":"ram"}]';
	--EXEC SearchPersonCustomFields 22, @json


	PRINT @clientId
	PRINT @searchJson

	DROP TABLE IF EXISTS #SearchParams

	SELECT *
	INTO #SearchParams
	FROM OPENJSON(@searchJson)
	WITH (
		guid UNIQUEIDENTIFIER '$.Guid',
		value NVARCHAR(150) '$.Value'
	);

	SELECT *, s.*
	FROM CasePerson AS p
	JOIN #SearchParams AS s ON p.CustomFieldGroupGUID = s.guid
	WHERE 1 = 1 
	AND p.clientID = @clientId
	AND
	( RTRIM(p.CustomFieldItemValue) LIKE '%' + s.value + '%' OR p.customFieldItemGUID = s.value)



END
