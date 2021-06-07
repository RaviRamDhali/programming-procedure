$date = Get-Date
$year = ($date).ToString("yyyy")
$month = ($date).ToString("MM")
$day = ($date).ToString("dd")
$millisecond = ($date).ToString("ffff")

$folderTarget = $month + $day + $year + "_" + $millisecond
$primaryBackupTarget = "D:\Projects-Backup\" + $folderTarget + "\"
$secondayBackupTarget = "K:\Projects-Backup\" + $year + "\" + $folderTarget + "\"

If ($day -eq '01' -or $day -eq '15') {
    Write-Host "1st or 15th day of the month. Make secondary backup" -ForegroundColor yellow -BackgroundColor green
}
$day
$primaryBackupTarget
$secondayBackupTarget
