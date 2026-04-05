<#
.SYNOPSIS
    Azure SQL Database Point-in-Time Restore with User Provisioning
.DESCRIPTION
    Complete runbook: restore database + create users with permissions + update statistics.
    1.  Authenticate with Managed Identity
    2.  Verify source database exists
    3.  Delete target database if exists
    4.  Initiate point-in-time restore
    5.  Monitor restore until online
    6.  Create SQL login on master (dev app user)
    7.  Create user on target database (dev app user)
    8.  Grant permissions (dev app user)
    9.  Create SQL login on master (func runner user)
    10. Create user on target database (func runner user)
    11. Grant permissions (func runner user)
    12. Update statistics on all tables inline

.NOTES
    Version: 2.8.0
    Combined restore + user provisioning + statistics update workflow (dev app + func runner)
    Statistics update runs inline, no child runbook dependency
    Stats loop: known large tables go straight to 1% sample, others use 60s timeout with one retry, then 20% and 1% sample fallbacks
    Modular functions with error checking
    Added diagnostic timestamps around deletion wait and restore call for slowness tracing
#>

# ============================================================
# CONFIGURATION
# ============================================================

$RestorePointOffsetMinutes   = 10
$DeletionWaitSeconds         = 30
$MonitorMaxWaitSeconds       = 900
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
        [System.Management.Automation.PSCredential]$Credential,
        [int]$CommandTimeout = 30
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
        $command.CommandTimeout = $CommandTimeout
        $command.ExecuteNonQuery() | Out-Null
    }
    finally {
        $connection.Close()
    }
}

function Invoke-SqlQuery {
    param(
        [string]$ServerName,
        [string]$DatabaseName,
        [string]$Query,
        [System.Management.Automation.PSCredential]$Credential
    )

    if ([string]::IsNullOrEmpty($ServerName)) { throw "ServerName is empty" }
    if ([string]::IsNullOrEmpty($DatabaseName)) { throw "DatabaseName is empty" }
    if ($null -eq $Credential) { throw "Credential is null" }

    $connectionString = "Server=tcp:$ServerName.database.windows.net,1433;Database=$DatabaseName;User Id=$($Credential.UserName);Password=$($Credential.GetNetworkCredential().Password);Encrypt=true;TrustServerCertificate=true;Connection Timeout=30;"

    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $results = @()
    try {
        $connection.Open()
        $command = New-Object System.Data.SqlClient.SqlCommand($Query, $connection)
        $command.CommandTimeout = 60
        $reader = $command.ExecuteReader()
        while ($reader.Read()) {
            $results += $reader.GetString(0)
        }
        $reader.Close()
    }
    finally {
        $connection.Close()
    }
    return $results
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
    
    $ResourceGroupName      = $restoreVars.Config['Sql_ResourceGroup']
    $ServerName             = $restoreVars.Config['Sql_ServerName']
    $SourceDatabaseName     = $restoreVars.Config['Sql_SourceDB']
    $TargetDatabaseName     = $restoreVars.Config['Sql_TargetDB']
    $TargetServiceTier      = $restoreVars.Config['Sql_TargetTier']
    $TargetComputeSize      = $restoreVars.Config['Sql_TargetSize']
    
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

    $funcRunnerCredResult = Get-CredentialAsset -CredentialName "Sql_dev_az_func_runner"
    if (-not $funcRunnerCredResult.Success) {
        throw "Failed to load func runner credentials: $($funcRunnerCredResult.Error)"
    }
    Write-Log "✓ Func runner credentials loaded" "SUCCESS"
    $funcRunnerCredential = $funcRunnerCredResult.Credential
    $FuncRunnerUserName = $funcRunnerCredential.UserName
    $FuncRunnerPassword = $funcRunnerCredential.GetNetworkCredential().Password
    
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
        Write-Log "Waiting $DeletionWaitSeconds seconds before restore at $(Get-Date -Format 'HH:mm:ss')" "SUCCESS"
        Start-Sleep -Seconds $DeletionWaitSeconds
        Write-Log "Deletion wait complete at $(Get-Date -Format 'HH:mm:ss')" "SUCCESS"
    }
    else {
        Write-Log "✓ Target database does not exist" "SUCCESS"
    }
    
    # ========== PHASE 7: INITIATE RESTORE ==========

    $restorePointInTime = (Get-Date).AddMinutes(-$RestorePointOffsetMinutes).ToUniversalTime()
    Write-Log "Restore point in time: $restorePointInTime" "SUCCESS"
    Write-Log "Calling Restore-AzSqlDatabase at $(Get-Date -Format 'HH:mm:ss')" "SUCCESS"
    
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
    Write-Log "✓ Restore initiated at $(Get-Date -Format 'HH:mm:ss')" "SUCCESS"
    
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
    
    # ========== PHASE 9: CREATE SQL LOGIN (DEV APP) ==========
    
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
    Write-Log "✓ Dev app SQL login created" "SUCCESS"
    
    # ========== PHASE 10: CREATE DATABASE USER (DEV APP) ==========
    
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
    Write-Log "✓ Dev app database user created with permissions" "SUCCESS"

    # ========== PHASE 11: CREATE SQL LOGIN (FUNC RUNNER) ==========

    $funcRunnerMasterSql = @"
IF NOT EXISTS (SELECT name FROM sys.sql_logins WHERE name = '$FuncRunnerUserName')
BEGIN
    CREATE LOGIN [$FuncRunnerUserName] WITH PASSWORD = '$FuncRunnerPassword';
    PRINT 'Login [$FuncRunnerUserName] created on master.';
END
ELSE
BEGIN
    PRINT 'Login [$FuncRunnerUserName] already exists on master.';
END
"@

    Invoke-SqlCommand -ServerName $ServerName -DatabaseName "master" -Query $funcRunnerMasterSql -Credential $adminCredential
    Write-Log "✓ Func runner SQL login created" "SUCCESS"

    # ========== PHASE 12: CREATE DATABASE USER (FUNC RUNNER) ==========

    $funcRunnerDbSql = @"
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = '$FuncRunnerUserName')
BEGIN
    CREATE USER [$FuncRunnerUserName] FOR LOGIN [$FuncRunnerUserName];
    PRINT 'User [$FuncRunnerUserName] created in database $TargetDatabaseName.';
END

IF IS_ROLEMEMBER('db_datareader', '$FuncRunnerUserName') = 0
    ALTER ROLE db_datareader ADD MEMBER [$FuncRunnerUserName];

IF IS_ROLEMEMBER('db_datawriter', '$FuncRunnerUserName') = 0
    ALTER ROLE db_datawriter ADD MEMBER [$FuncRunnerUserName];

GRANT EXECUTE TO [$FuncRunnerUserName];
GRANT VIEW DEFINITION TO [$FuncRunnerUserName];

PRINT 'Permissions for [$FuncRunnerUserName] verified/updated.';
"@

    Invoke-SqlCommand -ServerName $ServerName -DatabaseName $TargetDatabaseName -Query $funcRunnerDbSql -Credential $adminCredential
    Write-Log "✓ Func runner database user created with permissions" "SUCCESS"
    
    # ========== PHASE 13: UPDATE STATISTICS ==========

    Write-Log "Starting statistics update on $TargetDatabaseName..." "SUCCESS"
    $statsStart = Get-Date

    $tableQuery = @"
SELECT QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name)
FROM sys.tables
ORDER BY name
"@

    $tables = Invoke-SqlQuery -ServerName $ServerName `
                              -DatabaseName $TargetDatabaseName `
                              -Query $tableQuery `
                              -Credential $adminCredential

    $tableCount   = $tables.Count
    $successCount = 0
    $failCount    = 0
    $failedTables = @()

    # Known large tables - skip full scan and go straight to 1% sample
    $largeTables = @('[dbo].[CaseDiary]', '[dbo].[Log]')

    Write-Log "Found $tableCount tables to update" "SUCCESS"

    foreach ($table in $tables) {

        # Route known large tables straight to 1% sample
        if ($largeTables -contains $table) {
            try {
                Invoke-SqlCommand -ServerName $ServerName `
                                  -DatabaseName $TargetDatabaseName `
                                  -Query "UPDATE STATISTICS $table WITH SAMPLE 1 PERCENT" `
                                  -Credential $adminCredential `
                                  -CommandTimeout 300
                Write-Log "✓ Stats updated (1% sample - large table): $table" "SUCCESS"
                $successCount++
            }
            catch {
                Write-Log "✗ 1% sample failed on $table`: $($_.Exception.Message)" "ERROR"
                $failedTables += $table
                $failCount++
            }
            continue
        }

        $attempts = 0
        $updated  = $false
        do {
            $attempts++
            try {
                Invoke-SqlCommand -ServerName $ServerName `
                                  -DatabaseName $TargetDatabaseName `
                                  -Query "UPDATE STATISTICS $table" `
                                  -Credential $adminCredential `
                                  -CommandTimeout 60
                Write-Log "✓ Stats updated: $table$(if ($attempts -gt 1) { ' (retry succeeded)' })" "SUCCESS"
                $successCount++
                $updated = $true
            }
            catch {
                if ($attempts -lt 2) {
                    Write-Log "Retrying $table after failure..." "WARNING"
                }
                else {
                    Write-Log "✗ Full scan failed on $table - will retry with sample" "WARNING"
                    $failedTables += $table
                    $failCount++
                }
            }
        } while (-not $updated -and $attempts -lt 2)
    }

    # Second pass - retry failed tables with SAMPLE 20 PERCENT
    if ($failedTables.Count -gt 0) {
        Write-Log "Retrying $($failedTables.Count) failed tables with SAMPLE 20 PERCENT..." "WARNING"

        $sampledFailed  = @()
        $sampledSuccess = 0

        foreach ($table in $failedTables) {
            try {
                Invoke-SqlCommand -ServerName $ServerName `
                                  -DatabaseName $TargetDatabaseName `
                                  -Query "UPDATE STATISTICS $table WITH SAMPLE 20 PERCENT" `
                                  -Credential $adminCredential `
                                  -CommandTimeout 300
                Write-Log "✓ Stats updated (20% sample): $table" "SUCCESS"
                $sampledSuccess++
                $failCount--
            }
            catch {
                Write-Log "✗ 20% sample failed on $table - will retry with 1% sample" "WARNING"
                $sampledFailed += $table
            }
        }

        $failedTables  = $sampledFailed
        $successCount += $sampledSuccess
    }

    # Third pass - retry remaining failed tables with SAMPLE 1 PERCENT
    if ($failedTables.Count -gt 0) {
        Write-Log "Retrying $($failedTables.Count) failed tables with SAMPLE 1 PERCENT..." "WARNING"

        $minSampleFailed  = @()
        $minSampleSuccess = 0

        foreach ($table in $failedTables) {
            try {
                Invoke-SqlCommand -ServerName $ServerName `
                                  -DatabaseName $TargetDatabaseName `
                                  -Query "UPDATE STATISTICS $table WITH SAMPLE 1 PERCENT" `
                                  -Credential $adminCredential `
                                  -CommandTimeout 300
                Write-Log "✓ Stats updated (1% sample): $table" "SUCCESS"
                $minSampleSuccess++
                $failCount--
            }
            catch {
                Write-Log "✗ All sample rates failed on $table`: $($_.Exception.Message)" "ERROR"
                $minSampleFailed += $table
            }
        }

        $failedTables  = $minSampleFailed
        $successCount += $minSampleSuccess
    }

    $statsDuration = [math]::Round(((Get-Date) - $statsStart).TotalSeconds)

    if ($failedTables.Count -gt 0) {
        Write-Log "Statistics update complete with $($failedTables.Count) failures: $($failedTables -join ', ')" "WARNING"
    }
    else {
        Write-Log "✓ Statistics update complete. $successCount tables in $statsDuration seconds" "SUCCESS"
    }

    # ========== SUCCESS ==========

    Write-Log "========================================" "SUCCESS"
    Write-Log "✓ RESTORE, USER PROVISIONING AND STATS COMPLETE" "SUCCESS"
    Write-Log "========================================" "SUCCESS"

    return [PSCustomObject]@{
        Status          = "Success"
        SourceDatabase  = $SourceDatabaseName
        TargetDatabase  = $TargetDatabaseName
        DatabaseStatus  = $finalDb.Status
        ProvisionedUser = $DevUserName
        FuncRunnerUser  = $FuncRunnerUserName
        RestoredPolls   = $monitorResult.PollCount
        StatsTotal      = $tableCount
        StatsUpdated    = $successCount
        StatsFailed     = $failCount
        StatsDuration   = $statsDuration
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
