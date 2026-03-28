<#
.SYNOPSIS
    Create SQL Database User with Permissions
.DESCRIPTION
    Creates SQL login and user on target database with permissions.
    Standalone user provisioning (no database restore).
    
.NOTES
    Version: 1.0.0
    Standalone user provisioning
    Modular functions with error checking
#>

# ============================================================
# LOGGING
# ============================================================

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    # Only output SUCCESS, WARNING, and ERROR - skip INFO
    if ($Level -ne "INFO") {
        Write-Output "[$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss'))] [$Level] $Message"
    }
}

# ============================================================
# CONFIGURATION LOADING
# ============================================================

function Get-ConfigurationVariables {
    param([string[]]$VariableNames)
    try {
        $config = @{}
        foreach ($name in $VariableNames) {
            $value = Get-AutomationVariable -Name $name -ErrorAction Stop
            if ([string]::IsNullOrEmpty($value)) {
                throw "Variable '$name' is empty"
            }
            $config[$name] = $value
        }
        return @{ Success = $true; Config = $config; Error = $null }
    }
    catch {
        return @{ Success = $false; Config = $null; Error = $_.Exception.Message }
    }
}

function Get-CredentialAsset {
    param([string]$CredentialName)
    try {
        $cred = Get-AutomationPSCredential -Name $CredentialName -ErrorAction Stop
        if ($null -eq $cred) {
            throw "Credential '$CredentialName' not found"
        }
        return @{ Success = $true; Credential = $cred; Error = $null }
    }
    catch {
        return @{ Success = $false; Credential = $null; Error = $_.Exception.Message }
    }
}

# ============================================================
# SQL FUNCTIONS
# ============================================================

function Invoke-SqlCommand {
    param(
        [string]$ServerName,
        [string]$DatabaseName,
        [string]$Query,
        [System.Management.Automation.PSCredential]$Credential
    )
    
    if ([string]::IsNullOrEmpty($ServerName)) {
        throw "ServerName is empty"
    }
    if ([string]::IsNullOrEmpty($DatabaseName)) {
        throw "DatabaseName is empty"
    }
    if ($null -eq $Credential) {
        throw "Credential is null"
    }
    
    $connectionString = "Server=tcp:$ServerName.database.windows.net,1433;Database=$DatabaseName;User Id=$($Credential.UserName);Password=$($Credential.GetNetworkCredential().Password);Encrypt=true;TrustServerCertificate=true;Connection Timeout=30;"
    
    if ([string]::IsNullOrEmpty($connectionString)) {
        throw "Connection string is empty"
    }
    
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    
    try {
        $connection.Open()
        $command = New-Object System.Data.SqlClient.SqlCommand($Query, $connection)
        $command.CommandTimeout = 30
        $command.ExecuteNonQuery() | Out-Null
    }
    finally {
        $connection.Close()
    }
}

# ============================================================
# MAIN SCRIPT
# ============================================================

try {
    Write-Log "========================================" "SUCCESS"
    Write-Log "Create SQL database user" "SUCCESS"
    Write-Log "========================================" "SUCCESS"
    
    # Load configuration variables
    $configVars = Get-ConfigurationVariables -VariableNames @(
        'Sql_ServerName', 'Sql_TargetDB', 'Sql_UserDevAppName', 'Sql_UserDevAppPassword'
    )
    
    if (-not $configVars.Success) {
        throw "Failed to load configuration: $($configVars.Error)"
    }
    Write-Log "✓ Configuration loaded" "SUCCESS"
    
    $ServerName = $configVars.Config['Sql_ServerName']
    $TargetDatabaseName = $configVars.Config['Sql_TargetDB']
    $DevUserName = $configVars.Config['Sql_UserDevAppName']
    $DevAppPassword = $configVars.Config['Sql_UserDevAppPassword']
    
    # Load admin credentials
    $credResult = Get-CredentialAsset -CredentialName "Sql_AdminAccount"
    
    if (-not $credResult.Success) {
        throw "Failed to load credentials: $($credResult.Error)"
    }
    
    $adminCredential = $credResult.Credential
    
    # Create SQL login on master
    $masterSql = @"
IF NOT EXISTS (SELECT name FROM sys.sql_logins WHERE name = '$DevUserName')
BEGIN
    CREATE LOGIN [$DevUserName] WITH PASSWORD = '$DevAppPassword';
END
"@
    
    Invoke-SqlCommand -ServerName $ServerName -DatabaseName "master" -Query $masterSql -Credential $adminCredential
    Write-Log "✓ SQL login created" "SUCCESS"
    
    # Create database user
    $dbSql = @"
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = '$DevUserName')
BEGIN
    CREATE USER [$DevUserName] FOR LOGIN [$DevUserName];
END

IF IS_ROLEMEMBER('db_datareader', '$DevUserName') = 0
    ALTER ROLE db_datareader ADD MEMBER [$DevUserName];
    
IF IS_ROLEMEMBER('db_datawriter', '$DevUserName') = 0
    ALTER ROLE db_datawriter ADD MEMBER [$DevUserName];

GRANT EXECUTE TO [$DevUserName];
GRANT VIEW DEFINITION TO [$DevUserName];
"@
    
    Invoke-SqlCommand -ServerName $ServerName -DatabaseName $TargetDatabaseName -Query $dbSql -Credential $adminCredential
    Write-Log "✓ Database user created with permissions" "SUCCESS"
    
    # Success
    Write-Log "========================================" "SUCCESS"
    Write-Log "✓ COMPLETE" "SUCCESS"
    Write-Log "========================================" "SUCCESS"
    
    return [PSCustomObject]@{
        Status = "Success"
        Database = $TargetDatabaseName
        User = $DevUserName
    }

}
catch {
    Write-Log "========================================" "ERROR"
    Write-Log "✗ FAILED" "ERROR"
    Write-Log "========================================" "ERROR"
    Write-Log "Error: $($_.Exception.Message)" "ERROR"
    Write-Log "Line: $($_.InvocationInfo.ScriptLineNumber)" "ERROR"
    Write-Log "========================================" "ERROR"
    throw
}
