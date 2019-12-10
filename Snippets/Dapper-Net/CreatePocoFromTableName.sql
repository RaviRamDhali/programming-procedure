CREATE PROCEDURE [dbo].[Helper_CreatePocoFromTableName]    
    @tableName varchar(100)
AS
BEGIN
SET NOCOUNT ON;
declare @codeLines table (lineId int, lineText varchar(4000))

insert into @codeLines
Select  rowNr = ROW_NUMBER() over(order by rowNr), PropertyColumn from (
    SELECT 1 as rowNr, 'public class ' + @tableName + ' {' as PropertyColumn
    UNION
    SELECT  rowNr =2 , 'public ' + a1.NewType + ' ' + a1.COLUMN_NAME + ' {get;set;}' as PropertyColumn
    -- ,* comment added so that i get copy pasteable output
     FROM 
    (
        /*using top because i'm putting an order by ordinal_position on it. 
        putting a top on it is the only way for a subquery to be ordered*/
        SELECT TOP 100 PERCENT
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE,
        CASE 
            WHEN DATA_TYPE = 'varchar' THEN 'string'
            WHEN DATA_TYPE = 'nvarchar' THEN 'string' 
            WHEN DATA_TYPE = 'char' THEN 'string'
            WHEN DATA_TYPE = 'nchar' THEN 'string'
            WHEN DATA_TYPE = 'datetime' AND IS_NULLABLE = 'NO' THEN 'DateTime'
            WHEN DATA_TYPE = 'datetime' AND IS_NULLABLE = 'YES' THEN 'DateTime?'
            WHEN DATA_TYPE = 'smalldatetime' AND IS_NULLABLE = 'NO' THEN 'DateTime'
            WHEN DATA_TYPE = 'datetime2' AND IS_NULLABLE = 'NO' THEN 'DateTime'
            WHEN DATA_TYPE = 'smalldatetime' AND IS_NULLABLE = 'YES' THEN 'DateTime?'
            WHEN DATA_TYPE = 'datetime2' AND IS_NULLABLE = 'YES' THEN 'DateTime?'
            WHEN DATA_TYPE = 'int' AND IS_NULLABLE = 'YES' THEN 'int?'
            WHEN DATA_TYPE = 'int' AND IS_NULLABLE = 'NO' THEN 'int'
            WHEN DATA_TYPE = 'smallint' AND IS_NULLABLE = 'NO' THEN 'Int16'
            WHEN DATA_TYPE = 'smallint' AND IS_NULLABLE = 'YES' THEN 'Int16?'
            WHEN DATA_TYPE = 'decimal' AND IS_NULLABLE = 'NO' THEN 'decimal'
            WHEN DATA_TYPE = 'decimal' AND IS_NULLABLE = 'YES' THEN 'decimal?'
            WHEN DATA_TYPE = 'numeric' AND IS_NULLABLE = 'NO' THEN 'decimal'
            WHEN DATA_TYPE = 'numeric' AND IS_NULLABLE = 'YES' THEN 'decimal?'
            WHEN DATA_TYPE = 'money' AND IS_NULLABLE = 'NO' THEN 'decimal'
            WHEN DATA_TYPE = 'money' AND IS_NULLABLE = 'YES' THEN 'decimal?'
            WHEN DATA_TYPE = 'bigint' AND IS_NULLABLE = 'NO' THEN 'long'
            WHEN DATA_TYPE = 'bigint' AND IS_NULLABLE = 'YES' THEN 'long?'
            WHEN DATA_TYPE = 'tinyint' AND IS_NULLABLE = 'NO' THEN 'byte'
            WHEN DATA_TYPE = 'tinyint' AND IS_NULLABLE = 'YES' THEN 'byte?'
            WHEN DATA_TYPE = 'char' THEN 'string'                       
            WHEN DATA_TYPE = 'timestamp' THEN 'byte[]'
            WHEN DATA_TYPE = 'varbinary' THEN 'byte[]'
            WHEN DATA_TYPE = 'bit' AND IS_NULLABLE = 'NO' THEN 'bool'
            WHEN DATA_TYPE = 'bit' AND IS_NULLABLE = 'YES' THEN 'bool?'
            WHEN DATA_TYPE = 'xml' THEN 'string'
        END AS NewType
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = @tableName
        ORDER BY ORDINAL_POSITION
        ) AS a1 
    UNION 
    SELECT 1000 as rowNr,  '} // class ' + @tableName
    ) as t Order By rowNr asc


declare @max int=(select max(lineId) from @codeLines)

-- assembly result 
declare @i int=1
declare @res nvarchar(max)=''

while(@i<=@max)
begin
  set @res = @res +(select lineText +'
  ' from @codeLines l where l.lineId=@i )

  set @i=@i+1
end

select classCode=@res
END
