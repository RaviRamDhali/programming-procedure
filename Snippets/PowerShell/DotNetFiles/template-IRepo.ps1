# Define the output directory where .cs files will be created
$outputDirectory = "C:\_temp\output\Interface\"

if (Test-Path $outputDirectory -PathType Container) {
    # The directory exists, so delete it
    Remove-Item -Path $outputDirectory -Recurse -Force
    Write-Host "Directory $outputDirectory deleted successfully."
} 

# Check if the output directory exists; if not, create it
if (-not (Test-Path $outputDirectory -PathType Container)) {
    New-Item -Path $outputDirectory -ItemType Directory
}


# Define the CSV file path
$csvFilePath = $PSScriptRoot + "\input.csv"
$csvData = Import-csv -Path $csvFilePath

# Loop through each row in the CSV and generate .cs files
foreach ($row in $csvData) {
    $domain = $row.Header
    Write-Host $domain

    $csCode = @"
namespace Infrastructure.Interface
{
    public interface I$domain
    {
        Task<List<DbModel.$domain>> GetAll();
        Task<List<DbModel.$domain>> GetByClientId(int value);
        Task<DbModel.$domain`?> GetSingle(int value);
        Task<DbModel.$domain`?> GetSingle(Guid value);

        //Command
        Task<int> Insert(DbModel.$domain model);
        Task<bool> Update(DbModel.$domain model);
        Task<bool> Delete(DbModel.$domain model);
    }
}
"@


$csFilePath = Join-Path -Path $outputDirectory -ChildPath "I$domain.cs"
$csCode | Set-Content -Path $csFilePath
Write-Host "Created $domain.cs"

}
