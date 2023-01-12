& "C:\_temp\mock-setup.ps1"

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

#Clean out previous months (keep 1st and 15th folders)
## Get all the folders from the previous month
## Count is 2 (do nothing)
## Count is > 2, rename folders delete_(name)
## except 1st and 15th folders

$previousDate = (Get-Date).AddMonths(-2)
$previousYear = ($previousDate).Year
$previousMonth = ($previousDate).ToString("MM")
$monthfirst = $previousMonth + "01" + $previousYear
$monthfifteenth = $previousMonth + "15" + $previousYear

$objPreviousMonthFolders = (Get-ChildItem -Path C:\_temp\mock-folders -Filter "$previousMonth*" -Recurse -Directory)

foreach ($objFolder in $objPreviousMonthFolders)
{
     if ($objFolder | Where-Object {$_.Name -match "$monthfirst`_*|$monthfifteenth`_*"} )
    {
        $folderName = $objFolder.Name
        $folderName
    }
    
}
