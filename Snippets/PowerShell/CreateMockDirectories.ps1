$lastDayOfMonth = ((get-date $date -Day 1 -hour 0 -Minute 0 -Second 0).AddMonths(1).AddSeconds(-1)).Day
$range = 1..$lastDayOfMonth

$date = (Get-Date)
$year = ($date).Year
$month = ($date).ToString("MM")
$day = ($date).ToString("dd")
$minute = ($date).ToString("hhmmss")
$strDate = "$month$day$year`_$minute"

$rnumber = Get-Random -Minimum 100000 -Maximum 900000 | out-string
$rnMinute = $rnumber.PadLeft(7,'0').Trim()

# Write-Host "Year:" $year -ForegroundColor DarkRed;
# Write-Host "Month:" $month -ForegroundColor DarkRed;
# Write-Host "Day:" $day -ForegroundColor DarkRed;
# Write-Host "Time:" $minute -ForegroundColor Yellow;
# Write-Host "StrDate:" $strDate -ForegroundColor Yellow;

$rootMockFolder = 'C:\_temp\mock-folders\'
Remove-Item -Recurse -Force $rootMockFolder
New-Item -ItemType Directory -Path $rootMockFolder

foreach($i in $range){
    $day = "{0:D2}" -f $i
    # Write-Host $day
    $strDate = "$month$day$year`_$rnMinute"
    # Write-Host $strDate
    Write-Host $rootMockFolder$strDate
    New-Item -ItemType Directory -Path $rootMockFolder$strDate | Out-Null
}

# December 2021 (1-31)
$rangeDec = 1..31
foreach($i in $rangeDec){
    $day = "{0:D2}" -f $i
    # Write-Host $day
    $strDate = "12$day$year`_$rnMinute"
    # Write-Host $strDate
    Write-Host $rootMockFolder$strDate
    New-Item -ItemType Directory -Path $rootMockFolder$strDate | Out-Null
}


