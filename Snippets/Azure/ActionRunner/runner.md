Find the name of the GitHub Actions service
Run powershell:

```
(Get-Service actions.runner.*).name
```


Change service to use NT
Run command:

```
sc config "actions.runner.jacketsoftware-casejacket.com.DHALISERVER6" obj= "NT AUTHORITY\SYSTEM" type= own
```
