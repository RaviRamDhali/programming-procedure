
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

Function CreateSingleFile($outputDirectory, $csCode) {
    $csFilePath = Join-Path $outputDirectory "DependencyInjectionExt.cs"
    $csCode | Set-Content -Path $csFilePath
}

Function BuildCSDependencyService($domain) {
    $result = @"
    services.AddScoped<Interface.I$domain, Domain.$domain.$domain>();
"@
    return $result
}

Function BuildCSDependencyInfrastructure($domain) {
    $result = @"
    services.AddScoped<Infrastructure.Interface.I$domain, Infrastructure.Repository.$domain>();
"@
    return $result
}



# Define the output directory where .cs files will be created
$outputDirectory = "C:\_temp\output\Service\DependencyInjection\"

CleanupPathDir $outputDirectory

# Define the CSV file path
$csvFilePath = $PSScriptRoot + "\table_column_details.csv"
# Import CSV
$csvData = Import-csv -Path $csvFilePath
# Group the data by the values in the first column
$groupedData = $csvData | Group-Object -Property TABLE_NAME

$csCode = ""

$csHeader = @"
namespace Service
{
    public static class DependencyInjectionExt
    {
        public static IServiceCollection AddScopedServices(this IServiceCollection services)
        {

"@

$csDependencyService = " // Dependency Service" + "`n"
# Loop through each row in the CSV and generate .cs files
foreach ($group in $groupedData) {
    $domain = $group.Name    
    $csDependencyService += BuildCSDependencyService $domain
}
$csDependencyService += "`n`n"


$csDependencyInfrastructure = "// Dependency Infrastructure" + "`n"
# Loop through each row in the CSV and generate .cs files
foreach ($group in $groupedData) {
    $domain = $group.Name
    $csDependencyInfrastructure += BuildCSDependencyInfrastructure $domain
}
$csDependencyInfrastructure += "`n`n"


$csFooter = @"
return services;
        }
}
}
"@


$csCode = " $csHeader $csDependencyService $csDependencyInfrastructure $csFooter"

CreateSingleFile $outputDirectory $csCode
