<#
.SYNOPSIS
    Automated SQL user provisioning using Azure Automation Assets.
.DESCRIPTION
    Recreates a SQL login and user with specific permissions (Reader, Writer, Execute, View Definition)
    using variables and credentials stored in Azure Automation.
.NOTES
    Author: Jacket Software / DevOps Team
    Date: 2026-03-27
#>

try {
    # 1. Retrieve Configuration from Automation Variables
    $ServerName       = Get-AutomationVariable -Name "Sql_ServerName"
    $DatabaseName     = Get-AutomationVariable -Name "Sql_TargetDB"
    $DevUserName      = Get-AutomationVariable -Name "Sql_DevAppUserName"
    $DevAppPassword   = Get-AutomationVariable -Name "Sql_DevAppPassword"
    
    # 2. Retrieve Admin Credentials (Stored as a 'Credential' Asset)
    $AdminCred = Get-AutomationPSCredential -Name "Sql_AdminAccount"
    
    Write-Output "--------------------------------------------------------"
    Write-Output "Target Server:   $ServerName"
    Write-Output "Target DB:       $DatabaseName"
    Write-Output "Target User:     $DevUserName"
    Write-Output "--------------------------------------------------------"

    # 3. Ensure SqlServer Module is available
    if (-not (Get-Module -ListAvailable -Name SqlServer)) {
        Write-Output "SqlServer module not found. Installing..."
        Install-Module -Name SqlServer -Force -AllowClobber -Scope CurrentUser
    }
    Import-Module SqlServer

    # 4. Create Login on Master Database
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

    Write-Output "Verifying SQL Login on master..."
    Invoke-Sqlcmd -ServerInstance $ServerName `
                  -Database "master" `
                  -Credential $AdminCred `
                  -Query $masterSql `
                  -Encrypt Mandatory `
                  -TrustServerCertificate

    # 5. Create User and Grant Permissions on Target Database
    $dbSql = @"
-- Create user if it doesn't exist
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = '$DevUserName')
BEGIN
    CREATE USER [$DevUserName] FOR LOGIN [$DevUserName];
    PRINT 'User [$DevUserName] created in database $DatabaseName.';
END

-- Ensure role-based permissions
IF IS_ROLEMEMBER('db_datareader', '$DevUserName') = 0
    ALTER ROLE db_datareader ADD MEMBER [$DevUserName];

IF IS_ROLEMEMBER('db_datawriter', '$DevUserName') = 0
    ALTER ROLE db_datawriter ADD MEMBER [$DevUserName];

-- Grant specialized permissions
GRANT EXECUTE TO [$DevUserName];
GRANT VIEW DEFINITION TO [$DevUserName];

PRINT 'Permissions for [$DevUserName] verified/updated.';
"@

    Write-Output "Configuring permissions on $DatabaseName..."
    Invoke-Sqlcmd -ServerInstance $ServerName `
                  -Database $DatabaseName `
                  -Credential $AdminCred `
                  -Query $dbSql `
                  -Encrypt Mandatory `
                  -TrustServerCertificate

    Write-Output "SUCCESS: SQL User Provisioning Complete."

} catch {
    Write-Error "Recreate-SQLUser failed: $($_.Exception.Message)"
    throw
}
