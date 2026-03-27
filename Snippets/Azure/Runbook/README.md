## Azure Runbook

### Create an Automation Account
1. Go to Azure Portal
2. Search for: “Automation Accounts” (Not “Runbook”, not “Automation”, but Automation Accounts)


### Development Database Refresh - New Automated Process

Team just wanted to give you a quick heads up on something we have been improving to make our database refresh process more reliable and much faster

A bug was reported that we could not reproduce even after refreshing our development environment
The underlying issue turned out to be timeout problems during the database refresh process 
using our existing sync tool which has been causing delays and extra manual effort

We have now shifted this workflow to an automated cloud based runbook 
It handles the refresh end to end without manual intervention and the results so far look good

We will continue testing over the next few weeks as time allows to ensure everything runs smoothly before making it our standard process

#### Key improvements

- No more timeout issues the refresh uses an internal copy mechanism instead of the old sync method  
- Anyone on the team can trigger a development refresh without needing assistance  
- Much faster and more reliable especially as the database continues to grow  

## Setup Checklist for your Automation Account
To make this script work, you need to create the following Variables in your Azure Automation Account:

### Runbook Assets Variables for Restores script
[DB Restores script](https://github.com/RaviRamDhali/programming-procedure/blob/master/Snippets/Azure/Runbook/Restore-SqlDatabase-Dev.ps1)

| Variable Name        | Type    | Value Example      | Encrypted |
|----------------------|---------|---------------------|-----------|
| Sql_ResourceGroup    | String  | samplegroup         | No        |
| Sql_ServerName       | String  | sampleserver        | No        |
| Sql_SourceDB         | String  | samplesource        | No        |
| Sql_TargetDB         | String  | sampletarget        | No        |
| Sql_TargetTier       | String  | sampletier          | No        |
| Sql_TargetSize       | String  | samplesize          | No        |
| Sql_TargetMaxSize    | Integer | samplenumber        | No        |
| Sql_DevAppPassword   | String  | samplepassword      | Yes       |

### Runbook Assets Variables for Recreates a SQL login
[Recreates a SQL login](https://github.com/RaviRamDhali/programming-procedure/blob/master/Snippets/Azure/Runbook/Recreate-SqlUser.ps1)

| Variable Name        | Type                |
|----------------------|---------------------|
| Sql_AdminAccount     | Credential          |
| Sql_ServerName       | String              |
| Sql_TargetDB         | String              |
| Sql_DevAppUserName   | String              |
| Sql_DevAppPassword   | String (Encrypted)  |


