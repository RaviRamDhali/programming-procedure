# Data protection
# Enable soft delete for blobs
# Enable soft delete for containers

# az
# az login
# az storage account list
# az account set --subscription xxxxf11-xxxx-xxxx-xxxxx-xxxxxxxxxxxxxxxx
# az storage account list
# az storage account keys list -n prodbackup
# az storage container list

$resourceGroup="Development"
$storageAccount="prodbackup"

$connectionString=az storage account show-connection-string -n $storageAccount -g $resourceGroup --query connectionString -o tsv
$env:AZURE_STORAGE_CONNECTION_STRING = $connectionString
# az storage container create -n "private-test"

#Upload a single file
#az storage fs file upload --source "C:\_temp\sample.txt" -p sample.txt -f private-test

#Upload a folder
#az storage fs directory upload -f private-test -s "C:\_temp\dhali" --recursive

#Delete a folder
az storage fs directory delete -n xxxxxx -f private-test
az storage fs delete -n private-test

#az storage fs directory upload -f intranet -s "D:\_temp\" --recursive

#Move a file
az storage fs file move --new-path sql/web.bak -p web.bak -f newcontainer

