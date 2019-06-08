#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Auto execute section is the region before any return/hotkey


#Include  %A_ScriptDir%/IME.ahk
#Include  %A_ScriptDir%/IME-setting.ahk
#Include  %A_ScriptDir%/settings-for-each-app.ahk
#Include  %A_ScriptDir%/misc-setting.ahk
Return