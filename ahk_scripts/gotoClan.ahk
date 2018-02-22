#NoEnv
#Warn
#ErrorStdOut

; This script navigates to the clan pannel from the orbiter

; Check if the client is currently in focus
If  !WinActive("WARFRAME"){
    FileAppend, [ERROR] WARFRAME is not currently the focused window, *
    Exit, -1
}

; Navigating to clan pannel
Send, {Escape} ; Opening menu
Sleep, 600
Loop, 5 {
    Send, {Down}
    Sleep, 100
}
Send, {Enter} ; Communications menu
Sleep, 500
Loop, 2 {
    Send, {Down}
    Sleep, 100
}
Send, {Enter} ; Clan pane