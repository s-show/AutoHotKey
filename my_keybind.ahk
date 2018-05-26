#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Auto execute section is the region before any return/hotkey

;Vimを使う上でのIME(日本語入力)の取り扱い with AutoHotKey 
;https://rcmdnk.com/blog/2013/08/04/computer-windows-autohotkey/

; Include IME.hak
; IME.hak無しではIMEの状態は取得できない
; http://www6.atwiki.jp/eamat/pages/17.html
#Include  %A_ScriptDir%/IME.ahk
Return

;/* Atom専用の設定 */
#ifWinActive ahk_exe atom.exe
  ;ノーマルモードに戻ると同時にIMEをオフにする
  $Esc::
  $^[::
    Gosub, GoToNormalMode
    Return

  GoToNormalMode:
  if (IME_GET())
    {
      ;IMEがONの場合
      if (IME_GetConverting())
      {
        ;変換窓が出ている場合
        Send,{Esc} ;変換窓を閉じる
        Sleep, 10
        Send,{Esc} ;未変換状態に戻す
        Sleep, 10
        Send,{Esc} ;入力中の文字列の行末にカーソルを移動
        Sleep, 10
        Send,{Esc} ;入力文字の全削除
        IME_SET(0)
        Send,{Esc} ;ノーマルモードに戻る
      }
        else
      {
        ;変換窓が出ていない場合
        Send,{Esc} ;入力文字の全削除 
        IME_SET(0)
        Send,{Esc} ;ノーマルモードに戻る
      }
    }
    else
    {
      ;IMEがOffの場合
      Send,{Esc}
    }
  Return
#ifWinActive

;/* Chrome専用の設定 */
;Ctrl-Lでアドレスバーに移動したらIMEオフ, Ctrl-Tで新規タブを開いたらIMEオフ
#ifWinActive ahk_exe chrome.exe
  $^L::
    if (IME_GET())
    {
      Send,^l
      Sleep 1 ; wait 1 ms (Need to stop converting)
      IME_SET(0)
    }
    else
    {
      Send,^l
    }
    Return

  $^T::
    if (IME_GET())
    {
      Send,^t
      Sleep 1 ; wait 1 ms (Need to stop converting)
      IME_SET(0)
    }
    else
    {
      Send,^t
    }
    Return
#ifWinActive

;/* Excel専用の設定 */
#ifWinActive ahk_exe EXCEL.EXE
  ;IMEの状態に関係なくCtrl-Spaceで列選択する
  $^Space::
    if (IME_GET())
    {
      IME_SET(0)
      Send,^{Space}
      IME_SET(1)
    }
    else
    {
      Send,^{Space}
    }
    Return
    
  ;IMEの状態に関係なくShift-Spaceで行選択する
  $+Space::
    if (IME_GET())
    {
      IME_SET(0)
      Send,+{Space}
      IME_SET(1)
    }
    else
    {
      Send,+{Space}
    }
    Return

  ;F1キーでヘルプが開かないようにする
  ;ヘルプを開くときはShift-F1で開く
  $F1::Return
  $+F1::SendInput, {F1}
#ifWinActive

;/* Excel VBA編集画面専用の設定 */
#ifWinActive ahk_class wndclass_desked_gsk
  ;Ctrl-F5でマクロの実行をストップ
  $^f5::
    Send,!r
    Sleep 100
    Send,r
  
  ;F5でマクロを実行すると、実行前に上書き保存を行う。
  $f5::
    send,^s
    Sleep 100
    send, f5

#ifWinActive

;/* Windows全体での設定 */
;_をShiftキー無しで入力する
SC073::_

;Pauseキーでアクティブウインドウの最前面固定を切り替え
~Pause::WinSet, AlwaysOnTop, toggle, A

;テンキーのピリオド2連打でカンマ入力
;upを外して押した時点でコードを実行させると、押しっぱなしで`Input`以下のコードが実行されてカンマが連続で入力される。
~NumpadDot up::
  ;T0.1ではかなり早く連打しないといけないため、T0.2にした。
  Input, var_dot_press, I T0.2 L1, {NumpadDot} 
  if(ErrorLevel == "EndKey:NumpadDot"){
    ;"."２連打の場合、BackSpaceを送信して一度入力したピリオドを削除し、次にカンマを送信する。
    SendInput, {BackSpace 1}
    Send,{vkBCsc033}
  }
  else
  {
    ;"."以外のキーが押された場合、そのキーをそのまま出力する。
    Send,%var_dot_press%
  }
  Return

;無変換+gでGoogle検索開始
;キー名の前に`~`を付けないと、無変換が無変換として使えなくなり、EnthumbleのthumbIMEのIME OFFが効かなくなる。
~vk1Dsc07B & g::
  InputBox, sword, Input Search Word , , ,300,110
  if ErrorLevel <> 0
  {
    Return
  }
  else
  {
    searchWord := RegExReplace(sword, "\s+", "+")
    Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" -new-tab "http://www.google.co.jp/search?hl=ja&lr=lang_ja&ie=UTF-8&q=%sword%"
  }
  Return

;ScrollLock２連打でメモ帳を起動
~ScrollLock::
  Input, var_dot_press, I T0.2 L1, {ScrollLock} 
  if(ErrorLevel == "EndKey:ScrollLock"){
    Run,notepad.exe
  }
  else
  {
    Send,%var_dot_press%
  }
  Return

;Ctrl-Alt-Rでこのスクリプトを再読み込みする
;https://autohotkey.com/docs/commands/Reload.htm 参照
^!r::Reload
