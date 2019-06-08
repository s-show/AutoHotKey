/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
# Include IME.ahk
 - IMEの状態を取得するためにIME.ahkを読み込む
 - http://www6.atwiki.jp/eamat/pages/17.html

#IMEの状態取得関数の返り値
 - IME_GET()
   - IMEがOFF -> 0
   - IMEがON -> 1
 - IME_GetConverting()
   - IMEがOFF or (IMEがON & 未入力) -> 0
   - IMEがON & 文字入力中 & 変換窓が出ていない -> 1
   - IMEがON & 文字入力中 & 変換窓が出ている -> 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/

;Ctrl-BackSpaceを変換キーにする（本来の変換キーの代わり）
^BS::Send, {vk1C}

;変換/無変換でIMEをオン/オフする
;IMEオンで入力を始めたら、無変換を押してもIMEをオフにしない。
SC07B::
  if IME_GetConverting() >= 1 {
    Return
  }
  else {
    IME_SET(0)
  }
  Return
SC079::IME_SET(1)