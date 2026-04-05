# Azure SQL Database Restore & User Provisioning Runbook

## Overview

Automated runbook for **point-in-time restore** of Azure SQL databases with automatic user provisioning and statistics update. Complete workflow in a single execution with no manual steps required.

**Script:** `Restore-SqlDatabaseWithUsersAndStats.ps1`  
**Status:** Production-ready (v2.8.0)  
**Last Tested:** 2026-03-28  
**Verified:** ✓ Database restore working ✓ User login verified in SSMS

---

## What This Runbook Does

1. **Authenticate** with Managed Identity
2. **Verify** source database exists
3. **Delete** target database (if exists)
4. **Initiate** point-in-time restore
5. **Monitor** restore until online
6. **Create** SQL login on master (dev app user)
7. **Create** user on target database (dev app user)
8. **Grant** permissions to dev app user (db_datareader, db_datawriter, EXECUTE, VIEW DEFINITION)
9. **Create** SQL login on master (func runner user)
10. **Create** user on target database (func runner user)
11. **Grant** permissions to func runner user (db_datareader, db_datawriter, EXECUTE, VIEW DEFINITION)
12. **Update statistics** on all tables in the target database

**Total time:** ~12 minutes plus statistics update (depends on database size)

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

### Step 3: Create Credential Assets

Go to: **Automation Account → Shared Resources → Credentials**

Click **+ Add a credential** for each:

#### Credential 1: SQL Admin Account

| Field | Value |
|---|---|
| **Name** | `Sql_AdminAccount` |
| **Username** | SQL Server admin username |
| **Password** | SQL Server admin password |

#### Credential 2: Func Runner Account

| Field | Value |
|---|---|
| **Name** | `Sql_dev_az_func_runner` |
| **Username** | Func runner SQL username |
| **Password** | Func runner SQL password |

⚠️ **Important:** Both credentials are used for SQL operations only (creating logins/users).  
Use dedicated accounts with minimal required permissions.

---

## Running the Runbook

### Via Azure Portal

1. Go to **Automation Account → Runbooks**
2. Select **Restore-SqlDatabaseWithUsersAndStats**
3. Click **Start** (or **Test pane** for testing)
4. Monitor output in real-time

### Via PowerShell

```powershell
$params = @{
    AutomationAccountName = "my-automation-account"
    ResourceGroupName = "my-resource-group"
    RunbookName = "Restore-SqlDatabaseWithUsersAndStats"
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
[2026-03-28 15:06:12] [SUCCESS] ✓ Restore variables loaded
[2026-03-28 15:06:12] [SUCCESS] ✓ User variables loaded
[2026-03-28 15:06:12] [SUCCESS] ✓ Admin credentials loaded
[2026-03-28 15:06:12] [SUCCESS] ✓ Func runner credentials loaded
[2026-03-28 15:06:13] [SUCCESS] ✓ Source database found
[2026-03-28 15:06:31] [SUCCESS] ✓ Target database deleted
[2026-03-28 15:17:59] [SUCCESS] ✓ Restore initiated
[2026-03-28 15:18:00] [SUCCESS] ✓ Database is online after 1 polls
[2026-03-28 15:18:00] [SUCCESS] ✓ Dev app SQL login created
[2026-03-28 15:18:01] [SUCCESS] ✓ Dev app database user created with permissions
[2026-03-28 15:18:01] [SUCCESS] ✓ Func runner SQL login created
[2026-03-28 15:18:02] [SUCCESS] ✓ Func runner database user created with permissions
[2026-03-28 15:18:02] [SUCCESS] Starting statistics update on TargetDatabase...
[2026-03-28 15:18:02] [SUCCESS] Found 42 tables to update
[2026-03-28 15:20:14] [SUCCESS] ✓ Statistics update complete. 42 tables in 132 seconds
[2026-03-28 15:20:14] [SUCCESS] ========================================
[2026-03-28 15:20:14] [SUCCESS] ✓ RESTORE, USER PROVISIONING AND STATS COMPLETE
[2026-03-28 15:20:14] [SUCCESS] ========================================

Status          : Success
SourceDatabase  : SourceDatabase
TargetDatabase  : TargetDatabase
DatabaseStatus  : Online
ProvisionedUser : app_user
FuncRunnerUser  : func_runner_user
RestoredPolls   : 1
StatsTotal      : 42
StatsUpdated    : 42
StatsFailed     : 0
StatsDuration   : 132
```

### Return Object

The runbook returns a PowerShell object with:

- `Status` - "Success" or error message
- `SourceDatabase` - Source DB name
- `TargetDatabase` - Target DB name
- `DatabaseStatus` - "Online" or other status
- `ProvisionedUser` - Dev app user login name
- `FuncRunnerUser` - Func runner user login name
- `RestoredPolls` - Number of status checks performed during restore
- `StatsTotal` - Total number of tables found
- `StatsUpdated` - Number of tables successfully updated
- `StatsFailed` - Number of tables that failed all update attempts
- `StatsDuration` - Time in seconds to complete the statistics update

---

## Statistics Update Behavior

The runbook updates statistics on every table in the target database after restore. It uses a tiered retry strategy to handle large or slow tables.

**Known large tables** (`[dbo].[CaseDiary]`, `[dbo].[Log]`) skip straight to a 1% sample to avoid timeouts.

For all other tables, the runbook tries in this order:

1. Full scan with a 60-second timeout
2. Retry once with full scan if the first attempt fails
3. If still failing, retry with `SAMPLE 20 PERCENT` (300-second timeout)
4. If still failing, retry with `SAMPLE 1 PERCENT` (300-second timeout)

Tables that fail all attempts are listed in the output as warnings. The runbook still completes successfully even if some tables fail statistics update.

To add more known large tables, update the `$largeTables` array at the top of the statistics phase:

```powershell
$largeTables = @('[dbo].[CaseDiary]', '[dbo].[Log]', '[dbo].[YourLargeTable]')
```

---

## Troubleshooting

### Error: Variable 'Sql_ServerName' is empty
**Cause:** Variable not created or value is blank  
**Solution:** Go to Variables and ensure all 8 variables are created with non-empty values

### Error: Credential 'Sql_AdminAccount' not found
**Cause:** Credential asset not created  
**Solution:** Create credential asset with exact name `Sql_AdminAccount` in Shared Resources → Credentials

### Error: Credential 'Sql_dev_az_func_runner' not found
**Cause:** Func runner credential asset not created  
**Solution:** Create credential asset with exact name `Sql_dev_az_func_runner` in Shared Resources → Credentials

### Error: A network-related or instance-specific error occurred
**Cause:** Connection string invalid or SQL Server not accessible  
**Solution:** Verify `Sql_ServerName` is correct (e.g., `my-sql-server` not `my-sql-server.database.windows.net`)

### Error: Login failed for user
**Cause:** `Sql_AdminAccount` credentials incorrect  
**Solution:** Verify SQL admin username/password in credential asset are correct

### Restore takes longer than expected
**Reason:** Large databases take longer to restore (5-15 minutes typical)  
**Solution:** Monitor in portal, runbook will wait up to 15 minutes before timing out

### Statistics update takes longer than expected
**Reason:** Large tables with many rows take more time even with sampling  
**Solution:** Add the slow table to the `$largeTables` array so it goes straight to 1% sample on the next run

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
✓ **Credential Assets** - Admin and func runner passwords stored securely  
✓ **Error Handling** - Sensitive data not logged or returned  
✓ **Connection String** - TCP+TLS encryption to SQL Server  

**Best Practices:**
- Use dedicated SQL admin account for runbook (not production admin)
- Rotate `Sql_AdminAccount` and `Sql_dev_az_func_runner` credentials regularly
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
- `Invoke-SqlCommand()` - Execute SQL via native .NET SqlClient (non-query)
- `Invoke-SqlQuery()` - Execute SQL and return rows via native .NET SqlClient

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
3. Confirm both users created with SSMS

### Test Phase 2: Production
1. Schedule during maintenance window
2. Monitor first 2-3 runs
3. Adjust restore point offset if needed

### Verify Users Created

```sql
-- Connect to target database as admin
USE TargetDatabase;

-- Check logins exist on master
SELECT name, type FROM sys.sql_logins WHERE name IN ('app_user', 'func_runner_user');

-- Check users exist in target DB
SELECT name, type FROM sys.database_principals WHERE name IN ('app_user', 'func_runner_user');

-- Check role membership
SELECT dp.name AS UserName, dr.name AS RoleName
FROM sys.database_role_members rm
JOIN sys.database_principals dp ON rm.member_principal_id = dp.principal_id
JOIN sys.database_principals dr ON rm.role_principal_id = dr.principal_id
WHERE dp.name IN ('app_user', 'func_runner_user');
```

### Verify Statistics Updated

```sql
-- Connect to target database as admin
USE TargetDatabase;

-- Check last stats update time per table
SELECT
    OBJECT_NAME(s.object_id) AS TableName,
    s.name AS StatName,
    sp.last_updated
FROM sys.stats s
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) sp
WHERE OBJECTPROPERTY(s.object_id, 'IsUserTable') = 1
ORDER BY sp.last_updated DESC;
```

---

## Support & Logs

### View Runbook History
**Automation Account → Runbooks → Restore-SqlDatabaseWithUsersAndStats → All Logs**

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
| 2.8.0 | 2026-03-28 | Added func runner user provisioning. Added inline statistics update with tiered retry (full scan, 20% sample, 1% sample). Added large table fast-path. Added diagnostic timestamps around deletion wait and restore call. |
| 2.0.0 | 2026-03-28 | Production release: restore + dev app user provisioning combined. Verified with SSMS login test. |
| 1.0.0 | 2026-03-28 | Standalone user provisioning script (optional). Use when only creating users without restore. |

---

## Related Documentation

- [Azure Automation Account Setup](https://learn.microsoft.com/en-us/azure/automation/automation-quickstart-create-account)
- [Managed Identity in Automation](https://learn.microsoft.com/en-us/azure/automation/automation-hrw-run-runbooks)
- [SQL Server Contributor Role](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#sql-server-contributor)
- [Azure SQL Point-in-Time Restore](https://learn.microsoft.com/en-us/azure/azure-sql/database/recovery-using-backups)
- [UPDATE STATISTICS (T-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/statements/update-statistics-transact-sql)

---

**Questions?** Check logs in Automation Account. All errors are logged with line numbers and messages.
