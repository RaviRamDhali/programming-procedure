https://www.mssqltips.com/sqlservertip/2995/how-to-hide-sql-server-user-databases-in-sql-server-management-studio/

https://subhrosaha.wordpress.com/2012/04/26/sql-server-error-the-proposed-new-database-owner-is-already-a-user-or-aliased-in-the-database/

-- Database owners by running: 
```sp_helpdb```

-- Lockdown database from SSMS 
```USE MASTER
GO
DENY VIEW ANY DATABASE TO PUBLIC
GO
```

-- Remove any residual user role
```USE DBName
GO
SP_DROPUSER myuser
```

-- Add dbowner
```USE DBName
GO
SP_CHANGEDBOWNER myuser
```
