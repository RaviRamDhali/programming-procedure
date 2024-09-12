Using PowerShell as Admin install Azure CLI

```
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
```

After the Download is completed, use the following command to check your new Azure CLI's ExecutionPolicy, 
this will need to display ```Unrestricted``` in order to function correctly.
```
Get-ExecutionPolicy
```

If anything other than ```Unrestricted``` is displayed {RemoteSigned, Restricted} use the following command to change the ExecutionPolicy
```
Set-ExecutionPolicy Unrestricted
```

If you haven't already, check your new Azure CLI's ExecutionPolicy again to confirm that the ExecutionPolicy has been set to ```Unrestricted```
```
Get-ExecutionPolicy
```

Make sure you restart the powershell instance, then run 

```
Install-Module -Name Az -AllowClobber -Scope CurrentUser
```
Connecto Azure (Browser Signin appears)

```Connect-AzAccount```


Select Azure Subscription use Set-AzContext

```Set-AzContext -Subscription "29a123abcd-xxxx-xxxx-xxxx-xxxx"```


