React (with VStudio)

To get React project to run in VStudio 
1. Add folder and file WebApp\.vscode\launch.json
2. Add config to launch.json to open browser


Snippets/ReactJs/webapp/.vscode/launch.json
```
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Launch Chrome against localhost",
            "type": "chrome",
            "request": "launch",
            "url": "https://localhost:3000",
            "webRoot": "${workspaceFolder}"   
        }
    ]
}
```
![image](https://github.com/RaviRamDhali/programming-procedure/assets/1455413/58525af4-9e8b-4e96-a593-3ce2571f738e)
