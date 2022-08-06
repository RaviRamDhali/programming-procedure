The following files will setup a new Resource in Azure
to run a WordPress website and create a MYSql database entry.

To use the .ps1, you will need to install and setup Azure CLI

The directions are at:

https://github.com/RaviRamDhali/programming-procedure/blob/master/Snippets/Azure/CLI/readme.md

### Files

```azure-deploy.ps1```
Runs Azure CLI to create the WP Website and MSQL Db entry

```parameters.json```
Update the Website name parameter

```template.json```
Where to get WP Install files from 
"RepoUrl": "https://github.com/dhali-web/infojacket.com"
