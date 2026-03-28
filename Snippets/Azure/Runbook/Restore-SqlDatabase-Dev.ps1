<#
.SYNOPSIS
    Azure SQL Database Point-in-Time Restore with User Provisioning
.DESCRIPTION
    Complete runbook: restore database + create user with permissions.
    1. Authenticate with Managed Identity
    2. Verify source database exists
    3. Delete target database if exists
    4. Initiate point-in-time restore
    5. Monitor restore until online
    6. Create SQL login on master
    7. Create user on target database
    8. Grant permissions
    
.NOTES
    Version: 2.0.0
    Combined restore + user provisioning workflow
    Modular functions with error checking
#>

# ============================================================
# CONFIGURATION
# ============================================================

$RestorePointOffsetMinutes = 10
$DeletionWaitSeconds = 30
$MonitorMaxWaitSeconds = 900
$MonitorCheckIntervalSeconds = 5

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
# RESTORE FUNCTIONS
# ============================================================

function Get-SourceDatabase {
    param(
        [string]$ResourceGroupName,
        [string]$ServerName,
        [string]$DatabaseName
    )
    try {
        $db = Get-AzSqlDatabase -ResourceGroupName $ResourceGroupName `
                                -ServerName $ServerName `
                                -DatabaseName $DatabaseName `
                                -ErrorAction Stop
        return @{ Success = $true; Database = $db; Error = $null }
    }
    catch {
        return @{ Success = $false; Database = $null; Error = $_.Exception.Message }
    }
}

function Get-TargetDatabase {
    param(
        [string]$ResourceGroupName,
        [string]$ServerName,
        [string]$DatabaseName
    )
    try {
        $db = Get-AzSqlDatabase -ResourceGroupName $ResourceGroupName `
                                -ServerName $ServerName `
                                -DatabaseName $DatabaseName `
                                -ErrorAction SilentlyContinue
        return @{ Success = $true; Database = $db; Error = $null }
    }
    catch {
        return @{ Success = $false; Database = $null; Error = $_.Exception.Message }
    }
}

function Remove-TargetDatabase {
    param(
        [string]$ResourceGroupName,
        [string]$ServerName,
        [string]$DatabaseName
    )
    try {
        Remove-AzSqlDatabase -ResourceGroupName $ResourceGroupName `
                             -ServerName $ServerName `
                             -DatabaseName $DatabaseName `
                             -Force `
                             -ErrorAction Stop
        return @{ Success = $true; Error = $null }
    }
    catch {
        return @{ Success = $false; Error = $_.Exception.Message }
    }
}

function Invoke-Restore {
    param(
        [string]$ResourceGroupName,
        [string]$ServerName,
        [string]$TargetDatabaseName,
        [string]$SourceResourceId,
        [datetime]$RestorePointInTime,
        [string]$Edition,
        [string]$ServiceObjectiveName
    )
    try {
        $restoreParams = @{
            ResourceGroupName     = $ResourceGroupName
            ServerName            = $ServerName
            TargetDatabaseName    = $TargetDatabaseName
            FromPointInTimeBackup = $true
            PointInTime           = $RestorePointInTime
            ResourceId            = $SourceResourceId
            Edition               = $Edition
            ServiceObjectiveName  = $ServiceObjectiveName
            ErrorAction           = "Stop"
        }
        $result = Restore-AzSqlDatabase @restoreParams
        return @{ Success = $true; Database = $result; Error = $null }
    }
    catch {
        return @{ Success = $false; Database = $null; Error = $_.Exception.Message }
    }
}

function Monitor-RestoreStatus {
    param(
        [string]$ResourceGroupName,
        [string]$ServerName,
        [string]$TargetDatabaseName,
        [int]$MaxWaitSeconds,
        [int]$CheckIntervalSeconds
    )
    
    $pollCount = 0
    $status = "Unknown"
    $finalDb = $null
    $maxPolls = [math]::Ceiling($MaxWaitSeconds / $CheckIntervalSeconds)
    
    do {
        $pollCount++
        
        if ($pollCount -gt 1) {
            Start-Sleep -Seconds $CheckIntervalSeconds
        }
        
        $dbResult = Get-TargetDatabase -ResourceGroupName $ResourceGroupName `
                                        -ServerName $ServerName `
                                        -DatabaseName $TargetDatabaseName
        
        if ($dbResult.Success) {
            $status = $dbResult.Database.Status
            $finalDb = $dbResult.Database
            Write-Log "Poll #$pollCount`: Status = $status" "INFO"
            
            if ($status -eq "Online") {
                Write-Log "✓ Database is ONLINE" "SUCCESS"
                return @{ Success = $true; Database = $finalDb; PollCount = $pollCount; Error = $null }
            }
        }
        else {
            Write-Log "Poll #$pollCount`: Status check failed" "WARNING"
        }
        
        if ($pollCount -ge $maxPolls) {
            return @{ Success = $false; Database = $null; PollCount = $pollCount; Error = "Timeout: Status = $status" }
        }
        
    } while ($status -ne "Online")
}

# ============================================================
# USER PROVISIONING FUNCTIONS
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
    Write-Log "Database restore and user provisioning" "SUCCESS"
    Write-Log "========================================" "SUCCESS"
    
    # ========== PHASE 1: AUTHENTICATION ==========
    
    Connect-AzAccount -Identity -ErrorAction Stop | Out-Null
    Write-Log "✓ Authenticated with Managed Identity" "SUCCESS"
    
    # ========== PHASE 2: LOAD RESTORE VARIABLES ==========
    
    $restoreVars = Get-ConfigurationVariables -VariableNames @(
        'Sql_ResourceGroup', 'Sql_ServerName', 'Sql_SourceDB', 
        'Sql_TargetDB', 'Sql_TargetTier', 'Sql_TargetSize'
    )
    
    if (-not $restoreVars.Success) {
        throw "Failed to load restore variables: $($restoreVars.Error)"
    }
    Write-Log "✓ Restore variables loaded" "SUCCESS"
    
    $ResourceGroupName = $restoreVars.Config['Sql_ResourceGroup']
    $ServerName = $restoreVars.Config['Sql_ServerName']
    $SourceDatabaseName = $restoreVars.Config['Sql_SourceDB']
    $TargetDatabaseName = $restoreVars.Config['Sql_TargetDB']
    $TargetServiceTier = $restoreVars.Config['Sql_TargetTier']
    $TargetComputeSize = $restoreVars.Config['Sql_TargetSize']
    
    Write-Log "Source: $SourceDatabaseName | Target: $TargetDatabaseName" "INFO"
    
    # ========== PHASE 3: LOAD USER PROVISIONING VARIABLES ==========
    
    $userVars = Get-ConfigurationVariables -VariableNames @(
        'Sql_UserDevAppName', 'Sql_UserDevAppPassword'
    )
    
    if (-not $userVars.Success) {
        throw "Failed to load user variables: $($userVars.Error)"
    }
    Write-Log "✓ User variables loaded" "SUCCESS"
    
    $DevUserName = $userVars.Config['Sql_UserDevAppName']
    $DevAppPassword = $userVars.Config['Sql_UserDevAppPassword']
    
    # ========== PHASE 4: LOAD CREDENTIALS ==========
    
    $credResult = Get-CredentialAsset -CredentialName "Sql_AdminAccount"
    
    if (-not $credResult.Success) {
        throw "Failed to load credentials: $($credResult.Error)"
    }
    Write-Log "✓ Admin credentials loaded" "SUCCESS"
    
    $adminCredential = $credResult.Credential
    
    # ========== PHASE 5: VERIFY SOURCE DATABASE ==========
    
    $sourceDbResult = Get-SourceDatabase -ResourceGroupName $ResourceGroupName `
                                          -ServerName $ServerName `
                                          -DatabaseName $SourceDatabaseName
    
    if (-not $sourceDbResult.Success) {
        throw "Source database not found: $($sourceDbResult.Error)"
    }
    Write-Log "✓ Source database found" "SUCCESS"
    $sourceDb = $sourceDbResult.Database
    
    # ========== PHASE 6: DELETE TARGET DATABASE ==========
    
    $targetDbResult = Get-TargetDatabase -ResourceGroupName $ResourceGroupName `
                                          -ServerName $ServerName `
                                          -DatabaseName $TargetDatabaseName
    
    if ($targetDbResult.Database) {
        Write-Log "Target database exists - deleting..." "WARNING"
        $deleteResult = Remove-TargetDatabase -ResourceGroupName $ResourceGroupName `
                                              -ServerName $ServerName `
                                              -DatabaseName $TargetDatabaseName
        
        if (-not $deleteResult.Success) {
            throw "Failed to delete target database: $($deleteResult.Error)"
        }
        
        Write-Log "✓ Target database deleted" "SUCCESS"
        Start-Sleep -Seconds $DeletionWaitSeconds
    }
    else {
        Write-Log "✓ Target database does not exist" "SUCCESS"
    }
    
    # ========== PHASE 7: INITIATE RESTORE ==========
    
    $restorePointInTime = (Get-Date).AddMinutes(-$RestorePointOffsetMinutes).ToUniversalTime()
    
    $restoreResult = Invoke-Restore -ResourceGroupName $ResourceGroupName `
                                     -ServerName $ServerName `
                                     -TargetDatabaseName $TargetDatabaseName `
                                     -SourceResourceId $sourceDb.ResourceId `
                                     -RestorePointInTime $restorePointInTime `
                                     -Edition $TargetServiceTier `
                                     -ServiceObjectiveName $TargetComputeSize
    
    if (-not $restoreResult.Success) {
        throw "Restore failed: $($restoreResult.Error)"
    }
    Write-Log "✓ Restore initiated" "SUCCESS"
    
    # ========== PHASE 8: MONITOR RESTORE ==========
    
    $monitorResult = Monitor-RestoreStatus -ResourceGroupName $ResourceGroupName `
                                            -ServerName $ServerName `
                                            -TargetDatabaseName $TargetDatabaseName `
                                            -MaxWaitSeconds $MonitorMaxWaitSeconds `
                                            -CheckIntervalSeconds $MonitorCheckIntervalSeconds
    
    if (-not $monitorResult.Success) {
        throw "Restore monitoring failed: $($monitorResult.Error)"
    }
    Write-Log "✓ Database is online after $($monitorResult.PollCount) polls" "SUCCESS"
    $finalDb = $monitorResult.Database
    
    # ========== PHASE 9: CREATE SQL LOGIN ==========
    
    $masterSql = @"
IF NOT EXISTS (SELECT name FROM sys.sql_logins WHERE name = '$DevUserName')
BEGIN
    CREATE LOGIN [$DevUserName] WITH PASSWORD = '$DevAppPassword';
    PRINT 'Login [$DevUserName] created on master.';
END
ELSE
BEGIN
    PRINT 'Login [$DevUserName] already exists on master.';
END
"@
    
    Invoke-SqlCommand -ServerName $ServerName -DatabaseName "master" -Query $masterSql -Credential $adminCredential
    Write-Log "✓ SQL login created" "SUCCESS"
    
    # ========== PHASE 10: CREATE DATABASE USER ==========
    
    $dbSql = @"
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = '$DevUserName')
BEGIN
    CREATE USER [$DevUserName] FOR LOGIN [$DevUserName];
    PRINT 'User [$DevUserName] created in database $TargetDatabaseName.';
END

IF IS_ROLEMEMBER('db_datareader', '$DevUserName') = 0
    ALTER ROLE db_datareader ADD MEMBER [$DevUserName];
    
IF IS_ROLEMEMBER('db_datawriter', '$DevUserName') = 0
    ALTER ROLE db_datawriter ADD MEMBER [$DevUserName];

GRANT EXECUTE TO [$DevUserName];
GRANT VIEW DEFINITION TO [$DevUserName];

PRINT 'Permissions for [$DevUserName] verified/updated.';
"@
    
    Invoke-SqlCommand -ServerName $ServerName -DatabaseName $TargetDatabaseName -Query $dbSql -Credential $adminCredential
    Write-Log "✓ Database user created with permissions" "SUCCESS"
    
    # ========== SUCCESS ==========
    Write-Log "========================================" "SUCCESS"
    Write-Log "✓ RESTORE AND USER PROVISIONING COMPLETE" "SUCCESS"
    Write-Log "========================================" "SUCCESS"
    
    return [PSCustomObject]@{
        Status = "Success"
        SourceDatabase = $SourceDatabaseName
        TargetDatabase = $TargetDatabaseName
        DatabaseStatus = $finalDb.Status
        ProvisionedUser = $DevUserName
        RestoredPolls = $monitorResult.PollCount
    }

}
catch {
    Write-Log "========================================" "ERROR"
    Write-Log "✗ OPERATION FAILED" "ERROR"
    Write-Log "========================================" "ERROR"
    Write-Log "Error: $($_.Exception.Message)" "ERROR"
    Write-Log "Line: $($_.InvocationInfo.ScriptLineNumber)" "ERROR"
    Write-Log "========================================" "ERROR"
    throw
}
