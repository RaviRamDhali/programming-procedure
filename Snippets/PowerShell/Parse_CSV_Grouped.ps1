# Use to Generated file Snippets/Sql/Table_Column_Details.sql

# Define the CSV file path
$csvFilePath = $PSScriptRoot + "\table_column_details.csv"
$csvData = Import-csv -Path $csvFilePath

# Group the data by the values in the first column
$groupedData = $csvData | Group-Object -Property TABLE_NAME


# Loop over each group
foreach ($group in $groupedData) {
    # Access the group's key (the unique value from the first column)
    $groupKey = $group.Name

    Write-Host "Group Key: $groupKey"

    # Access the items in the group
    $groupItems = $group.Group

    Write-Host "Group Items: $groupItems"

    # Perform operations on the items in the group
    foreach ($item in $groupItems) {
        # Access the values in each row
        $TABLE_NAME = $item.TABLE_NAME
        $COLUMN_NAME = $item.COLUMN_NAME
        $SQL_TYPE = $item.SQL_TYPE
        $NULLABLE = $item.NULLABLE
        $CLASS_TYPE = $item.CLASS_TYPE
        $PRIMARYKEY = $item.PRIMARYKEY

        Write-Host $TABLE_NAME
        Write-Host $COLUMN_NAME
        Write-Host $SQL_TYPE
        Write-Host $NULLABLE
        Write-Host $CLASS_TYPE
        Write-Host $PRIMARYKEY
    }

}
