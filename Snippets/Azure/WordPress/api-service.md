## Azure API App Service
Connecting to GitHub Actions > Actions secrets and variables | Repository secrets

## Steps

1. Click "Download publish profile"
2. Message "Basic authentication is disabled."
3. Settings > Configuration > SCM Basic Auth Publishih > Set to ON
4. Overview > "Download publish profile"

## Error
To troubleshot error you can look at the live request log.
You’ll see real-time errors or logs—this is the fastest way to spot the startup issue.
1. Go to your App Service in the Azure Portal.
2. Under “Monitoring,” select “Log stream.”
3. Open Log stream and refresh your API URL in your browser.

## Images

![image](https://github.com/user-attachments/assets/e37ba73e-42ca-4002-8772-4bb63b6e5c00)

![image](https://github.com/user-attachments/assets/ac42495d-f89b-4b5f-8e0c-7133cc1238c6)

