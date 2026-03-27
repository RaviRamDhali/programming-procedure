<#
.SYNOPSIS
    Point-in-time restore using Azure Automation Assets for configuration.
.DESCRIPTION
    Replaces hardcoded values with Get-AzAutomationVariable for better security and flexibility.
#>

# 1. Fetch Configuration from Azure Automation Variables
try {
    $ResourceGroupName   = Get-AzAutomationVariable -Name "Sql_ResourceGroup"
    $ServerName          = Get-AzAutomationVariable -Name "Sql_ServerName"
    $SourceDatabaseName  = Get-AzAutomationVariable -Name "Sql_SourceDB"
    $TargetDatabaseName  = Get-AzAutomationVariable -Name "Sql_TargetDB"
    $TargetServiceTier   = Get-AzAutomationVariable -Name "Sql_TargetTier"      # e.g., "Standard"
    $TargetComputeSize    = Get-AzAutomationVariable -Name "Sql_TargetSize"      # e.g., "S2"
    $TargetMaxSizeBytes  = Get-AzAutomationVariable -Name "Sql_TargetMaxSize"   # e.g., 53687091200
    
    # Use Get-AutomationPSCredential for the Dev App password if stored as a Credential Asset
    # Or Get-AzAutomationVariable if stored as an encrypted string
    $DevAppPassword      = Get-AzAutomationVariable -Name "Sql_DevAppPassword"
} 
catch {
    throw "Failed to retrieve one or more Automation Variables. Ensure they exist in the 'Shared Resources > Variables' section."
}

function Write-Log {
    param($Message, $Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "[$timestamp] [$Level] $Message"
}

try {
    Write-Log "Starting Database Restore Process for $TargetDatabaseName"
    
    # Connect using Managed Identity
    Connect-AzAccount -Identity
    
    # Step 1: Verify Source
    $sourceDb = Get-AzSqlDatabase -ResourceGroupName $ResourceGroupName `
                                   -ServerName $ServerName `
                                   -DatabaseName $SourceDatabaseName -ErrorAction SilentlyContinue
    
    if (-not $sourceDb) { throw "Source database '$SourceDatabaseName' not found!" }
    
    # Step 2: Clean up Target
    $targetDb = Get-AzSqlDatabase -ResourceGroupName $ResourceGroupName `
                                   -ServerName $ServerName `
                                   -DatabaseName $TargetDatabaseName -ErrorAction SilentlyContinue
    
    if ($targetDb) {
        Write-Log "Deleting existing target database '$TargetDatabaseName'..." "WARNING"
        Remove-AzSqlDatabase -ResourceGroupName $ResourceGroupName `
                             -ServerName $ServerName `
                             -DatabaseName $TargetDatabaseName -Force
        Start-Sleep -Seconds 20 
    }
    
    # Step 3: Perform Restore
    # Subtracting 10 minutes from current time to ensure Azure has a valid restore point
    $restorePointInTime = (Get-Date).AddMinutes(-10).ToUniversalTime()
    
    $restoreParams = @{
        ResourceGroupName     = $ResourceGroupName
        ServerName            = $ServerName
        TargetDatabaseName    = $TargetDatabaseName
        FromPointInTimeBackup = $true
        PointInTime           = $restorePointInTime
        ResourceId            = $sourceDb.ResourceId
        Edition               = $TargetServiceTier
        ServiceObjectiveName  = $TargetComputeSize
        MaxSizeBytes          = $TargetMaxSizeBytes
    }
    
    Write-Log "Initiating restore to $TargetComputeSize tier..."
    $restoredDb = Restore-AzSqlDatabase @restoreParams
    
    Write-Log "✓ Database restored successfully!" "SUCCESS"

    # Summary Output
    return [PSCustomObject]@{
        Status           = "Success"
        Target           = $TargetDatabaseName
        Tier             = $restoredDb.CurrentServiceObjectiveName
        Timestamp        = Get-Date
    }
    
} catch {
    Write-Error "Restore failed: $($_.Exception.Message)"
    throw
}
