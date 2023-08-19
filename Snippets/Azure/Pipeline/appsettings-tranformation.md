Pipeline > Releases > Edit

Foreach each stage
Deploy Azure App Service > 
File Transforms & Variable Substitution Options > 

## For Web.config
You can add each Pipeline Variable
![image](https://github.com/RaviRamDhali/programming-procedure/assets/1455413/6151e35c-651c-481e-a6db-9c397564328e)



## For Appsettings.json
JSON variable substitution enter into textarea 
```**/appsettings.json``` . In NAME field, use Appsettings.*******

![image](https://github.com/RaviRamDhali/programming-procedure/assets/1455413/cbfda275-82f2-485d-bc06-74c6af374e22)


Pipeline > Releases > Edit
Variables > add each variable

Name: ```ConnectionStrings.SJConnection```

Value: ```Data Source=dev.xxxxxxxx.com;Initial Catalog=xxxxxxxxxxxx;User Id=xxxxxxxxxxxxxx;Password=xxxxxxxxxxxxx;```

Scope: (whatever)


