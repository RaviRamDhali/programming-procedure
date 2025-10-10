## Addmin Users to Azure SQL

In your database (not master):

```
CREATE USER [dev_app] WITH PASSWORD = 'xxxxxxxxxxxxxxxxxxxxxxxxxx';
EXEC sp_addrolemember 'db_datareader', 'dev_app';
EXEC sp_addrolemember 'db_datawriter', 'dev_app';
GRANT EXECUTE TO [dev_app];
```
