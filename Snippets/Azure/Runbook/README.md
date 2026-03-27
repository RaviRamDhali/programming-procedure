## Azure Runbook
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

### Runbook Assets Variables

| Variable Name        | Type    | Value Example      | Encrypted |
|----------------------|---------|---------------------|-----------|
| Sql Resourcegroup    | String  | sample group        | No        |
| Sql Servername       | String  | sample server       | No        |
| Sql Sourcedb         | String  | sample source       | No        |
| Sql Targetdb         | String  | sample target       | No        |
| Sql Targettier       | String  | sample tier         | No        |
| Sql Targetsize       | String  | sample size         | No        |
| Sql Targetmaxsize    | Integer | sample number       | No        |
| Sql Devapppassword   | String  | sample password     | Yes       |
