# CSV variables
$csvfile = "C:\target\temp_agt.txt"
$csvdelimiter = ","
$firstRowColumns = $true

# Get column header
$columns = (Get-Content $csvfile -First 1).Split($csvdelimiter)

# Create empty Datatable to store data
$dt = New-Object System.Data.Datatable
# Datatable create header row dynamically
foreach ($column in $columns) {
    if ($firstRowColumns -eq $true) {
        [void]$dt.Columns.Add($column)
    }
}

# Read text into reader
$reader = New-Object System.IO.StreamReader $csvfile
while ($null -ne ($line = $reader.ReadLine())) {
    $line
    [void]$dt.Rows.Add($line.Split($csvdelimiter))
}

# Remove first header row
if ($firstRowColumns -eq $true) {
    $dt[0].Rows[0].Delete();
}

$dt.Rows.Count
$dt

$reader.Dispose()


$SQLConnectionString = "Data Source=**.**.**..88;Initial Catalog=testDb;Persist Security Info=True;User ID=test;Password=***********"
$SQLConnection = New-Object System.Data.SqlClient.SqlConnection
$SQLConnection.ConnectionString = $SQLConnectionString
$SQLConnection.Open()

$command1 = New-Object System.Data.SqlClient.SqlCommand
$command1.Connection = $SqlConnection
$MySql1 = "TRUNCATE TABLE dbo.temp_agt"
$command1.CommandText = $MySql1
$command1.ExecuteNonQuery()


# Build the sqlbulkcopy connection, and set the timeout to infinite
$table = "temp_agt"
$connectionstring = $SQLConnectionString
$bulkcopy = New-Object Data.SqlClient.SqlBulkCopy($connectionstring, [System.Data.SqlClient.SqlBulkCopyOptions]::TableLock)
$bulkcopy.DestinationTableName = $table

foreach ($column in $dt.Columns) {
    $bulkcopy.ColumnMappings.Add($column.ColumnName, $column.ColumnName) > $null
}
$bulkcopy.WriteToServer($dt)

# -- *** Clean up *********************
$command2 = New-Object System.Data.SqlClient.SqlCommand
$command2.Connection = $SqlConnection
$MySql2 = "Update temp_agt set EMAIL = LOWER(EMAIL)"
$command2.CommandText = $MySql2
$command2.ExecuteNonQuery()


$SQLConnection.Close()
