;;;;; vncdesktop.au3
;;;;;

#include "main.au3"

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=3
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt ( "TrayIconHide", 1 )

#Region ### START Koda GUI section ### Form=
$_1 = GUICreate ( "VNC desktop", 500, 368, 193, 124 )
GUISetFont ( 16, 400, 0, "MS Sans Serif" )
$Group = GUICtrlCreateGroup ( "Quick Support", 15, 30, 470, 320 )

GUICtrlCreateLabel ( "Server :", 40, 70, 120, 29 )
$idInputSRV = GUICtrlCreateInput ( $sServer & ":" & $iSSH_port, 185, 70, 255, 33, BitOR ( $GUI_SS_DEFAULT_INPUT,$ES_READONLY ))

GUICtrlCreateLabel ( "Your ID :", 40, 120, 80, 29 )
$idInputID = GUICtrlCreateInput ( $sGUI_ID, 288, 120, 145, 33, BitOR ( $GUI_SS_DEFAULT_INPUT,$ES_READONLY ))

GUICtrlCreateLabel ( "Your Password :", 40, 170, 145, 29 )
$idInputPASS = GUICtrlCreateInput ( $sGUI_PASS, 288, 170, 145, 33, BitOR ( $GUI_SS_DEFAULT_INPUT,$ES_READONLY ))

GUICtrlCreateLabel ( "Status :", 40, 250, 70, 29 )
$idLabelSTAT = GUICtrlCreateLabel ( $sSRV_Stat, 185, 250, 450, 33 )

GUICtrlCreateLabel ( "Mode :", 40, 300, 70, 29 )
$idLabelMODE = GUICtrlCreateLabel ( $sMode, 185, 300, 450, 33 )

GUICtrlCreateGroup ( "", -99, -99, 1, 1 )
GUISetState ( @SW_SHOW )
#EndRegion ### END Koda GUI section ###

$retStat = ServerStat ( $sServer, $iSSH_port )
Switch $retStat
   Case -5
	  GUICtrlSetData ( $idInputID, "" )
	  GUICtrlSetData ( $idInputPASS, "" )
	  GUICtrlSetData ( $idLabelSTAT, "Fail TCP connection" )
   Case -2
	  GUICtrlSetData ( $idInputID, "" )
	  GUICtrlSetData ( $idInputPASS, "" )
	  GUICtrlSetData ( $idLabelSTAT, "Not connected" )
   Case -1
	  GUICtrlSetData ( $idInputID, "" )
	  GUICtrlSetData ( $idInputPASS, "" )
	  GUICtrlSetData ( $idLabelSTAT, "Wrong server name " & $sServer )
   Case 0
	  GUICtrlSetData ( $idInputID, "" )
	  GUICtrlSetData ( $idInputPASS, "" )
	  GUICtrlSetData ( $idLabelSTAT, "Socket error" )
   Case 1
	  GUICtrlSetData ( $idInputID, "" )
	  GUICtrlSetData ( $idInputPASS, "" )
	  GUICtrlSetData ( $idLabelSTAT, "IP-address is incorrect = " & $sIPAddress )
   Case 2
	  GUICtrlSetData ( $idInputID, "" )
	  GUICtrlSetData ( $idInputPASS, "" )
	  GUICtrlSetData ( $idLabelSTAT, "Port is incorrect" )
   Case 5
	  KillTools ()
	  $iConn = ConnectSRV ( $sServer, $iSSH_port )
	  If $iConn == 1 Then
		 GUICtrlSetData ( $idLabelSTAT, "winvnc.exe NOT started" )
	  ElseIf $iConn == 2 Then
		 GUICtrlSetData ( $idLabelSTAT, "plink.exe NOT started" )
	  ElseIf $iConn == 5 Then
		 GUICtrlSetData ( $idLabelSTAT, "Connected" )
	  Else
		 GUICtrlSetData ( $idLabelSTAT, "Unknown" )
	  EndIf
	  GUICtrlSetData ( $idInputID, $sGUI_ID )
	  GUICtrlSetData ( $idInputPASS, $sGUI_PASS )
   Case Else
	  GUICtrlSetData ( $idInputID, "" )
	  GUICtrlSetData ( $idInputPASS, "" )
	  GUICtrlSetData ( $idLabelSTAT, "Sockets Error = " & $retStat )
EndSwitch

While 1
   $nMsg = GUIGetMsg ()
   Switch $nMsg
	  Case $GUI_EVENT_CLOSE
		 KillTools ()
		 Exit
   EndSwitch
WEnd
