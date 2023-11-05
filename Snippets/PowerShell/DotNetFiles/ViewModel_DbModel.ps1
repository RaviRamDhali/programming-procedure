
##--------------------------------------------------##
## FUNCTIONS
##--------------------------------------------------##

# This function creates a new text file in the specified directory with the provided content.
Function CreateFile($outputDirectory, $domain, $csCode) {

        $csFilePath = Join-Path -Path $outputDirectory -ChildPath "$domain.cs"
        $csCode | Set-Content -Path $csFilePath
        Write-Host "Created $domain.cs"
}

# Combines rows generated from a collection of tables into a single string.
Function BuildEachRow ($groupItems, $class) {
    
    $propRow = ""
    
    foreach ($table in $groupItems) {
        $row = ProcessTable $table $class
        $propRow += $row
    }

    $propRow = $propRow.TrimEnd("`n")

    return $propRow
}

# Combines rows generated from a collection of tables into a single string.
Function BuildCSFooter($propRow) {
    $result = @"
        $propRow 
    }
}
"@
    return $result
}

# Combines rows generated from a collection of tables into a single string.
Function BuildCSHeader ($domain) {
    
    $csCode = ""

    if ($class -eq "DbModel") {
        $csCode = BuildCSHeaderDbModel $domain
    }

    if ($class -eq "ViewModel") {
        $csCode = BuildCSHeaderViewModel $domain
    }

    return $csCode
}

# Combines rows generated from a collection of tables into a single string.
Function BuildCSHeaderDbModel ($domain) {

    $result = @"
namespace Infrastructure.DbModel
{
    [Table("$domain")]
    public class $domain
    {
"@

    return $result
}

# Combines rows generated from a collection of tables into a single string.
Function BuildCSHeaderViewModel ($domain) {
    $result = @"
namespace Service.ViewModel
{
    public class $domain
    {
"@

    return $result
}

# Converts table metadata into C# property declarations for a specified class.
Function ProcessTable ($table, $class) {

    $row = ""

    # Access the values in each row
    $DOMAIN = $table.TABLE_NAME
    $TABLE_NAME = $table.TABLE_NAME
    $COLUMN_NAME = $table.COLUMN_NAME
    $SQL_TYPE = $table.SQL_TYPE
    $NULLABLE = $table.NULLABLE
    $CLASS_TYPE = $table.CLASS_TYPE
    $PRIMARYKEY = $table.PRIMARYKEY


    if ($PRIMARYKEY -eq "YES" -and $class -eq "DbModel") {
        $row += "[Key]" + "`n"
    }

    $row += "public $CLASS_TYPE $COLUMN_NAME { get; set; }" + "`n"


    return $row
}

# Processes grouped data and generates C# class files for each group.
Function ProcessCSV ($groupedData, $outputDirectory, $class)
{
    

    # Loop over each group
    foreach ($group in $groupedData) {
        # Access the group's key (the unique value from the first column)
        $domain = $group.Name
        # Access the items in the group
        $groupItems = $group.Group

        $csCode = BuildCSHeader $domain
        
        $propRow = BuildEachRow $groupItems $class

        $csCode += BuildCSFooter $propRow

        CreateFile $outputDirectory $domain $csCode
    }

}



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

##--------------------------------------------------##
## INIT
##--------------------------------------------------##

# Root patch
$rootPath = @("C:\_temp\output\")

# Define the CSV file path
$csvFilePath = $PSScriptRoot + "\table_column_details.csv"

##--------------------------------------------------##
## START UP
##--------------------------------------------------##

# Define a hashtable named $enviroments to store environment information.
# If you want to just run DbModel or ViewModel, remove object from here
$enviroments = @{
    Infrastructure = @{
        class = 'DbModel'
        path  = Join-Path -Path $rootPath -ChildPath 'DbModel'
    }
    Service        = @{
        class = 'ViewModel'
        path  = Join-Path -Path $rootPath -ChildPath 'ViewModel'
    }
}

# Iterate through each key (environment) in the $enviroments hashtable.
foreach ($key in $enviroments.Keys) {
    $enviroment = $enviroments[$key]
    $class = $enviroment.class
    $path = $enviroment.path
    $outputDirectory = $path

    CleanupPathDir $outputDirectory

    # Import CSV
    $csvData = Import-csv -Path $csvFilePath
    # Group the data by the values in the first column
    $groupedData = $csvData | Group-Object -Property TABLE_NAME

    
    ProcessCSV $groupedData $outputDirectory $class

}

##--------------------------------------------------##
##--------------------------------------------------##
##--------------------------------------------------##
