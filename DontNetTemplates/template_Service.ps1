
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

    $rootDomain = $csFilePath = Join-Path $outputDirectory "$domain"

    # Check if the output directory exists; if not, create it
    if (-not (Test-Path $rootDomain -PathType Container)) {
        New-Item -Path $rootDomain -ItemType Directory
    }
    
    $csFilePath = Join-Path $rootDomain "$domain.cs"
    $csCode | Set-Content -Path $csFilePath
    # Write-Host "Created $domain.cs"
}

Function BuildCSService($domain, $groupItems) {

    $table = $groupItems | Where-Object { $_.PRIMARYKEY -eq "Yes" -and $_.TABLE_NAME -eq $domain }

    # $DOMAIN = $table.TABLE_NAME
    # $TABLE_NAME = $table.TABLE_NAME
    # $COLUMN_NAME = $table.COLUMN_NAME
    # $SQL_TYPE = $table.SQL_TYPE
    # $NULLABLE = $table.NULLABLE
    # $CLASS_TYPE = $table.CLASS_TYPE
    # $PRIMARYKEY = $table.PRIMARYKEY
    $PRIMARYKEY_COLUMN_NAME = $table.COLUMN_NAME

    # Write-Host "PRIMARYKEY_COLUMN_NAME: $PRIMARYKEY_COLUMN_NAME"
    # Write-Host "PRIMARYKEY_COLUMN_NAME: $PRIMARYKEY_COLUMN_NAME"
    # Write-Host "PRIMARYKEY_COLUMN_NAME: $PRIMARYKEY_COLUMN_NAME"
    # Write-Host "PRIMARYKEY_COLUMN_NAME: $PRIMARYKEY_COLUMN_NAME"
    # Write-Host "PRIMARYKEY_COLUMN_NAME: $PRIMARYKEY_COLUMN_NAME"
    
    # Write-Host "PRIMARYKEY_COLUMN_NAME: $PRIMARYKEY_COLUMN_NAME"

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

                if (data.IsNotNull())
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

                if (data.IsNotNull())
                    return _map.FromDbModel(data);

                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "$domain.GetSingle() error occurred while retrieving data");
                return null;
            }
        }


        // CRUD Operations

        public async Task<ViewModel.$domain`?> Save(ViewModel.$domain formData)
        {
            try
            {
                var dbModel = await _repo.GetSingle(formData.$PRIMARYKEY_COLUMN_NAME);

                if (dbModel.IsNull())
                {
                    // Do Insert
                    var model = _map.ToDbModel(formData);
                    var newId = await _repo.Insert(model);

                    if (newId == 0)
                        throw new Exception($"{GetType().FullName}.Save.Insert() failed", new Exception(JsonSerializer.Serialize(formData)));

                    _logger.LogInformation("$domain Insert");
                    return await GetSingle(newId);
                }
                else
                {
                    // Do Update
                    var model = _map.ToDbModel(formData);
                    var updated = await _repo.Update(model);

                    if (!updated)
                        throw new Exception($"{GetType().FullName}.Save.Update() failed", new Exception(JsonSerializer.Serialize(formData)));

                    _logger.LogInformation("$domain Update");
                    return await GetSingle(model.$PRIMARYKEY_COLUMN_NAME);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "$domain.Save() error occurred while saving data");
                return null;
            }
        }
        public async Task<bool> Delete(int value)
        { 
            try
            {
                var dbModel = await _repo.GetSingle(value);

                if (dbModel.IsNull())
                    throw new Exception($"{GetType().FullName}.Delete.GetSingle() failed", new Exception("Value: " + value));

                var deleted = await _repo.Delete(dbModel);

                if (!deleted)
                    throw new Exception($"{GetType().FullName}.Delete failed", new Exception("Value: " + value));

                _logger.LogInformation("$domain Delete");
                return true; 
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "$domain.Delete() error occurred while deleting data");
                return false;
            }
        }
        
    }
}
"@

return $csCode
}
# Define the output directory where .cs files will be created
$outputDirectory = "C:\_temp\output\Service\Domain\"

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
    $groupItems = $group.Group
    
    $csCode = BuildCSService $domain $groupItems

    CreateFile $outputDirectory $domain $csCode

}
