/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
関数定義
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/

/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Title: Shift-Ctrlの2連打でキーボードのチートシートを表示する
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/
~+^Space::
  Input, inputText, I L11 T0.5, +^Space
  ;If (A_PriorHotKey == A_ThisHotKey and A_TimeSincePriorHotkey < 200)
  {
    Gui, Destroy  ;一度画面を破棄しないと、もう一度ホットキーを押したときにエラーになる。
    IniRead, filePath, %A_WorkingDir%/display-keyboardLayout.ini, ImageSource, filePath,
    Gui, New,, Keyboard Layout 
    Gui, Color, FFFFFF
    Gui, Add, Picture ,vcheetSheet, %filePath%
    Gui, Font, S14 Norm Q5
    Gui, Add, Text ,Border BackgroundWhite vimgFilePath, ImageSource: %filePath%
    Gui, Add, Button, default gSelectImage, Select ImageFile(Enter)
    Gui, Add, Button, gClose, Close(ESC)
    Gui, Show
  }
  Return

/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GuiEscape: AutoHotKeyに組み込まれている特殊なサブルーチンラベル
           Escapeキーを押したときに実行される
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/
GuiEscape:
  Gui, Destroy
  Return

SelectImage:
  FileSelectFile, newFilePath, 1, %A_WorkingDir%, , Image File(*.jpg;*.jpeg;*.png;*.bmp;*.gif)
  If (ErrorLevel == 0)
  {
    IniWrite, %newFilepath%, %A_WorkingDir%/display-keyboardLayout.ini, ImageSource, filePath
    Gui, Destroy  ;一度画面を破棄しないと思い通りの再表示にならない。
    Gui, New,, Keyboard Layout 
    Gui, Add, Picture ,vcheetSheet, %newFilePath%
    Gui, Font, S14 Norm Q5
    Gui, Add, Text ,Border BackgroundWhite vimgFilePath, ImageSource: %newFilePath%
    Gui, Add, Button, default gSelectImage, Change_ImageFile
    Gui, Add, Button, gClose, Close(ESC)
    Gui, Show
  }
  Return

Close:
  Gui, Destroy
  Return