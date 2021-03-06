:setvar DatabaseName
:setvar DatabasePath

USE [master];
GO

IF DB_ID('$(DatabaseName)') IS NOT NULL
BEGIN
	EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'$(DatabaseName)';
	ALTER DATABASE [$(DatabaseName)] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [$(DatabaseName)];
END
GO

CREATE DATABASE [$(DatabaseName)]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'$(DatabaseName)', FILENAME = N'$(DatabasePath)\$(DatabaseName).mdf' , SIZE = 4096KB , FILEGROWTH = 1024KB ), 
 FILEGROUP [USERDATA] 
( NAME = N'$(DatabaseName)_data', FILENAME = N'$(DatabasePath)\$(DatabaseName)_data.ndf' , SIZE = 4096KB , FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'$(DatabaseName)_log', FILENAME = N'$(DatabasePath)\$(DatabaseName)_log.ldf' , SIZE = 1024KB , FILEGROWTH = 10%)
GO
USE [$(DatabaseName)]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'USERDATA') ALTER DATABASE [$(DatabaseName)] MODIFY FILEGROUP [USERDATA] DEFAULT
GO

USE [$(DatabaseName)];
GO

IF OBJECT_ID('Demo.proc_Users_Add') IS NOT NULL
	DROP PROCEDURE Demo.proc_Users_Add;
GO
IF OBJECT_ID('Demo.Users') IS NOT NULL
	DROP TABLE Demo.Users;
GO

IF EXISTS(SELECT 1 FROM sys.schemas WHERE name = 'Demo')
	DROP SCHEMA Demo;
GO

CREATE SCHEMA Demo;
GO

CREATE TABLE Demo.Users
(
	  UserId int NOT NULL
	, FirstName varchar(30) NOT NULL
	, LastName varchar(30) NOT NULL
	, Age tinyint NOT NULL
	, UserStatusId tinyint NOT NULL
	, CONSTRAINT PK_DemoUsers PRIMARY KEY CLUSTERED
	(
		UserId
	)
);
GO

INSERT INTO Demo.Users (UserId, FirstName, LastName, Age, UserStatusId)
VALUES 
	(1, 'Marco', 'Parenzan', 25, 1),
	(2, 'Marco', 'Pozzan', 25, 1),
	(3, 'Gilberto', 'Zampatti', 25, 1),
	(4, 'Alessandro', 'Alpi', 25, 1);
GO

CREATE PROCEDURE Demo.proc_Users_Add
	  @UserId int
	, @FirstName varchar(30)
	, @LastName varchar(30)
	, @Age tinyint
	, @UserStatusId tinyint
	, @Error int OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM Demo.Users WHERE UserId = @UserId)
	BEGIN
		SET @Error = 100;
		SELECT CAST(@Error AS varchar(5)) + ' - User already exists!';
		RETURN;
	END;

	INSERT INTO Demo.Users (UserId, FirstName, LastName, Age, UserStatusId)
	VALUES (@UserId, @FirstName, @LastName, @Age, @UserStatusId);

	SET @Error = 1; --OK
END;
GO