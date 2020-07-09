IF EXISTS (SELECT 1 FROM sysobjects WHERE type='FN' AND name='ReturnNullOrValue') BEGIN
DROP FUNCTION IfNull
END
GO

CREATE FUNCTION ReturnNullOrValue (
@value varchar(256)
)
RETURNS varchar(256)
AS
BEGIN
DECLARE @return varchar(256)
SET @return =
CASE Coalesce(@value,'')
WHEN '' THEN NULL
ELSE @value
END
RETURN @return
END

--  SELECT dbo.ReturnNullOrValue('123') As [text], dbo.ReturnNullOrValue('') As [blank], dbo.ReturnNullOrValue(NULL) As [NULL], dbo.ReturnNullOrValue(' ') As [white space]

GO

SELECT dbo.ReturnNullOrValue('123') As [text], dbo.ReturnNullOrValue('') As [blank], dbo.ReturnNullOrValue(NULL) As [NULL], dbo.ReturnNullOrValue(' ') As [white space]
GO

DROP FUNCTION ReturnNullOrValue
