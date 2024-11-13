@set iasver=1.2
@setlocal DisableDelayedExpansion
@echo off

::============================================================================
::
::   IDM Activation Script (IAS)
::
::   Homepages: https://github.com/WindowsAddict/IDM-Activation-Script
::              https://massgrave.dev/idm-activation-script
::
::       Email: windowsaddict@protonmail.com
::
::============================================================================



::  To activate, run the script with "/act" parameter or change 0 to 1 in below line
set _activate=0

::  To Freeze the 30 days trial period, run the script with "/frz" parameter or change 0 to 1 in below line
set _freeze=0

::  To reset the activation and trial, run the script with "/res" parameter or change 0 to 1 in below line
set _reset=0

::  If value is changed in above lines or parameter is used then script will run in unattended mode

::========================================================================================================================================

::  Set Path variable, it helps if it is misconfigured in the system

set "PATH=%SystemRoot%\System32;%SystemRoot%\System32\wbem;%SystemRoot%\System32\WindowsPowerShell\v1.0\"
if exist "%SystemRoot%\Sysnative\reg.exe" (
set "PATH=%SystemRoot%\Sysnative;%SystemRoot%\Sysnative\wbem;%SystemRoot%\Sysnative\WindowsPowerShell\v1.0\;%PATH%"
)

:: Re-launch the script with x64 process if it was initiated by x86 process on x64 bit Windows
:: or with ARM64 process if it was initiated by x86/ARM32 process on ARM64 Windows

set "_cmdf=%~f0"
for %%# in (%*) do (
if /i "%%#"=="r1" set r1=1
if /i "%%#"=="r2" set r2=1
)

if exist %SystemRoot%\Sysnative\cmd.exe if not defined r1 (
setlocal EnableDelayedExpansion
start %SystemRoot%\Sysnative\cmd.exe /c ""!_cmdf!" %* r1"
exit /b
)

:: Re-launch the script with ARM32 process if it was initiated by x64 process on ARM64 Windows

if exist %SystemRoot%\SysArm32\cmd.exe if %PROCESSOR_ARCHITECTURE%==AMD64 if not defined r2 (
setlocal EnableDelayedExpansion
start %SystemRoot%\SysArm32\cmd.exe /c ""!_cmdf!" %* r2"
exit /b
)

::========================================================================================================================================

set "blank="
set "mas=ht%blank%tps%blank%://mass%blank%grave.dev/"

::  Check if Null service is working, it's important for the batch script

sc query Null | find /i "RUNNING"
if %errorlevel% NEQ 0 (
echo:
echo Dich vu Null khong chay, tap lenh co the bi loi...
echo:
echo:
echo Tro giup - %mas%idm-activation-script.html#Troubleshoot
echo:
echo:
ping 127.0.0.1 -n 10
)
cls

::  Check LF line ending

pushd "%~dp0"
>nul findstr /v "$" "%~nx0" && (
echo:
echo Loi: Tap lenh co van de ve ket thuc dong LF hoac thieu mot dong trong o cuoi tap lenh.
echo:
ping 127.0.0.1 -n 6 >nul
popd
exit /b
)
popd

::========================================================================================================================================

cls
color 07
title  IDM Activation Script %iasver% - Viet Hoa By DucNguyen Tech 2.1

set _args=
set _elev=
set _unattended=0

set _args=%*
if defined _args set _args=%_args:"=%
if defined _args (
for %%A in (%_args%) do (
if /i "%%A"=="-el"  set _elev=1
if /i "%%A"=="/res" set _reset=1
if /i "%%A"=="/frz" set _freeze=1
if /i "%%A"=="/act" set _activate=1
)
)

for %%A in (%_activate% %_freeze% %_reset%) do (if "%%A"=="1" set _unattended=1)

::========================================================================================================================================

set "nul1=1>nul"
set "nul2=2>nul"
set "nul6=2^>nul"
set "nul=>nul 2>&1"

set psc=powershell.exe
set winbuild=1
for /f "tokens=6 delims=[]. " %%G in ('ver') do set winbuild=%%G

set _NCS=1
if %winbuild% LSS 10586 set _NCS=0
if %winbuild% GEQ 10586 reg query "HKCU\Console" /v ForceV2 %nul2% | find /i "0x0" %nul1% && (set _NCS=0)

if %_NCS% EQU 1 (
for /F %%a in ('echo prompt $E ^| cmd') do set "esc=%%a"
set     "Red="41;97m""
set    "Gray="100;97m""
set   "Green="42;97m""
set    "Blue="44;97m""
set  "_White="40;37m""
set  "_Green="40;92m""
set "_Yellow="40;93m""
) else (
set     "Red="Red" "white""
set    "Gray="Darkgray" "white""
set   "Green="DarkGreen" "white""
set    "Blue="Blue" "white""
set  "_White="Black" "Gray""
set  "_Green="Black" "Green""
set "_Yellow="Black" "Yellow""
)

set "nceline=echo: &echo ==== ERROR ==== &echo:"
set "eline=echo: &call :_color %Red% "==== ERROR ====" &echo:"
set "line=___________________________________________________________________________________________________"
set "_buf={$W=$Host.UI.RawUI.WindowSize;$B=$Host.UI.RawUI.BufferSize;$W.Height=34;$B.Height=300;$Host.UI.RawUI.WindowSize=$W;$Host.UI.RawUI.BufferSize=$B;}"

::========================================================================================================================================

if %winbuild% LSS 7600 (
%nceline%
echo Da phat hien phien ban he dieu hanh khong ho tro [%winbuild%].
echo Du an chi ho tro cho Windows 7/8/8.1/10/11 va May Chu tuong duong cua chung.
goto done2
)

for %%# in (powershell.exe) do @if "%%~$PATH:#"=="" (
%nceline%
echo Khong the tim thay powershell.exe trong he thong.
goto done2
)

::========================================================================================================================================

::  Fix for the special characters limitation in path name

set "_work=%~dp0"
if "%_work:~-1%"=="\" set "_work=%_work:~0,-1%"

set "_batf=%~f0"
set "_batp=%_batf:'=''%"

set _PSarg="""%~f0""" -el %_args%
set _PSarg=%_PSarg:'=''%

set "_appdata=%appdata%"
set "_ttemp=%userprofile%\AppData\Local\Temp"

setlocal EnableDelayedExpansion

::========================================================================================================================================

echo "!_batf!" | find /i "!_ttemp!" %nul1% && (
if /i not "!_work!"=="!_ttemp!" (
%eline%
echo Tap lenh duoc khoi chay tu thu muc tam thoi,
echo Rat co the ban dang chay tap lenh truc tiep tu tep luu tru.
echo:
echo Giai nen tep luu tru va khoi chay tap lenh tu thu muc duoc giai nen.
goto done2
)
)

::========================================================================================================================================

::  Check PowerShell

REM :PowerShellTest: $ExecutionContext.SessionState.LanguageMode :PowerShellTest:

%psc% "$f=[io.file]::ReadAllText('!_batp!') -split ':PowerShellTest:\s*';iex ($f[1])" | find /i "FullLanguage" %nul1% || (
%eline%
%psc% $ExecutionContext.SessionState.LanguageMode
echo:
echo PowerShell khong hoat dong. Huy bo...
echo Neu ban da ap dung cac han che tren PowerShell thi hay hoan tac nhung thay doi do.
echo:
echo Kiem tra trang nay de duoc tro giup. %mas%idm-activation-script.html#Troubleshoot
goto done2
)

::========================================================================================================================================

::  Elevate script as admin and pass arguments and preventing loop

%nul1% fltmc || (
if not defined _elev %psc% "start cmd.exe -arg '/c \"!_PSarg!\"' -verb runas" && exit /b
%eline%
echo Tap lenh nay yeu cau quyen quan tri vien.
echo De lam nhu vay, nhap chuot phai vao tap lenh nay va chon 'Run With Administrator'.
goto done2
)

::========================================================================================================================================

::  Disable QuickEdit and launch from conhost.exe to avoid Terminal app

set quedit=
set terminal=

if %_unattended%==1 (
set quedit=1
set terminal=1
)

for %%# in (%_args%) do (if /i "%%#"=="-qedit" set quedit=1)

if %winbuild% LSS 10586 (
reg query HKCU\Console /v QuickEdit %nul2% | find /i "0x0" %nul1% && set quedit=1
)

if %winbuild% GEQ 17763 (
set "launchcmd=start conhost.exe %psc%"
) else (
set "launchcmd=%psc%"
)

set "d1=$t=[AppDomain]::CurrentDomain.DefineDynamicAssembly(4, 1).DefineDynamicModule(2, $False).DefineType(0);"
set "d2=$t.DefinePInvokeMethod('GetStdHandle', 'kernel32.dll', 22, 1, [IntPtr], @([Int32]), 1, 3).SetImplementationFlags(128);"
set "d3=$t.DefinePInvokeMethod('SetConsoleMode', 'kernel32.dll', 22, 1, [Boolean], @([IntPtr], [Int32]), 1, 3).SetImplementationFlags(128);"
set "d4=$k=$t.CreateType(); $b=$k::SetConsoleMode($k::GetStdHandle(-10), 0x0080);"

if defined quedit goto :skipQE
%launchcmd% "%d1% %d2% %d3% %d4% & cmd.exe '/c' '!_PSarg! -qedit'" &exit /b
:skipQE

::========================================================================================================================================

::  Check for updates

set -=
set old=

for /f "delims=[] tokens=2" %%# in ('ping -4 -n 1 iasupdatecheck.mass%-%grave.dev') do (
if not [%%#]==[] (echo "%%#" | find "127.69" %nul1% && (echo "%%#" | find "127.69.%iasver%" %nul1% || set old=1))
)

if defined old (
echo ________________________________________________
%eline%
echo Ban dang chay phien ban IAS loi thoi %iasver%
echo ________________________________________________
echo:
if not %_unattended%==1 (
echo [1] Nhan phien ban IAS moi nhat
echo [0] Van tiep tuc su dung phien ban cu
echo:
call :_color %_Green% "Nhap mot tuy chon Menu trong ban phim [1,0] :"
choice /C:10 /N
if !errorlevel!==2 rem
if !errorlevel!==1 (start https://github.com/WindowsAddict/IDM-Activation-Script & start %mas%/idm-activation-script & exit /b)
)
)

::========================================================================================================================================

cls
title  IDM Activation Script %iasver% - Viet Hoa By DucNguyen Tech 2.1

echo:
echo Dang khoi tao...

::  Check WMI

%psc% "Get-WmiObject -Class Win32_ComputerSystem | Select-Object -Property CreationClassName" %nul2% | find /i "computersystem" %nul1% || (
%eline%
%psc% "Get-WmiObject -Class Win32_ComputerSystem | Select-Object -Property CreationClassName"
echo:
echo WMI khong hoat dong. Huy bo...
echo:
echo Kiem tra trang nay de duoc tro giup. %mas%idm-activation-script.html#Troubleshoot
goto done2
)

::  Check user account SID

set _sid=
for /f "delims=" %%a in ('%psc% "([System.Security.Principal.NTAccount](Get-WmiObject -Class Win32_ComputerSystem).UserName).Translate([System.Security.Principal.SecurityIdentifier]).Value" %nul6%') do (set _sid=%%a)
 
reg query HKU\%_sid%\Software %nul% || (
for /f "delims=" %%a in ('%psc% "$explorerProc = Get-Process -Name explorer | Where-Object {$_.SessionId -eq (Get-Process -Id $pid).SessionId} | Select-Object -First 1; $sid = (gwmi -Query ('Select * From Win32_Process Where ProcessID=' + $explorerProc.Id)).GetOwnerSid().Sid; $sid" %nul6%') do (set _sid=%%a)
)

reg query HKU\%_sid%\Software %nul% || (
%eline%
echo:
echo [%_sid%]
echo Khong tim thay SID tai khoan nguoi dung. Huy bo...
echo:
echo Kiem tra trang nay de duoc tro giup. %mas%idm-activation-script.html#Troubleshoot
goto done2
)

::========================================================================================================================================

::  Check if the current user SID is syncing with the HKCU entries

%nul% reg delete HKCU\IAS_TEST /f
%nul% reg delete HKU\%_sid%\IAS_TEST /f

set HKCUsync=$null
%nul% reg add HKCU\IAS_TEST
%nul% reg query HKU\%_sid%\IAS_TEST && (
set HKCUsync=1
)

%nul% reg delete HKCU\IAS_TEST /f
%nul% reg delete HKU\%_sid%\IAS_TEST /f

::  Below code also works for ARM64 Windows 10 (including x64 bit emulation)

for /f "skip=2 tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PROCESSOR_ARCHITECTURE') do set arch=%%b
if /i not "%arch%"=="x86" set arch=x64

if "%arch%"=="x86" (
set "CLSID=HKCU\Software\Classes\CLSID"
set "CLSID2=HKU\%_sid%\Software\Classes\CLSID"
set "HKLM=HKLM\Software\Internet Download Manager"
) else (
set "CLSID=HKCU\Software\Classes\Wow6432Node\CLSID"
set "CLSID2=HKU\%_sid%\Software\Classes\Wow6432Node\CLSID"
set "HKLM=HKLM\SOFTWARE\Wow6432Node\Internet Download Manager"
)

for /f "tokens=2*" %%a in ('reg query "HKU\%_sid%\Software\DownloadManager" /v ExePath %nul6%') do call set "IDMan=%%b"

if not exist "%IDMan%" (
if %arch%==x64 set "IDMan=%ProgramFiles(x86)%\Internet Download Manager\IDMan.exe"
if %arch%==x86 set "IDMan=%ProgramFiles%\Internet Download Manager\IDMan.exe"
)

if not exist %SystemRoot%\Temp md %SystemRoot%\Temp
set "idmcheck=tasklist /fi "imagename eq idman.exe" | findstr /i "idman.exe" %nul1%"

::  Check CLSID registry access

%nul% reg add %CLSID2%\IAS_TEST
%nul% reg query %CLSID2%\IAS_TEST || (
%eline%
echo Khong the viet vao %CLSID2%
echo:
echo Kiem tra trang nay de duoc tro giup. %mas%idm-activation-script.html#Troubleshoot
goto done2
)

%nul% reg delete %CLSID2%\IAS_TEST /f

::========================================================================================================================================

if %_reset%==1 goto :_reset
if %_activate%==1 (set frz=0&goto :_activate)
if %_freeze%==1 (set frz=1&goto :_activate)

:MainMenu

cls
title  IDM Activation Script %iasver% - Viet Hoa By DucNguyen Tech 2.1
if not defined terminal mode 75, 28

echo:
echo:
echo:
echo:
echo:
call :_color2 %_White% "               " %_Yellow% "IAS %iasver% - Viet Hoa By DucNguyen Tech 2.1"  
call :_color2 %_White% "              " %Red% "Tap lenh nay KHONG hoat dong voi IDM moi nhat."
echo:            ___________________________________________________ 
echo:                                                               
echo:               [1] Dong bang phien ban dung thu
echo:               [2] Kich hoat
echo:               [3] Dat lai kich hoat / dung thu
echo:               [4] Tat thong bao cap nhat IDM
echo:               _____________________________________________   
echo:                                                               
echo:               [5] Tai xuong IDM
echo:               [6] Tro giup
echo:               [0] Thoat
echo:            ___________________________________________________
echo:         
call :_color2 %_White% "           " %_Green% "Nhap mot tuy chon Menu trong ban phim [1,2,3,4,5,6,0]"
choice /C:1234560 /N
set _erl=%errorlevel%

if %_erl%==7 exit /b
if %_erl%==6 start https://github.com/WindowsAddict/IDM-Activation-Script & start https://massgrave.dev/idm-activation-script & goto MainMenu
if %_erl%==5 start https://www.internetdownloadmanager.com/download.html & goto MainMenu
if %_erl%==4 goto _turnoffupdatecheck
if %_erl%==3 goto _reset
if %_erl%==2 (set frz=0&goto :_activate)
if %_erl%==1 (set frz=1&goto :_activate)
goto :MainMenu

::========================================================================================================================================

::Tắt kiểm tra cập nhật
:_turnoffupdatecheck
cls
ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ECHO @
ECHO @ IAS 1.2 - Viet Hoa By DucNguyen Tech 2.1
ECHO @ Disable IDM Automatic Update Check
ECHO @
ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo.
reg delete HKCU\SOFTWARE\DownloadManager /v LstCheck /f
reg add HKCU\SOFTWARE\DownloadManager /v LstCheck /t REG_SZ /d 01/10/99
echo.
call :_color %Green% "Da tat IDM Automatic Update Check."
timeout /t 10
goto MainMenu


:_reset

cls
if not %HKCUsync%==1 (
if not defined terminal mode 153, 35
) else (
if not defined terminal mode 113, 35
)
if not defined terminal %psc% "&%_buf%" %nul%

echo:
%idmcheck% && taskkill /f /im idman.exe

set _time=
for /f %%a in ('%psc% "(Get-Date).ToString('yyyyMMdd-HHmmssfff')"') do set _time=%%a

echo:
echo Tao ban sao luu cac Key dang ky CLSID trong %SystemRoot%\Temp

reg export %CLSID% "%SystemRoot%\Temp\_Backup_HKCU_CLSID_%_time%.reg"
if not %HKCUsync%==1 reg export %CLSID2% "%SystemRoot%\Temp\_Backup_HKU-%_sid%_CLSID_%_time%.reg"

call :delete_queue
%psc% "$sid = '%_sid%'; $HKCUsync = %HKCUsync%; $lockKey = $null; $deleteKey = 1; $f=[io.file]::ReadAllText('!_batp!') -split ':regscan\:.*';iex ($f[1])"

call :add_key

echo:
echo %line%
echo:
call :_color %Green% "Qua trinh dat lai IDM da hoan tat."

goto done

:delete_queue

echo:
echo Xoa cac Registry Keys IDM...
echo:

for %%# in (
""HKCU\Software\DownloadManager" "/v" "FName""
""HKCU\Software\DownloadManager" "/v" "LName""
""HKCU\Software\DownloadManager" "/v" "Email""
""HKCU\Software\DownloadManager" "/v" "Serial""
""HKCU\Software\DownloadManager" "/v" "scansk""
""HKCU\Software\DownloadManager" "/v" "tvfrdt""
""HKCU\Software\DownloadManager" "/v" "radxcnt""
""HKCU\Software\DownloadManager" "/v" "LstCheck""
""HKCU\Software\DownloadManager" "/v" "ptrk_scdt""
""HKCU\Software\DownloadManager" "/v" "LastCheckQU""
"%HKLM%"
) do for /f "tokens=* delims=" %%A in ("%%~#") do (
set "reg="%%~A"" &reg query !reg! %nul% && call :del
)

if not %HKCUsync%==1 for %%# in (
""HKU\%_sid%\Software\DownloadManager" "/v" "FName""
""HKU\%_sid%\Software\DownloadManager" "/v" "LName""
""HKU\%_sid%\Software\DownloadManager" "/v" "Email""
""HKU\%_sid%\Software\DownloadManager" "/v" "Serial""
""HKU\%_sid%\Software\DownloadManager" "/v" "scansk""
""HKU\%_sid%\Software\DownloadManager" "/v" "tvfrdt""
""HKU\%_sid%\Software\DownloadManager" "/v" "radxcnt""
""HKU\%_sid%\Software\DownloadManager" "/v" "LstCheck""
""HKU\%_sid%\Software\DownloadManager" "/v" "ptrk_scdt""
""HKU\%_sid%\Software\DownloadManager" "/v" "LastCheckQU""
) do for /f "tokens=* delims=" %%A in ("%%~#") do (
set "reg="%%~A"" &reg query !reg! %nul% && call :del
)

exit /b

:del

reg delete %reg% /f %nul%

if "%errorlevel%"=="0" (
set "reg=%reg:"=%"
echo Deleted - !reg!
) else (
set "reg=%reg:"=%"
call :_color2 %Red% "Failed - !reg!"
)

exit /b

::========================================================================================================================================

:_activate

::Add Custom Name
cls
ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ECHO @
ECHO @ IAS 1.2 - Viet Hoa By DucNguyen Tech 2.1
ECHO @ Set Custom Name
ECHO @
ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
call :_color %_Yellow% "Them ten va email tuy chinh vao Infomation License IDM"
call :_color %_Yellow% "Ten duoc viet bang tieng anh hoac tieng viet khong dau hoac so o duoi"
call :_color %_Yellow% "Ban co the bo qua buoc nay neu khong muon dat ten."
echo.
set /p name=  Ban co the dat ten cua minh tai day :
echo.
set /p email=  Ban co the dat email cua minh tai day :
mode 93, 32
%nul% %_psc% "&%_buf%" 

cls
if not %HKCUsync%==1 (
if not defined terminal mode 153, 35
) else (
if not defined terminal mode 113, 35
)
if not defined terminal %psc% "&%_buf%" %nul%

if %frz%==0 if %_unattended%==0 (
echo:
echo %line%
echo:
echo      Kich hoat khong hoat dong voi mot so nguoi dung va IDM co the thong bao Fake Serial.
echo:
call :_color2 %_White% "     " %_Green% "Thay vao do, nen su dung tuy chon 'Dong bang dung thu'."
echo %line%
echo:
choice /C:19 /N /M ">    [1] Quay Lai [9] Kich hoat : "
if !errorlevel!==1 goto :MainMenu
cls
)

echo:
if not exist "%IDMan%" (
call :_color %Red% "IDM [Internet Download Manager] chua duoc cai dat."
echo Ban co the tai xuong tu duong link https://www.internetdownloadmanager.com/download.html
goto done
)

:: Internet check with internetdownloadmanager.com ping and port 80 test

set _int=
for /f "delims=[] tokens=2" %%# in ('ping -n 1 internetdownloadmanager.com') do (if not [%%#]==[] set _int=1)

if not defined _int (
%psc% "$t = New-Object Net.Sockets.TcpClient;try{$t.Connect("""internetdownloadmanager.com""", 80)}catch{};$t.Connected" | findstr /i "true" %nul1% || (
call :_color %Red% "Khong the ket noi toi internetdownloadmanager.com, dang huy bo..."
goto done
)
call :_color %Gray% "Lenh Ping internetdownloadmanager.com khong thanh cong"
echo:
)

for /f "skip=2 tokens=2*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName 2^>nul') do set "regwinos=%%b"
for /f "skip=2 tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PROCESSOR_ARCHITECTURE') do set "regarch=%%b"
for /f "tokens=6-7 delims=[]. " %%i in ('ver') do if "%%j"=="" (set fullbuild=%%i) else (set fullbuild=%%i.%%j)
for /f "tokens=2*" %%a in ('reg query "HKU\%_sid%\Software\DownloadManager" /v idmvers %nul6%') do set "IDMver=%%b"

echo Kiem tra thong tin may tinh - [%regwinos% ^| %fullbuild% ^| %regarch% ^| IDM: %IDMver%]

%idmcheck% && (echo: & taskkill /f /im idman.exe)

set _time=
for /f %%a in ('%psc% "(Get-Date).ToString('yyyyMMdd-HHmmssfff')"') do set _time=%%a

echo:
echo Tao ban sao luu cac Registry Key CLSID trong %SystemRoot%\Temp

reg export %CLSID% "%SystemRoot%\Temp\_Backup_HKCU_CLSID_%_time%.reg"
if not %HKCUsync%==1 reg export %CLSID2% "%SystemRoot%\Temp\_Backup_HKU-%_sid%_CLSID_%_time%.reg"

call :delete_queue
call :add_key

%psc% "$sid = '%_sid%'; $HKCUsync = %HKCUsync%; $lockKey = 1; $deleteKey = $null; $toggle = 1; $f=[io.file]::ReadAllText('!_batp!') -split ':regscan\:.*';iex ($f[1])"

if %frz%==0 call :register_IDM

call :download_files
if not defined _fileexist (
%eline%
echo Loi: Khong tai duoc file bang IDM.
echo:
echo Tro giup: %mas%idm-activation-script.html#Troubleshoot
goto :done
)

%psc% "$sid = '%_sid%'; $HKCUsync = %HKCUsync%; $lockKey = 1; $deleteKey = $null; $f=[io.file]::ReadAllText('!_batp!') -split ':regscan\:.*';iex ($f[1])"

::Adding Block Host IDM
cls
SETLOCAL ENABLEDELAYEDEXPANSION
ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ECHO @
ECHO @ IAS 1.2 - Viet Hoa By DucNguyen Tech 2.1
ECHO @ Block Host IDM
ECHO @
ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	
		SET BLOCKLINE=127.0.0.1 tonec.com
		ECHO Checking : !BLOCKLINE!
	    FIND /C /I "!BLOCKLINE!" "%WINDIR%\system32\drivers\etc\hosts" >NUL 2>NUL
	    IF !ERRORLEVEL! NEQ 0 (
	    	ECHO Line not found, adding to the hosts file.
	    	ECHO !BLOCKLINE!>>%WINDIR%\system32\drivers\etc\hosts
	    ) ELSE (
	    	ECHO Line found.
	    )
    	ECHO.
    	
		SET BLOCKLINE=127.0.0.1 www.tonec.com
		ECHO Checking : !BLOCKLINE!
	    FIND /C /I "!BLOCKLINE!" "%WINDIR%\system32\drivers\etc\hosts" >NUL 2>NUL
	    IF !ERRORLEVEL! NEQ 0 (
	    	ECHO Line not found, adding to the hosts file.
	    	ECHO !BLOCKLINE!>>%WINDIR%\system32\drivers\etc\hosts
	    ) ELSE (
	    	ECHO Line found.
	    )
    	ECHO.

        		SET BLOCKLINE=127.0.0.1 registeridm.com
		ECHO Checking : !BLOCKLINE!
	    FIND /C /I "!BLOCKLINE!" "%WINDIR%\system32\drivers\etc\hosts" >NUL 2>NUL
	    IF !ERRORLEVEL! NEQ 0 (
	    	ECHO Line not found, adding to the hosts file.
	    	ECHO !BLOCKLINE!>>%WINDIR%\system32\drivers\etc\hosts
	    ) ELSE (
	    	ECHO Line found.
	    )
    	ECHO.
    	
		SET BLOCKLINE=127.0.0.1 *.registeridm.com
		ECHO Checking : !BLOCKLINE!
	    FIND /C /I "!BLOCKLINE!" "%WINDIR%\system32\drivers\etc\hosts" >NUL 2>NUL
	    IF !ERRORLEVEL! NEQ 0 (
	    	ECHO Line not found, adding to the hosts file.
	    	ECHO !BLOCKLINE!>>%WINDIR%\system32\drivers\etc\hosts
	    ) ELSE (
	    	ECHO Line found.
	    )
    	ECHO.

        		SET BLOCKLINE=127.0.0.1 secure.registeridm.com
		ECHO Checking : !BLOCKLINE!
	    FIND /C /I "!BLOCKLINE!" "%WINDIR%\system32\drivers\etc\hosts" >NUL 2>NUL
	    IF !ERRORLEVEL! NEQ 0 (
	    	ECHO Line not found, adding to the hosts file.
	    	ECHO !BLOCKLINE!>>%WINDIR%\system32\drivers\etc\hosts
	    ) ELSE (
	    	ECHO Line found.
	    )
    	ECHO.
    	
		SET BLOCKLINE=127.0.0.1 internetdownloadmanager.com
		ECHO Checking : !BLOCKLINE!
	    FIND /C /I "!BLOCKLINE!" "%WINDIR%\system32\drivers\etc\hosts" >NUL 2>NUL
	    IF !ERRORLEVEL! NEQ 0 (
	    	ECHO Line not found, adding to the hosts file.
	    	ECHO !BLOCKLINE!>>%WINDIR%\system32\drivers\etc\hosts
	    ) ELSE (
	    	ECHO Line found.
	    )
    	ECHO.

        		SET BLOCKLINE=127.0.0.1 *.internetdownloadmanager.com
		ECHO Checking : !BLOCKLINE!
	    FIND /C /I "!BLOCKLINE!" "%WINDIR%\system32\drivers\etc\hosts" >NUL 2>NUL
	    IF !ERRORLEVEL! NEQ 0 (
	    	ECHO Line not found, adding to the hosts file.
	    	ECHO !BLOCKLINE!>>%WINDIR%\system32\drivers\etc\hosts
	    ) ELSE (
	    	ECHO Line found.
	    )
    	ECHO.
    	
		SET BLOCKLINE=127.0.0.1 www.internetdownloadmanager.com
		ECHO Checking : !BLOCKLINE!
	    FIND /C /I "!BLOCKLINE!" "%WINDIR%\system32\drivers\etc\hosts" >NUL 2>NUL
	    IF !ERRORLEVEL! NEQ 0 (
	    	ECHO Line not found, adding to the hosts file.
	    	ECHO !BLOCKLINE!>>%WINDIR%\system32\drivers\etc\hosts
	    ) ELSE (
	    	ECHO Line found.
	    )
    	ECHO.

                		SET BLOCKLINE=127.0.0.1 secure.internetdownloadmanager.com
		ECHO Checking : !BLOCKLINE!
	    FIND /C /I "!BLOCKLINE!" "%WINDIR%\system32\drivers\etc\hosts" >NUL 2>NUL
	    IF !ERRORLEVEL! NEQ 0 (
	    	ECHO Line not found, adding to the hosts file.
	    	ECHO !BLOCKLINE!>>%WINDIR%\system32\drivers\etc\hosts
	    ) ELSE (
	    	ECHO Line found.
	    )
    	ECHO.
    	
		SET BLOCKLINE=127.0.0.1 mirror.internetdownloadmanager.com
		ECHO Checking : !BLOCKLINE!
	    FIND /C /I "!BLOCKLINE!" "%WINDIR%\system32\drivers\etc\hosts" >NUL 2>NUL
	    IF !ERRORLEVEL! NEQ 0 (
	    	ECHO Line not found, adding to the hosts file.
	    	ECHO !BLOCKLINE!>>%WINDIR%\system32\drivers\etc\hosts
	    ) ELSE (
	    	ECHO Line found.
	    )
    	ECHO.

        		SET BLOCKLINE=127.0.0.1 mirror2.internetdownloadmanager.com
		ECHO Checking : !BLOCKLINE!
	    FIND /C /I "!BLOCKLINE!" "%WINDIR%\system32\drivers\etc\hosts" >NUL 2>NUL
	    IF !ERRORLEVEL! NEQ 0 (
	    	ECHO Line not found, adding to the hosts file.
	    	ECHO !BLOCKLINE!>>%WINDIR%\system32\drivers\etc\hosts
	    ) ELSE (
	    	ECHO Line found.
	    )
    	ECHO.
    	
		SET BLOCKLINE=127.0.0.1 mirror3.internetdownloadmanager.com
		ECHO Checking : !BLOCKLINE!
	    FIND /C /I "!BLOCKLINE!" "%WINDIR%\system32\drivers\etc\hosts" >NUL 2>NUL
	    IF !ERRORLEVEL! NEQ 0 (
	    	ECHO Line not found, adding to the hosts file.
	    	ECHO !BLOCKLINE!>>%WINDIR%\system32\drivers\etc\hosts
	    ) ELSE (
	    	ECHO Line found.
	    )
    	ECHO.
		attrib +r %WINDIR%\system32\drivers\etc\hosts

        SETLOCAL DisableDelayedExpansion

echo:
echo %line%
echo:
if %frz%==0 (
call :_color %Green% "Qua trinh kich hoat IDM da hoan tat."
echo:
call :_color %Gray% "Neu hien thong bao Fake Serial, hay su dung tuy chon 'Dong bang dung thu'."
) else (
call :_color %Green% "IDM dung thu 30 ngay da duoc dong bang tron doi thanh cong."
echo:
call :_color %Gray% "Neu IDM hien thong bao yeu cau dang ky, hay cai dat lai IDM."
)

::========================================================================================================================================

:done

echo %line%
echo:
echo:
if %_unattended%==1 timeout /t 2 & exit /b

if defined terminal (
call :_color %_Yellow% "Nhan phim 0 de quay lai..."
choice /c 0 /n
) else (
call :_color %_Yellow% "Nhan phim bat ky de quay lai..."
pause %nul1%
)
goto MainMenu

:done2

if %_unattended%==1 timeout /t 2 & exit /b

if defined terminal (
echo Nhan phim 0 de quay lai...
choice /c 0 /n
) else (
echo Nhan phim bat ky de quay lai...
pause %nul1%
)
exit /b

::========================================================================================================================================

:_rcont

reg add %reg% %nul%
call :add
exit /b

:register_IDM

echo:
echo Ap dung thong tin dang ky...
echo:

If not defined name set name=Tonec FZE
If not defined email set email=Tonec FZE@tonec.com

for /f "delims=" %%a in ('%psc% "$key = -join ((Get-Random -Count  20 -InputObject ([char[]]('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'))));$key = ($key.Substring(0,  5) + '-' + $key.Substring(5,  5) + '-' + $key.Substring(10,  5) + '-' + $key.Substring(15,  5) + $key.Substring(20));Write-Output $key" %nul6%') do (set key=%%a)

set "reg=HKCU\SOFTWARE\DownloadManager /v FName /t REG_SZ /d "%name%"" & call :_rcont
set "reg=HKCU\SOFTWARE\DownloadManager /v LName /t REG_SZ /d """ & call :_rcont
set "reg=HKCU\SOFTWARE\DownloadManager /v Email /t REG_SZ /d "%email%"" & call :_rcont
set "reg=HKCU\SOFTWARE\DownloadManager /v Serial /t REG_SZ /d "%key%"" & call :_rcont

if not %HKCUsync%==1 (
set "reg=HKU\%_sid%\SOFTWARE\DownloadManager /v FName /t REG_SZ /d "%name%"" & call :_rcont
set "reg=HKU\%_sid%\SOFTWARE\DownloadManager /v LName /t REG_SZ /d """ & call :_rcont
set "reg=HKU\%_sid%\SOFTWARE\DownloadManager /v Email /t REG_SZ /d "%email%"" & call :_rcont
set "reg=HKU\%_sid%\SOFTWARE\DownloadManager /v Serial /t REG_SZ /d "%key%"" & call :_rcont
)
exit /b

:download_files

echo:
echo Dang kich hoat mot vai luot tai xuong de tao mot so khoa dang ky nhat dinh, vui long doi...
echo:

set "file=%SystemRoot%\Temp\temp.png"
set _fileexist=

set link=https://www.internetdownloadmanager.com/images/idm_box_min.png
call :download
set link=https://www.internetdownloadmanager.com/register/IDMlib/images/idman_logos.png
call :download
set link=https://www.internetdownloadmanager.com/pictures/idm_about.png
call :download

echo:
timeout /t 3 %nul1%
%idmcheck% && taskkill /f /im idman.exe
if exist "%file%" del /f /q "%file%"
exit /b

:download

set /a attempt=0
if exist "%file%" del /f /q "%file%"
start "" /B "%IDMan%" /n /d "%link%" /p "%SystemRoot%\Temp" /f temp.png

:check_file

timeout /t 1 %nul1%
set /a attempt+=1
if exist "%file%" set _fileexist=1&exit /b
if %attempt% GEQ 20 exit /b
goto :Check_file

::========================================================================================================================================

:add_key

echo:
echo Them Registry da dang ky...
echo:

set "reg="%HKLM%" /v "AdvIntDriverEnabled2""

reg add %reg% /t REG_DWORD /d "1" /f %nul%

:add

if "%errorlevel%"=="0" (
set "reg=%reg:"=%"
echo Da them - !reg!
) else (
set "reg=%reg:"=%"
call :_color2 %Red% "That bai - !reg!"
)
exit /b

::========================================================================================================================================

:regscan:
$finalValues = @()

$arch = (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment').PROCESSOR_ARCHITECTURE
if ($arch -eq "x86") {
  $regPaths = @("HKCU:\Software\Classes\CLSID", "Registry::HKEY_USERS\$sid\Software\Classes\CLSID")
} else {
  $regPaths = @("HKCU:\Software\Classes\WOW6432Node\CLSID", "Registry::HKEY_USERS\$sid\Software\Classes\Wow6432Node\CLSID")
}

foreach ($regPath in $regPaths) {
    if (($regPath -match "HKEY_USERS") -and ($HKCUsync -ne $null)) {
        continue
    }
	
	Write-Host
	Write-Host "Tim kiem khoa dang ky IDM CLSID trong $regPath"
	Write-Host
	
    $subKeys = Get-ChildItem -Path $regPath -ErrorAction SilentlyContinue -ErrorVariable lockedKeys | Where-Object { $_.PSChildName -match '^\{[A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12}\}$' }

    foreach ($lockedKey in $lockedKeys) {
        $leafValue = Split-Path -Path $lockedKey.TargetObject -Leaf
        $finalValues += $leafValue
        Write-Output "$leafValue - Da tim thay Locked Key"
    }

    if ($subKeys -eq $null) {
	continue
	}
	
	$subKeysToExclude = "LocalServer32", "InProcServer32", "InProcHandler32"

    $filteredKeys = $subKeys | Where-Object { !($_.GetSubKeyNames() | Where-Object { $subKeysToExclude -contains $_ }) }

    foreach ($key in $filteredKeys) {
        $fullPath = $key.PSPath
        $keyValues = Get-ItemProperty -Path $fullPath -ErrorAction SilentlyContinue
        $defaultValue = $keyValues.PSObject.Properties | Where-Object { $_.Name -eq '(default)' } | Select-Object -ExpandProperty Value

        if (($defaultValue -match "^\d+$") -and ($key.SubKeyCount -eq 0)) {
            $finalValues += $($key.PSChildName)
            Write-Output "$($key.PSChildName) - Da tim thay Digit mac dinh va khong co Subkeys"
            continue
        }
        if (($defaultValue -match "\+|=") -and ($key.SubKeyCount -eq 0)) {
            $finalValues += $($key.PSChildName)
            Write-Output "$($key.PSChildName) - Tim thay + hoac = mac dinh va khong co Subkeys"
            continue
        }
        $versionValue = Get-ItemProperty -Path "$fullPath\Version" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty '(default)' -ErrorAction SilentlyContinue
        if (($versionValue -match "^\d+$") -and ($key.SubKeyCount -eq 1)) {
            $finalValues += $($key.PSChildName)
            Write-Output "$($key.PSChildName) - Tim thay Digit trong \Version và khong co Subkeys"
            continue
        }
        $keyValues.PSObject.Properties | ForEach-Object {
            if ($_.Name -match "MData|Model|scansk|Therad") {
                $finalValues += $($key.PSChildName)
                Write-Output "$($key.PSChildName) - Da tim thay MData Model scansk Therad"
                continue
            }
        }
        if (($key.ValueCount -eq 0) -and ($key.SubKeyCount -eq 0)) {
            $finalValues += $($key.PSChildName)
            Write-Output "$($key.PSChildName) - Tim thay Key trong"
            continue
        }
    }
}

$finalValues = @($finalValues | Select-Object -Unique)

if ($finalValues -ne $null) {
    Write-Host
    if ($lockKey -ne $null) {
        Write-Host "Khoa Registry Key IDM CLSID..."
    }
    if ($deleteKey -ne $null) {
        Write-Host "Xoa Registry Key IDM CLSID..."
    }
    Write-Host
} else {
    Write-Host "Khong tim thay IDM CLSID Registry Keys."
	Exit
}

if (($finalValues.Count -gt 20) -and ($toggle -ne $null)) {
	$lockKey = $null
	$deleteKey = 1
    Write-Host "So luong Key IDM lon hon 20. Hay xoa chung ngay thay vi khoa..."
	Write-Host
}

function Take-Permissions {
    param($rootKey, $regKey)
    $AssemblyBuilder = [AppDomain]::CurrentDomain.DefineDynamicAssembly(4, 1)
    $ModuleBuilder = $AssemblyBuilder.DefineDynamicModule(2, $False)
    $TypeBuilder = $ModuleBuilder.DefineType(0)

    $TypeBuilder.DefinePInvokeMethod('RtlAdjustPrivilege', 'ntdll.dll', 'Public, Static', 1, [int], @([int], [bool], [bool], [bool].MakeByRefType()), 1, 3) | Out-Null
    9,17,18 | ForEach-Object { $TypeBuilder.CreateType()::RtlAdjustPrivilege($_, $true, $false, [ref]$false) | Out-Null }

    $SID = New-Object System.Security.Principal.SecurityIdentifier('S-1-5-32-544')
    $IDN = ($SID.Translate([System.Security.Principal.NTAccount])).Value
    $Admin = New-Object System.Security.Principal.NTAccount($IDN)

    $everyone = New-Object System.Security.Principal.SecurityIdentifier('S-1-1-0')
    $none = New-Object System.Security.Principal.SecurityIdentifier('S-1-0-0')

    $key = [Microsoft.Win32.Registry]::$rootKey.OpenSubKey($regkey, 'ReadWriteSubTree', 'TakeOwnership')

    $acl = New-Object System.Security.AccessControl.RegistrySecurity
    $acl.SetOwner($Admin)
    $key.SetAccessControl($acl)

    $key = $key.OpenSubKey('', 'ReadWriteSubTree', 'ChangePermissions')
    $rule = New-Object System.Security.AccessControl.RegistryAccessRule($everyone, 'FullControl', 'ContainerInherit', 'None', 'Allow')
    $acl.ResetAccessRule($rule)
    $key.SetAccessControl($acl)

    if ($lockKey -ne $null) {
        $acl = New-Object System.Security.AccessControl.RegistrySecurity
        $acl.SetOwner($none)
        $key.SetAccessControl($acl)

        $key = $key.OpenSubKey('', 'ReadWriteSubTree', 'ChangePermissions')
        $rule = New-Object System.Security.AccessControl.RegistryAccessRule($everyone, 'FullControl', 'Deny')
        $acl.ResetAccessRule($rule)
        $key.SetAccessControl($acl)
    }
}

foreach ($regPath in $regPaths) {
    if (($regPath -match "HKEY_USERS") -and ($HKCUsync -ne $null)) {
        continue
    }
    foreach ($finalValue in $finalValues) {
        $fullPath = Join-Path -Path $regPath -ChildPath $finalValue
        if ($fullPath -match 'HKCU:') {
            $rootKey = 'CurrentUser'
        } else {
            $rootKey = 'Users'
        }

        $position = $fullPath.IndexOf("\")
        $regKey = $fullPath.Substring($position + 1)

        if ($lockKey -ne $null) {
            if (-not (Test-Path -Path $fullPath -ErrorAction SilentlyContinue)) { New-Item -Path $fullPath -Force -ErrorAction SilentlyContinue | Out-Null }
            Take-Permissions $rootKey $regKey
            try {
                Remove-Item -Path $fullPath -Force -Recurse -ErrorAction Stop
                Write-Host -back 'DarkRed' -fore 'white' "That bai - $fullPath"
            }
            catch {
                Write-Host "Da khoa - $fullPath"
            }
        }

        if ($deleteKey -ne $null) {
            if (Test-Path -Path $fullPath) {
                Remove-Item -Path $fullPath -Force -Recurse -ErrorAction SilentlyContinue
                if (Test-Path -Path $fullPath) {
                    Take-Permissions $rootKey $regKey
                    try {
                        Remove-Item -Path $fullPath -Force -Recurse -ErrorAction Stop
                        Write-Host "Da xoa - $fullPath"
                    }
                    catch {
                        Write-Host -back 'DarkRed' -fore 'white' "That bai - $fullPath"
                    }
                }
                else {
                    Write-Host "Da xoa - $fullPath"
                }
            }
        }
    }
}
:regscan:

::========================================================================================================================================

:_color

if %_NCS% EQU 1 (
echo %esc%[%~1%~2%esc%[0m
) else (
%psc% write-host -back '%1' -fore '%2' '%3'
)
exit /b

:_color2

if %_NCS% EQU 1 (
echo %esc%[%~1%~2%esc%[%~3%~4%esc%[0m
) else (
%psc% write-host -back '%1' -fore '%2' '%3' -NoNewline; write-host -back '%4' -fore '%5' '%6'
)
exit /b

::========================================================================================================================================
:: Leave empty line below
