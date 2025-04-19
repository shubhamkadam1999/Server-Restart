@echo off
setlocal

:: Launch the HTA file (included via Bat To Exe Converter)
start "" "%~dp0ssh_control.hta"

:: Optional: Wait for the HTA to close before continuing
:: Uncomment this if the HTA must close before running the rest
:: timeout /t 10

:: Server restart logic
set "PLINK=C:\Program Files\PuTTY\plink.exe"
set "REMOTE_DIR=/comptel/ilink_om/sas"

echo === Starting server restart script ===
echo USER: %USER%
echo HOST: %HOST%
echo REMOTE_DIR: %REMOTE_DIR%
echo.

echo Stopping service... > "ssh_output.log"
"%PLINK%" -batch -ssh %USER%@%HOST% -pw %PASS% -P 22 "cd %REMOTE_DIR% && . .profile && ctl_control -f stop" >> "ssh_output.log" 2>&1
echo Stopped service. >> "ssh_output.log"

echo Waiting 10 seconds... >> "ssh_output.log"
timeout /t 10 >> "ssh_output.log"

echo Starting service... >> "ssh_output.log"
"%PLINK%" -batch -ssh %USER%@%HOST% -pw %PASS% -P 22 "cd %REMOTE_DIR% && . .profile && ctl_control -f start && exec bash" >> "ssh_output.log" 2>&1
echo Started service. >> "ssh_output.log"

echo === Done === >> "ssh_output.log"

endlocal
