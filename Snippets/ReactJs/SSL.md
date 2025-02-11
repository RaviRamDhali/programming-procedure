Instruction to follow: https://chocolatey.org/install#individual

1. open powershell (admin)
1. run: `Get-ExecutionPolicy` (Should show your policy type)
1. Confirm that Policy is: AllSigned
	1. If policy is NOT unrestricted > run: `Set-ExecutionPolicy AllSigned`
   	1. run: `Get-ExecutionPolicy` : should be AllSigned now
   	1. Set-ExecutionPolicy Unrestricted used in a last case scenario. Change back to Set-ExecutionPolicy AllSigned
1. run
```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```
1. Let it run to completion
1. run: `choco` (will show you your version)
1. Confirm you have version: 2.2.2 or greater
	1. If you dont have 2.2.2 OR greater > delete your chocolatey folder and reRun steps again
  	1. My folder was at `C:\ProgramData\chocolatey`

Open NEW Instructions link: 
<br>https://www.briangetsbinary.com/react/software%20engineering/2022/09/24/react-js-configuring-localhost-ssl.html#google_vignette<br>
P.S. - still in PowerShell (admin) 

1. run: `choco install openssl`
1. Restart Computer

## Git for Windows Installation

1. run: `openssl version` (will show version) my version is: OpenSSL 3.1.1
1. Using Powershell (admin)
1. In the project navigate to: `web-app\WebApp\ClientApp\.cert\ssl.ps1`
1. ~remove text `/ClientApp/.cert/` from lines 6, 8, 9~

1. Run the `ssl.ps1` script
   1. Error: ssl.ps1 is not digitally signed
   2. Set-ExecutionPolicy RemoteSigned
1. Look for the following files: `server.crt | server.key | ssl.ps1`

1. Open folder: {git-project-folder}\web-app\WebApp\ClientApp\.cert (folder)
1. Double click: `server.crt`
    
1. Select Current User
1. Select Place all Certificates in the following store, Browse
1. Trusted Root Certification Authorities
1. Select Finish

## Install YARN
1. npm install -g corepack
1. yarn install
   
## Update package.json
C:\Projects\web-app\WebApp\ClientApp\package.json
Updated npm start script:

```
  "scripts": {
    "start": "react-scripts start",
    "test": "react-scripts test",
    "eject": "react-scripts eject",
    "build": "echo \"Please use build:dev or build:prod \" && exit 1",
    "build:prod": "CI=false && react-scripts --max_old_space_size=4096 build",
    "build:local": "react-scripts build"
  },
```
## Run Project
1. Run Project like normal... cross fingers
1. You might need to copy the .cert folder to /ClientApp/

# Degug Steps
1. Delete server.crt file from C:\Projects\web-app\WebApp\ClientApp\.cert
1. Run as admin Powershell > C:\Projects\web-app\WebApp\ClientApp\.cert\ssl.ps1
1. In file explorer, open folder: {git-project-folder}\web-app\WebApp\ClientApp.cert (folder) 13.a. in .cert (folder) double click: server.crt
1. Select Current User
1. Select Place all Certificates in the following store, Browse
1. Trusted Root Certification Authorities
1. Select Finish
