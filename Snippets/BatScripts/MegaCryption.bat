SET today=%Date:~-10,2%%Date:~-7,2%%Date:~-4,4%

SET "dirMega=C:\Program Files (x86)\ASPG Software\MegaCryption\""
REM echo %dirMega%
cd %dirMega%

SET "sourseDir=E:\FTP\ClientName\"
SET "sourseFileAgt=Agt.ASC"

SET "destinationAgtFile=%sourseFileAgt%.txt"

SET "decryptAgt=--decrypt %sourseDir%%sourseFileAgt%"

MD %sourseDir%%today%\

SET "outputAgt=--output %sourseDir%%today%\%destinationAgtFile%"

SET "passphrase=--passphrase ***************************"

SET "paramsAgt=%passphrase% %outputAgt% %decryptAgt%"

mgc.exe %paramsAgt%

cd %sourseDir%

