<#  This script will dump the Warframe client memory if available 
    The warframe client should be logged in and before executing #>

#Requires -Version 5

Write-Host "`nStarting Data Extration script"

# Check if warframe is running
Write-Host "`nChecking for client status ..."
$WarframeProcess = Get-Process -Name Warframe.x64 -ErrorAction SilentlyContinue
if (-Not $WarframeProcess) {
    Write-Host "[ERROR] Warframe.x64 is not currently running" -ForegroundColor Red
    exit
} 
Write-Host "[OK] Aqcuired Warframe.x64 PID: $($WarframeProcess.Id)" -ForegroundColor Green


# Setting client as active window
Write-Host "`nSetting Warframe client as active window ..."
$ErrorAHK = & "$PSScriptRoot\..\lib\autohotkey\AutoHotkeyU64.exe" "$PSScriptRoot\..\ahk_scripts\setWindow.ahk" | more
if ($ErrorAHK) {
    Write-Host $ErrorAHK -ForegroundColor Red
    exit
} else {
    Write-Host "[OK] Set WARFRAME as active window." -ForegroundColor Green
}

# Triggering Clan data transaction
Write-Host "`nNavigating to Clan Window ..."
$ErrorAHK = & "$PSScriptRoot\..\lib\autohotkey\AutoHotkeyU64.exe" "$PSScriptRoot\..\ahk_scripts\gotoClan.ahk" | more
if ($ErrorAHK) {
    Write-Host $ErrorAHK -ForegroundColor Red
    exit
} else {
    Write-Host "[OK] Navigated to Clan page" -ForegroundColor Green
}

# Waiting for Warframe client to retrieve the data
$WaitTimeMs = 750
Write-Host "`nWaiting for Warframe to fetch the data ..."
Start-Sleep -Milliseconds $WaitTimeMs
Write-Host "[OK] Waited $WaitTimeMs ms" -ForegroundColor Green

# Dumping process memory
Write-Host "`nReading process memory ..."
$DumpPath = "$PSScriptRoot\..\dumps\clanDump"
& "$PSScriptRoot\..\lib\procdump\procdump64.exe" -o -ma $WarframeProcess.Id $DumpPath

# Analysing memory dump
Write-Host "`nInspecting memory dump ..."


# Extracting Clan Data
Write-Host "`nExtracting Clan Data ..."


# Saving Extracted data
Write-Host "`nSaving extracted data ..."

# Deleting

# End script
Write-Host "`n[SUCCES] Successfully extracted clan data" -ForegroundColor Green