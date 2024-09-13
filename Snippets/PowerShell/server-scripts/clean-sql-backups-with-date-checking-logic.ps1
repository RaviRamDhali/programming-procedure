# Get the current year dynamically
$currentYear = (Get-Date).Year

# Define the root folder paths with the current year dynamically
$rootFolders = @("C:\SqlDataBackup\dev\$currentYear", "C:\SqlDataBackup\prod\$currentYear")

# Get the current date
$currentDate = Get-Date

# Get the current and previous month
$currentMonth = $currentDate.Month
$previousMonth = $currentDate.AddMonths(-1).Month

# Loop through each root folder (dev and prod)
foreach ($rootFolder in $rootFolders) {
    
    # Check if the root folder exists (e.g., for the current year)
    if (-Not (Test-Path $rootFolder)) {
        Write-Host "Root folder not found: $rootFolder"
        continue
    }

    # Get all folders with datetime stamp pattern (like 09032024_020002)
    $backupFolders = Get-ChildItem -Path $rootFolder -Directory | Where-Object {
        $_.Name -match '^\d{8}_\d{6}$' # Match folders with datetime pattern (e.g., 09032024_020002)
    }

    foreach ($folder in $backupFolders) {
        # Extract the date part from the folder name (first 8 characters)
        $folderDate = $folder.Name.Substring(0, 8)

        # Convert the folder date into a [datetime] object
        $backupDate = [datetime]::ParseExact($folderDate, 'MMddyyyy', $null)

        # Check if the folder is from the current or previous month
        if ($backupDate.Month -eq $currentMonth -or $backupDate.Month -eq $previousMonth) {
            Write-Host "Skipping backup folder from current or previous month: $folder"
        }
        # Check if the day is the 1st or 15th
        elseif ($backupDate.Day -eq 1 -or $backupDate.Day -eq 15) {
            Write-Host "Skipping backup folder for the 1st or 15th day: $folder"
        }
        else {
            # Get all files in the folder and delete them
            Get-ChildItem -Path $folder.FullName -File | Remove-Item -Force
            Write-Host "Deleted all files in folder: $folder"
        }
    }
}
