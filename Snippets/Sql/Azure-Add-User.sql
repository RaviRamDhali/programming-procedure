-- User Master
CREATE USER [web_app] FOR LOGIN [dev_app]
GO
ALTER LOGIN [web_app] WITH PASSWORD = '***********************';

-- Database Level Permissions
GRANT EXECUTE TO [web_app]
ALTER USER [web_app] FOR LOGIN [web_app]
GO
GRANT EXECUTE TO [dev_app]
ALTER ROLE [db_owner] ADD MEMBER [web_app]
GO
