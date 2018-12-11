#NoEnv
#Warn
#ErrorStdOut

; This script sets The active window to the warframe UI

; Check if the client is running
If  !WinExist("Warframe"){
    FileAppend, [ERROR] Could not find Warframe window, *
    Exit, -1
}

; Setting WARFRAME as active focus
WinActivate, Warframe
WinMaximize, Warframe
WinGetActiveStats, Warframe, Width, Height, X, Y
MouseMove, Width / 2, Height / 2, 0
Click