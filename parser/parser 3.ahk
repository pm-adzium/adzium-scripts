#SingleInstance, force
#Include, wget.ahk

mainDir := "c:\Users\Sage\Desktop\adzium scripts\parser\testDir2"
parsingFile := "parsing-debug.csv"






update(field, text){
	
		guiControl,,%field%, %text%
	
}

createTXT(text, location){
	;~ msgbox, creating textfile at %location%
	
	if(!FileExist(location "\text.txt")){
		FileAppend,
		(
		%text%
		), %location%\text.txt
	}
}

savePic(message, url, name, output){
	RegExMatch(url, "\w+$", ext)
	
	fileName := name . "." . ext
	update("CurrentFile", "Working on" fileName "`n at " url)
		
	targetPath := output . "\" . fileName
	;msgbox, targetPath is %targetPath%

	try{
		URLDownloadToFile, %url%, %targetPath%
		
		return true
	} catch e {
				
		;errorLocation = %output%\%name%.txt
		
		;createError(, errorLocation)
		
		;run, explorer.exe "%output%"
		
		return false
		
	}
	
	
	
}




Gui, Add, Text, x12 y19 w450 h80 vCurrentFile , File Status
Gui, Add, Text, x12 y109 w450 h80 vFileDetails , File Details
Gui, Add, Button, x12 y289 w450 h40 gRunparse , PARSE DAT SHIT
Gui, Add, Edit, x12 y199 w450 h30 vparsingFile, %parsingFile%
Gui, Add, Edit, x12 y239 w450 h30 vMainDir,  %mainDir% 
Gui, Show, w490 h372, Super parser pre-pre-pre alpha version
return

GuiClose:
ExitApp


;~ ^q::
;~ savePic("https://images.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png", "test", mainDir)
;~ return
Runparse:
+^t::
Gui, submit, NoHide

dataCollector := {}
dataCollector.state := ""
dataCollector.taskFolder := ""
dataCollector.fileName := ""
dataCollector.articleName := ""
dataCollector.placementText := ""
pictureLinks.pictureLinks := []

loop, read, %parsingFile%
{
	
	dataCollector.pictureLinks := []
	
	lineNum := A_Index
	loop, parse, A_LoopReadLine, CSV
	
	{
			
			
			fieldNum := A_Index
			field := A_LoopField
			if(field != "" && !(field ~= "i)^[x�]mood")) {
				
				switch true{
					
					case (fieldNum = 1):
					dataCollector.state := field
					
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
					
					
					
					
					
					
			
					if(dataCollector.state = "FALSE"){
						
						;~ create subfolders if necessary
						
						subfolder := mainDir . "\" . dataCollector.articleName . "\" . dataCollector.taskFolder
							if (!fileExist(subfolder)){
								FileCreateDir, %subfolder%
							}
					
						;~ add textfile
						createTXT(dataCollector.placementText, subfolder)
						
						uCounter := 0
				
						;~ download pictures from links
						
						for k, v in dataCollector.pictureLinks {
							;MsgBox, % "Picture Link" . k . " = " v
							picFile := dataCollector.fileName . "___" . uCounter++
							;intermFile := dataCollector.articleName . "\" . dataCollector.folderName
							;~ msgbox, %intermFile%
							savePic(picFile, v, picFile, subfolder)
							
						}
						
					}
					
					
				summary := ""
					for key, value in dataCollector{
						summary .= key . ": " . value . "`n"
					}
					update("FileDetails", summary)
					
				}
				
				
				
			}
			

	}
	update("CurrentFile", "done")
}	
return
