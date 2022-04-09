### Website > Webforms ASPX Project > Azure CI/CD


While building Pipeline to upload files to Remote IIS server, the XML Transformation where not working as expected.

Comparing DROP files from a known good Pipeline XML Transformation showed that website.SetParameters.xml was different.

#### DROP file

![image](https://user-images.githubusercontent.com/1455413/162583810-863e1bf4-54df-4d79-b139-83e59ade131c.png)


Check the  website.SetParameters.xml (should be clean). 

#### Bad Example

![image](https://user-images.githubusercontent.com/1455413/162583688-f9d7b1ac-a41f-49de-86a8-5f11057d5855.png)

#### Good Example

![image](https://user-images.githubusercontent.com/1455413/162583736-4eb00056-b7db-45f3-a9e8-33158554bccc.png)


Update the YML task as follows using  /p:AutoParameterizationWebConfigConnectionStrings=False

```
- task: MSBuild@1
    displayName: Build solution **/*.publishproj
    inputs:
      solution: '**/*.publishproj'
      platform: $(BuildPlatform)
      configuration: $(BuildConfiguration)
      msbuildArguments: /p:DeployOnBuild=true /p:WebPublishMethod=Package /p:PackageAsSingleFile=true /p:SkipInvalidConfigurations=true /p:PackageLocation="$(build.artifactstagingdirectory)\\" /p:AutoParameterizationWebConfigConnectionStrings=False
```

#### Troubleshooting Notes found in Log Files

Using YML Task:
- task: VSBuild@1  or
- task: MSBuild@1 


```
2022-04-09T14:32:47.0474605Z Compressed: 3281956
2022-04-09T14:32:47.1827589Z Initiated variable substitution in config file : C:\azagent\A1\_work\_temp\temp_web_package_6730604951747712\Content\C_C\Users\VssAdministrator\AppData\Local\Temp\WebSitePublish\AdminWebsite--56643332\obj\Release\Package\PackageTmp\Web.config
2022-04-09T14:32:47.2044477Z Processing substitution for xml node : appSettings
2022-04-09T14:32:47.2061320Z Updating value for key= system with token value: CONFIG_FILE_SETTINGS_TOKEN(system)
2022-04-09T14:32:47.2069967Z Updating value for key= website with token value: CONFIG_FILE_SETTINGS_TOKEN(website)
2022-04-09T14:32:47.2083529Z Processing substitution for xml node : connectionStrings
2022-04-09T14:32:47.2151086Z Config file : C:\azagent\A1\_work\_temp\temp_web_package_6730604951747712\Content\C_C\Users\VssAdministrator\AppData\Local\Temp\WebSitePublish\AdminWebsite--56643332\obj\Release\Package\PackageTmp\Web.config updated.
2022-04-09T14:32:47.2153306Z XML variable substitution applied successfully.
```

![image](https://user-images.githubusercontent.com/1455413/162583548-464238b4-c92a-415f-a71a-5441c0020ad2.png)

