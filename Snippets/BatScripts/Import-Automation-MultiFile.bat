REM IMPORT - AUTOMATION
@ECHO OFF

setlocal ENABLEDELAYEDEXPANSION

REM *** SETUP Day string ** 
set hh=%time:~-11,2%
set /a hh=%hh%+100
set hh=%hh:~1%
set today=%date:~10,4%%date:~4,2%%date:~7,2%_%hh%%time:~3,2%%time:~6,2%

set "sourseDir=D:\temp\"
set /a counter=0

REM *** SETUP DIRs ** 
RD %sourseDir%\target /s /q
MD %sourseDir%\target
MD %sourseDir%archive\%today%\


REM *** Loop over each file  ** 
for %%f in (%sourseDir%*.txt) do (

  echo "fullname: %%f"
  echo "name: %%~nf"

    REM *** Find filenames containing "ce" *******
    echo."%%~nf"|findstr /C:"ce" >nul 2>&1
    if not errorlevel 1 (
        echo Found
        set /a counter=counter+1
        echo !counter!
        
        REM *** Copy file and Save As needed *******
        copy "%%f" %sourseDir%\archive\%today%\  /y
        copy "%%f" %sourseDir%\target\import_!counter!.txt /y
        copy "%%f" %sourseDir%\target\%%~nf /y

        REM *** Clean-up *******
        REM *** Delete original file *******
        del "%%f"
    ) else (
        echo Not found.
    )

)

endlocal
