@echo off
setlocal

set "ROOT_DIR=repo-root"

echo Creating folder structure in %ROOT_DIR%...

:: Function to create the base 'Server' structure
:CreateServerStructure
set "BASE_PATH=%~1"
if not exist "%BASE_PATH%\Server\SQLServer\Demo-TEXT\MyDatabase" mkdir "%BASE_PATH%\Server\SQLServer\Demo-TEXT\MyDatabase"
mkdir "%BASE_PATH%\Server\SQLServer\Demo-TEXT\MyDatabase\tables"
mkdir "%BASE_PATH%\Server\SQLServer\Demo-TEXT\MyDatabase\views"
mkdir "%BASE_PATH%\Server\SQLServer\Demo-TEXT\MyDatabase\procedures"
mkdir "%BASE_PATH%\Server\SQLServer\Demo-TEXT\MyDatabase\functions"
type nul > "%BASE_PATH%\Server\SQLServer\Demo-TEXT\MyDatabase\flyway.toml"

if not exist "%BASE_PATH%\Server\Oracle\MyOracleContainer\ORCL" mkdir "%BASE_PATH%\Server\Oracle\MyOracleContainer\ORCL"
mkdir "%BASE_PATH%\Server\Oracle\MyOracleContainer\ORCL\tables"
mkdir "%BASE_PATH%\Server\Oracle\MyOracleContainer\ORCL\views"
mkdir "%BASE_PATH%\Server\Oracle\MyOracleContainer\ORCL\procedures"
mkdir "%BASE_PATH%\Server\Oracle\MyOracleContainer\ORCL\functions"
type nul > "%BASE_PATH%\Server\Oracle\MyOracleContainer\ORCL\flyway.toml"
exit /b

:: Create main root directory
if not exist "%ROOT_DIR%" mkdir "%ROOT_DIR%"

:: Create structure for 'dev'
if not exist "%ROOT_DIR%\dev" mkdir "%ROOT_DIR%\dev"
call :CreateServerStructure "%ROOT_DIR%\dev"
type nul > "%ROOT_DIR%\dev\Jenkinsfile"

:: Create structure for 'qa'
if not exist "%ROOT_DIR%\qa" mkdir "%ROOT_DIR%\qa"
call :CreateServerStructure "%ROOT_DIR%\qa"
type nul > "%ROOT_DIR%\qa\Jenkinsfile"

:: Create structure for 'prod'
if not exist "%ROOT_DIR%\prod" mkdir "%ROOT_DIR%\prod"
call :CreateServerStructure "%ROOT_DIR%\prod"
type nul > "%ROOT_DIR%\prod\Jenkinsfile"

echo Folder structure created successfully.
endlocal
pause