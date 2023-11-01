-- # Instructions
-- Run the SQL to generate the csv file to parse in PowerShell<br>
-- Save the results as:  \table_columns.csv
-- DOT NET files to run Snippets/PowerShell/DotNetFiles
        

DECLARE @tableName nvarchar(max)

declare @json nvarchar(max) = 'table,columns'
SET @json += CHAR(13)+CHAR(10)

DECLARE curTable CURSOR LOCAL FOR 
select TABLE_NAME from INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
Order by TABLE_NAME

OPEN curTable
FETCH NEXT FROM curTable into @tableName
WHILE @@FETCH_STATUS = 0
BEGIN

        SET @json += @tableName + ','
        
            declare @ColumnName NVARCHAR(1000)
            declare @jsonRow varchar(max) = ''
            declare curColumn CURSOR FOR

            select replace(col.name, ' ', '_') ColumnName
            from sys.columns col
            where object_id = object_id(@tableName)
            order by column_id

            -- Open the cursor and fetch the first row
            OPEN curColumn
            FETCH NEXT FROM curColumn
            INTO @ColumnName

            -- Loop through the rows until there are no more rows
            WHILE @@FETCH_STATUS = 0
            BEGIN

                SET @jsonRow += @ColumnName + '|'

            -- Fetch the next row
            FETCH NEXT FROM curColumn 
            INTO @ColumnName
            END
            CLOSE curColumn
            DEALLOCATE curColumn

            -- close row
            set @jsonRow = Left(@jsonRow,len(@jsonRow)-1)
            SET @jsonRow += CHAR(13)+CHAR(10)

            -- clean-up row
            -- SET @jsonRow = REPLACE(@jsonRow, '},],', '}],') 
            

            
        -- add row to parent table
        
        SET @json += @jsonRow

    FETCH NEXT FROM curTable into @tableName
    
END
CLOSE curTable
DEALLOCATE curTable

    -- SET @json = REPLACE(@json, ',}', ']}')
    set @json = Left(@json,len(@json)-1)

    select @json
