$database = 'master'

$date = (Get-Date)
$year = ($date).Year
$month = ($date).ToString("MM")
$day = ($date).ToString("dd")
$minute = ($date).ToString("hhmmss")
$strDate = "$day$month$year`_$minute"

# Write-Host "Year:" $year -ForegroundColor DarkRed;
# Write-Host "Month:" $month -ForegroundColor DarkRed;
# Write-Host "Day:" $day -ForegroundColor DarkRed;
# Write-Host "Time:" $minute -ForegroundColor Yellow;
# Write-Host "StrDate:" $strDate -ForegroundColor Yellow;

$enviroments = @{
    Dev = @{
        server  = 'SQL_00\SQLDEV'
        path = 'D:\DataBackup\dev\'
    }
    Prod = @{
        server  = 'SQL_00\SQLPROD'
        path = 'D:\lDataBackup\prod\'
    }
}



Write-Host "Staring SQL Backup" -ForegroundColor BLUE;

foreach ($key in $enviroments.Keys) {
    $person = $enviroments[$key]
    $server = $person.server
    $rootPath = $person.path

    $pathYear = "$rootPath$year"
    $pathBackup = "$pathYear\$strDate"

    Write-Host "  - Created new backup dir: $pathBackup" -ForegroundColor Cyan;
    Write-Host "  - Set server to  $server" -ForegroundColor Cyan;

    If(!(test-path -PathType container $pathBackup))
    {
        New-Item -ItemType Directory -Path $pathBackup | Out-Null
    }

    Write-Host "  - Creating database backups via TSQL ......" -ForegroundColor Cyan;

    Invoke-Sqlcmd -ServerInstance $server -Database $database -Query "sp_custom_SqlFullBackUp '$pathBackup'"
    Write-Host "  - Completed $server" -ForegroundColor Green;
}

Write-Host "END" -ForegroundColor BLUE;
Write-Host "------------------------";
