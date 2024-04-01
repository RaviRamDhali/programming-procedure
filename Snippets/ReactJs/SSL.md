Instruction to follow: https://chocolatey.org/install#individual

1. open powershell (admin)

2. run: Get-ExecutionPolicy (Should show your policy type)

3. Confirm that Policy is: unrestricted
	3.a. If policy is NOT unrestricted... run: Set-ExecutionPolicy AllSigned
	3.b. run: Get-ExecutionPolicy... should be unrestricted now

4. run: Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
	4.a. just copy it from the instructions link above

5. Let it run to completion

6. run: choco (will show you your version)

7. Confirm you have version: 2.2.2
	7.a. If you dont have 2.2.2 delete your chocolatey folder and reRun step 4 - 6
		- My folder was at: C:\ProgramData\chocolatey

Open NEW Instructions link: https://www.briangetsbinary.com/react/software%20engineering/2022/09/24/react-js-configuring-localhost-ssl.html#google_vignette
P.S. - still in PowerShell (admin) 

8. run: choco install openssl

9. Restart Computer

10. run: openssl version (will show version)
	10.a. my version is: OpenSSL 3.1.1

11. In the casejacket project navigate to: {git-project-folders}\casejacket-app\WebApp\ClientApp\.cert\ssl.ps1
	11.a. remove text { ./ClientApp/.cert/ } from lines 6, 8, 9

12. Run the ssl.ps1 script
	12.a. the following files should now be modified:
		- server.crt
		- server.key
		- ssl.ps1

13. in file explorer, open folder: {git-project-folder}\casejacket-app\WebApp\ClientApp\.cert (folder)
	13.a. in .cert (folder) double click: server.crt

14. Go to Section: Certificate Installation, in the NEW Instructions link
	14.a. follow step 1 - 5

15. Run Project like normal... cross fingers
