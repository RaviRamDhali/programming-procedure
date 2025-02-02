# Script to traverse all directories under C:\Projects
# and find Git repositories

$rootPath = "C:\Projects"

try {
    # Verify the root directory exists
    if (-not (Test-Path -Path $rootPath)) {
        Write-Error "The directory $rootPath does not exist!"
        exit 1
    }

    # Get all directories under the root path
    $allDirs = Get-ChildItem -Path $rootPath -Directory -Recurse -ErrorAction SilentlyContinue

    # Loop through each directory
    foreach ($dir in $allDirs) {
        # Check if this directory has a .git folder
        $gitPath = Join-Path -Path $dir.FullName -ChildPath ".git"
        if (Test-Path -Path $gitPath -PathType Container) {
            # Output the parent directory path where .git was found
            Write-Host $dir.FullName
        }
    }
} catch {
    Write-Error "An error occurred while traversing directories: $_"
    exit 1
}

