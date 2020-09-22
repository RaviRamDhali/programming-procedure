$Path = "C:\Users\ravi\Dropbox\Dhali\Users\ravi\ProjectScratch\mpoint\Entity-Directory\Jennifer\Contacts.csv"
$data = Import-Csv -Path $Path -Delimiter '|'

$ColNames =  ($data[0].psobject.Properties).name
$ColNames

# $StoreList | where {$_.State -eq "CA"} | select -First 1000
$data.Count
# $StoreList1 = $data | where {$_."Last Name" -like "*z*"}
$StoreList1 = $data | Select-String -Pattern '[^\x00-\x7F]'
$StoreList1 | ft



#$StoreList2 = $data | where {$_."First Name" -like "*'*"}
#$StoreList2

