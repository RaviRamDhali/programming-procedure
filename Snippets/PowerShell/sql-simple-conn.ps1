$SQLConnectionString = "Data Source=xxx.xxx.xxx.88;Initial Catalog=testdb;Persist Security Info=True;User ID=ace;Password=*********************"
$SQLConnection = New-Object System.Data.SqlClient.SqlConnection
$SQLConnection.ConnectionString = $SQLConnectionString
$SQLConnection.Open()

# create your command
$SQLCommand = $SQLConnection.CreateCommand();
$query = 'Select top 10 CustomerID, LastName, FirstName, Addr1, Email from Customer order by CustomerID desc'
$SQLCommand.CommandText = $query

# data adapter
$adp = New-Object System.Data.SqlClient.SqlDataAdapter $SQLCommand
$data = New-Object System.Data.DataSet
$adp.Fill($data) | Out-Null

$data.Tables[0]


$SQLConnection.Close()
