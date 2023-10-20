Add web.config to React Project: <br>
- Allow fonts
- Routing fix https://stackoverflow.com/questions/43041513/additional-paths-with-azure-web-app-returns-error
example: WebApp\ClientApp\public\web.config
```
<?xml version="1.0" encoding="utf-8"?>
<configuration>
    <system.webServer>
        <staticContent>
            <mimeMap fileExtension="woff" mimeType="application/font-woff" />
            <mimeMap fileExtension="woff2" mimeType="application/font-woff" />
            <remove fileExtension=".json"/>
            <mimeMap fileExtension=".json" mimeType="application/json"/>
        </staticContent>
        <rewrite>
            <rules>
                <rule name="React Routes" stopProcessing="true">
                    <match url=".*" />
                    <conditions logicalGrouping="MatchAll">
                        <add input="{REQUEST_FILENAME}" matchType="IsFile" negate="true" />
                        <add input="{REQUEST_FILENAME}" matchType="IsDirectory" negate="true" />
                        <add input="{REQUEST_URI}" pattern="^/(api)" negate="true" />
                    </conditions>
                    <action type="Rewrite" url="/" />
                </rule>
            </rules>
        </rewrite>
    </system.webServer>
</configuration>
```

Summary:
```
VITE_ENV = DEV
VITE_API_URL = https://localhost:7096
```
Usage: 
```
var apiUrl = import.meta.env.VITE_API_URL;
console.log('apiUrl',apiUrl);
```
