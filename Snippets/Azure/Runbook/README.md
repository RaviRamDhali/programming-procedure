# Azure SQL Database Restore & User Provisioning Runbook

## Overview

Automated runbook for **point-in-time restore** of Azure SQL databases with automatic user provisioning. Complete workflow in a single execution with no manual steps required.

**Status:** Production-ready (v2.0.0)  
**Last Tested:** 2026-03-28  
**Verified:** ✓ Database restore working ✓ User login verified in SSMS

---

## What This Runbook Does

1. **Authenticate** with Managed Identity
2. **Verify** source database exists
3. **Delete** target database (if exists)
4. **Initiate** point-in-time restore
5. **Monitor** restore until online
6. **Create** SQL login on master database
7. **Create** user on target database
8. **Grant** permissions (db_datareader, db_datawriter, EXECUTE, VIEW DEFINITION)

**Total time:** ~12 minutes (depends on database size)

---

## Standalone User Provisioning (Optional)

**Also included:** `New-SqlDatabaseUser.ps1` (v1.0.0)

If you only need to create a SQL user **without** restoring a database, use this standalone script instead of the full runbook.

**Use case:** Creating users on existing databases (no restore needed)

**What it does:**
- Create SQL login on master
- Create user on target database
- Grant permissions (db_datareader, db_datawriter, EXECUTE, VIEW DEFINITION)

**Time:** ~2 seconds

**Variables needed:** Same 4 configuration variables + 1 credential (see Setup section)

✓ Optional - only use if you don't need the full restore workflow

---

## Prerequisites

### Azure Resources
- Azure Automation Account with system-assigned Managed Identity enabled
- Managed Identity with "SQL Server Contributor" role on SQL server
- Source database must exist and be accessible
- SQL Server firewall allows Azure Services

### Local Requirements
- None - runbook is cloud-based and self-contained

---

## Setup Instructions

### Step 1: Create Automation Account (if needed)

```
Azure Portal → Search: "Automation Accounts" (exact name)
→ Create new Automation Account
→ Enable System-assigned Managed Identity
```

### Step 2: Create Variables

Go to: **Automation Account → Shared Resources → Variables**

Click **+ Add a variable** for each:

#### Restore Variables (6 required)

| Variable Name | Type | Example | Encrypted |
|---|---|---|---|
| `Sql_ResourceGroup` | String | `my-resource-group` | No |
| `Sql_ServerName` | String | `my-sql-server` | No |
| `Sql_SourceDB` | String | `SourceDatabase` | No |
| `Sql_TargetDB` | String | `TargetDatabase` | No |
| `Sql_TargetTier` | String | `Standard` | No |
| `Sql_TargetSize` | String | `S1` | No |

#### User Provisioning Variables (2 required)

| Variable Name | Type | Example | Encrypted |
|---|---|---|---|
| `Sql_UserDevAppName` | String | `app_user` | No |
| `Sql_UserDevAppPassword` | String | `P@ssw0rd123!` | **Yes** |

---

### Step 3: Create Credential Asset

Go to: **Automation Account → Shared Resources → Credentials**

Click **+ Add a credential**

| Field | Value |
|---|---|
| **Name** | `Sql_AdminAccount` |
| **Username** | SQL Server admin username |
| **Password** | SQL Server admin password |

⚠️ **Important:** This credential is used for SQL operations only (creating logins/users).  
Use a dedicated SQL admin account with minimal required permissions.

---

## Running the Runbook

### Via Azure Portal

1. Go to **Automation Account → Runbooks**
2. Select **Restore-AzSqlDatabase** (or **New-SqlDatabaseUser** for standalone)
3. Click **Start** (or **Test pane** for testing)
4. Monitor output in real-time

### Via PowerShell

```powershell
$params = @{
    AutomationAccountName = "my-automation-account"
    ResourceGroupName = "my-resource-group"
    RunbookName = "Restore-AzSqlDatabase"
}
Start-AzAutomationRunbook @params
```

---

## Output & Monitoring

### Successful Run

```
[2026-03-28 15:06:06] [SUCCESS] ========================================
[2026-03-28 15:06:06] [SUCCESS] Database restore and user provisioning
[2026-03-28 15:06:10] [SUCCESS] ✓ Authenticated with Managed Identity
[2026-03-28 15:06:12] [SUCCESS] ✓ Configuration loaded
[2026-03-28 15:06:13] [SUCCESS] ✓ Source database verified
[2026-03-28 15:06:31] [SUCCESS] ✓ Target database deleted
[2026-03-28 15:17:59] [SUCCESS] ✓ Restore initiated
[2026-03-28 15:18:00] [SUCCESS] ✓ Database online
[2026-03-28 15:18:00] [SUCCESS] ✓ SQL login created
[2026-03-28 15:18:01] [SUCCESS] ✓ Database user created with permissions
[2026-03-28 15:18:01] [SUCCESS] ✓ COMPLETE
[2026-03-28 15:18:01] [SUCCESS] ========================================

Status          : Success
SourceDatabase  : SourceDatabase
TargetDatabase  : TargetDatabase
DatabaseStatus  : Online
ProvisionedUser : app_user
RestoredPolls   : 1
```

### Return Object

The runbook returns a PowerShell object with:

- `Status` - "Success" or error message
- `SourceDatabase` - Source DB name
- `TargetDatabase` - Target DB name
- `DatabaseStatus` - "Online" or other status
- `ProvisionedUser` - Created user login name
- `RestoredPolls` - Number of status checks performed

---

## Troubleshooting

### Error: Variable 'Sql_ServerName' is empty
**Cause:** Variable not created or value is blank  
**Solution:** Go to Variables and ensure all 8 variables are created with non-empty values

### Error: Credential 'Sql_AdminAccount' not found
**Cause:** Credential asset not created  
**Solution:** Create credential asset with exact name `Sql_AdminAccount` in Shared Resources → Credentials

### Error: A network-related or instance-specific error occurred
**Cause:** Connection string invalid or SQL Server not accessible  
**Solution:** Verify `Sql_ServerName` is correct (e.g., `my-sql-server` not `my-sql-server.database.windows.net`)

### Error: Login failed for user
**Cause:** `Sql_AdminAccount` credentials incorrect  
**Solution:** Verify SQL admin username/password in credential asset are correct

### Restore takes longer than expected
**Reason:** Large databases take longer to restore (5-15 minutes typical)  
**Solution:** Monitor in portal, runbook will wait up to 15 minutes before timing out

---

## Configuration Reference

### Restore Point Timing
```powershell
$RestorePointOffsetMinutes = 10  # Restore from 10 minutes ago
```
Adjust if you need to restore from a different point in time. Azure SQL supports up to 35 days of restore points.

### Monitoring Intervals
```powershell
$MonitorMaxWaitSeconds = 900              # 15 minutes max wait
$MonitorCheckIntervalSeconds = 5          # Check every 5 seconds
```

### Target Database Deletion
```powershell
$DeletionWaitSeconds = 30  # Wait 30 seconds for deletion to propagate
```

---

## Security Considerations

✓ **Managed Identity** - No hard-coded credentials for Azure authentication  
✓ **Encrypted Variables** - Password stored encrypted (Sql_UserDevAppPassword)  
✓ **Credential Asset** - Admin password stored securely (Sql_AdminAccount)  
✓ **Error Handling** - Sensitive data not logged or returned  
✓ **Connection String** - TCP+TLS encryption to SQL Server  

**Best Practices:**
- Use dedicated SQL admin account for runbook (not production admin)
- Rotate `Sql_AdminAccount` credentials regularly
- Limit who can view Automation Account variables
- Audit runbook execution history

---

## Architecture

### Modular Functions

- `Get-ConfigurationVariables()` - Load and validate variables
- `Get-CredentialAsset()` - Load credential with error checking
- `Get-SourceDatabase()` - Query source DB via Azure SDK
- `Get-TargetDatabase()` - Query target DB via Azure SDK
- `Remove-TargetDatabase()` - Delete target DB
- `Invoke-Restore()` - Call Azure restore API
- `Monitor-RestoreStatus()` - Poll database status until online
- `Invoke-SqlCommand()` - Execute SQL via native .NET SqlClient

### Tech Stack

- **Authentication:** Managed Identity
- **Azure:** Az.Sql PowerShell module
- **SQL Operations:** System.Data.SqlClient (.NET built-in)
- **Connection:** TCP + TLS 1.2 encryption

---

## Testing

### Test Phase 1: Dry Run
1. Run once on staging/dev environment
2. Verify output matches expected
3. Confirm user created with SSMS

### Test Phase 2: Production
1. Schedule during maintenance window
2. Monitor first 2-3 runs
3. Adjust restore point offset if needed

### Verify User Created

```sql
-- Connect to target database as admin
USE TargetDatabase;

-- Check login exists on master
SELECT name, type FROM sys.sql_logins WHERE name = 'app_user';

-- Check user exists in target DB
SELECT name, type FROM sys.database_principals WHERE name = 'app_user';

-- Check role membership
SELECT * FROM sys.database_role_members
WHERE member_principal_id = (SELECT principal_id FROM sys.database_principals WHERE name = 'app_user');
```

---

## Support & Logs

### View Runbook History
**Automation Account → Runbooks → Restore-AzSqlDatabase → All Logs**

Shows:
- Job ID
- Start/End time
- Status
- Full output

### Export Logs
```powershell
Get-AzAutomationJobOutput -ResourceGroupName "my-resource-group" `
  -AutomationAccountName "my-automation-account" `
  -Id "<job-id>" | Export-Csv -Path "./runbook-logs.csv"
```

---

## Version History

| Version | Date | Changes |
|---|---|---|
| 2.0.0 | 2026-03-28 | Production release: restore + user provisioning combined. Verified with SSMS login test. |
| 1.0.0 | 2026-03-28 | Standalone user provisioning script (optional). Use when only creating users without restore. |

---

## Related Documentation

- [Azure Automation Account Setup](https://learn.microsoft.com/en-us/azure/automation/automation-quickstart-create-account)
- [Managed Identity in Automation](https://learn.microsoft.com/en-us/azure/automation/automation-hrw-run-runbooks)
- [SQL Server Contributor Role](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#sql-server-contributor)
- [Azure SQL Point-in-Time Restore](https://learn.microsoft.com/en-us/azure/azure-sql/database/recovery-using-backups)

---

**Questions?** Check logs in Automation Account. All errors are logged with line numbers and messages.
