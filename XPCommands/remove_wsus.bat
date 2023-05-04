@echo off
rem This script removes the registry keys that point Windows Update at the Proxy server.

set key=HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate
echo.
reg delete %key% /v WUServer /f
reg delete %key% /v WUStatusServer /f
reg delete %key%\AU /v UseWUServer /f
rem net stop wuauserv 2>nul
echo.
echo Deleted WSUS Server from regisry
echo Press any key to exit.
pause >nul
