; NetHack Mod Editor (v. Angry Monkey) Lite
; http://github.com/IAGet/NetHack/
; Написано на PureBasic 5.11 Win x64

XIncludeFile "NetHack_OnError.pbi"

OnErrorCall(@ErrorHandler())

XIncludeFile "NetHack_ModEditor_Lang.pbi" ; язык...
XIncludeFile "NetHack_CheckData.pbi" ; проверка на присутствие ресурсов (файлы языка и т.д)

Global NetHack_edt_f_type = 0 ; 0 - none, 1 - mod, 2 - user

If InitSound() = 0 Or UseOGGSoundDecoder() = 0; пасхалка работать не будет :c
  pashalkarobit = #False
Else
  pashalkarobit = #True
  LoadSound(0, "data\sound\music\callMeKatla.ogg")
EndIf

AboutWinBtnPrsd = 0 ; остальные переменные

#NetHack_VERSION = "Angry Monkey" ; версия (шок ужас непонятки)
#NetHack_VERSION_N = 1
#NetHack_Page = "http://github.com/AGet/NetHack/" ; в about адрес пишется...
#NetHack_UpdScr = "http://test1.ru/NetHack/nethack_version" ; проверяем содержание этого файла, если там цифра больше #NetHack_VERSION_N - 
; предлагаем обновление

#NewLine = Chr(13) + Chr(10) ; символ новой строки :)

Declare AboutWindow() ; окно о программе
Declare CheckUpdates() ; проверка обновлений
Declare OpenModFile() ; реакция на #MenuItem_Open
Declare NewModFile() ; реакция на #MenuItem_NewMod
Declare NewUser() ; реакция на #MenuItem_NewUser
Declare Save() ; ...

netInit = InitNetwork() ; инициализим сеть. Если не получится - лочим в редакторе возможность обновления

Enumeration ; нумерация окон
  #Window_0
  #Window_about
  #Window_settings
EndEnumeration

Enumeration ; нумерация кнопок меню
  #MenuItem_Open
  #MenuItem_NewMod
  #MenuItem_NewUser
  #MenuItem_Save
  #MenuItem_Settings
  #MenuItem_Exit
  #MenuItem_CheckUpdate
  #MenuItem_Help
  #MenuItem_About
EndEnumeration

Enumeration ; нумерация гаджетов
  #About_Window_Button
EndEnumeration

#Flags = #PB_Window_SystemMenu | #PB_Window_ScreenCentered ; флаги окошек :)

If OpenWindow(#Window_0, 0, 0, 800, 600, "NetHack Mod Editor Lite", #Flags)
  If CreateMenu(0, WindowID(#Window_0))
    MenuTitle("Файл")
     MenuItem(#MenuItem_Open, "Открыть")
     MenuBar()
    OpenSubMenu("Новый")
     MenuItem(#MenuItem_NewMod, "Мод")
     MenuItem(#MenuItem_NewUser, "Юзер")
    CloseSubMenu()
     MenuItem(#MenuItem_Save, "Сохранить")
     MenuBar()
     MenuItem(#MenuItem_Exit, "Выход")
    MenuTitle("Прочее")
     MenuItem(#MenuItem_CheckUpdate, "Проверить обновление")
    MenuTitle("Помощь")
     MenuItem(#MenuItem_Help, "Справка")
     MenuBar()
     MenuItem(#MenuItem_About, "О программе")
   EndIf
   If NetHack_edt_f_type = 0 : DisableMenuItem(0, #MenuItem_Save, 1) : EndIf ; нет чего сохранить? нет сохранения!
   If netInit = 0 : DisableMenuItem(0, #MenuItem_CheckUpdate, 1) : EndIf ; нет инициализации сети? нет обновы!
  Repeat
    WindowID = EventWindow()
    Event=WaitWindowEvent()
    Menu=EventMenu()
    Gadget=EventGadget()
    
    If Event=#PB_Event_Menu
      Select Menu
        Case #MenuItem_Open ; Открыть
          OpenModFile()
        Case #MenuItem_NewMod ; Новый->Мод
          MessageRequester("!", "mod")
        Case #MenuItem_NewUser ; Новый->Юзер
          MessageRequester("!", "user")
        Case #MenuItem_Save ; Сохранить
        Case #MenuItem_Settings ; Настройки
          
        Case #MenuItem_Exit ; Выход
          Exit=1
        Case #MenuItem_CheckUpdate ; Проверить обновление
          CheckUpdates()
        Case #MenuItem_Help ; Справка
          OpenHelp("modeditor_help.chm", "index.html")
        Case #MenuItem_About ; О программе
          AboutWindow()
      EndSelect
    EndIf
    
    If WindowID=#Window_about And Event=#PB_Event_CloseWindow
      DisableWindow(#Window_0, 0)
      StopSound(0)
      CloseWindow(#Window_about)
    EndIf
    
    If WindowID=#Window_about And Event=#PB_Event_Gadget And Gadget=#About_Window_Button
      If pashalkarobit = #True And PashalkaMusicEnabled = #False : SetGadgetText(#About_Window_Button, "Секретный текст ты не видел(-а)") : Delay(1500) : SetGadgetText(#About_Window_Button, "") : EndIf
    EndIf
    
    If WindowID=#Window_0 And Event=#PB_Event_CloseWindow
      Exit=1
    EndIf
  Until Exit=1
Else
  MessageRequester("NetHack Mod Editor", "Не удаётся запустить программу", #MB_ICONERROR)
  End
EndIf

Procedure AboutWindow()
  If OpenWindow(#Window_about, 0, 0, 420, 230, "О программе", #Flags)
    DisableWindow(#Window_0, 1)
    PlaySound(0)
    Frame3DGadget(#PB_Any, 10, 10, 400, 210, "NetHack v. "+#NetHack_VERSION+" ModEditor Lite")
    ReadFile(0, "data\sound\music\callMeKatla.txt")
    AboutMessage.s = ""
    ; Set About Message Start
    AboutMessage + "Написано на PureBasic 5"
    AboutMessage + #NewLine
    AboutMessage + "Использовался справочник PureBasic'a и C.A.V. :o"
    AboutMessage + #NewLine
    AboutMessage + "http://www.purearea.net"
    AboutMessage + #NewLine
    AboutMessage + "А полная версия полного редактора у AGet'a... :)"
    AboutMessage + #NewLine + #NewLine
    AboutMessage + ReadString(0)
    AboutMessage + #NewLine + #NewLine + #NewLine
    AboutMessage + "http://github.com/AGet/NetHack/"
    AboutMessage + #NewLine + #NewLine
    AboutMessage + "(c) 2012, 2014 AGet"
    ; Set About Message End
    CloseFile(0)
    TextGadget(#PB_Any, 20, 30, 380, 150, AboutMessage, #PB_Text_Border)
    ButtonGadget(#About_Window_Button, 20, 180, 380, 30, "")
  Else
    MessageRequester("Ошибка", "Не могу :o", #MB_ICONERROR)
  EndIf
EndProcedure

Procedure SettingsWindow()
  If OpenWindow(#Window_settings, 0, 0, 10, 10, "Настройки", #Flags)
  EndIf
EndProcedure

Procedure CheckUpdates()
  ; Проверка на новую версию
  ; Тут участвует #NetHack_UpdScr
  ; И если есть новая верса, открываем NetHackAUpd.exe
EndProcedure

Procedure OpenModFile() ; реакция на #MenuItem_Open
  file$ = OpenFileRequester("Открыть файл", "", "NetHack Mod File (.nhm)|*.nhm|NetHack User (.nhu)|*.nhu", 0)
EndProcedure

Procedure NewModFile()
EndProcedure

Procedure NewUserFile()
EndProcedure

Procedure Save()
  If NetHack_edt_f_type=0
    MessageRequester("NetHack ModEditor", "Невозможно сохранить пустоту", #MB_ICONWARNING)
  ElseIf NetHack_edt_f_type=1
    Debug "Сохраняем мод"
    file$ = SaveFileRequester("Сохранить мод", "", "NetHack Mod File (.nhm)|*.nhm", 0)
  ElseIf NetHack_edt_f_type=2
    Debug "Сохраняем юзера"
    file$ = SaveFileRequester("Сохранить юзера", "", "NetHack User (.nhu)|*.nhu", 0)
  EndIf
EndProcedure
; IDE Options = PureBasic 5.30 (Windows - x86)
; CursorPosition = 1
; Folding = --
; EnableUnicode
; EnableXP
; Executable = NetHack_ModEditor.exe
; IncludeVersionInfo
; VersionField0 = 0,0,0,0
; VersionField1 = 0,0,0,0
; VersionField2 = AGet
; VersionField3 = NetHack ModEditor Lite
; VersionField4 = Angry Monkey
; VersionField5 = 1.0
; VersionField6 = Mod Editor...
; VersionField7 = %SOURCE
; VersionField8 = NetHack_ModEditor.exe
; VersionField13 = eml.anony@gmail.com
; VersionField14 = http://github.com/AGet/NetHack/