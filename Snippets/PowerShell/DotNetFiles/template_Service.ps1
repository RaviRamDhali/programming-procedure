
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

Function BuildCSService($domain) {
    $csCode = @"
namespace Service.Domain.$domain
{
    public class $domain : I$domain
    {
        private readonly Infrastructure.Interface.I$domain _repo;
        private readonly Service.Mapper.$domain _map;
        private readonly ILogger<$domain> _logger;

        public $domain(Infrastructure.Interface.I$domain repo, ILogger<$domain> logger)
        {
            _repo = repo;
            _map = new Service.Mapper.$domain();
            _logger = logger;
        }

        public async Task<List<ViewModel.$domain>> GetAll()
        { 
            try
            {
                var data = await _repo.GetAll();

                if (data.IsNotNullOrEmpty())
                    return _map.FromDbModel(data);

                return new List<ViewModel.$domain>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "$domain.GetAll() error occurred while retrieving data");
                return new List<ViewModel.$domain>();
            }
        }

        public async Task<List<ViewModel.$domain>> GetByClientId(int value)
        { 
            try
            {
                var data = await _repo.GetByClientId(value);

                if (data.IsNotNullOrEmpty())
                    return _map.FromDbModel(data);

                return new List<ViewModel.$domain>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "$domain.GetByClientId() error occurred while retrieving data");
                return new List<ViewModel.$domain>();
            }
        }

        public async Task<ViewModel.$domain`?> GetSingle(int value)
        { 
            try
            {
                var data = await _repo.GetSingle(value);

                if (data.IsNotNullOrEmpty())
                    return _map.FromDbModel(data);

                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "$domain.GetSingle() error occurred while retrieving data");
                return null;
            }
        }


        public async Task<ViewModel.$domain`?> GetSingle(Guid value)
        { 
            try
            {
                var data = await _repo.GetSingle(value);

                if (data.IsNotNullOrEmpty())
                    return _map.FromDbModel(data);

                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "$domain.GetSingle() error occurred while retrieving data");
                return null;
            }
        }

        public async Task<ViewModel.$domain`?> Save(int value)
        { 
            try
            {
                var data = await _repo.Insert(DbModel.$domain);
                var data = await _repo.Update(DbModel.$domain);

                if (data.IsNotNullOrEmpty())
                    return _map.FromDbModel(data);

                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "$domain.GetSingle() error occurred while retrieving data");
                return null;
            }
        }

        public async Task<ViewModel.$domain`?> Delete(int value)
        { 
            try
            {
                var data = await _repo.Delete(DbModel.$domain);
                
                if (data.IsNotNullOrEmpty())
                    return _map.FromDbModel(data);

                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "$domain.GetSingle() error occurred while retrieving data");
                return null;
            }
        }

        public async Task<ViewModel.$domain`?> Delete(Guid value)
        { 
            return Delete(value);
        }


    }
}
"@

return $csCode
}
# Define the output directory where .cs files will be created
$outputDirectory = "C:\_temp\output\Service\"

CleanupPathDir $outputDirectory

# Define the CSV file path
$csvFilePath = $PSScriptRoot + "\table_column_details.csv"
# Import CSV
$csvData = Import-csv -Path $csvFilePath
# Group the data by the values in the first column
$groupedData = $csvData | Group-Object -Property TABLE_NAME



# Loop through each row in the CSV and generate .cs files
foreach ($group in $groupedData) {
    $domain = $group.Name
    # Write-Host $domain

    $csCode = BuildCSService $domain

    CreateFile $outputDirectory $domain $csCode
}
