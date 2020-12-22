--------------------------------------------
----- JSON QUERY ---------------------------
--------------------------------------------
-- caseid, caseactivityid, casepersonid, casedocumentsid

set statistics time on 

DECLARE @caseId NVARCHAR(100)
DECLARE @type NVARCHAR(100)
DECLARE @typeId NVARCHAR(100)

SET @caseId = '8251'
SET @type = 'caseactivityid'
SET @typeId = '42121'

SELECT 
ClientId
,JSON_QUERY(MetaData, '$.CaseId') AS CaseIds
,JSON_QUERY(MetaData, '$.CaseActivityId') AS CaseActivityId
,JSON_QUERY(MetaData, '$.CasePersonId') AS CasePersonId
,JSON_QUERY(MetaData, '$.CaseDocumentsId') AS CaseDocumentsId
,*
FROM dbo.Tags
WHERE 1 = 1 
AND  ClientId = 6
AND '8251' IN (SELECT value FROM OPENJSON(MetaData,'$.CaseId'))
AND 
    (@type = LOWER('caseactivityid') AND @typeId IN (SELECT value FROM OPENJSON(MetaData,'$.CaseActivityId')))
    OR
    (@type = LOWER('casepersonid') AND @typeId IN (SELECT value FROM OPENJSON(MetaData,'$.CasePersonId')))
    OR
    (@type = LOWER('casedocumentsid') AND @typeId IN (SELECT value FROM OPENJSON(MetaData,'$.CaseDocumentsId')))
	

set statistics time off
