$server = "SQLPROD-SQLDEV"
$database = "master"
$rootPath = 'C:\scripts\dev\'

$date = (Get-Date)
$year = ($date).Year
$month = ($date).ToString("MM")
$day = ($date).ToString("dd")
$minute = ($date).ToString("hhmmss")
$strDate = "$day$month$year`_$minute"

Write-Host "Year:" $year -ForegroundColor DarkRed;
Write-Host "Month:" $month -ForegroundColor DarkRed;
Write-Host "Day:" $day -ForegroundColor DarkRed;
Write-Host "Time:" $minute -ForegroundColor Yellow;
Write-Host "StrDate:" $strDate -ForegroundColor Yellow;

$pathYear = "$rootPath$year"
$pathBackup = "$pathYear\$strDate"

Write-Host "pathBackup:" $pathBackup -ForegroundColor Yellow;
Write-Host "PathYear:" $pathYear -ForegroundColor Green;

If(!(test-path -PathType container $pathBackup))
{
      New-Item -ItemType Directory -Path $pathBackup
}


# Invoke-Sqlcmd -ServerInstance $server -Database $database -Query "exec sp_custom_SqlFullBackUpProduction 'ram'"
