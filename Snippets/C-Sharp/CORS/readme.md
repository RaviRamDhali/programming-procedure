Adding CORS policy to .NET API, GitHubAction and Azure DevOps.
This code relies only on C# CORS and does not use the CORS options in Azure Resopurce WebApp


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

1. Add appSettings.json AppSettings > AllowedOrigins
2. Update: [Program.cs](Program.cs)
3. Add new file Helper class for CORS configuration-related operations: [CorsConfigHelper.cs](Helper/CorsConfigHelper.cs)

![image](https://github.com/user-attachments/assets/f7022e54-af9c-4b24-ae92-45c7d14556d8)



## Images
![image](https://github.com/user-attachments/assets/0d0fce53-9e01-41d4-9e58-80ffc23fac7d)

