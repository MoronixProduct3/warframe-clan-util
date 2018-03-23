<#  
    This script extracts the json data structure containing the attributes of a clan.
    The current approach for this script is to dump the process memory and parse it
    to retreive the string matching the clan data structure.

    The formatted json is saved to disk alongside the process dump.
    The proccess dump is overwritten every time the script executes.

    Before executing:
        - Make sure to run the setup script before
        - Login through the game client. The player account must be part of a clan.
        - Leave the game client idle, in orbiter, with no menus open
    
    Potential data extracted (what to expect in the json):
        - Clan ID (if available)
        - Clan Name
        - Creator (you or not)
        - Members
        - Ranks
        - XP
        - Tier
        - Contributions
#>
#Requires -Version 5

# The memory dump location
$dumpPath = "$PSScriptRoot\..\dumps"
$dumpFile = "$dumpPath\clanDump.dmp"
# The json output location
$outputPath = "$PSScriptRoot\..\output"

# Start of script
Write-Host "`nStarting Data Extration script"

# Check if warframe is running
Write-Host "`nChecking for client status ..."
$WarframeProcess = Get-Process -Name Warframe.x64 -ErrorAction SilentlyContinue
if (-Not $WarframeProcess) {
    Write-Host "[ERROR] Warframe.x64 is not currently running" -ForegroundColor Red
    Read-Host -Prompt "Press Enter to exit"
    exit
} 
Write-Host "[OK] Aqcuired Warframe.x64 PID: $($WarframeProcess.Id)" -ForegroundColor Green

# Different factor will affect the window during which the clan data will be available in plain text in memory.
# To metigate this effect, multiple will be take with an incrementing delay after the request.
# For now a simple delay is used. A more comprehensive approach would be to monitor the process for Network requests and responses.
$delayMs = 0
Do
{
    # Iteration of delay
    $delayMs += 200 # stepping by 200 ms
    If ($delayMs -gt 1600)  # Max 1.6 s wait
    {
        Write-Host "[ERROR] Could not find clan data. Make sure you are part of a clan." -ForegroundColor Red
        Read-Host -Prompt "Press Enter to exit"
        exit
    }
    Write-Host "`nTrying to acquire data with $delayMs ms delay." -ForegroundColor Blue -BackgroundColor White

    # Setting client as active window
    Write-Host "`nSetting Warframe client as active window ..."
    $ErrorAHK = & "$PSScriptRoot\..\lib\autohotkey\AutoHotkeyU64.exe" "$PSScriptRoot\..\ahk_scripts\setWindow.ahk" | more
    if ($ErrorAHK) {
        Write-Host $ErrorAHK -ForegroundColor Red
        Read-Host -Prompt "Press Enter to exit"
        exit
    } else {
        Write-Host "[OK] Set WARFRAME as active window." -ForegroundColor Green
    }

    # Triggering Clan data transaction
    Write-Host "`nNavigating to Clan Window ..."
    $ErrorAHK = & "$PSScriptRoot\..\lib\autohotkey\AutoHotkeyU64.exe" "$PSScriptRoot\..\ahk_scripts\gotoClan.ahk" | more
    if ($ErrorAHK) {
        Write-Host $ErrorAHK -ForegroundColor Red
        Read-Host -Prompt "Press Enter to exit"
        exit
    } else {
        Write-Host "[OK] Navigated to Clan page" -ForegroundColor Green
    }

    # Waiting for Warframe client to retrieve the data
    Write-Host "`nWaiting for Warframe to fetch the data ..."
    Start-Sleep -Milliseconds $delayMs
    Write-Host "[OK] Waited $delayMs ms" -ForegroundColor Green

    # Dumping process memory
    Write-Host "`nReading process memory ..."
    New-Item -ItemType Directory -Force -Path $dumpPath | Out-Null
    If(!(test-path $dumpPath)) { New-Item -ItemType Directory -Force -Path $dumpPath }
    & "$PSScriptRoot\..\lib\procdump\procdump64.exe" -o -ma $WarframeProcess.Id $dumpFile
    if($LASTEXITCODE -eq 1) {
        Write-Host "[OK] Successfully created dump: $dumpFile" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Failed to dump process memory"
        Read-Host -Prompt "Press Enter to exit"
        exit
    }

    # Minimize warframe client
    $ErrorAHK = & "$PSScriptRoot\..\lib\autohotkey\AutoHotkeyU64.exe" "$PSScriptRoot\..\ahk_scripts\minimiseWindow.ahk" | more
    if ($ErrorAHK) {
        Write-Host "`n[WARNING] Trouble minimizing the Warframe client"
        # Write-Host $ErrorAHK -ForegroundColor Red
        # Read-Host -Prompt "Press Enter to exit"
        # exit
    } else {
        # Write-Host "[OK] Minimized client" -ForegroundColor Green
    }

    # Analysing memory dump
    Write-Host "`nInspecting memory dump ..."
    . "$PSScriptRoot\..\psFunctions\grepClan.ps1"   # Include file seach function
    $clanStructures = Find-Clan $dumpFile
    Write-Host "Found $($clanStructures.Count) clan structures"
    
} While ($clanStructures.Count -lt 1) 
If ($clanStructures.Count -gt 1) {
    Write-Host "[WARNING] More than one clan structure was found." -ForegroundColor Yellow
}
Else {
    Write-Host "[OK] Found clan data structure in memory" -ForegroundColor Green
}

# Saving Extracted data
Write-Host "`nSaving extracted data ..."
If(!(test-path $outputPath)) { New-Item -ItemType Directory -Force -Path $outputPath }
$currentOutputPath = "$outputPath\$(Get-Date -f dd-MM-yyyy_HH_mm_ss)"
$outputFile = "$currentOutputPath\clanDump.json"
New-Item -ItemType Directory -Force -Path $currentOutputPath
$outputJson = "{clans:["
Foreach ($clan in $clanStructures.Values)
{
    $outputJson += "{$($clan)},"
}
$outputJson = $outputJson.Substring(0,$outputJson.Length-1) # removing trailing comma
$outputJson += "]}"
$outputJson >> $outputFile
notepad.exe $outputFile

# End script
Write-Host "`n[SUCCES] Successfully extracted clan data" -ForegroundColor Green