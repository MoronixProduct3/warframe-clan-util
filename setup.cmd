@echo off

echo Starting Warframe util setup

REM Saving current directory
SET mypath=%~dp0

REM Asking User for admin privileges
echo Admin privileges are required to execute PowerShell scripts
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit)

REM Running setup
PowerShell.exe -ExecutionPolicy Bypass -File %mypath%scripts\setup.ps1

pause