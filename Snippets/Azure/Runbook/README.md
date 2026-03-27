## Azure Runbook
### Development Database Refresh - New Automated Process

Team just wanted to give you a quick heads up on something we have been improving to make our database refresh process more reliable and much faster

A bug was reported that we could not reproduce even after refreshing our development environment
The underlying issue turned out to be timeout problems during the database refresh process 
using our existing sync tool which has been causing delays and extra manual effort

We have now shifted this workflow to an automated cloud based runbook 
It handles the refresh end to end without manual intervention and the results so far look good

We will continue testing over the next few weeks as time allows to ensure everything runs smoothly before making it our standard process

## Key improvements

- No more timeout issues the refresh uses an internal copy mechanism instead of the old sync method  
- Anyone on the team can trigger a development refresh without needing assistance  
- Much faster and more reliable especially as the database continues to grow  
