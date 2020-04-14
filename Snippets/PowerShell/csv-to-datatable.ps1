# CSV variables
$csvfile = "c:\temp\target\import.txt"
$csvdelimiter = ","
$firstRowColumns = $true

# Get column header
$columns = (Get-Content $csvfile -First 1).Split($csvdelimiter)

# Create empty Datatable to store data
$dt = New-Object System.Data.Datatable
# Datatable create header row dynamically
foreach ($column in $columns) {
    if ($firstRowColumns -eq $true) {
        [void]$dt.Columns.Add($column)
    }
}

# Read text into reader
$reader = New-Object System.IO.StreamReader $csvfile
while ($null -ne ($line = $reader.ReadLine())) {
    $line
    [void]$dt.Rows.Add($line.Split($csvdelimiter))
}

# Remove first header row
if ($firstRowColumns -eq $true) {
    $dt[0].Rows[0].Delete();
}

$dt.Rows.Count
$dt

$reader.Dispose()
