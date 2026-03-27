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
    Version: 1.0
    
    Requirements:
      1. Automation Account with system-assigned Managed Identity ENABLED
         - Portal: Automation Account > Identity > Status = "On"
         - This is the identity used to authenticate to Azure
      
      2. Managed Identity must have "SQL Server Contributor" role on SQL server
         - Critical: Without this role, the runbook CANNOT query or restore databases
         
         BASH COMMAND to grant role:
         ──────────────────────────────────────────────────────────────────────
         # Step 1: Set your parameters (customize for your environment)
         AUTOMATION_ACCOUNT_NAME="sql-automations"
         RESOURCE_GROUP="Development"
         SUBSCRIPTION_ID="ad281c21-b09d-4451-85b8-75ff29ac7a66"
         SQL_SERVER_NAME="goldendesigns"
         
         # Step 2: Get the Managed Identity Object ID
         OBJECT_ID=$(az automation account show \
           --name $AUTOMATION_ACCOUNT_NAME \
           --resource-group $RESOURCE_GROUP \
           --query identity.principalId -o tsv)
         
         echo "Object ID: $OBJECT_ID"
         
         # Step 3: Grant the SQL Server Contributor role
         az role assignment create \
           --assignee $OBJECT_ID \
           --role "SQL Server Contributor" \
           --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Sql/servers/$SQL_SERVER_NAME
         
         # Step 4: Wait 2-3 minutes for role to propagate, then run this script
         ──────────────────────────────────────────────────────────────────────
      
      3. All 6 configuration variables must exist in Automation Account
         - Sql_ResourceGroup
         - Sql_ServerName
         - Sql_SourceDB
         - Sql_TargetDB
         - Sql_TargetTier
         - Sql_TargetSize
      
      4. SQL Server firewall must allow Azure Services
         - Portal: SQL Server > Networking > "Allow Azure services and resources to access this server" = ON
         - OR add explicit firewall rule for your network
    
    Common Failures:
      - "Authentication failed": Managed Identity not enabled on Automation Account
      - "'this.Client.SubscriptionId' cannot be null": Missing SQL Server Contributor role
      - "Source database not found": Managed Identity lacks read permissions (missing role)
      - "Cannot open database": SQL firewall blocking access
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

function Invoke-Authentication {
    try {
        Connect-AzAccount -Identity -ErrorAction Stop | Out-Null
        Write-Log "✓ Authentication successful" "SUCCESS"
        return @{ Success = $true; Error = $null }
    }
    catch {
        Write-Log "========================================" "ERROR"
        Write-Log "✗ MANAGED IDENTITY AUTHENTICATION FAILED" "ERROR"
        Write-Log "========================================" "ERROR"
        Write-Log "Error: $($_.Exception.Message)" "ERROR"
        Write-Log "" "ERROR"
        Write-Log "TROUBLESHOOTING STEPS:" "ERROR"
        Write-Log "1. Verify Managed Identity is ENABLED on Automation Account" "ERROR"
        Write-Log "   - Go to: Automation Account > Identity" "ERROR"
        Write-Log "   - Confirm: Status = 'On'" "ERROR"
        Write-Log "" "ERROR"
        Write-Log "2. Grant SQL Server Contributor role to Managed Identity" "ERROR"
        Write-Log "   - Run the bash command from the .NOTES section above" "ERROR"
        Write-Log "   - Update these parameters in the script:" "ERROR"
        Write-Log "     * AUTOMATION_ACCOUNT_NAME = your automation account name" "ERROR"
        Write-Log "     * RESOURCE_GROUP = your resource group name" "ERROR"
        Write-Log "     * SUBSCRIPTION_ID = your subscription ID" "ERROR"
        Write-Log "     * SQL_SERVER_NAME = your SQL server name" "ERROR"
        Write-Log "   - Missing role causes: 'SubscriptionId cannot be null' error" "ERROR"
        Write-Log "" "ERROR"
        Write-Log "3. Wait 2-3 minutes after granting role for propagation" "ERROR"
        Write-Log "" "ERROR"
        Write-Log "4. Verify Automation Account is in correct Subscription" "ERROR"
        Write-Log "   - Managed Identity can only access resources in same subscription" "ERROR"
        Write-Log "" "ERROR"
        Write-Log "5. Check Runbook PowerShell version" "ERROR"
        Write-Log "   - Requires PowerShell 7.2 or later" "ERROR"
        Write-Log "========================================" "ERROR"
        return @{ Success = $false; Error = "Cannot proceed - authentication failed" }
    }
}

function Invoke-DeleteTargetDatabase {
    param([string]$ResourceGroupName, [string]$ServerName, [string]$TargetDatabaseName, [int]$DeletionWaitSeconds)
    
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
}

function Invoke-MonitorRestore {
    param(
        [string]$ResourceGroupName,
        [string]$ServerName,
        [string]$TargetDatabaseName,
        [int]$MonitorMaxWaitSeconds,
        [int]$MonitorCheckIntervalSeconds
    )
    
    $elapsed = 0
    $pollCount = 0
    $status = "Unknown"
    $firstCheck = $true
    
    do {
        $pollCount++
        
        if (-not $firstCheck) {
            Start-Sleep -Seconds $MonitorCheckIntervalSeconds
            $elapsed += $MonitorCheckIntervalSeconds
        }
        else {
            $firstCheck = $false
        }
        
        $dbResult = Get-TargetDatabase -ResourceGroupName $ResourceGroupName `
                                        -ServerName $ServerName `
                                        -DatabaseName $TargetDatabaseName
        
        if ($dbResult.Success) {
            $status = $dbResult.Database.Status
            
            if ($status -eq "Online") {
                Write-Log "✓ Database is online" "SUCCESS"
                return @{ Success = $true; Database = $dbResult.Database; Elapsed = $elapsed; PollCount = $pollCount }
            }
        }
        else {
            Write-Log "Status check failed: $($dbResult.Error)" "WARNING"
        }
        
        if ($elapsed -gt $MonitorMaxWaitSeconds) {
            throw "Restore monitoring exceeded maximum wait time ($MonitorMaxWaitSeconds seconds). Final status: $status"
        }
        
    } while ($status -ne "Online")
}

# ============================================================
# MAIN SCRIPT
# ============================================================

try {
    Write-Log "========================================" "INFO"
    Write-Log "Starting database restore process" "INFO"
    Write-Log "========================================" "INFO"
    
    # Step 1: Authenticate
    $authResult = Invoke-Authentication
    if (-not $authResult.Success) {
        throw $authResult.Error
    }
    
    # Step 2: Load configuration
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
    $sourceDbResult = Get-SourceDatabase -ResourceGroupName $ResourceGroupName `
                                          -ServerName $ServerName `
                                          -DatabaseName $SourceDatabaseName
    
    if (-not $sourceDbResult.Success) {
        throw "Source database not found: $($sourceDbResult.Error)"
    }
    
    Write-Log "✓ Source database found" "SUCCESS"
    $sourceDb = $sourceDbResult.Database
    
    # Step 4: Check and delete target database
    Invoke-DeleteTargetDatabase -ResourceGroupName $ResourceGroupName `
                                 -ServerName $ServerName `
                                 -TargetDatabaseName $TargetDatabaseName `
                                 -DeletionWaitSeconds $DeletionWaitSeconds
    
    # Step 5: Initiate restore
    $restorePointInTime = (Get-Date).AddMinutes(-$RestorePointOffsetMinutes).ToUniversalTime()
    
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
    
    # Step 6: Monitor restore status
    $monitorResult = Invoke-MonitorRestore -ResourceGroupName $ResourceGroupName `
                                            -ServerName $ServerName `
                                            -TargetDatabaseName $TargetDatabaseName `
                                            -MonitorMaxWaitSeconds $MonitorMaxWaitSeconds `
                                            -MonitorCheckIntervalSeconds $MonitorCheckIntervalSeconds
    
    $finalDb = $monitorResult.Database
    
    # Step 7: Verify restore
    if ($finalDb.Status -ne "Online") {
        throw "Database restore incomplete. Status: $($finalDb.Status)"
    }
    
    Write-Log "✓ Restore verification successful" "SUCCESS"
    
    # Success summary
    Write-Log "========================================" "SUCCESS"
    Write-Log "✓ DATABASE RESTORE SUCCESSFUL" "SUCCESS"
    Write-Log "========================================" "SUCCESS"
    
    $minutes = [math]::Floor($monitorResult.Elapsed / 60)
    $seconds = $monitorResult.Elapsed % 60
    $elapsedTime = "{0}m {1}s" -f $minutes, $seconds
    
    return [PSCustomObject]@{
        Status = "Success"
        SourceDatabase = $SourceDatabaseName
        TargetDatabase = $TargetDatabaseName
        DatabaseStatus = $finalDb.Status
        ElapsedTime = $elapsedTime
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
