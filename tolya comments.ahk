﻿#Persistent
#InstallKeybdHook
ClipboardPaste(stuff){
	tempSave := Clipboard
	Clipboard := stuff
	send, ^v
	Clipboard := tempSave
}

incrementIndex(inc := false){
	global index
	if (inc){
		return ++index
	} else {
		return index
	}
}

Gui, Add, Edit, x12 y9 w440 h40 vComment_1, Комментарий раз
Gui, Add, Edit, x12 y59 w440 h40 vComment_2, Комментарий два
Gui, Add, Edit, x12 y109 w440 h40 vComment_3, Комментарий три
Gui, Add, Edit, x12 y159 w440 h40 vComment_4, Комментарий четыре
Gui, Add, Edit, x12 y209 w440 h40 vComment_5, Комментарий пять
Gui, Add, Edit, x12 y259 w440 h40, Индекс
Gui, Add, UpDown, vIndex Range1-999
Gui, Add, Button, x12 y309 w440 h40 gSubmit , Сохранить значения

Gui, Show, w479 h379, Оставляй комментарии как бог
return

Submit:
gui, Submit, NoHide
return

^Numpad1:: ClipboardPaste(Comment_1 . incrementIndex())
^Numpad2:: ClipboardPaste(Comment_2 . incrementIndex())
^Numpad3:: ClipboardPaste(Comment_3 . incrementIndex())
^Numpad4:: ClipboardPaste(Comment_4 . incrementIndex())
^Numpad5:: ClipboardPaste(Comment_5 . incrementIndex())

^!Numpad1:: ClipboardPaste(Comment_1 . incrementIndex(true))
^!Numpad2:: ClipboardPaste(Comment_2 . incrementIndex(true))
^!Numpad3:: ClipboardPaste(Comment_3 . incrementIndex(true))
^!Numpad4:: ClipboardPaste(Comment_4 . incrementIndex(true))
^!Numpad5:: ClipboardPaste(Comment_5 . incrementIndex(true))



GuiClose:
ExitApp