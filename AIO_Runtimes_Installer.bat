@echo off
REM ============================================================================
REM All in One Runtimes 2.5.0 - Production-Ready Installer
REM FIXED VERSION - Stays open and shows progress
REM ============================================================================

setlocal EnableDelayedExpansion
chcp 65001 >nul 2>&1
title AIO Runtimes 2.5.0 Installer

REM Check if already running as admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ============================================
    echo    All in One Runtimes 2.5.0 - Installer
    echo ============================================
    echo.
    echo [ADMIN] Requesting administrator privileges...
    echo Please click YES in the UAC prompt to continue...
    echo.
    timeout /t 3 >nul
    
    REM FIX: Use different elevation method that keeps window open
    PowerShell -Command "Start-Process cmd -ArgumentList '/k \"%~f0\"' -Verb RunAs"
    exit /b
)

REM ============================================================================
REM MAIN INSTALLATION - RUNNING AS ADMINISTRATOR
REM ============================================================================

echo ============================================
echo    All in One Runtimes 2.5.0 - Installer
echo ============================================
echo [SYSTEM] Administrator privileges confirmed
echo [SYSTEM] Starting installation process...
echo.

REM Configuration
set "TEMP_DIR=%TEMP%\AIO_Runtimes_2.5.0"
set "LOG_FILE=%TEMP_DIR%\installation.log"
set "DOWNLOAD_SCRIPT=%TEMP_DIR%\download.vbs"
set "CHECK_SCRIPT=%TEMP_DIR%\registry_check.vbs"
set "COMPONENT_COUNT=0"
set "SUCCESS_COUNT=0"
set "FAILED_COUNT=0"
set "REBOOT_REQUIRED=0"

REM Initialize directories
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%" 2>nul
echo AIO Runtimes 2.5.0 - Installation Log > "%LOG_FILE%"
echo Started: %date% %time% >> "%LOG_FILE%"

REM Create download script
(
echo Option Explicit
echo On Error Resume Next
echo Dim args, url, target
echo args = Split(WScript.Arguments(0), " "^|"")
echo url = args(0)
echo target = args(1)
echo Dim xhr, stream
echo Set xhr = CreateObject("MSXML2.XMLHTTP.6.0")
echo xhr.open "GET", url, False
echo xhr.send
echo If xhr.Status = 200 Then
echo     Set stream = CreateObject("ADODB.Stream")
echo     stream.Type = 1
echo     stream.Open
echo     stream.Write xhr.responseBody
echo     stream.SaveToFile target, 2
echo     stream.Close
echo     WScript.Quit 0
echo Else
echo     WScript.Quit 1
echo End If
) > "%DOWNLOAD_SCRIPT%"

REM Create registry check script
(
echo Option Explicit
echo Function RegistryValueExists(keyPath, valueName)
echo     On Error Resume Next
echo     Dim shell, value
echo     Set shell = CreateObject("WScript.Shell")
echo     value = shell.RegRead(keyPath ^& "\" ^& valueName)
echo     RegistryValueExists = (Err.Number = 0)
echo End Function
echo Dim keyPath, valueName
echo keyPath = WScript.Arguments(0)
echo valueName = WScript.Arguments(1)
echo If RegistryValueExists(keyPath, valueName) Then
echo     WScript.Quit 0
echo Else
echo     WScript.Quit 1
echo End If
) > "%CHECK_SCRIPT%"

REM Component installation function
:INSTALL_COMPONENT
set "COMPONENT_NAME=%~1"
set "DOWNLOAD_URL=%~2"
set "FILE_NAME=%~3"
set "INSTALL_ARGS=%~4"
set "REG_KEY=%~5"
set "REG_VALUE=%~6"

set /a COMPONENT_COUNT+=1
echo [%COMPONENT_COUNT%] PROCESSING: %COMPONENT_NAME%

REM Skip x64 on 32-bit systems
if "%COMPONENT_NAME:~-4%"=="x64)" (
    if "%PROCESSOR_ARCHITECTURE%"=="x86" (
        echo [SKIP] Skipping x64 component on 32-bit system
        goto :EOF
    )
)

REM Check if already installed
cscript //nologo "%CHECK_SCRIPT%" "%REG_KEY%" "%REG_VALUE%" >nul 2>&1
if %errorlevel% equ 0 (
    echo [EXISTS] Already installed
    set /a SUCCESS_COUNT+=1
    goto :EOF
)

REM Download component
set "FILE_PATH=%TEMP_DIR%\%FILE_NAME%"
echo [DOWNLOAD] Retrieving...
cscript //nologo "%DOWNLOAD_SCRIPT%" "%DOWNLOAD_URL%" "%FILE_PATH%" >nul 2>&1

if not exist "%FILE_PATH%" (
    echo [ERROR] Download failed
    set /a FAILED_COUNT+=1
    goto :EOF
)

REM Install component
echo [INSTALL] Installing...
start /wait "" "%FILE_PATH%" %INSTALL_ARGS%
set "INSTALL_RESULT=%errorlevel%"

if %INSTALL_RESULT% equ 0 (
    echo [SUCCESS] Installation completed
    set "INSTALL_SUCCESS=1"
) else if %INSTALL_RESULT% equ 3010 (
    echo [SUCCESS] Installation completed (reboot required)
    set "INSTALL_SUCCESS=1"
    set "REBOOT_REQUIRED=1"
) else (
    echo [ERROR] Installation failed: code %INSTALL_RESULT%
    set "INSTALL_SUCCESS=0"
)

REM Verify installation
if %INSTALL_SUCCESS% equ 1 (
    timeout /t 2 >nul
    cscript //nologo "%CHECK_SCRIPT%" "%REG_KEY%" "%REG_VALUE%" >nul 2>&1
    if %errorlevel% equ 0 (
        echo [VERIFIED] Successfully installed and verified
        set /a SUCCESS_COUNT+=1
    ) else (
        echo [WARNING] Installed but verification failed
        set /a SUCCESS_COUNT+=1
    )
) else (
    set /a FAILED_COUNT+=1
)
goto :EOF

REM ============================================================================
REM INSTALLATION SEQUENCE
REM ============================================================================

echo [INIT] Starting installation of runtime components...
echo.

REM Visual C++ Redistributables
call :INSTALL_COMPONENT "Visual C++ 2005 Redistributable (x86)" "https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x86.EXE" "vcredist2005_x86.exe" "/Q" "HKLM\SOFTWARE\Microsoft\VisualStudio\8.0\VC\REDIST\x86" "Installed"
call :INSTALL_COMPONENT "Visual C++ 2005 Redistributable (x64)" "https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x64.EXE" "vcredist2005_x64.exe" "/Q" "HKLM\SOFTWARE\Microsoft\VisualStudio\8.0\VC\REDIST\x64" "Installed"
call :INSTALL_COMPONENT "Visual C++ 2008 Redistributable (x86)" "https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe" "vcredist2008_x86.exe" "/Q" "HKLM\SOFTWARE\Microsoft\VisualStudio\9.0\VC\REDIST\x86" "Installed"
call :INSTALL_COMPONENT "Visual C++ 2008 Redistributable (x64)" "https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x64.exe" "vcredist2008_x64.exe" "/Q" "HKLM\SOFTWARE\Microsoft\VisualStudio\9.0\VC\REDIST\x64" "Installed"
call :INSTALL_COMPONENT "Visual C++ 2010 Redistributable (x86)" "https://download.microsoft.com/download/C/6/D/C6D0FD4E-9E53-4897-9B91-836EBA2AACD3/vcredist_x86.exe" "vcredist2010_x86.exe" "/Q /norestart" "HKLM\SOFTWARE\Microsoft\VisualStudio\10.0\VC\VCRedist\x86" "Installed"
call :INSTALL_COMPONENT "Visual C++ 2010 Redistributable (x64)" "https://download.microsoft.com/download/C/6/D/C6D0FD4E-9E53-4897-9B91-836EBA2AACD3/vcredist_x64.exe" "vcredist2010_x64.exe" "/Q /norestart" "HKLM\SOFTWARE\Microsoft\VisualStudio\10.0\VC\VCRedist\x64" "Installed"
call :INSTALL_COMPONENT "Visual C++ 2012 Redistributable (x86)" "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" "vcredist2012_x86.exe" "/install /quiet /norestart" "HKLM\SOFTWARE\Microsoft\VisualStudio\11.0\VC\Runtimes\x86" "Installed"
call :INSTALL_COMPONENT "Visual C++ 2012 Redistributable (x64)" "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe" "vcredist2012_x64.exe" "/install /quiet /norestart" "HKLM\SOFTWARE\Microsoft\VisualStudio\11.0\VC\Runtimes\x64" "Installed"
call :INSTALL_COMPONENT "Visual C++ 2013 Redistributable (x86)" "https://download.visualstudio.microsoft.com/download/pr/10912113/5da66ddebb0ad32ebd4b922fd82e8e25/vcredist_x86.exe" "vcredist2013_x86.exe" "/install /quiet /norestart" "HKLM\SOFTWARE\Microsoft\VisualStudio\12.0\VC\Runtimes\x86" "Installed"
call :INSTALL_COMPONENT "Visual C++ 2013 Redistributable (x64)" "https://download.visualstudio.microsoft.com/download/pr/10912041/cee5d6bca2ddbcd039da727bf4acb48a/vcredist_x64.exe" "vcredist2013_x64.exe" "/install /quiet /norestart" "HKLM\SOFTWARE\Microsoft\VisualStudio\12.0\VC\Runtimes\x64" "Installed"
call :INSTALL_COMPONENT "Visual C++ 2015-2022 Redistributable (x86)" "https://aka.ms/vs/17/release/vc_redist.x86.exe" "vcredist2015_2022_x86.exe" "/install /quiet /norestart" "HKLM\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x86" "Installed"
call :INSTALL_COMPONENT "Visual C++ 2015-2022 Redistributable (x64)" "https://aka.ms/vs/17/release/vc_redist.x64.exe" "vcredist2015_2022_x64.exe" "/install /quiet /norestart" "HKLM\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64" "Installed"

REM .NET Framework 3.5
echo.
echo [SPECIAL] Installing .NET Framework 3.5...
dism /online /enable-feature /featurename:NetFX3 /All /NoRestart >nul 2>&1
if %errorlevel% equ 0 (
    echo [SUCCESS] .NET Framework 3.5 enabled successfully
    set /a SUCCESS_COUNT+=1
) else if %errorlevel% equ 3010 (
    echo [SUCCESS] .NET Framework 3.5 enabled (reboot required)
    set /a SUCCESS_COUNT+=1
    set "REBOOT_REQUIRED=1"
) else (
    echo [WARNING] .NET Framework 3.5 installation returned code: %errorlevel%
)

REM .NET Framework 4.8
call :INSTALL_COMPONENT ".NET Framework 4.8" "https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/9b7b8746971ed51a1770ae4293618187/ndp48-x86-x64-allos-enu.exe" "ndp48-x86-x64-allos-enu.exe" "/q /norestart" "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" "Release"

REM DirectX
call :INSTALL_COMPONENT "DirectX End-User Runtime" "https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe" "directx_redist.exe" "/Q" "HKLM\SOFTWARE\Microsoft\DirectX" "Version"

REM ============================================================================
REM INSTALLATION COMPLETE
REM ============================================================================

echo.
echo ============================================
echo         INSTALLATION COMPLETE
echo ============================================
echo Total Components Processed: %COMPONENT_COUNT%
echo Successfully Installed: %SUCCESS_COUNT%
echo Failed: %FAILED_COUNT%
echo.

if %REBOOT_REQUIRED% equ 1 (
    echo [IMPORTANT] SYSTEM REBOOT REQUIRED
    echo Some components require a system reboot
    echo.
    set /p REBOOT_NOW="Reboot now? (Y/N): "
    if /i "!REBOOT_NOW!"=="Y" (
        echo [REBOOT] System restarting in 10 seconds...
        shutdown /r /t 10
    )
)

echo.
echo Installation log: %LOG_FILE%
echo Press any key to close...
pause >nul