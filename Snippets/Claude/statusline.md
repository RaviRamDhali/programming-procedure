

DIR : C:\Users\ravi\.claude 
Add  : statusline-command.sh

Update: settings.json
```
{
	"autoUpdatesChannel": "latest",
	"spinnerVerbs": {
		"mode": "replace",
		"verbs": ["Working"]
	},
	"enabledPlugins": {
		"superpowers@claude-plugins-official": true
	},
	"statusLine": {
		"type": "command",
		"command": "bash C:/Users/ravi/.claude/statusline-command.sh"
	}
}
```

INSTALL: winget install jqlang.jq

Run: Test-Path "$env:LOCALAPPDATA\Microsoft\WinGet\Links\jq.exe"   
TRUE

Add that folder to your System Environment Variables / User / Path
