#SingleInstance, force
#Include, wget.ahk

mainDir := "c:\Users\Sage\Desktop\adzium scripts\parser\testDir2"
parsingFile := "parsing-debug.csv"






update(field, text){
	
		guiControl,,%field%, %text%
	
}

validate(input){
	rgx := "[\\\/\*<>:?|""]"
	;~ rgx := "[:\\/><`"\|\*\?]"
	input := RegExReplace(input, rgx, " ")
	return input
	
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

getPathDetails(path){
	msgbox, function called
	
	SplitPath, path, file, dir, ext, name
	fileDetails := {"path":path
		, "file": file
		, "dir": dir
		, "ext": ext
		, "name": name}
	;~ fileDetails.fileDetails := fd
	for k, v in fileDetails{
		if (v != ""){
			msgbox, file details: %k% : %v%
		}
	}
}

Gui, Add, Text, x12 y19 w450 h80 vCurrentFile , File Status
Gui, Add, Text, x12 y109 w450 h80 vFileDetails , File Details
Gui, Add, Edit, x12 y190 w310 r1 vparsingFile, %parsingFile%
Gui, Add, Edit, x12 y230 w310 r1 vMainDir,  %mainDir% 
Gui, Add, Button, x12 y270 w460 h40 gRunparse , PARSE DAT SHIT
Gui, Add, Button, x332 y189 w140 r1 gUpdateSource , Source File
Gui, Add, Button, x332 y229 w140 r1 gUpdateOutput, Output Directory
Gui, Show, w490 h372, Super parser pre-pre alpha version
return

GuiClose:
ExitApp

UpdateSource:
FileSelectFile, parsingFile
update("parsingFile", parsingFile)
return

updateOutput:
FileSelectFolder, mainDir
update("mainDir", mainDir)
return

Runparse:
;~ +^t::
Gui, submit, NoHide

dataCollector 
:= {"state":""
	, "taskFolder":""
	, "fileName":""
	, "articleName":""
	, "placementText":""
	, "pictureLinks":[]}


;~ FileRead, OriginalFileContents, %parsingFile%
;~ getPathDetails(parsingFile)
;~ FileExist, %
;~ FileAppend, %CoreFile%, 

if(true){
loop, read, %parsingFile%
{
	
	dataCollector.pictureLinks := []
	dataCollector.placementText := ""
	
	lineNum := A_Index
	loop, parse, A_LoopReadLine, CSV
	
	{
			
			
			fieldNum := A_Index
			field := A_LoopField
			
			if(field != "" && !(field ~= "i)^[xõ]mood")) {
				
				switch true{
					
					case (fieldNum = 1):
					dataCollector.state := field
					
					;MsgBox, % "Status " . dataCollector.status
					
				
					case (fieldNum = 3):
					field := validate(field)
					dataCollector.taskFolder := field
					
					;MsgBox, % "Folder " . dataCollector.taskFolder
					
					
					case (fieldNum = 4):
					dataCollector.fileName := field
					
					;MsgBox, % "Filename " . dataCollector.fileName
					
					case (fieldNum = 5):
					field := validate(field)
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
						if(dataCollector.placementText != ""){
							createTXT(dataCollector.placementText, subfolder)
						}
						
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
}
