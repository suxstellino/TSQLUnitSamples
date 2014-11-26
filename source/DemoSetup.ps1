<#
    Unit testing with tSQLUnit framework - setup script v1.0 by Alessandro Alpi
    
    PARAMETERS
    Every parameter is specified after a :setvar keyword.
    - $DatabaseName: it's the name of the target database. The framework and demonstration objects will be installed on this database.
    - $DatavasePath: it's your path where your test database will be installed to.

    OUTCOME
    You will find a database created with test framework objects (tsu_*) and a set of user objects:

    - A Schema "Demo"
    - A Table "Demo.Users" with 4 rows
    - A Stored Procedure "Demo.proc_Users_Add"
#>

cls
$CurrentFolder = Split-Path $MyInvocation.MyCommand.Definition -Parent
$DatabaseCreateScript = Join-Path -Path $CurrentFolder -ChildPath "01_CreateDatabaseAndSchema.sql"
$FrameworkInstallScript = Join-Path -Path $CurrentFolder -ChildPath "02_FrameworkInstall.sql"
$DemoTestProceduresScript = Join-Path -Path $CurrentFolder -ChildPath "03_TestSetup.sql"

Write-Host "Unit testing with tSQLUnit framework - setup script v1.0 by Alessandro Alpi. Hit ENTER to continue, ESC to quit.." -ForegroundColor Cyan
$x = $host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
if ($x.VirtualKeyCode -eq [char]27) {
    Return
}

#server name
Write-Host "Server name (hit ENTER for local server): " -ForegroundColor White -NoNewline
$ServerName = Read-Host 

if (-Not $ServerName)
{
    $ServerName = "."
}

#instance name
Write-Host "Instance name (hit ENTER for default instance): " -ForegroundColor White -NoNewline
$InstanceName = Read-Host 

if (-Not $InstanceName)
{
    $InstanceName = ""
}

$FullServerName = Join-Path -Path $ServerName -ChildPath $InstanceName

#database name
Write-Host "Test database name: " -ForegroundColor White -NoNewline
$DatabaseName = Read-Host 

if (-Not $DatabaseName)
{
    $DatabaseName = "UnitTestDatabase"
}

#databases path
Write-Host "Test database path (drive included): " -ForegroundColor White -NoNewline
$DatabasesPath = Read-Host 

if (-Not $DatabasesPath)
{
    $DatabasesPath = "C:\__TestDatabases"
}

#full database path
$DatabaseFullPath = Join-Path -path $DatabasesPath -ChildPath $DatabaseName

if (Test-Path $DatabaseFullPath -IsValid -PathType Container)
{
    if (-Not (Test-Path $DatabaseFullPath))
    {
        New-Item -ItemType directory -Path $DatabaseFullPath | Out-Null
        Write-Host "Folder '$DatabaseFullPath' created!" -ForegroundColor Green
    } 
    else
    {
        Write-Host "Folder '$DatabaseFullPath' already exists.. no action required." -ForegroundColor Yellow
    }
} 

Write-Host "Creating database '$DatabaseName' and database schema.." -ForegroundColor White
#database creation
Invoke-Sqlcmd -inputfile $DatabaseCreateScript -serverinstance $FullServerName -Variable DatabaseName="$DatabaseName", DatabasePath="$DatabaseFullPath"
Write-Host "Database '$DatabaseName' created successfully!" -ForegroundColor Green

Write-Host "Installing tSQLUnit framework on database '$DatabaseName'.." -ForegroundColor White
#tSQLUnit framework setup
Invoke-Sqlcmd -inputfile $FrameworkInstallScript -serverinstance $FullServerName -Variable DatabaseName="$DatabaseName"
Write-Host "tSQLUnit installed successfully!" -ForegroundColor Green

Write-Host "Installing demo test procedures on database '$DatabaseName'.." -ForegroundColor White
#demo test procedures
Invoke-Sqlcmd -inputfile $DemoTestProceduresScript -serverinstance $FullServerName -Variable DatabaseName="$DatabaseName"
Write-Host "Demo test procedures installed successfully!" -ForegroundColor Green

Write-Host "Done. You can open SampleTestExecutions.sql script in order to try tSQLUnit. Hit ENTER to close.." -ForegroundColor Cyan
Read-Host