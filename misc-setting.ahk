/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
関数定義
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/

/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Title: Pauseキーでアクティブウインドウの最前面固定を切り替え
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/
~Pause::WinSet, AlwaysOnTop, toggle, A

/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Title: テンキーのピリオド2連打でカンマ入力
Note:
- If (A_PriorHotKey == A_ThisHotKey and A_TimeSincePriorHotkey < 200) 
- →前回と今回のホットキーが同じ かつ 前回のホットキーの入力から200ミリ秒以内
- この設定を行うと、テンキーのピリオドを押し続けても'.,'が入力された時点で入力が止まる
- IMEの状態に関係無く半角カンマ（,）を入力するため、UNICODEコードで指定している。
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/
~NumpadDot::
  If (A_PriorHotKey == A_ThisHotKey and A_TimeSincePriorHotkey < 200)
  {
    SendInput, {BackSpace 2}
    Send,{U+002c}
  }
  Return

/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Title: 選択した文字列を'('等で囲む
Usage: 文字列を選択→無変換+sを押す→続けて入力した文字で囲む
Note:
- IMEオンでも囲む文字は半角になる
- 「{,`,%,#,*」はエスケープ(`)が必要な文字
- 半角スペースは、条件の途中に指定しないと認識されない
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/
^,::
  backup = ClipboardAll
  Clipboard =
  Send, ^c	
  ClipWait, 1
  imeStatus := IME_GET()
  ;MsgBox,%imeStatus%
  if ErrorLevel = 0
  {
    Input, inputText, I L1 T1,{Esc}, (,[,`{,',",``,-,_,=,`%,`#,`*, ,|
    ;MsgBox,%inputText%
    If ErrorLevel = Match
    {
      IME_SET(0)
      If inputText = [
      {
        Send,{[}
        Send,^v
        Send,{]}
        Sleep 200
      } 
      Else if inputText = (
      {
        Send,{(}
        Send,^v
        Send,{)}
        Sleep 200
      }
      Else if inputText = {
      {
        Send,{{}
        Send,^v
        Send,{}}
        Sleep 200
      }
      ;スペースは`=`による条件判定ができないため、変数の型で判定している。
      Else if inputText is space
      {
        Send,{Space}
        Send,^v
        Send,{Space}
        Sleep 200
      }
      ;`#`は個別に条件指定しないと動かない
      Else if inputText = `#
      {
        Send,{`#}
        Send,^v
        Send,{`#}
        Sleep 200
      }
      Else
      {
        ;MsgBox,%inputText%
        Send,%inputText%
        Send,^v
        Send,%inputText%
        Sleep 200
      }
    }
  }
  Clipboard = %backup%
  IME_SET(imeStatus)
  Return

/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Title: Ctrl-Alt-カーソルキーで矢印を入力
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/
^!Left::Send,{U+2190}
^!Up::Send,{U+2191}
^!Right::Send,{U+2192}
^!Down::Send,{U+2193}

/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Title: Alt-Qの2連打でアプリを閉じる
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/
~!q::
  Input, inputText, I L1 T0.5, !q
  IfInString, ErrorLevel, EndKey:
  {
    Send, !{F4}
  }
  Return

/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Title: Ctrl-Alt-Rでこのスクリプトを再読み込みする
Note:
- https://autohotkey.com/docs/commands/Reload.htm 参照
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/
^!r::Reload