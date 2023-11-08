Function CleanupPathDir($outputDirectory) {

    if (Test-Path $outputDirectory -PathType Container) {
        # The directory exists, so delete it
        Remove-Item -Path $outputDirectory -Recurse -Force

    } 

    # Check if the output directory exists; if not, create it
    if (-not (Test-Path $outputDirectory -PathType Container)) {
        New-Item -Path $outputDirectory -ItemType Directory
    }
}

Function BuildCSMapper($domain, $props) {
    $csCode = ""

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

        public Infrastructure.DbModel.$domain ToDbModel(ViewModel.$domain data)
        {
             if (data.IsNull())
                return null;
            
            return new Infrastructure.DbModel.$domain{
                $props
            };
        }
    }
}
"@

    return $csCode

}


Function ProcessTable ($table) {

    $row = ""
     # Access the values in each row
        $DOMAIN = $table.TABLE_NAME
        $TABLE_NAME = $table.TABLE_NAME
        $COLUMN_NAME = $table.COLUMN_NAME
        $SQL_TYPE = $table.SQL_TYPE
        $NULLABLE = $table.NULLABLE
        $CLASS_TYPE = $table.CLASS_TYPE
        $PRIMARYKEY = $table.PRIMARYKEY

        $row = "$COLUMN_NAME = data.$COLUMN_NAME," + "`n"

    return $row
}
Function BuildEachRow($groupItems, $class) {

    $propRow = ""
    
    foreach ($table in $groupItems) {
        $row = ProcessTable $table
        $propRow += $row
    }

    $propRow = $propRow.TrimEnd(",`n")

    return $propRow
}

# This function creates a new text file in the specified directory with the provided content.
Function CreateFile($outputDirectory, $domain, $csCode) {

    $csFilePath = Join-Path -Path $outputDirectory -ChildPath "$domain.cs"
    $csCode | Set-Content -Path $csFilePath
    # Write-Host "Created $domain.cs"
}

# Define the output directory where .cs files will be created
$outputDirectory = "C:\_temp\output\Mapper\"

CleanupPathDir $outputDirectory

# Define the CSV file path
$csvFilePath = $PSScriptRoot + "\table_column_details.csv"
# Import CSV
$csvData = Import-csv -Path $csvFilePath
# Group the data by the values in the first column
$groupedData = $csvData | Group-Object -Property TABLE_NAME


# Loop over each group
foreach ($group in $groupedData) {
    # Access the group's key (the unique value from the first column)
    $domain = $group.Name
    # Access the items in the group
    $groupItems = $group.Group

    $propRow = BuildEachRow $groupItems $class

    $csCode = BuildCSMapper $domain $propRow

    CreateFile $outputDirectory $domain $csCode
}
