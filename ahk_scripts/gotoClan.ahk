#NoEnv
#Warn
#ErrorStdOut

; This script navigates to the clan pannel from the orbiter

; Check if the client is currently in focus
If  !WinActive("Warframe"){
    FileAppend, [ERROR] Warframe is not currently the focused window, *
    Exit, -1
}

; Navigating to clan pannel
Send, {Escape} ; Opening menu
Sleep, 600
MouseMove, 100, 200 , 0
Sleep, 800
Loop, 5 {
    Send, {Down}
    Sleep, 150
}
Send, {Enter} ; Communications menu
Sleep, 500
Loop, 2 {
    Send, {Up}
    Sleep, 150
}
Send, {Enter} ; Clan pane