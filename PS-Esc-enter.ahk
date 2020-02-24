#InstallKeybdHook
#IfWinActive, ahk_exe Photoshop.exe
#SingleInstance, force
^Esc::
Send, {Enter}
return

+d::
Send, ^{[}
return

+e::
send, ^{]}
return


#IfWinActive
!s::Suspend, toggle
