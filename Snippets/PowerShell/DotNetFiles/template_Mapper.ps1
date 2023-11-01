# Define the output directory where .cs files will be created
$outputDirectory = "C:\_temp\output\Mapper\"

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
$csvFilePath = $PSScriptRoot + "\table_columns.csv"
$csvData = Import-csv -Path $csvFilePath

# Loop through each row in the CSV and generate .cs files
foreach ($row in $csvData) {
    $domain = $row.table
    # Write-Host $domain

    $columns = $row.columns 
    # Write-Host $columns

    $props = ""

    $columns.split("|") | ForEach {
        # Write-Host $_
        $prop = "$_ = data.$_,"
        # Write-Host $prop
        $props += $prop
    }
    
    $props += $props.TrimEnd(",")
    # Write-Host $props
    

#Template
$csCode = @"
namespace Service.Mapper
{
    public class $domain
    {
        public List<ViewModel.$domain> FromDbModel(List<Infrastructure.DbModel.$domain> data)
        {
            var results = new List<ViewModel.$domain>();
            results.AddRange(data.Select(FromDbModel)!);
            return results;
        }

        public ViewModel.$domain`? FromDbModel(Infrastructure.DbModel.$domain`? data)
        {
            if (data == null)
                return null;
            
            return new ViewModel.$domain{
                $props
            };
        }
    }
}
"@


# Create File
$csFilePath = Join-Path -Path $outputDirectory -ChildPath "$domain.cs"
$csCode | Set-Content -Path $csFilePath
Write-Host "Created $domain.cs"


}
