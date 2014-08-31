; NetHack Updater
; Часть игры NetHack
; Автор AGet
; http://github.com/IAGet/NetHack/

Declare AddText(Text.s)
Declare CheckMD5Client(File.s)
Declare CheckMD5Server(File.s)
Declare UpdateFile(File.s)

If InitNetwork() <> #True
  MessageRequester("NetHack Updater", "Не удалось инициализировать сеть")
  End
EndIf

Global Clientmd5.s, Servermd5.s, url.s="test1.ru", urlLoad.s="/NetHack/", urlMD5.s=urlLoad+"nethack_md5.php?file="
Global txtGadget, wGadget

If OpenWindow(0, 0, 0, 320, 230, "NetHack Updater", #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | #PB_Window_Invisible)
  AnimateWindow_(WindowID(0),2500,#AW_BLEND|#AW_ACTIVATE) ; плавное появление...
  txtGadget = TextGadget(#PB_Any, 0, 0, 320, 230, "Запущено", #PB_Text_Border)
  CheckMD5Client("NetHackEditor.exe")
  Repeat
    If WaitWindowEvent() = #PB_Event_CloseWindow
      AnimateWindow_(WindowID(0),2500,#AW_BLEND|#AW_HIDE) ; плавное изчезание...
      Exit=1
    EndIf
  Until Exit=1
Else
  End
EndIf

Procedure AddText(Text.s)
  SetGadgetText(txtGadget, GetGadgetText(txtGadget)+Chr(13)+Text)
EndProcedure

Procedure CheckMD5Client(File.s)
  If ReadFile(0, File) = 0
    AddText("Файл "+File+" не найден, проверка md5 не нужна, обновляем...")
    UpdateFile(File)
  Else
    CloseFile(0)
    AddText("Проверяем MD5 файла "+File+" на стороне клиента...")
    Clientmd5 = MD5FileFingerprint(File)
    AddText("Ок, md5 - "+Clientmd5)
    AddText("Сверяем его с md5 на сервере...")
    CheckMD5Server(File)
  EndIf
EndProcedure

Procedure CheckMD5Server(File.s)
  
  AddText("MD5 с сервера - "+Servermd5)
  If Clientmd5=Servermd5
    AddText("MD5 равен, обновление файла не требуется")
  Else
    AddText("MD5 не равен, требуется обновление")
    Clientmd5=""
    Servermd5=""
    UpdateFile(File)
  EndIf
EndProcedure
  
Procedure UpdateFile(File.s)
  AddText("Обновляем "+File+"...")
  If ReceiveHTTPFile(urlLoad+File, GetCurrentDirectory()+File)
    AddText("Файл "+File+" успешно обновлён.")
  Else
    AddText("Файл "+File+" не удалось обновить по неизвестной науке причине.")
  EndIf
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; CursorPosition = 3
; Folding = -
; EnableUnicode
; EnableXP
; Executable = NetHackAUpd.exe
; IncludeVersionInfo
; VersionField0 = 1,0,0,0
; VersionField1 = 1,0,0,0
; VersionField2 = AGet
; VersionField3 = NetHack AutoUpdater
; VersionField4 = Since Angry Monkey
; VersionField5 = 1.0
; VersionField6 = NetHack Auto Updater. Run & Wait :)
; VersionField7 = NetHackAutoUpd
; VersionField8 = NetHackAUpd.exe