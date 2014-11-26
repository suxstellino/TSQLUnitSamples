TSQLUnitSamples
===============

Execute DemoSetup.ps1 as administrator.
Once the script has been executed successfully, you will find:

- a table called "Demo.Users" with 4 records
- two sample test procedures:
	- dbo.ut_DemoUsers_Add
	- dbo.ut_DemoUsers_AddMany
- a setup procedure called "dbo.ut_DemoUsers_setup" used for preparing data just before each test
- a teardown procedure called "dbo.ut_DemoUsers_teardown" for getting the situation just before the test execution

You can see sample TestSuite executions on "SampleTestExecutions.sql" script.

The execution structure is:
- _setup procedure
- test
- _teardown procedure

This behavior is repeated for each test suite and for each "ut_" procedure with suffix which does not contains "_setup" or "_teardown".

If you want to create a new test suite you may have to create new procedure(s). For instance, if you want to create a MyTest test suite you have to create the "ut_MyTest_something" procedure. If you want to add setup and/or teardown procedure, you need to create "ut_MyTest_setup" and/or "ut_MyTest_teardown". For further details about tSQLUnit framework, watch my slide deck [here](http://www.slideshare.net/suxstellino/eng-sql-saturday-355-in-parma-test-your-sql-server-databases). 
TSQLUnit is just one of the three framework I describe in slides).




