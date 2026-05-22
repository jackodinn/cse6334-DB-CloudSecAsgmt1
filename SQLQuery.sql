=========================================================================
-- 1. SERVER-LEVEL LOGINS (The Front Door Keys)
-- =========================================================================
USE [master];
GO

-- Create Admin Login
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'Admin_DB_User')
BEGIN
    CREATE LOGIN [Admin_DB_User] 
    WITH PASSWORD = N'ChangeThisToAStrongAdminPassword123!', 
    DEFAULT_DATABASE = [DataSec], 
    CHECK_EXPIRATION = OFF, 
    CHECK_POLICY = ON;
    PRINT 'Server Login for Admin_DB_User created successfully.';
END
ELSE
BEGIN
    PRINT 'Server Login for Admin_DB_User already exists.';
END
GO

-- Create Staff Login
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'Staff_DB_User')
BEGIN
    CREATE LOGIN [Staff_DB_User] 
    WITH PASSWORD = N'ChangeThisToAStrongStaffPassword123!', 
    DEFAULT_DATABASE = [DataSec], 
    CHECK_EXPIRATION = OFF, 
    CHECK_POLICY = ON;
    PRINT 'Server Login for Staff_DB_User created successfully.';
END
ELSE
BEGIN
    PRINT 'Server Login for Staff_DB_User already exists.';
END
GO


-- =========================================================================
-- 2. DATABASE-LEVEL USERS (The Room Keys)
-- =========================================================================
USE [DataSec];
GO

-- Map Admin Login to a Database User
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Admin_DB_User')
BEGIN
    CREATE USER [Admin_DB_User] FOR LOGIN [Admin_DB_User];
    PRINT 'Database User for Admin_DB_User created successfully.';
END
ELSE
BEGIN
    PRINT 'Database User for Admin_DB_User already exists.';
END
GO

-- Map Staff Login to a Database User
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Staff_DB_User')
BEGIN
    CREATE USER [Staff_DB_User] FOR LOGIN [Staff_DB_User];
    PRINT 'Database User for Staff_DB_User created successfully.';
END
ELSE
BEGIN
    PRINT 'Database User for Staff_DB_User already exists.';
END
GO


-- =========================================================================
-- 3. ROLE ASSIGNMENTS
-- =========================================================================

-- Admin Permissions: Full administrative ownership over this specific database
ALTER ROLE [db_owner] ADD MEMBER [Admin_DB_User];
PRINT 'Admin_DB_User granted db_owner role successfully.';

-- Staff Permissions: Least Privilege 
ALTER ROLE [db_datareader] ADD MEMBER [Staff_DB_User];
ALTER ROLE [db_datawriter] ADD MEMBER [Staff_DB_User];
PRINT 'Staff_DB_User granted reader/writer roles successfully.';
GO

-- 1. Allow advanced options to be changed
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
GO

-- 2. Enable C2 Audit Mode (1 means ON, 0 means OFF)
EXEC sp_configure 'c2 audit mode', 1;
RECONFIGURE;
GO

-- Restart needed