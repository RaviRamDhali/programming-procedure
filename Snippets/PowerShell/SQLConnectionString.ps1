$DBConnectionString = "DSN=ClientDB;Uid=UploadMang;Pwd=************;"
$DBConn = New-Object System.Data.Odbc.OdbcConnection;
$DBConn.ConnectionString = $DBConnectionString;
$DBConn.Open();
$DBCmd = $DBConn.CreateCommand();
$DBCmd.CommandText = "Select * from Contacts"
$Reader = $DBCmd.ExecuteReader()


#DBCC CHECKIDENT('dbo.import_account',reseed,0)	
#DBCC CHECKIDENT('dbo.[import_account]')

$SQLConnectionString = "Data Source=RA-UPLOAD\SQLEXPRESS;Initial Catalog=UploadMang;Uid='UploadMang';Pwd='************'"
$SQLConnection = New-Object System.Data.SqlClient.SqlConnection
$SQLConnection.ConnectionString = $SQLConnectionString
$SQLConnection.Open()


while ($Reader.Read()) {

    $email = $Reader.GetValue($Reader.GetOrdinal("Contact Email"));
    $pw = $Reader.GetValue($Reader.GetOrdinal("Portal Password"));
    $lname = $Reader.GetValue($Reader.GetOrdinal("Contact LName"));
    $fname = $Reader.GetValue($Reader.GetOrdinal("Contact FName"));
    $company = $Reader.GetValue($Reader.GetOrdinal("Contact Company"));
    $customerNumber = $Reader.GetValue($Reader.GetOrdinal("Customer Number"));
    
    [bool] $import = $true

    if ([string]::IsNullOrEmpty($lname)) { $import = $false }
    if ([string]::IsNullOrEmpty($fname)) { $import = $false }
    if ([string]::IsNullOrEmpty($email)) { $import = $false }
    if ([string]::IsNullOrEmpty($company)) { $import = $false }
    if ([string]::IsNullOrEmpty($customerNumber)) { $import = $false }
    if ([string]::IsNullOrEmpty($pw)) { $import = $false }
    
    if(!$import){
        Write-Host "######## NONE ###########";
        $email = ""
        $pw = ""
        $lname = ""
        $fname = ""
        $company = ""
        $customerNumber = ""
        Continue
    }

    if($import){
        Write-Host "********************************"
        Write-Host "email: " $email;
        Write-Host "pw: " $pw;
        Write-Host "lname: " $lname;
        Write-Host "fname: " $fname;
        Write-Host "company: " $company;
        Write-Host "customerNumber: " $customerNumber;
        
        Write-Host "------------------------------------"
        
    
    $SQLInsert = 'INSERT INTO [dbo].[import_account] (lastName,firstName,email,company,password,customerNumber)VALUES(@lname,@fname,@email,@company,@pw,@customerNumber)'
    
    Write-Host $SQLInsert

    Write-Host "********************************"

    $SQLCommand = $SQLConnection.CreateCommand();
    $SQLCommand.CommandText = $SQLInsert
    $SQLCommand.Parameters.AddWithValue('@email', $email)
    $SQLCommand.Parameters.AddWithValue('@pw', $pw)
    $SQLCommand.Parameters.AddWithValue('@lname', $lname)
    $SQLCommand.Parameters.AddWithValue('@fname', $fname)
    $SQLCommand.Parameters.AddWithValue('@company', $company)
    $SQLCommand.Parameters.AddWithValue('@customerNumber', $customerNumber)
    $SQLCommand.ExecuteNonQuery()

    Continue

    }

}

$SQLConnection.Close()
$DBConn.Close()
