ALTER PROCEDURE [dbo].[AllClients]
@clientId INT = NULL
AS
BEGIN


DECLARE @pricingNameFree VARCHAR(10);
DECLARE @caseLimitFree INT;
DECLARE @memLimitFree INT;
DECLARE @documentLimitFree INT;

SET @pricingNameFree = 'Free';
SET @caseLimitFree = 25;
SET @memLimitFree = 2;
SET @documentLimitFree = 2500000;


SELECT
c.clientID AS ClientId,
c.clientGUID AS ClientGuid,
c.clientName AS ClientName,
c.clientDept AS ClientDept,
c.clientEmail AS ClientEmail,
m.memFirstName AS FirstName,
m.memLastName AS LastName,
c.isActive AS ClientIsActive,
MAX(s.Created) AS PaidOn,
ISNULL(MAX(s.GatewayAmount), 0)  AS PaidAmount,

ISNULL(p.pricingName, @pricingNameFree) AS PaidName,
ISNULL(p.caseLimit, @caseLimitFree) AS MaxCaseCount,
ISNULL(p.memLimit, @memLimitFree) AS MaxMemberHasAccess,
ISNULL(p.documentLimit, @documentLimitFree) AS MaxSizeUpload,


ISNULL(cntCase.cntCase, 0)AS CountCase,
ISNULL(cntMembers.cntMemberHasAccess, 0)AS CountMemberHasAccess,
ISNULL(cntMembers.cntMember, 0)AS CountMember,
ISNULL(cntMembers.cntMemberNotDelete, 0)AS CountMemberNotDeleted,
ISNULL(cntMembers.cntMemberDeleted, 0)AS CountMemberDeleted,
ISNULL(cntMembers.cntClientContact, 0)AS CountClientContact,
ISNULL(cntMembers.cntClientContactHasAccess, 0)AS CountClientContactHasAccess,
ISNULL(cntUploads.cntUploads, 0)AS CountUploads,
ISNULL(cntUploads.sizeUploads, 0)AS SizeUploads,

CAST (IIF ( ISNULL(p.caseLimit, 3) < ISNULL(cntCase.cntCase, 0), 1, 0) AS bit) AS ExceededCaseCount,
CAST (IIF ( p.memLimit < ISNULL(cntMembers.cntMemberHasAccess, 0), 1, 0) AS bit) AS ExceededMemberCount,
CAST (IIF ( p.documentLimit < ISNULL(cntUploads.sizeUploads, 0), 1, 0) AS bit) AS ExceededUploadSize,

ISNULL(MAX(t.trackDate), c.clientCreatedDate) AS LastActivity,
c.clientCreatedDate AS ClientCreated

FROM dbo.Client AS c
LEFT JOIN dbo.Subscription AS s ON s.ClientId = c.clientID
LEFT JOIN dbo.ClientToPlan AS cp ON cp.clientID = c.clientID 
LEFT JOIN dbo.Pricing AS p ON p.pricingCost = s.GatewayAmount
LEFT JOIN dbo.Tracking AS t ON t.clientID = c.ClientId
LEFT JOIN dbo.MemberToClients AS mc ON mc.clientID = c.clientID
LEFT JOIN dbo.Members AS m ON c.clientEmail = m.memEMail
-- Count Members, IsDelete Count, NotDelete Count
LEFT JOIN (
	-- SELECT count(*) cntMember, clientID FROM MemberToClients GROUP by clientID
	SELECT  clientID,
		COUNT(*) AS cntMember,
		SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) cntMemberHasAccess,
        SUM(CASE WHEN IsDeleted = 1 THEN 1 ELSE 0 END) cntMemberDeleted,
		SUM(CASE WHEN IsDeleted = 0 THEN 1 ELSE 0 END) cntMemberNotDelete,
		SUM(CASE WHEN RoleId = 6 THEN 1 ELSE 0 END) cntClientContact,
		SUM(CASE WHEN RoleId = 6 AND IsActive = 1 THEN 1 ELSE 0 END) cntClientContactHasAccess
	FROM MemberToClients
	GROUP BY clientID
)as cntMembers on cntMembers.clientID = c.clientID


-- Count Cases
LEFT JOIN (
	SELECT count(*) cntCase, clientID FROM Cases GROUP by clientID
)as cntCase on cntCase.clientID = c.clientID


-- Count Uploads, Sum Upload Sizes
LEFT JOIN (
	SELECT c.clientId,
		COUNT(*) AS cntUploads,
		SUM(u.fileSize) sizeUploads
	FROM dbo.Uploads AS u 
	LEFT JOIN dbo.Cases AS c ON c.caseID = u.caseId 
	GROUP BY c.clientId
)as cntUploads on cntUploads.clientID = c.clientID


WHERE 1 = 1
AND (@clientId IS NULL OR c.clientID = @clientId)


GROUP BY
c.clientID,
c.clientGUID,
c.clientName,
c.clientDept,
c.clientEmail,
m.memFirstName,m.memLastName,
c.isActive,
c.clientCreatedDate,
p.pricingName,
p.caseLimit,
p.memLimit,
p.documentLimit,
cntMembers.cntMemberHasAccess,
cntMembers.cntMember,
cntMembers.cntMemberNotDelete,
cntMembers.cntMemberDeleted,
cntMembers.cntClientContact,
cntMembers.cntClientContactHasAccess,
cntCase.cntCase,
cntUploads.cntUploads,
cntUploads.sizeUploads

ORDER BY LastActivity DESC


END

