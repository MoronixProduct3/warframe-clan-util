<#
    This script makes sure all the ressources are available to start using the tool
#>

$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path

Import-Module BitsTransfer

# Checking for 64-bit OS
if ([System.IntPtr]::Size -eq 8){
    Write-Host "`nRunning on 64 bit [OK]" -ForegroundColor Green
} else {
    Write-Host "`nError this software is intended for 64 bit only" -ForegroundColor Red
    exit
}

# Checking PowerShell version
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Host "`nPlease install PowerShell 5.1 or more." -ForegroundColor Red
    Write-Host "Instaler can be found here:"
    Write-Host "https://docs.microsoft.com/en-us/powershell/wmf/5.1/install-configure"
    Write-Host "Restart the setup process once this is complete`n"
    
    exit
}
else {
    Write-Host "`nPowerShell Version $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor) [OK]" -ForegroundColor Green
}

# Setting execution policy for future script runs
Write-Host "`nSetting MachineLevel Execution Policy to Bypass" -ForegroundColor Yellow
Set-ExecutionPolicy Bypass -Scope LocalMachine -Force

# Installing ProcDump
Write-Host "`nInstalling ProcDump ..."
$procdump_url = "https://download.sysinternals.com/files/Procdump.zip"
$procdump_path = "$ScriptDir\..\lib\procdump\"
$procdump_zip = $procdump_path + "procdump.zip"
New-Item -ItemType Directory -Force -Path $procdump_path | Out-Null
Start-BitsTransfer -Source $procdump_url -Destination $procdump_zip
Expand-Archive -Force -LiteralPath $procdump_zip -DestinationPath $procdump_path
Remove-Item -Path $procdump_zip
Write-Host "[DONE]" -ForegroundColor Green

# Installing AutoHotkey
Write-Host "`nInstalling AutoHotkey ..."
$ahk_url = "https://autohotkey.com/download/1.1/AutoHotkey_1.1.28.00.zip"
$ahk_path = "$ScriptDir\..\lib\autohotkey\"
$ahk_zip = $procdump_path + "ahk.zip"
New-Item -ItemType Directory -Force -Path $ahk_path | Out-Null
Start-BitsTransfer -Source $ahk_url -Destination $ahk_zip
Expand-Archive -Force -LiteralPath $ahk_zip -DestinationPath $ahk_path
Remove-Item -Path $ahk_zip
Write-Host "[DONE]" -ForegroundColor Green

# End script
Write-Host "`nFinished installation" -ForegroundColor Green