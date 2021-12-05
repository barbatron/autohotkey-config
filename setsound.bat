@echo off

if "%1" == "" (
	echo USAGE: %0 "My sound dev"
	echo.
	echo Selects a sound device as default output, if an available device matches the search terms.
	echo.
	exit /b
)

rem ** Verify SoundVolumeView is available
where /Q SoundVolumeView || (
	echo SoundVolumeView executable is not in PATH - unable to continue.
	exit /b 2
)

setlocal EnableExtensions

set "searchExpr=%1"
set "setsound_newdevice=%tmp%\setsound_newdevice.tmp"
set "setsound_devices=%tmp%\setsound_devices.tmp"
echo Using files "%setsound_newdevice%" and "%setsound_devices%"

rem ** First delete found devices from before
if exist "%setsound_newdevice%" (
	echo Deleting existing newdevice file
	del "%setsound_newdevice%" >NUL
)

rem ** Find output device, write any result to file
echo Enumerating devices...
SoundVolumeView /stab "%setsound_devices%" && type "%setsound_devices%" | findstr /i /R /B "%searchExpr%.*Render" | awk "{print $1;}" >>"%setsound_newdevice%"

echo Devices enumerated into "%setsound_devices%"

rem ** Read contents of file into newDevice variable
set newDevice=
for /f %%a in (%setsound_newdevice%) do set newDevice=%%a

if not "%newDevice%" == "" (
	echo Activating device "%newDevice%"...
	SoundVolumeView /setDefault %newDevice% all
) else (
	echo No device found.
	exit /b 1
)

endlocal
