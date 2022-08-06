New-AzResourceGroupDeployment `
    -Name WordPressDeploy `
    -ResourceGroupName WP1 `
    -TemplateFile .\template.json `
    -TemplateParameterFile .\parameters.json `
    -Verbose
