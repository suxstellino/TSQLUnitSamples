:setvar DatabaseName

USE [$(DatabaseName)];
GO

IF OBJECT_ID('dbo.ut_DemoUsers_Add') IS NOT NULL
	DROP PROCEDURE dbo.ut_DemoUsers_Add;
GO

CREATE PROCEDURE dbo.ut_DemoUsers_Add
AS
BEGIN

  -- Assemble
  DECLARE @e int = 100;

  -- Act
  EXEC Demo.proc_Users_Add
      @UserId = 1000
    , @FirstName = 'Thousand'
    , @LastName = 'User'
    , @Age = 30
    , @UserStatusId = 1
    , @Error = @e OUT;
  
  -- Assert
  IF @e <> 1
    EXEC tsu_failure 'A new record was not created for table MyTable.'

END
GO

IF OBJECT_ID('dbo.ut_DemoUsers_AddMany') IS NOT NULL
	DROP PROCEDURE dbo.ut_DemoUsers_AddMany;
GO

CREATE PROCEDURE dbo.ut_DemoUsers_AddMany
AS
BEGIN

  -- Assemble
  DECLARE @e int = 100;

  -- Act
  EXEC Demo.proc_Users_Add
      @UserId = 1000
    , @FirstName = 'Thousand'
    , @LastName = 'User'
    , @Age = 30
    , @UserStatusId = 1
    , @Error = @e OUT;
	
  -- Assert
  IF @e <> 1
    EXEC tsu_failure 'A new record was not created for table MyTable.'

  EXEC Demo.proc_Users_Add
      @UserId = 2000
    , @FirstName = 'Thousand'
    , @LastName = 'User'
    , @Age = 30
    , @UserStatusId = 1
    , @Error = @e OUT;
  
  -- Assert
  IF @e <> 1
    EXEC tsu_failure 'A new record was not created for table MyTable.'

END
GO


-- SETUP & TEARDOWN
IF OBJECT_ID('dbo.ut_DemoUsers_setup') IS NOT NULL
	DROP PROCEDURE dbo.ut_DemoUsers_setup;
GO

CREATE PROCEDURE dbo.ut_DemoUsers_setup
AS
BEGIN

	DELETE FROM Demo.Users;
	
END
GO

IF OBJECT_ID('dbo.ut_DemoUsers_teardown') IS NOT NULL
	DROP PROCEDURE dbo.ut_DemoUsers_teardown;
GO

CREATE PROCEDURE dbo.ut_DemoUsers_teardown
AS
BEGIN

	INSERT INTO Demo.Users (UserId, FirstName, LastName, Age, UserStatusId)
	VALUES 
		(1, 'Marco', 'Parenzan', 25, 1),
		(2, 'Marco', 'Pozzan', 25, 1),
		(3, 'Gilberto', 'Zampatti', 25, 1),
		(4, 'Alessandro', 'Alpi', 25, 1);
	
END
GO