function WriteLog
{
    Param ([string]$LogString)

    $DateTimeStamp = (Get-Date).toString("yyyyMMdd")
    $DateTime = "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
    $LogFile = "C:\ServerScripts\WordPressCore\log\" + $DateTimeStamp + ".txt"
       
    $LogMessage = "$Datetime $LogString"

    Write-Host $LogMessage
    
    Add-content $LogFile -value $LogMessage
}



#Download Latest Version of Wordpress to the Wordpress-Download Folder
function DowloadWordpressDeleteOldVersion
{
    
    $location = "C:\ServerScripts\wordpressdownload"
    Set-Location $location

     #Gets a list of all the folders in the core download
     $Items = Get-ChildItem $location
     Foreach($t in $Items)
     {
         WriteLog "Deleting Old WP Version"
         Remove-Item -Path ($location + "\" + $t) -Recurse
     }
   
     WriteLog "Waiting to delete Old Version" -BackgroundColor DarkRed -ForegroundColor Cyan

     Start-Sleep -Milliseconds 10000

    ## download latest version of wp
    $file = "http://wordpress.org/latest.zip"
    $wp = $location + "\wordpress.zip"

    WriteLog "Starting Download"
    

    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($file,$wp)

    ## unzip wp file


    WriteLog "Unzipping"
    


    $shellApp = New-Object -com shell.application
    $zip = $shellApp.NameSpace($wp)
    $dir = $shellApp.NameSpace((Get-Location).Path)

    foreach($item  in $zip.items()){ 
    WriteLog $item
    
        $shellApp.NameSpace($dir).CopyHere($item)
       
    }

    ## clean up | rename dir and remove zip

    Remove-Item .\wordpress.zip

    $finalDir = $location + "\wordpress"

    $result = DeleteContentFolder  $finalDir

    if($result)
    {
        return  $finalDir
    }
    else
    {
        WriteLog "Terminating - NO CONTENT FOLDER (DowloadWordpressDeleteOldVersion)"
        exit
    }

   
}


#Pass in the Directory where extracted core is ex:\Downloads\wordpress-4.9.1\wordpress
function DeleteContentFolder ($wpDir) {
   
     #Gets a list of all the folders in the core download
     $Items = Get-ChildItem $wpDir
     Foreach($t in $Items)
     {
     #Deletes the wp-content folder if not deleted already
        if($t -match "wp-content")
        {
        #If not deleted previously the folder will be deleted and ricky will be fired
             WriteLog "Deleting Content"
             Remove-Item -Path ($wpDir + '\wp-content') -Recurse
             return $true
        }
     }
     #If already deleted it will return false
     WriteLog "No Content"
     return $false
}

function DeleteExcessItems ($currentFolder) {
  
     $Items = Get-ChildItem $currentFolder
     Foreach($t in $Items)
     {
        if($t -eq "wp-admin")
        {
            try
            {
                Remove-Item -Path ($currentFolder + '\wp-admin') -Recurse  
            }
            catch [Exception]
            {
                echo $_.Exception|format-list -force
            }
        }
        if($t -eq"wp-includes")
        {
             try
             {
                Remove-Item -Path ($currentFolder + '\wp-includes') -Recurse  
             }
             catch [Exception]
             {
                echo $_.Exception|format-list -force
             }
        }
     }

     WriteLog "Waiting to delete wp-admin and wp-includes" -BackgroundColor DarkRed -ForegroundColor Cyan
     Start-Sleep -Milliseconds 10000
 
}


#Pass in the Core folder ex:\Downloads\wordpress-4.9.1\wordpress for $source
#Pass in the Website folder ex:E:\Projects\WordpressScript\Test.com $target
function CopyFilesToFolder ($source, $target) {
    
 
    if($target -Match "-redirect")
    {
        WriteLog "Redirect (Skipping)" -ForegroundColor DarkGreen 
        return;
    }
    #WriteLog "No Redirect" -ForegroundColor DarkGray

    DeleteExcessItems $target

    #Gets all the folders from the core download (source)
    $sourceItems = Get-ChildItem $source
    #Gets all the folders from the website (target)
    $targetItems = Get-ChildItem $target

    #Iterates through each folder from the source
    $sourceItems | ForEach-Object {
     
        #Then Iterates through all the folders from the target
        Foreach($t in $targetItems)
        {
            #Break on Content folder to ensure it is not deleted
            if($_.Name -eq "wp-content")
            {
                break
            }
            #If there is a match from target to source it will delete the entire folder
            if($t -match $_.Name) 
            {
                try
                {
                    Remove-Item -Path ($target + "\" + $t) -Recurse 
                }
                catch [Exception]
                {
                    echo $_.Exception|format-list -force
                }
                break

            }
        }
        #Another check from source for content
        if($_.Name -ne "wp-content")
        {
            #Copies the entire folder from source to target (Replacing the Deleted Folders) and adding the new ones were needed
            try
            {
                Copy-Item -Path $_.FullName -Destination $target -Recurse -Force
            }
            catch [Exception]
            {
                echo $_.Exception|format-list -force
            }
           
        }

        #WriteLog "sleep @ " $t -BackgroundColor DarkRed -ForegroundColor Cyan
        Start-Sleep -Milliseconds 500
    }

    WriteLog "Finished " $target
}

#End of Functions beggining core script below


$now = "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)

WriteLog "***********************************************"
WriteLog "DEV Server Core Update $now"
WriteLog "***********************************************"


$sourceDir = DowloadWordpressDeleteOldVersion

WriteLog $sourceDir

WriteLog "DONE WITH DOWNLOAD"



#Where the dowladed core update exists
#$sourceDir = 'E:\Projects\Server-Scripts\Updates\wordpress'

#This is the folder containin all the websites to be updated
$targetParent = 'C:\websites-wp'


#Stop IIS
iisreset /stop
WriteLog "Stopping IIS"



#Checks if the content folder is deleted or already deleted
$content = (DeleteContentFolder $sourceDir)
#If deleted by method then terminates the program
if($content)
{
    WriteLog "Terminating"
    exit
}

#Gets a list of all the website folders
$targets = Get-ChildItem $targetParent
$targetsCount = ($targets| Measure-Object ).Count;

WriteLog "$targetsCount Website Folders Found"
WriteLog "Copying Files!"


$count = 0
#Iterates through all the website folders
Foreach($target in $targets)
{
    WriteLog $count -ForegroundColor DarkYellow
    #Gets the complete directory to pass into the method
    if($count -gt 100)
    {
        break
    }
    $completeDir = $targetParent + "\" + $target
    WriteLog "Copying to $completeDir"  -BackgroundColor DarkBlue


    #Calls the copy files method on the current website folder
    try
    {
         CopyFilesToFolder $sourceDir $completeDir
    }
    catch [Exception]
    {
        WriteLog "And Error Occurred Terminating Program" -ForegroundColor red -BackgroundColor white
        echo $_.Exception|format-list -force
        exit
    }

    

    $count ++
}

WriteLog "Finished " + $count + " sites"

#Start IIS
iisreset /start
WriteLog "Starting IIS"
