Clear-Host
Write-Host "Enter the name of the WordPress website and MySQL database to be created" -ForeGround Yellow
$projectName = Read-Host -Prompt "[ex: rockerbros]" 
Write-Host ""
Write-Host ""
Write-Host "-----------------------------------------------" -ForeGround Cyan
Write-Host "Azure resource provisioning started [$projectName]" -ForeGround Cyan
Write-Host "-----------------------------------------------" -ForeGround Cyan
Write-Host ""
Write-Host ""

New-AzResourceGroupDeployment `
    -Name WordPressDeploy `
    -ResourceGroupName WP1 `
    -TemplateFile .\template.json `
    -TemplateParameterFile .\parameters.json `
    -resource_name $projectName `
    -Verbose

Write-Host ""
Write-Host ""
Write-Host ""

Write-Host "Completed View site https://$projectName.azurewebsites.net" -ForeGround Green
