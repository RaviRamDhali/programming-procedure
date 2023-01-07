# BAT ver https://github.com/RaviRamDhali/programming-procedure/blob/master/Snippets/BatScripts/WsFTPpro_Upload.bat

# Automate WS_FTP 12 Upload using Connection Configuration settings
# Connection Configuration name = "CJ PRODUCTION UPLOAD"
# Remote Dir = "INTAKE.UP"
# Remote Remote File Name = "CLIENTS.C0000"
# **Note Remote Dir** = The single quote is required for the remote dir path to be valid.
# The sigle quote is only used once, no closing single quote.

$args = @"
-s "local:c:\FTP\CLIENT\CLIENTS.C0000" -d "CJ PRODUCTION UPLOAD:'INTAKE.UP.CLIENTS.C0000"
"@

Start-Process "c:\Program Files (x86)\Ipswitch\WS_FTP 12\wsftppro.exe" $args
