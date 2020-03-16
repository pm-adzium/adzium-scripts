#Persistent
#SingleInstance, force
#InstallKeybdHook
#UseHook
#MaxThreadsPerHotkey, 2

counter := 1

Gui, Add, Edit, x12 y19 w140 h30 vBg, Bg
Gui, Add, Edit, x12 y59 w140 h30 vPic , Picture Template
Gui, Add, Edit, x12 y99 w140 h30 vPath , Path
Gui, Add, Edit, x12 y139 w140 h30 vIndex , Index
Gui, Add, Button, x12 y179 w140 h30 gSubmit , Save Paths Config
Gui, Show, w171 h220, +++
return



saveShiz(shiz){
	iniWrite, shiz, settings.ini, settings
}

testArray(array){
	
}

ClipboardPaste(stuff){
	tempSave := Clipboard
	Clipboard := stuff
	send, ^v
	Clipboard := tempSave
}

UpdateIndexGUI(){
	global Index
GuiControl,, Index, %Index%
return
}

IncreaseIndex(Update){
	global Index
	
	if Index is not number
	{
		Index := 1
	}
	if (Update = true)
	{
		Return ++Index
	}
	else Return Index
}

SendPath(Mode, CountUp := false){
	global
	PicPath := "psd`\" . Pic
	BgPath := "bg`\" . Bg
	pathComposite := Path . "`\" . (Mode = "Pic" ? PicPath : BgPath) . IncreaseIndex((CountUp = true ? true:false)) . (Mode = "BG" ? "`.`*" : "`.psd")
	ClipboardPaste(pathComposite)
}

GuiClose:
ExitApp
return

Submit:
Gui, Submit, NoHide
return


^F1::
SendPath("Pic")
UpdateIndexGUI()
return

^F2::
SendPath("BG")
UpdateIndexGUI()
return

^+F1::
SendPath("Pic", true)
UpdateIndexGUI()
return

^+F2::
SendPath("BG", true)
UpdateIndexGUI()
return

^F3::
clippedValue := Clipboard
Loop, parse, clippedValue, " x "
{
	if (a_index = 2) {
		continue
	}
	Send, %A_LoopField%{Tab}
}

filterQuotes(){
	String := Clipboard
	Template := Chr(34)
	String := StrReplace(String, Template)
	sleep, 10
	Clipboard := String
}


;^v::
;send, ^v
;return


~^c::
splitString := ""
splitString := StrSplit(Clipboard, "`n")
sleep, 100
;testing purposes
;msgbox, % "array length: " . splitString.Length() . "counter: " . counter
counter := 1
return

^+v::
SendInput, splitString[counter]
;testing purposes
;msgbox, % "array length: " . splitString.Length() . "counter: " . counter
if(counter < splitString.Length()){
	counter++
	} else {
	counter := 1
}
return

^!+q::Suspend, toggle