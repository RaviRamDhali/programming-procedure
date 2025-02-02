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
    Write-Host "------------------------------------------------------" -ForegroundColor Cyan    
    Write-Host "------------------------------------------------------" -ForegroundColor Cyan
    # Check if path exists
    if (Test-Path $config.Path) {
        # Get the folder name and convert to uppercase
        $folderName = Split-Path $config.Path -Leaf
        Write-Host $folderName.ToUpper() -ForegroundColor DarkGreen
        # Write-Host $config.Path -ForegroundColor DarkGreen
        
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
                }
                else {
                    Write-Host "Not on $($config.Branch) branch (current: $branch) - skipping git operations" -ForegroundColor Yellow -BackgroundColor Red
                }
            }
            catch {
                Write-Host "Error performing git operations: $_" -ForegroundColor Red
            }
        }
        else {
            Write-Host "Not a git repository - skipping" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "`n"
        Write-Host "Path not found: $($config.Path)" -ForegroundColor DarkRed
    }

    Write-Host "------------------------------------------------------" -ForegroundColor Cyan    
    Write-Host "------------------------------------------------------" -ForegroundColor Cyan
}
