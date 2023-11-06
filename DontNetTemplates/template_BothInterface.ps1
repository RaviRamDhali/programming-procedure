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
Function CreateFile($outputDirectory, $domain, $csCode) {

    $csFilePath = Join-Path -Path $outputDirectory -ChildPath "$domain.cs"
    $csCode | Set-Content -Path $csFilePath
    # Write-Host "Created $domain.cs"
}

Function BuildIServiceRow($domain) {

    $result = @"
    public interface I$domain
    {
        Task<List<ViewModel.$domain>> GetAll();
        Task<List<ViewModel.$domain>> GetByClientId(int value);
        Task<ViewModel.$domain`?> GetSingle(int value);
        Task<ViewModel.$domain`?> GetSingle(Guid value);

        //Command
        Task<int> Insert(ViewModel.$domain model);
        Task<bool> Update(ViewModel.$domain model);
        Task<bool> Delete(ViewModel.$domain model);
"@
    return $result

}

Function BuildIRepositoryRow($domain) {

    $result = @"
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
"@
    return $result

}
Function BuildCSHeaderIService ($domain) {
    $result = @"
namespace Service.Interface
{
"@
    return $result
}
Function BuildCSHeaderIRepository ($domain) {
    $result = @"
namespace Infrastructure.Interface
{
"@
    return $result
}
Function BuildCSHeader($domain) {
    $csCode = ""

    if ($class -eq "IService") {
        $csCode = BuildCSHeaderIService $domain
    }

    if ($class -eq "IRepository") {
        $csCode = BuildCSHeaderIRepository $domain
    }

    return $csCode

}

Function BuildEachRow($domain) {
    $propRow = ""

    if ($class -eq "IService") {
        $propRow = BuildIServiceRow $domain
    }

    if ($class -eq "IRepository") {
        $propRow = BuildIRepositoryRow $domain
    }

    return $propRow

}
Function BuildCSFooter($propRow) {
    $result = @"
        $propRow 
    }
}
"@
    return $result
}
Function ProcessCSV($groupedData, $outputDirectory, $class) {

    # Loop over each group
    foreach ($group in $groupedData) {
        $domain = $group.Name
        # $groupItems = $group.Group

        $csCode = BuildCSHeader $domain        
        $propRow = BuildEachRow $domain
        $csCode += BuildCSFooter $propRow
        
        CreateFile $outputDirectory $domain $csCode
    }
}

# Root patch
$rootPath = @("C:\_temp\output\")
# Define the CSV file path
$csvFilePath = $PSScriptRoot + "\table_column_details.csv"


# Define a hashtable named $enviroments to store environment information.
# If you want to just run DbModel or ViewModel, remove object from here
$enviroments = @{
    Infrastructure = @{
        class = 'IService'
        path  = Join-Path -Path $rootPath -ChildPath 'IService'
    }
    Service        = @{
        class = 'IRepository'
        path  = Join-Path -Path $rootPath -ChildPath 'IRepository'
    }
}



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
