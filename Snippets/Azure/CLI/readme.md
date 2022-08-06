Using PowerShell as Admin install Azure CLI

```
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
```

Make sure you restart the powershell instance, then run 

```
Install-Module -Name Az -AllowClobber -Scope CurrentUser
```
Connecto Azure (Browser Signin appears)

```Connect-AzAccount```


Select Azure Subscription use Set-AzContext
```Set-AzContext -Subscription "29a123abcd-xxxx-xxxx-xxxx-xxxx"```


