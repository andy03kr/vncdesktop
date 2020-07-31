;;;;; main.au3
;;;;; plink.exe -ssh -N -R 45554:127.0.0.1:5900 -hostkey 24:b1:c4:9e:c9:b5:d6:e6:03:12:df:1f:64:dd:81:1d -P 10022 -i c:\vncdesktop\bin\vncproxy.ppk -l vncproxy -batch vncproxy.home.lan
;;;;; copy /b 7zSD.sfx + config.txt + vncdesktop.7z vncdesktop.exe
;;;;;

#include-once
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Opt ( "TrayIconHide", 1 )

$sBin         = @ScriptDir & "\bin\"
$sINI_file    = $sBin & "vncdesktop.ini"

If FileExists ( $sINI_file ) Then
   $sServer   = IniRead ( $sINI_file, "General", "server", "" )
   $iSSH_port = IniRead ( $sINI_file, "General", "sshport", "22022" )
   $iVNC_port = IniRead ( $sINI_file, "General", "vncport", "15900" )
   $sSSH_user = IniRead ( $sINI_file, "General", "sshuser", "vncproxy" )
   $sSSH_crt  = IniRead ( $sINI_file, "General", "certificate", "" )
   $sHostKey  = IniRead ( $sINI_file, "General", "hostkey", "" )
Else
   Exit
EndIf

If $sServer = "" Then
   Exit
EndIf

If $sSSH_crt = "" Then
   Exit
Else
   $sSSH_crt = $sBin & $sSSH_crt
EndIf

If $sHostKey = "" Then
   Exit
EndIf

$sMode        = "app mode"
$sSRV_Stat    = "Not Connected"
$sCMD         = ""
$sGUI_PASS    = ""
$sGUI_ID      = ""

; use winvnc.exe from @ScriptDir & "\bin\"
$iVNC_exists  = 0
$iPLINK_pid   = -1
$iVNC_pid     = -1

$idLabelSTAT  = ""
$idLabelMODE  = ""
$idInputSRV   = ""
$idInput      = ""
$idButtConn   = ""
$idInputID    = ""
$idInputPASS  = ""

$aProcessList = ProcessList ()
For $i = 1 To $aProcessList[0][0]
   If ( StringInStr ( $aProcessList[$i][0], "vnc" ) > 0 ) Or ( StringInStr ( $aProcessList[$i][0], "tvns" ) > 0 ) Then
	  $iVNC_port = 5900
	  ; use system vnc service
	  $iVNC_exists = 1
	  $sMode = "service mode"
	  ExitLoop 0
   EndIf
Next

; Func ServerStat return:
; -5 fail TCP connection
; -2 not connected
; -1 server name is incorrect
; 0 wrong server name
; 1 IP-addr is incorrect
; 2 port is incorrect
; 5 connection established
; or Windows Sockets Error https://docs.microsoft.com/ru-ru/windows/desktop/WinSock/windows-sockets-error-codes-2
Func ServerStat ( $sServer, $iSSH_port )
   Local $idSock = 0
   Local $sIPAddress = ""

   If $sServer = "" Or $sServer = "127.0.0.1" Then Return -1
   If $iSSH_port = "" Or $iSSH_port < 0 Or $iSSH_port > 65536 Then Return 2
   If TCPStartup () = 0 Then Return -5
   $sIPAddress = TCPNameToIP ( $sServer )
   If $sIPAddress = "" Then Return @error
   $idSock = TCPConnect ( $sIPAddress, $iSSH_port )
   If @error Then
	  Return @error
   EndIf
   TCPCloseSocket ( $idSock )
   Return 5
EndFunc

Func ReNewPARAM ( $sServer, $iSSH_port )
   If $sServer = "" Or $sServer = "127.0.0.1" Then Return 0
   If $iVNC_exists == 0 Then $sGUI_PASS = Random ( @MSEC + 40000, 50000, 1 )
   Sleep ( Random ( 0, 1000, 1 ))
   $sGUI_ID = Random ( @MSEC + 40000, 50000, 1 )
   $sCMD = $sBin & "plink.exe -ssh -N -R " & $sGUI_ID & ":127.0.0.1:" & $iVNC_port & " -hostkey " & $sHostKey & " -P " & $iSSH_port & " -i " & $sSSH_crt & " -l " & $sSSH_user & " -batch " & $sServer
   Return 1
EndFunc

; Func ConnectSRV return:
; -1 server name is incorrect
; 1 error while run winvnc
; 2 error while run plink
; 5 connection established
Func ConnectSRV ( $sServer, $iSSH_port )
   If $sServer = "" Or $sServer = "127.0.0.1" Then Return -1
   KillTools ()
   If $iVNC_exists == 0 Then
	  RunWait ( $sBin & "setpasswd.exe " & $sGUI_PASS, "", @SW_HIDE )
	  $iVNC_pid = Run ( $sBin & "winvnc.exe -run -settings UltraVNC.ini", "", @SW_HIDE )
	  If $iVNC_pid = 0 Then Return 1
   EndIf
   $iPLINK_pid = Run ( $sCMD, "", @SW_HIDE )
   If $iPLINK_pid <= 0 Then Return 2
   Return 5
EndFunc

Func KillTools ()
   If $iVNC_exists == 0 Then
	  RunWait ( @ComSpec & " /c taskkill /F /T /PID " & $iVNC_pid, "", @SW_HIDE )
   EndIf
   If $iPLINK_pid > 0 Then
	  RunWait ( @ComSpec & " /c taskkill /F /T /PID " & $iPLINK_pid, "", @SW_HIDE )
   EndIf
EndFunc
