/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Title: Atom専用の設定
Note:
- ESC & Ctrl-[を1回押すと、Esc連打でIMEオフとノーマルモードへの移行を行う
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/
#ifWinActive ahk_exe atom.exe
  $Esc::
  $^[::
    Gosub, GoToNormalMode
    Return

  GoToNormalMode:
  if (IME_GET()) ;IMEがONの場合
    {
      if (IME_GetConverting()) ;変換窓が出ている場合
      {
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
        else ;変換窓が出ていない場合
      {
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

/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Title: Chrome専用の設定
Note:
- Ctrl-Lでアドレスバーに移動したらIMEオフ,
- Ctrl-Tで新規タブを開いたらIMEオフ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/
#ifWinActive ahk_exe chrome.exe
  $^L::
    if (IME_GET())
    {
      Send,^l
      Sleep 1
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
      Sleep 1
      IME_SET(0)
    }
    else
    {
      Send,^t
    }
    Return
#ifWinActive

/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Title: Firefox専用の設定
Note:
- F6でアドレスバーに移動したらIMEオフ
- Win-K -> Ctrl-K
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/
#ifWinActive ahk_exe firefox.exe
  $F6::IME_SET(0)
  $#k::^k
#ifWinActive

/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Title: Excel専用の設定
Note:
- IMEの状態に関係なくCtrl-Spaceで列選択する
- IMEの状態に関係なくShift-Spaceで行選択する
- 誤爆防止のため、F1を無効化し、Shift-F1でヘルプを開く。
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/
#ifWinActive ahk_exe EXCEL.EXE
  $^Space::
    if (IME_GET())
    {
      IME_SET(0)
      Sleep 30
      Send,^{Space}
      Sleep 30
      IME_SET(1)
    }
    else
    {
      Send,^{Space}
    }
    Return
    
    $+Space::
    if (IME_GET())
    {
      IME_SET(0)
      ;`Send,+{Space}`の前後に`Sleep 30`が無いと普通のスペースが入力される
      Sleep 30
      Send,+{Space}
      Sleep 30
      IME_SET(1)
    }
    else
    {
      Send,+{Space}
    }
    Return

  $F1::Return
  $+F1::SendInput, {F1}
#ifWinActive

/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Title: Excel VBA編集画面専用の設定
Note:
- F5 -> マクロを実行する前に上書き保存を行う。
- Ctrl-F5 -> マクロの実行をストップ
- F5 -> Ctrl-F5の順番で設定しないと、マクロの実行を停止した後にマクロが実行される
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/
#ifWinActive ahk_class wndclass_desked_gsk
  $f5::
    send,^s
    Sleep 100
    send,{f5}
    Return
    
  $^f5::
    Send,!r
    Sleep 100
    Send,r
    Return
#ifWinActive