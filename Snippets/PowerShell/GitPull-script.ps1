# Array of project paths and their target branches
$projectConfigs = @(
    @{
        Path = "C:\Projects\one\web-app"
        Branch = "main"
    },
    @{
        Path = "C:\Projects\one\web-app-github"
        Branch = "main"
    }
)

# Loop through each project configuration
foreach ($config in $projectConfigs) {
    Write-Host "------------------------------------------------------" -ForegroundColor DarkGray    

    # Check if path exists
    if (Test-Path $config.Path) {
        # Get the folder name and convert to uppercase
        $folderName = Split-Path $config.Path -Leaf
        Write-Host $folderName.ToUpper() -ForegroundColor DarkGreen
        
        # Change to project directory
        Set-Location $config.Path

        # Check if .git directory exists
        if (Test-Path ".git") {
            try {
                # Get current branch
                $branch = &git rev-parse --abbrev-ref HEAD

                # If on specified branch, perform git operations
                if ($branch -eq $config.Branch) {
                    Write-Host "On $($config.Branch) branch - performing git operations..." -ForegroundColor Yellow
                    git pull
                    git status

                    # Get last commit info
                    Write-Host "`nLast Commit Details:" -ForegroundColor Blue
                    $author = git log -1 --pretty=format:"%an" --date=local
                    $date = git log -1 --pretty=format:"%ad" --date=local
                    $message = git log -1 --pretty=format:"%s" --date=local
                    Write-Host "Date: $date" -ForegroundColor Blue
                    Write-Host "Author: $author" -ForegroundColor Blue
                    Write-Host "Message: $message" -ForegroundColor Blue
                }
                else {
                    Write-Host "Not on $($config.Branch) branch (current: $branch) - skipping git operations" -ForegroundColor Yellow -BackgroundColor DarkRed
                }
            }
            catch {
                Write-Host "Error performing git operations: $_" -ForegroundColor Red
            }
        }
        else {
            Write-Host "Not a git repository - skipping" -ForegroundColor Yellow
            # Prompt user to clone the repository
            if ($config.RepoUrl) {
            
            
                $cloneChoice = Read-Host "Would you like to clone $($folderName) repository? (Y/N)"
                if ($cloneChoice -eq 'Y' -or $cloneChoice -eq 'y') {

                    try {
                        git config --global --add safe.directory $config.Path

                        Write-Host "Cloning repository from $($config.RepoUrl)..." -ForegroundColor Green
                        git clone $config.RepoUrl $config.Path
    
                        # Verify if cloning was successful
                        if (Test-Path $config.Path) {
                            Write-Host "Repository cloned successfully!" -ForegroundColor Green
                        }
                        else {
                            Write-Host "Failed to clone the repository." -ForegroundColor Red
                        }
                    }
                    catch {
                        Write-Host "Failed to clone the repository." -ForegroundColor Red
                        Write-Host "Error performing git operations: $_" -ForegroundColor Red
                    }
                }
                else {
                    Write-Host "Skipping cloning for $($config.Path)" -ForegroundColor Yellow
                }
            }
            else {
                Write-Host "No repository URL provided, skipping clone." -ForegroundColor Yellow
            }
        }
    }
    else {
        Write-Host "`n"
        Write-Host "Path not found: $($config.Path)" -ForegroundColor DarkRed

        
    }

    Write-Host "------------------------------------------------------" -ForegroundColor DarkGray    
}
