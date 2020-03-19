#SingleInstance, force
#Include, wget.ahk

mainDir := "c:\Users\Sage\Desktop\adzium scripts\parser\testDir2"
;mainDir := "c:/Users/Sage/Desktop/adzium scripts/parser/testDir"

savePic(url, name, output){
		
	;MsgBox, loading from %url%
	StringReplace, url, url, "&", "^&", All
	
	RegExMatch(url, "\w+$", ext)
	
	fileName := name . "." . ext
	;MsgBox, filename is %fileName%

	
	
	targetPath := output . "\" . fileName
	;msgbox, targetPath is %targetPath%
	
	messageText := "parsing file " . message
	;wget(messageText, url, targetPath, "0")
	
	
	curl := "curl " . """" . url . """" . " > " . """" . targetPath . """"
	
	RunWait, %ComSpec% /k %curl%, ,, $console
	WinWait, ahk_pid %$console%
	msgbox, 11

	
	
	if(errorlevel){
		msgbox, % "ERROR WITH THIS BITCH " . targetPath
	}
}


^e::

savePic("https://www.dhresource.com/0x0/f2/albu/g7/M01/28/23/rBVaSVti8MqAY2iuAAG6Vn2F_EA380.jpg", "ffs11", mainDir)
return

;~ ^q::
;~ savePic("https://images.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png", "test", mainDir)
;~ return

^t::
loop, read, parse-test-file (2).csv
{
	dataCollector := {}
	dataCollector.pictureLinks := []
	
	lineNum := A_Index
	loop, parse, A_LoopReadLine, CSV
	
	{
			
			
			fieldNum := A_Index
			field := A_LoopField
			if(field != "" && !(field ~= "i)^[x�]mood")) {
				
				switch true{
					
					case (fieldNum = 1):
					dataCollector.status := field
					
					;MsgBox, % "Status " . dataCollector.status
					
				
					case (fieldNum = 3):
					dataCollector.taskFolder := field
					
					;MsgBox, % "Folder " . dataCollector.taskFolder
					
					
					case (fieldNum = 4):
					dataCollector.fileName := field
					
					;MsgBox, % "Filename " . dataCollector.fileName
					
					case (fieldNum = 5):
					dataCollector.articleName := field
					
					;MsgBox, % "Article " . dataCollector.articleName . ""
					
					case (fieldNum = 6):
					dataCollector.placementText := field
					
					;MsgBox, % "Picture text " . dataCollector.placementText
					
					case (fieldNum >= 8):
					dataCollector.pictureLinks.push(field)
					
					
					;~ create subfolders if necessary
					
					subfolder := mainDir . "\" . dataCollector.articleName . "\" . dataCollector.taskFolder
					if (!fileExist(subfolder)){
						FileCreateDir, %subfolder%
					}
					
					;~ download pictures from links
					
					uCounter := 0
					
					for k, v in dataCollector.pictureLinks {
						;MsgBox, % "Picture Link" . k . " = " v
						picFile := dataCollector.fileName . "___" . uCounter++
						;intermFile := dataCollector.articleName . "\" . dataCollector.folderName
						;~ msgbox, %intermFile%
						savePic(v, picFile, subfolder)
					}
					
				}
				;~ MsgBox, Line: %lineNum% Field index: %FieldNum% Field: %Field% 
				;~ summary := ""
				;~ for key, value in dataCollector{
					;~ summary .= key . ": " . value . "`n"
				;~ }
				
				
			}

	}
	;~ MsgBox, SUMMARY`n%summary%
}	
return

