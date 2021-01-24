DECLARE @json NVARCHAR(MAX);
SET @json = '[{"Guid":"ad5aa3f4-7b44-4985-b1ab-40080d719d09","Value":"86f01bf5-e739-40bb-9e89-ab5d860b498a"},{"Guid":"ad5aa3f4-7b44-4985-b1ab-40080d719d09","Value":"866a9d4b-afff-4258-9b4a-7f299a1f327a"}]';

SELECT *
FROM OPENJSON(@json)
  WITH (
    guid UNIQUEIDENTIFIER '$.Guid',
    value NVARCHAR(150) '$.Value'
  );
