Running azure-deploy.ps1 will

1. Create new Resource in Azure (PHP Website)
2. Copy WordPress files into new Website
3. Create a MYSql database entry

### Prerequisite
To use the .ps1, you will need to install and setup Azure CLI. The directions are at:

https://github.com/RaviRamDhali/programming-procedure/blob/master/Snippets/Azure/CLI/readme.md


### Files

```azure-deploy.ps1``` 
Runs Azure CLI to create the WP Website and MSQL Db entry

```parameters.json```
Update the Website name parameter

```template.json```
Where to get WP Install files from 
"RepoUrl": "https://github.com/dhali-web/infojacket.com"
