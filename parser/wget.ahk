;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; _    _  _____  _____  _____         ______  _____  _    _  _   _  _      _____   ___  ______ 
;| |  | ||  __ \|  ___||_   _|        |  _  \|  _  || |  | || \ | || |    |  _  | / _ \ |  _  \
;| |  | || |  \/| |__    | |   ______ | | | || | | || |  | ||  \| || |    | | | |/ /_\ \| | | |
;| |/\| || | __ |  __|   | |  |______|| | | || | | || |/\| || . ` || |    | | | ||  _  || | | |
;\  /\  /| |_\ \| |___   | |          | |/ / \ \_/ /\  /\  /| |\  || |____\ \_/ /| | | || |/ / 
; \/  \/  \____/\____/   \_/          |___/   \___/  \/  \/ \_| \_/\_____/ \___/ \_| |_/|___/  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
wget($TEXT = "Downloading...", $URL = "", $TARGET = "", $RETRY = "3", $POSITION = "FALSE", $POSX = "", $POSY = "", $ERRORCLBCK = "")
{
	; Maxrate and other parameters can be added to wget
	; $MAXRATE = 0k 	; --limit-rate=%$MAXRATE%
	; must insert a ^ in front of & on urls because amperstand is a console operator, see next line.
	StringReplace, $URL, $URL, "&", "^&", All	
	
	$CMD = wget --progress=bar:force --no-cache  --retry-connrefused --tries=%$RETRY% --waitretry=1 "%$URL%" --no-check-certificate --auth-no-challenge --output-file "%$TARGET%.status" -O "%$TARGET%"

	Run, %$CMD%, , Hide, $wget_pid
	Process, Exist, %$wget_pid%
	
	IF ($POSITION = "TRUE") {
			Progress, ZH10 B1 CWE6E3E4 CT000020 CBF73D00 FM10 X%$POSX% Y%$POSY%, , %$TEXT%, d_progress, 
	} 
	Else {
		Progress, ZH10 B1 CWE6E3E4 CT000020 CBF73D00 FM10, , %$TEXT%, d_progress, 
	}
	
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
		}
		; Progress, ProgressParam1 [, SubText, MainText, WinTitle, FontName] h46
		if ( L1 is digit )
		{
			if ( L1 > 0 )
			{
				Progress, %L1%
			}
		}
		if ( GetKeyState("Escape", P) = true )
		{
			Progress,100,, Canceling...
			;Process, Close, wget.exe
			Process, Close, %$wget_pid%
			WinWaitClose, ahk_pid %$wget_pid%
			FileDelete, %$TARGET%
		}
		Process, Exist, %$wget_pid%
		Sleep, 50
	}
	Progress,100,, Done.
	Sleep 200
	Progress, Off
	FileGetSize, d_size, %$TARGET%
	if ( d_size > 0 && d_size is digit)
	{
		FileDelete, %$TARGET%.status
		Return true
	}
	else
	{
		;MsgBox, , ERROR, There was a problem accessing the server.`nCheck status file for details., 60
		;FileDelete, %$TARGET%.status
		;FileDelete, %$TARGET%
		Return false
	}
}


wput($TEXT = "Uploading...", $FTPURL = "", $SOURCE = "", $BASENAME = "NONE", $RETRY = "3", $POSITION = "FALSE", $POSX = "", $POSY = "")
{
	L1 = 0
	; --basename="C:\RemoteVT/VTVI/"
	if ( $BASENAME = "NONE" )
	{
		$BASENAME := ""
	} else {
		$BASENAME = --basename="%$BASENAME%"
	}
	
	StringReplace, $URL, $URL, "&", "^&", All	
	
	$CMD = wput -nc -t %$RETRY% --reupload  %$BASENAME% -o "%$SOURCE%.status" "%$SOURCE%" %$FTPURL%
	;MsgBox %$CMD%
	Run, %$CMD%, , Hide, $wput_pid
	Process, Exist, %$wput_pid%
	
	IF ($POSITION = "TRUE") {
		if ($POSX is digit)
			$XVAR = X%$POSX%
		if ($POSY is digit)
			$YVAR = Y%$POSY%
		
		Progress, ZH10 B1 CWE6E3E4 CT000020 CBF73D00 FM10 %$XVAR% %$YVAR%, , %$TEXT%, u_progress, 
	} 
	Else {
		Progress, ZH10 B1 CWE6E3E4 CT000020 CBF73D00 FM10, , %$TEXT%, u_progress, 
	}
	
	while ErrorLevel != 0
	{
		Loop Read, %$SOURCE%.status
		{
			L = %A_LoopReadLine%
			if ( InStr(L, `%) != 0 )
			{
				StringSplit, UploadInfo, L, `%,
				;MsgBox %UploadInfo1%
				StringRight, L1, UploadInfo1, 3
				if ( L1 = "100" )
					Break
			}
		}
		; Progress, ProgressParam1 [, SubText, MainText, WinTitle, FontName] h46
		if ( L1 is digit )
		{
			if ( L1 > 0 )
			{
				if ( InStr(UploadInfo2, "null") != 0 )
				{
					UploadInfo2 =
				}
				Progress, %L1%, , %$TEXT%%UploadInfo2%
			}
		}
		if ( GetKeyState("Escape", P) = true )
		{
			Progress,100,, Canceling...
			;Process, Close, wput.exe
			Process, Close, %$wput_pid%
			WinWaitClose, ahk_pid %$wput_pid%
			;FileDelete, %$TARGET%.status
		}
		Process, Exist, %$wput_pid%
		Sleep, 50
	}
	Progress,100,, Done.
	Sleep 200
	Progress, Off
	Loop Read, %$SOURCE%.status
	{
		L = %A_LoopReadLine%
		IfInString, L, Nothing done.
		{
			Return "failed"
		}
		IfInString, L, FINISHED
		{
			Return "success"
		}
		
	}
	return "failed"
	;FileGetSize, d_size, %$TARGET%
	;if ( d_size > 0 && d_size is digit)
	;{
	;	FileDelete, %$TARGET%.status
	;	Return true
	;}
	;else
	;{
	;	MsgBox There was a problem accessing the server.`nCheck status file for details.
	;	FileDelete, %$TARGET%.status
	;	FileDelete, %$TARGET%
	;	Return false
	;}
}


wput_list($TEXT = "Uploading...", $FTPURL = "", $FILELIST = "", $BASENAME = "NONE", $RETRY = "3")
{
	if FileExist($FILELIST) 
	{
		$file_count = 0
		Loop, Read, %$FILELIST%
		{
			$this_y := A_ScreenHeight / 2 - 48
			$that_y := A_ScreenHeight / 2 + 1

			Progress, 2:ZH10 B1 CWE6E3E4 CT000020 CBF73D00 FM10, , Scanning file(s)..., multi_progress, 
			if FileExist(A_LoopReadLine) 
			{
				$file_count += 1
				
				Progress, 2:, , Scanning %$file_count% file(s),
				Sleep 25
			}
		}
		if ($file_count > 0 )
		{
			Progress, 2:ZH10 B1 CWE6E3E4 CT000020 CBF73D00 FM10 2:R0-%$file_count% Y%$this_y%, , Total %$file_count% file(s),
			Sleep 200
			$current_file_number = 1
			Loop, Read, %$FILELIST%
			{
				if FileExist(A_LoopReadLine) 
				{
					SplitPath, A_LoopReadLine, $current_file_name
					Progress, 2:R0-%$file_count% ZH10 B1 CWE6E3E4 CT000020 CBF73D00 FM10 Y%$this_y% , , %$current_file_name% (%$current_file_number%/%$file_count%), multi_progress, 
					Progress, 2:%$current_file_number% 
					wput( $TEXT, $FTPURL, A_LoopReadLine, $BASENAME, $RETRY, "TRUE", "", $that_y )
					$current_file_number += 1
				}
			}
		} Else {
			msgbox No valid files.
		}
	} Else {
		Msgbox Not a valid list file.
	}
}


Flip( Str) {
 Loop, Parse, Str
  nStr=%A_LoopField%%nStr%
Return nStr
}