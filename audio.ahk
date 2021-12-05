#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance Force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; String array join helper
Join(sep, params*) {
    for index,param in params
        str .= sep . param
    return SubStr(str, StrLen(sep)+1)
}

; Attempt to activate a sound device by a substring of its name, from provided array
SetSound(devices*)
{
	dev := ""
	for index,device in devices {
		SplashTextOn, , , Switching to %device%
		RunWait, "C:\tools\bin\setsound.bat" %device%, , Min UseErrorLevel
		if (ErrorLevel = 0) {
			dev = %device%
			break
		}
	}

	if (StrLen(dev) > 0) {
		msg := "Audio out: " . dev
		SplashTextOn,,, %msg%
		SoundBeep, 350, 100
		Sleep 200
		SoundBeep, 350, 100
		Sleep 500
		SplashTextOff
		return %dev%
	} else {
		msg := "❗Audio out failed for: """ . Join(""", """, devices*) . """"
		SplashTextOn, 600, , %msg%
		Sleep 1500
		SplashTextOff
		return Error
	}
}

mapped_devices := [
	["Desk"], 				; Desk speakers
	["Yeti"), 				; Blue Yeti headphone out
	["RX", "Philips"],		; Yamaha RX-767 or Philips TV 
	["Headphones"]			; Bose QC35 
)
; TODO: Generate hotkey triggers

; Sound device: Desk speakers
^+F1::
SetSound("Desk")
return

; Sound device: Yeti out
^+F2::
SetSound("Yeti")
return

; Sound device: Yamaha RX-767 or Philips TV
^+F3::
SetSound("RX", "Philips")
return

; Sound device: Bose QuietComfort 35
^+F4::
SetSound("Headphones")
return

