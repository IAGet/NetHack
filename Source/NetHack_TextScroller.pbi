Structure SCROLLER_STRUCT
  scroll_hwnd.l
  scroll_text.s
  scroll_x.l
  scroll_y.l
  scroll_width.l
  scroll_hFont.l
  scroll_textcolor.l
  scroll_alpha.b
  scroll_wait.l
  scroll_pause.b
  scroll_speed.l
  scroll_hThread.l
EndStructure

Import "lib\TextScroller_Unicode.lib"
  CreateScroller(scr.l)
  PauseScroller(scr)
EndImport
; IDE Options = PureBasic 5.30 (Windows - x86)
; CursorPosition = 18
; EnableXP