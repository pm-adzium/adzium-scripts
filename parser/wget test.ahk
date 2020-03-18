;
;
; ahk-wget w/ progress by MetaCognition. 2014.
;
;

; Hotkey to terminate Downloads.
Hotkey, Escape, EarlyTerm 

; pid for wget_pid
$wget_pid = ""

d_url = http://ahkscript.org/download/1.1/AutoHotkey111605_Install.exe 		;url of file to download 
SplitPath, d_url, d_file										;this line will pull the file name from above url
d_target = %A_Desktop%\%d_file%									;target is where to save file
d_text = Downloading Autohotkey									;target is where to save file

wget(d_text, d_url, d_target) ; get the file

wget($TEXT = "downloading...", $URL = "", $TARGET = "", $RETRY = "3")
{
	Global $wget_pid
	; Maxrate and other parameters can be added to wget
	; $MAXRATE = 0k 	; --limit-rate=%$MAXRATE%
	; must insert a ^ in front of & on urls because amperstand is a console operator, see next line.
	StringReplace, $URL, $URL, "&", "^&", All	
	$CMD = wget -O "%$TARGET%" --progress=bar:force --no-cache --tries=%$RETRY% --retry-connrefused --waitretry=1 "%$URL%" 1>"%$TARGET%.status" 2>&1
	;msgbox %$CMD%
	Run, %comspec% /c %$CMD%, , Hide,$wget_pid
	Process, Exist, %$wget_pid%
	; Customise the progress bar as you see fit!
	Progress, ZH10 B1 CWE6E3E4 CT000020 CBF73D00, , %$TEXT%, d_progress, 
	;WinSet, Transparent, 210, d_progress
	$lastline = 
	while ErrorLevel != 0
	{
		Loop Read, %$TARGET%.status
		{
			L = %A_LoopReadLine%
			if ( InStr(L, `%) != 0 )
			{
				StringSplit, DownloadInfo, L, `%,
				StringLeft, L1, DownloadInfo1, 3
				if ( L1 = "100" )
					Break
			}
			if ( InStr(L, `%) = 0 )
				L = 0
		}
		; Progress, ProgressParam1 [, SubText, MainText, WinTitle, FontName] h46
		if ( L1 is digit )
			Progress, %L1% 
		Process, Exist, %$wget_pid%
		Sleep, 50
	}
	sleep 200
	Progress, Off
	FileGetSize, d_size, %$TARGET%
	if d_size > 0
	{
		FileDelete, %$TARGET%.status
		Return true
	}
	else
	{
		MsgBox There was a problem accessing the server.`nCheck status file for details.
		FileDelete, %$TARGET%.status
		Return false
	}
}

EarlyTerm:     ;;;STEP TO END THE HOTKEY FROM RUNNIN
	Process, Close, %$wget_pid%
Return