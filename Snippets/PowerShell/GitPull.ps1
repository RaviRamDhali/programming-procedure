Set-Location C:\Projects\cde-project\cde
$branch = &git rev-parse --abbrev-ref HEAD
If ($branch -eq 'main') {
    git checkout main
    git pull
    git status
}

Set-Location C:\Projects\cde-project\augusta
$branch = &git rev-parse --abbrev-ref HEAD
If ($branch -eq 'main') {
    git checkout main
    git pull
    git status
}

Start-Process -FilePath "C:\araxis-saved-comparison\cde.cmp7"
Exit-PSSession

Start-Process -FilePath "C:\araxis-saved-comparison\augusta.cmp7"
Exit-PSSession
