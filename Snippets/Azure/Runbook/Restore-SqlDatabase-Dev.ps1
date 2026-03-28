<#
.SYNOPSIS
    Azure SQL Database Point-in-Time Restore Runbook
.DESCRIPTION
    Performs point-in-time restore of SQL database using Managed Identity authentication.
    
    Process:
    1. Authenticate with Managed Identity
    2. Validate configuration variables
    3. Verify source database exists
    4. Delete target database if it exists
    5. Initiate point-in-time restore
    6. Monitor restore status until online
    7. Verify restore completion
    
.PARAMETER None
    All configuration comes from Automation Account Variables:
    - Sql_ResourceGroup: Azure resource group name
    - Sql_ServerName: SQL server name (without .database.windows.net)
    - Sql_SourceDB: Source database name to restore from
    - Sql_TargetDB: Target database name for restore
    - Sql_TargetTier: Service tier (Standard, Premium, etc.)
    - Sql_TargetSize: Compute size (S0, S1, S2, P1, etc.)

.NOTES
    Author: DevOps Automation
    Version: 1.6
    
    CHANGES IN 1.6:
    - Removed elapsed time tracking (was unreliable due to async restore)
    - Simplified to focus on status polling only
    - Removed wall-clock timing calculations
    - Kept poll count for diagnostics
    - Removed elapsed time from return object
    - Return object now contains: Status, SourceDatabase, TargetDatabase, DatabaseStatus, PollCount
    
    CHANGES IN 1.5:
    - Fixed elapsed time tracking to measure from restore initiation
    - Asynchronous operation handling
    - All PowerShell string syntax verified
    
    Requirements:
      1. Automation Account with system-assigned Managed Identity ENABLED
      2. Managed Identity must have "SQL Server Contributor" role on SQL server
      3. All 6 configuration variables must exist
      4. SQL Server firewall must allow Azure Services
#>

# ============================================================
# CONFIGURATION
# ============================================================

$RestorePointOffsetMinutes = 10   # Restore from N minutes in the past
$DeletionWaitSeconds = 30         # Wait for target DB deletion to propagate
$MonitorMaxWaitSeconds = 900      # Max time to wait for restore (15 minutes)
$MonitorCheckIntervalSeconds = 5  # Check status every N seconds

# ============================================================
# INLINE FUNCTIONS
# ============================================================

function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "[$timestamp] [$Level] $Message"
}

function Get-ConfigurationVariables {
    param([string[]]$VariableNames)
    try {
        $config = @{}
        foreach ($name in $VariableNames) {
            $config[$name] = Get-AutomationVariable -Name $name -ErrorAction Stop
        }
        return @{ Success = $true; Config = $config; Error = $null }
    }
    catch {
        return @{ Success = $false; Config = $null; Error = $_.Exception.Message }
    }
}

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

# ============================================================
# MAIN SCRIPT
# ============================================================

try {
    Write-Log "========================================" "INFO"
    Write-Log "Starting database restore process" "INFO"
    Write-Log "========================================" "INFO"
    
    # Step 1: Authenticate
    Write-Log "Authenticating with Managed Identity..." "INFO"
    try {
        Connect-AzAccount -Identity -ErrorAction Stop | Out-Null
        Write-Log "✓ Authentication successful" "SUCCESS"
    }
    catch {
        Write-Log "✗ Auth FAILED: $($_.Exception.Message)" "ERROR"
        throw "Managed Identity authentication failed"
    }
    
    # Step 2: Load configuration
    Write-Log "Loading configuration variables..." "INFO"
    $configResult = Get-ConfigurationVariables -VariableNames @(
        'Sql_ResourceGroup', 'Sql_ServerName', 'Sql_SourceDB', 
        'Sql_TargetDB', 'Sql_TargetTier', 'Sql_TargetSize'
    )
    
    if (-not $configResult.Success) {
        throw "Failed to load configuration: $($configResult.Error)"
    }
    
    Write-Log "✓ Configuration loaded" "SUCCESS"
    
    $cfg = $configResult.Config
    $ResourceGroupName = $cfg['Sql_ResourceGroup']
    $ServerName = $cfg['Sql_ServerName']
    $SourceDatabaseName = $cfg['Sql_SourceDB']
    $TargetDatabaseName = $cfg['Sql_TargetDB']
    $TargetServiceTier = $cfg['Sql_TargetTier']
    $TargetComputeSize = $cfg['Sql_TargetSize']
    
    Write-Log "Source: $SourceDatabaseName | Target: $TargetDatabaseName | Tier: $TargetServiceTier $TargetComputeSize" "INFO"
    
    # Step 3: Verify source database
    Write-Log "Verifying source database exists..." "INFO"
    $sourceDbResult = Get-SourceDatabase -ResourceGroupName $ResourceGroupName `
                                          -ServerName $ServerName `
                                          -DatabaseName $SourceDatabaseName
    
    if (-not $sourceDbResult.Success) {
        throw "Source database not found: $($sourceDbResult.Error)"
    }
    
    Write-Log "✓ Source database found" "SUCCESS"
    $sourceDb = $sourceDbResult.Database
    
    # Step 4: Check and delete target database
    Write-Log "Checking for existing target database..." "INFO"
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
        Write-Log "Waiting $DeletionWaitSeconds seconds for deletion to propagate..." "INFO"
        Start-Sleep -Seconds $DeletionWaitSeconds
    }
    else {
        Write-Log "✓ Target database does not exist" "SUCCESS"
    }
    
    # Step 5: Initiate restore
    Write-Log "Initiating point-in-time restore..." "INFO"
    $restorePointInTime = (Get-Date).AddMinutes(-$RestorePointOffsetMinutes).ToUniversalTime()
    Write-Log "Restore point: $($restorePointInTime.ToString('u'))" "INFO"
    
    $restoreResult = Invoke-Restore -ResourceGroupName $ResourceGroupName `
                                     -ServerName $ServerName `
                                     -TargetDatabaseName $TargetDatabaseName `
                                     -SourceResourceId $sourceDb.ResourceId `
                                     -RestorePointInTime $restorePointInTime `
                                     -Edition $TargetServiceTier `
                                     -ServiceObjectiveName $TargetComputeSize
    
    if (-not $restoreResult.Success) {
        throw "Restore command failed: $($restoreResult.Error)"
    }
    
    Write-Log "✓ Restore command initiated" "SUCCESS"
    
    # ========================================================
    # Step 6: Monitor restore status
    # ========================================================
    Write-Log "Monitoring restore status..." "INFO"
    
    $pollCount = 0
    $status = "Unknown"
    $finalDb = $null
    $maxPolls = [math]::Ceiling($MonitorMaxWaitSeconds / $MonitorCheckIntervalSeconds)
    
    do {
        $pollCount++
        
        # Only sleep if not the first check
        if ($pollCount -gt 1) {
            Start-Sleep -Seconds $MonitorCheckIntervalSeconds
        }
        
        # Query database status
        $dbResult = Get-TargetDatabase -ResourceGroupName $ResourceGroupName `
                                        -ServerName $ServerName `
                                        -DatabaseName $TargetDatabaseName
        
        if ($dbResult.Success) {
            $status = $dbResult.Database.Status
            $finalDb = $dbResult.Database
            
            Write-Log "Poll #$pollCount`: Status = $status" "INFO"
            
            if ($status -eq "Online") {
                Write-Log "✓ Database is now ONLINE" "SUCCESS"
                break
            }
        }
        else {
            Write-Log "Poll #$pollCount`: Status check failed: $($dbResult.Error)" "WARNING"
        }
        
        # Check if exceeded max polling attempts
        if ($pollCount -ge $maxPolls) {
            throw "Restore monitoring exceeded maximum wait time ($MonitorMaxWaitSeconds seconds). Status: $status. Polls: $pollCount"
        }
        
    } while ($status -ne "Online")
    
    # Step 7: Verify restore
    Write-Log "Verifying restore completion..." "INFO"
    
    if ($null -eq $finalDb) {
        throw "No database object returned from monitoring"
    }
    
    if ($finalDb.Status -ne "Online") {
        throw "Database restore incomplete. Status: $($finalDb.Status)"
    }
    
    Write-Log "✓ Restore verification successful" "SUCCESS"
    
    # Success summary
    Write-Log "========================================" "SUCCESS"
    Write-Log "✓ DATABASE RESTORE SUCCESSFUL" "SUCCESS"
    Write-Log "========================================" "SUCCESS"
    Write-Log "Restore completed successfully after $pollCount polling attempts" "SUCCESS"
    
    return [PSCustomObject]@{
        Status = "Success"
        SourceDatabase = $SourceDatabaseName
        TargetDatabase = $TargetDatabaseName
        DatabaseStatus = $finalDb.Status
        PollCount = $pollCount
    }
    
}
catch {
    Write-Log "========================================" "ERROR"
    Write-Log "✗ RESTORE FAILED" "ERROR"
    Write-Log "========================================" "ERROR"
    Write-Log "Error: $($_.Exception.Message)" "ERROR"
    Write-Log "Line: $($_.InvocationInfo.ScriptLineNumber)" "ERROR"
    Write-Log "Details: $($_.ScriptStackTrace)" "ERROR"
    Write-Log "========================================" "ERROR"
    throw
}
