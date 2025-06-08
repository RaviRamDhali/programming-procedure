Adding CORS policy to .NET API, GitHubAction and Azure DevOps.

## Azure Resource 
WebApp > Settings > CORS: Leave everything empty as #C API code will handle CORS  (see img below)

## GitHubAction
Go to repo > Settings > Secrets and variables > Variable tab > Create new variable
1. Name: ALLOWEDORIGINS
2. CSV Value: ```https://sb1-website-xxxxxxsam.westus-01.azurewebsites.net, https://xxx-another-domain.com```
3. In workflows/deploy-api.yml >

        ```
        - uses: microsoft/variable-substitution@v1
          with:
            files: "./WebApi/appsettings.json"
          env:
              ConnectionStrings.Connection: ${{ secrets.CONNSTRING_DEV }}
             .......................
              AppSettings.AllowedOrigins: ${{ vars.ALLOWEDORIGINS }}
          ```

![image](https://github.com/user-attachments/assets/21c152e9-7e91-4c1f-bc4e-b63d8cfe46f9)

## C# Code


## Images

![image](https://github.com/user-attachments/assets/891e68a3-9bd1-4048-931f-1e018c167158)
