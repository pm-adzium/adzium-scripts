#Persistent
#InstallKeybdHook
ClipboardPaste(stuff){
	tempSave := Clipboard
	Clipboard := stuff
	send, ^v
	Clipboard := tempSave
}



Gui, Add, Edit, x12 y9 w440 h40 vComment_1, Поле раз
Gui, Add, Edit, x12 y59 w440 h40 vComment_2, Поле два
Gui, Add, Edit, x12 y109 w440 h40 vComment_3, Поле три
Gui, Add, Edit, x12 y159 w440 h40 vComment_4, Поле четыре
Gui, Add, Edit, x12 y209 w440 h40 vComment_5, Поле пять
Gui, Add, Button, x12 y309 w440 h40 gSubmit , Сохранить значения

Gui, Show, w479 h379, Вставляй значения как бог
return

Submit:
gui, Submit, NoHide
return

^Numpad1:: ClipboardPaste(Comment_1)
^Numpad2:: ClipboardPaste(Comment_2)
^Numpad3:: ClipboardPaste(Comment_3)
^Numpad4:: ClipboardPaste(Comment_4)
^Numpad5:: ClipboardPaste(Comment_5)



GuiClose:
ExitApp