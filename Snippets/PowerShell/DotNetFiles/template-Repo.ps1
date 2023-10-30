# Define the output directory where .cs files will be created
$outputDirectory = "C:\_temp\output\Repository\"

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
$csvFilePath = "input.csv"
$csvData = Import-csv -Path $csvFilePath

# Loop through each row in the CSV and generate .cs files
foreach ($row in $csvData) {
    $domain = $row.Header
    Write-Host $domain

    $csCode = @"
namespace Infrastructure.Repository
{
    public class $domain : BaseRepository, I$domain
    {
        public $domain() { }

        public async Task<List<DbModel.$domain>> GetAll()
        {
            string query = "SELECT top 250 * FROM dbo.$domain";
            return await WithConnectionAsync(async connection => (await connection.QueryAsync<DbModel.$domain>(query)).ToList());
        }

        public async Task<List<DbModel.$domain>> GetByClientId(int value)
        {
            var dynamicParameters = new DynamicParameters();
            dynamicParameters.Add("value", value);

            string query = "SELECT * FROM dbo.$domain where clientId = @value";
            return await WithConnectionAsync(async connection => (await connection.QueryAsync<DbModel.$domain>(query, dynamicParameters)).ToList());
        }

        public async Task<DbModel.$domain`?> GetSingle(int value)
        {
            var dynamicParameters = new DynamicParameters();
            dynamicParameters.Add("value", value);

            string query = "Select top 1 * from $domain where Id = @value ";
            return await WithConnectionAsync(connection => connection.QueryFirstOrDefaultAsync<DbModel.$domain>(query, dynamicParameters));
        }

        public async Task<DbModel.$domain`?> GetSingle(Guid value)
        {
            var dynamicParameters = new DynamicParameters();
            dynamicParameters.Add("value", value);

            string query = "Select top 1 * from $domain where Guid = @value ";
            return await WithConnectionAsync(connection => connection.QueryFirstOrDefaultAsync<DbModel.$domain>(query, dynamicParameters));
        }

        
        // CRUD Operations

        public async Task<int> Insert(DbModel.$domain data)
        {
            return await WithConnectionAsync<int>(connection => connection.InsertAsync(data));
        }

        public async Task<bool> Update(DbModel.$domain data)
        {
            return await WithConnectionAsync<bool>(connection => connection.UpdateAsync(data));
        }

        public async Task<bool> Delete(DbModel.$domain data)
        {
            return await WithConnectionAsync<bool>(connection => connection.DeleteAsync(data));
        }

    }
}
"@


# Write-Host $csCode

$csFilePath = Join-Path -Path $outputDirectory -ChildPath "$domain.cs"
$csCode | Set-Content -Path $csFilePath
Write-Host "Created $domain.cs"

}
