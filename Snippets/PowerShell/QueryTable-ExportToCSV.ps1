$beginDate = (Get-Date -Hour 9 -Minute 00 -Second 00).AddDays(-1);
$endDate = (Get-Date -Hour 9 -Minute 00 -Second 00);
$archiveDate = (get-date).AddDays(-1);
$strArchiveDate = $archiveDate.ToString('yyyyMMddhhmmss')

$date = $endDate.ToString('MMddyyyy')
$strDateTime = (((get-date)).ToString("yyyyMMddhhmmss"))
$source_raw = $PSScriptRoot + '\source\raw-' + $strDateTime + '.txt'
$source_data = $PSScriptRoot + '\source\S26082.txt'
$source_archive = $PSScriptRoot + '\archive\data-' + $strArchiveDate + '.txt'

$SQLConnectionString = "Data Source=**.**.**.88;Initial Catalog=testDb;Persist Security Info=True;User ID=test;Password=****************"
$SQLConnection = New-Object System.Data.SqlClient.SqlConnection
$SQLConnection.ConnectionString = $SQLConnectionString
$SQLConnection.Open()

# create your command
$SQLCommand = $SQLConnection.CreateCommand();
$query = 'Select * from Report'
$SQLCommand.CommandText = $query


# data adapter
$adp = New-Object System.Data.SqlClient.SqlDataAdapter $SQLCommand
$data = New-Object System.Data.DataSet
$adp.Fill($data) | Out-Null
$data.Tables

#Output RESULTS to CSV
$data.Tables[0] | Export-Csv $source_raw -NoTypeInformation

(Get-Content $source_raw | Select-Object -Skip 1) | Set-Content $source_raw


$SQLConnection.Close()
