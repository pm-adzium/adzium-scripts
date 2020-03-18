#SingleInstance, force

dataCollector(data){
static collectedData := {}
	



}



^t::
loop, read, parse-test-file (1).csv
{
	dataCollector := {}
	dataCollector.pictureLinks := []
	lineNum := A_Index
	loop, parse, A_LoopReadLine, CSV
	{
			
			
			fieldNum := A_Index
			field := A_LoopField
			if(field != "" && !(field ~= "i)^[xõ]mood")) {
				
				switch true{
					
					case (fieldNum = 1):
					dataCollector.status := field
					
					MsgBox, % "Status " . dataCollector.status
					
				
					case (fieldNum = 3):
					dataCollector.taskFolder := field
					
					MsgBox, % "Folder " . dataCollector.taskFolder
					
					
					case (fieldNum = 4):
					dataCollector.fileName := field
					
					MsgBox, % "Filename " . dataCollector.fileName
					
					case (fieldNum = 5):
					dataCollector.articleName := field
					
					MsgBox, % "Article " . dataCollector.articleName . ""
					
					case (fieldNum = 6):
					dataCollector.placementText := field
					
					MsgBox, % "Picture text " . dataCollector.placementText
					
					case (fieldNum >= 8):
					dataCollector.pictureLinks.push(field)
					
					for k, v in dataCollector.pictureLinks {
						MsgBox, % "Picture Link" . k . " = " v
					}
					
				}
				MsgBox, Line: %lineNum% Field index: %FieldNum% Field: %Field% 
				summary := ""
				for key, value in dataCollector{
					summary .= key . ": " . value . "`n"
				}
				
				
			}

	}
	MsgBox, SUMMARY`n%summary%
}	
return

