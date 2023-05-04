@echo off
rem This script sets the registry keys to point Windows Update at the Proxy server.

set result=F
IF "%1"=="-h" set result=T
IF "%1"=="--help" set result=T
IF "%1"=="/?" set result=T
IF "%result%"=="T" (
    call :printUse
    call :exitFunc
    exit /B
)

IF "%1"=="" (
    echo ERROR: Must provide a Proxy server.
    echo:
    call :printUse

    call :exitFunc
    exit /B
)

set server=%1
IF "%2"=="" (
  set port=8530
) ELSE (
  set port=%2
)

echo The server is at %server% on port %port%

set key=HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate
echo:
reg add %key% /v WUServer /t REG_SZ /d "http://%server%:%port%/?" /f
reg add %key% /v WUStatusServer /t REG_SZ /d "http://%server%:%port%/?" /f
reg add %key%\AU /v UseWUServer /t REG_DWORD /d 1 /f
rem net stop wuauserv 2>nul
echo:

:exitFunc
    echo:
    echo Press any key to exit.
    pause >nul
    exit /B

:printUse
    echo USE: add_wsus.cmd ^<server ip^> [^<server port^>]
    echo EXAMPLE: add_wsus.cmd 192.168.2.246
    echo The server port is not required and defaults to '8530'
    echo Please note that you must use CMD.exe or run with Win+R to set the arguments.
    exit /B
