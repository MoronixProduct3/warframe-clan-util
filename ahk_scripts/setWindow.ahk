#NoEnv
#Warn
#ErrorStdOut

; This script sets The active window to the warframe UI

; Check if the client is running
If  !WinExist("WARFRAME"){
    FileAppend, [ERROR] Could not find WARFRAME window, *
    Exit, -1
}

; Setting WARFRAME as active focus
WinActivate, WARFRAME
WinMaximize, WARFRAME
WinGetActiveStats, WARFRAME, Width, Height, X, Y
MouseMove, Width / 2, Height / 2, 0
Click