#NoEnv
#Warn
#ErrorStdOut

; This script minizes the warframe window

; Check if the client is running
If  !WinExist("Warframe"){
    FileAppend, [ERROR] Could not find Warframe window, *
    Exit, -1
}

; Escaping opened menus
Loop, 3 {
    Sleep, 300
    Send, {Escape}
}
Sleep, 300

; Unsetting WARFRAME as active focus
WinMinimize, Warframe