@REM Automate WS_FTP 12 Upload using Connection Configuration settings
@REM Connection Configuration name = "CJ PRODUCTION UPLOAD"
@REM Remote Dir = "INTAKE.UP"
@REM Remote Remote File Name = "CLIENTS.C0000"

@REM **Note Remote Dir** = The single quote is required for the remote dir path to be valid.
@REM The sigle quote is only used once, no closing single quote.

"c:\Program Files (x86)\Ipswitch\WS_FTP 12\wsftppro.exe" -s "local:c:\FTP\CLIENT\CLIENTS.C0000" -d "CJ PRODUCTION UPLOAD:'INTAKE.UP.CLIENTS.C0000"
