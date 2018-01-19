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

; ESC + IME
#ifWinActive ahk_exe atom.exe
$Esc:: ; Just send Esc at converting.
  if (IME_GET(1)) {
    if (IME_GetConverting(A)) {
      IME_SET(0)
      Send,{Esc}
    } else {
      IME_SET(0)
    }
  } else {
    IME_SET(0)
    Send,{Esc}
  }
  Return
$^[:: ; Go to Normal mode (for vim) with IME off even at converting.
  if (IME_GET(1)) {
    Send,{Esc}
    ;Cliborのホットキーの指定時間500ミリ秒のため、600ミリ秒待つ
    Sleep 10 ; wait 1 ms (Need to stop converting)
    IME_SET(0)
    Send,{Esc}
  } else {
    IME_SET(0)
    Send,{Esc}
  }
  Return
#ifWinActive

;_をShiftキー無しで入力する
SC073::_

;Chrome Ctrl-LでアドレスバーにフォーカスしたらIMEオフ
#ifWinActive ahk_exe chrome.exe
$^L::
  if (IME_GET(1)) {
    Send,^l
    Sleep 1 ; wait 1 ms (Need to stop converting)
    IME_SET(0)
  } else {
    Send,^l
    Sleep 1 ; wait 1 ms (Need to stop converting)
    IME_SET(0)
  }
  Return
#ifWinActive

;Pauseキーでアクティブウインドウの最前面固定を切り替え
~Pause::WinSet, AlwaysOnTop, toggle, A

;テンキーのピリオド2連打でカンマ入力
;upを外してピリオドキーを押した時点でコードを実行するように設定すると、押しっぱなしでも`Input`以下のコードが実行され、カンマが連続で入力される。
~NumpadDot up::
  ;Input, var_dot_press, I T0.1 V L1, {NumpadDot}
  Input, var_dot_press, I T0.2 L1, {NumpadDot}
  if(ErrorLevel == "EndKey:NumpadDot"){
    ;SendInput, {BackSpace 2}
    ;MsgBox var_dot_press
    SendInput, {BackSpace 1}
    Send,{vkBCsc033}
  }
Return

;Space+gでGoogle検索開始
Space & g::
InputBox, sword, Google Search, , ,500,130
if ErrorLevel <> 0
  {}
else
{
  searchWord := RegExReplace(sword, "\s+", "+")
  IfWinActive, Google Chrome
    {
      ; Chromeが既に起動している場合
      ;IfWinActiveで見つかったウィンドウがLastFoundWindowに格納されているので、WinActivateの引数は省略できる。
      WinActivate 
      Send,{^k} ;Ctrl-kで検索画面モードにする
      clipboard = searchWord ;クリップボードに検索用語を格納する
      Send,{^v} ;検索用語を貼り付けする
      Send,{!Enter} ;Alt+Enterで検索結果を新しいタブで開く
      Return
    }
  else
    {
      ; Chromeが起動していない場合
      Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" -new-tab "http://www.google.co.jp/search?hl=ja&lr=lang_ja&ie=UTF-8&q=%sword%"
      Return
    }
}
return
