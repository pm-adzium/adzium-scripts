#IfWinActive, ahk_exe TOTALCMD.EXE

SetKeyDelay,0, 50

^1::
send, !^+{p}
return

^2::
send, !^{p}
return