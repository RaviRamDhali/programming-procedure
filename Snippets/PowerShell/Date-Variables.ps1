$date = (Get-Date)
$year = ($date).Year
$month = ($date).ToString("MM")
$day = ($date).ToString("dd")
$minute = ($date).ToString("hhmmss")
$strDate = "$month$day$year`_$minute"

# Write-Host "Year:" $year -ForegroundColor DarkRed;
# Write-Host "Month:" $month -ForegroundColor DarkRed;
# Write-Host "Day:" $day -ForegroundColor DarkRed;
# Write-Host "Time:" $minute -ForegroundColor Yellow;
# Write-Host "StrDate:" $strDate -ForegroundColor Yellow;
