##  Finds the top 10 .cs files with the most lines of code:



`
Get-ChildItem -Path . -Filter *.cs -Recurse -File | ForEach-Object { [PSCustomObject]@{ File = $_.FullName; Lines = (Get-Content $_.FullName | Measure-Object -Line).Lines } } | Sort-Object -Property Lines -Descending | Select-Object -First 10 | Format-Table -AutoSize
`
