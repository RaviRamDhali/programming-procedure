--------------------------------------------
----- JSON QUERY ---------------------------
--------------------------------------------
-- id, activityid, personid, documentsid

set statistics time on 

DECLARE @Id NVARCHAR(100)
DECLARE @type NVARCHAR(100)
DECLARE @typeId NVARCHAR(100)

SET @Id = '8251'
SET @type = 'activityid'
SET @typeId = '42121'

SELECT 
ClientId
,JSON_QUERY(MetaData, '$.Id') AS Ids
,JSON_QUERY(MetaData, '$.ActivityId') AS ActivityId
,JSON_QUERY(MetaData, '$.PersonId') AS PersonId
,JSON_QUERY(MetaData, '$.DocumentsId') AS DocumentsId
,*
FROM dbo.Tags
WHERE 1 = 1 
AND  ClientId = 6
AND '8251' IN (SELECT value FROM OPENJSON(MetaData,'$.Id'))
AND 
    (@type = LOWER('activityid') AND @typeId IN (SELECT value FROM OPENJSON(MetaData,'$.ActivityId')))
    OR
    (@type = LOWER('personid') AND @typeId IN (SELECT value FROM OPENJSON(MetaData,'$.PersonId')))
    OR
    (@type = LOWER('documentsid') AND @typeId IN (SELECT value FROM OPENJSON(MetaData,'$.DocumentsId')))
	

set statistics time off
