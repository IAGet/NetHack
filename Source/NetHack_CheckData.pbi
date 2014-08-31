; Unpack data.zip...
; Часть игры NetHack
; Автор AGet
; http://github.com/IAGet/NetHack/

#Pack_Data = 0 ; для архива data.zip :)
#Pack_Sounds = 0 ; для архива sounds.zip :(

CompilerIf #PB_Compiler_OS = #PB_OS_Windows : #Sep = "\"
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux : #Sep = "/"
CompilerEndIf

Procedure ICannotFind()
  MessageRequester("NetHack", "Я не нашёл некоторые вещи, буду докачивать...")
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows : RunProgram("NetHackAUpd.exe") : CompilerElse : RunProgram("NetHackAUpd", "", "", #PB_Program_Open|#PB_Program_Read) : CompilerEndIf
EndProcedure

If ReadFile(0, "."+#Sep+"data"+#Sep+"language"+#Sep+"NetHack_Ru.lng") ; и если файл языка читается
  CloseFile(0) ; закрываем файл
  Goto after ; и идём другой дорогой
Else ; иначе
  If ReadFile(0, "."+#Sep+"data.zip") = 0 ; если data.zip не читается
    ICannotFind() ; я не могу найти это
  EndIf ; конец дороги
  
  Goto ok ; если же читается святая молитва в виде data.zip, мы идём вперёд
EndIf ; конец дороги

Goto after ; а на всякий случай :D

ok:
If UseZipPacker() = 0 ; если святой zip инициализировать не получается
  MessageRequester("NetHack", "Я.. я.. Я не смог инициализировать это! :OOO", #MB_ICONERROR) ; пишем это
  End ; и офаем игру/редактор
EndIf ; конец

DeleteDirectory("data", "", #PB_FileSystem_Force|#PB_FileSystem_Recursive) ; изыдиdata

If CreateDirectory("data") = 0
  MessageRequester("Nethack", "Не могу создать папку data :oooo", #MB_ICONERROR) ; ?
  End
EndIf
; Если открыть пак data.zip не представляется возможным пишем что-то офаем игру конец.
If OpenPack(#Pack_Data, "data.zip") = 0 : MessageRequester("NetHack", "Не могу открыть data.zip", #MB_ICONERROR) : End : EndIf

If ExaminePack(#Pack_Data) ; начинаем лазить по архиву
  While NextPackEntry(#Pack_Data) ; пока у нас есть файлы там
    If PackEntryType(#Pack_Data) = 0 ; если файл
      UncompressPackFile(#Pack_Data, "data"+#Sep+PackEntryName(#Pack_Data)) ; распаковываем...
    ElseIf PackEntryType(#Pack_Data) = 1 ; если папка...
      CreateDirectory("data"+#Sep+PackEntryName(#Pack_Data)) ; создаём её...
    EndIf
  Wend
EndIf
ClosePack(#Pack_Data)

If OpenPack(#Pack_Sounds, "sounds.zip") = 0 : MessageRequester("NetHack", "Не могу открыть sounds.zip", #MB_ICONERROR) : End : EndIf

If ExaminePack(#Pack_Sounds) ; начинаем лазить по архиву
  While NextPackEntry(#Pack_Sounds) ; пока у нас есть файлы там
    If PackEntryType(#Pack_Sounds) = 0 ; если файл
      UncompressPackFile(#Pack_Sounds, "data"+#Sep+PackEntryName(#Pack_Data)) ; распаковываем...
    ElseIf PackEntryType(#Pack_Sounds) = 1 ; если папка...
      CreateDirectory("data"+#Sep+PackEntryName(#Pack_Sounds)) ; создаём её...
    EndIf
  Wend
EndIf
ClosePack(#Pack_Sounds)
  
after:
; IDE Options = PureBasic 5.30 (Windows - x86)
; CursorPosition = 67
; FirstLine = 31
; Folding = -
; EnableUnicode
; EnableXP