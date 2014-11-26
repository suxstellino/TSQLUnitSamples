DECLARE @Success bit;
DECLARE @TestCount bit;
DECLARE @FailureCount bit;
DECLARE @ErrorCount bit;

-- test execution
EXEC dbo.tsu_runTests
    @suite			= N'DemoUsers'
  , @success		= @Success out
  , @testCount		= @TestCount out
  , @failureCount	= @FailureCount out
  , @errorCount		= @ErrorCount out;

SELECT Success = @Success, TestCount = @TestCount, FailureCount = @FailureCount, ErrorCount = @ErrorCount;
GO

