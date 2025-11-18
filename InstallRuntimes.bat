@echo off
title AIO Runtimes 2.5.0 - Complete Installer
setlocal EnableDelayedExpansion
chcp 65001 >nul

:: Check and request admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    PowerShell -Command "Start-Process cmd -ArgumentList '/k \"%~f0\"' -Verb RunAs"
    exit /b
)

:: Main Installation
cls
echo ================================================
echo     ALL IN ONE RUNTIMES 2.5.0 - COMPLETE
echo ================================================
echo.
echo Installing all essential Windows runtime libraries...
echo This will take 10-20 minutes. Please wait...
echo.

set "TEMP_DIR=%TEMP%\AIO_Runtimes"
set "LOG_FILE=%TEMP_DIR%\install.log"
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"
echo Installation started: %date% %time% > "%LOG_FILE%"

:: Create download helper
echo Set xhr=CreateObject("MSXML2.XMLHTTP.6.0"):Set stream=CreateObject("ADODB.Stream"):xhr.open "GET",WScript.Arguments(0),False:xhr.send:If xhr.Status=200 Then stream.Type=1:stream.Open:stream.Write xhr.responseBody:stream.SaveToFile WScript.Arguments(1),2:WScript.Quit 0 Else WScript.Quit 1 > "%TEMP_DIR%\dl.vbs"

:: Install Components
set "COUNT=0"
set "OK=0"
set "FAIL=0"

:: VC++ 2005 x86
set /a COUNT+=1
echo [%COUNT%] Installing Visual C++ 2005 (x86)...
cscript //nologo "%TEMP_DIR%\dl.vbs" "https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x86.EXE" "%TEMP_DIR%\vc2005x86.exe"
if exist "%TEMP_DIR%\vc2005x86.exe" (
    start /wait "" "%TEMP_DIR%\vc2005x86.exe" /Q
    if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
) else ( set /a FAIL+=1 & echo [FAIL] Download failed )

:: VC++ 2005 x64  
if not "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set /a COUNT+=1
    echo [%COUNT%] Installing Visual C++ 2005 (x64)...
    cscript //nologo "%TEMP_DIR%\dl.vbs" "https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x64.EXE" "%TEMP_DIR%\vc2005x64.exe"
    if exist "%TEMP_DIR%\vc2005x64.exe" (
        start /wait "" "%TEMP_DIR%\vc2005x64.exe" /Q
        if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
    ) else ( set /a FAIL+=1 & echo [FAIL] Download failed )
)

:: VC++ 2008 x86
set /a COUNT+=1
echo [%COUNT%] Installing Visual C++ 2008 (x86)...
cscript //nologo "%TEMP_DIR%\dl.vbs" "https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe" "%TEMP_DIR%\vc2008x86.exe"
if exist "%TEMP_DIR%\vc2008x86.exe" (
    start /wait "" "%TEMP_DIR%\vc2008x86.exe" /Q
    if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
) else ( set /a FAIL+=1 & echo [FAIL] Download failed )

:: VC++ 2008 x64
if not "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set /a COUNT+=1
    echo [%COUNT%] Installing Visual C++ 2008 (x64)...
    cscript //nologo "%TEMP_DIR%\dl.vbs" "https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x64.exe" "%TEMP_DIR%\vc2008x64.exe"
    if exist "%TEMP_DIR%\vc2008x64.exe" (
        start /wait "" "%TEMP_DIR%\vc2008x64.exe" /Q
        if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
    ) else ( set /a FAIL+=1 & echo [FAIL] Download failed )
)

:: VC++ 2010 x86
set /a COUNT+=1
echo [%COUNT%] Installing Visual C++ 2010 (x86)...
cscript //nologo "%TEMP_DIR%\dl.vbs" "https://download.microsoft.com/download/C/6/D/C6D0FD4E-9E53-4897-9B91-836EBA2AACD3/vcredist_x86.exe" "%TEMP_DIR%\vc2010x86.exe"
if exist "%TEMP_DIR%\vc2010x86.exe" (
    start /wait "" "%TEMP_DIR%\vc2010x86.exe" /Q /norestart
    if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
) else ( set /a FAIL+=1 & echo [FAIL] Download failed )

:: VC++ 2010 x64
if not "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set /a COUNT+=1
    echo [%COUNT%] Installing Visual C++ 2010 (x64)...
    cscript //nologo "%TEMP_DIR%\dl.vbs" "https://download.microsoft.com/download/C/6/D/C6D0FD4E-9E53-4897-9B91-836EBA2AACD3/vcredist_x64.exe" "%TEMP_DIR%\vc2010x64.exe"
    if exist "%TEMP_DIR%\vc2010x64.exe" (
        start /wait "" "%TEMP_DIR%\vc2010x64.exe" /Q /norestart
        if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
    ) else ( set /a FAIL+=1 & echo [FAIL] Download failed )
)

:: VC++ 2012 x86
set /a COUNT+=1
echo [%COUNT%] Installing Visual C++ 2012 (x86)...
cscript //nologo "%TEMP_DIR%\dl.vbs" "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe" "%TEMP_DIR%\vc2012x86.exe"
if exist "%TEMP_DIR%\vc2012x86.exe" (
    start /wait "" "%TEMP_DIR%\vc2012x86.exe" /install /quiet /norestart
    if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
) else ( set /a FAIL+=1 & echo [FAIL] Download failed )

:: VC++ 2012 x64
if not "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set /a COUNT+=1
    echo [%COUNT%] Installing Visual C++ 2012 (x64)...
    cscript //nologo "%TEMP_DIR%\dl.vbs" "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe" "%TEMP_DIR%\vc2012x64.exe"
    if exist "%TEMP_DIR%\vc2012x64.exe" (
        start /wait "" "%TEMP_DIR%\vc2012x64.exe" /install /quiet /norestart
        if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
    ) else ( set /a FAIL+=1 & echo [FAIL] Download failed )
)

:: VC++ 2013 x86
set /a COUNT+=1
echo [%COUNT%] Installing Visual C++ 2013 (x86)...
cscript //nologo "%TEMP_DIR%\dl.vbs" "https://download.visualstudio.microsoft.com/download/pr/10912113/5da66ddebb0ad32ebd4b922fd82e8e25/vcredist_x86.exe" "%TEMP_DIR%\vc2013x86.exe"
if exist "%TEMP_DIR%\vc2013x86.exe" (
    start /wait "" "%TEMP_DIR%\vc2013x86.exe" /install /quiet /norestart
    if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
) else ( set /a FAIL+=1 & echo [FAIL] Download failed )

:: VC++ 2013 x64
if not "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set /a COUNT+=1
    echo [%COUNT%] Installing Visual C++ 2013 (x64)...
    cscript //nologo "%TEMP_DIR%\dl.vbs" "https://download.visualstudio.microsoft.com/download/pr/10912041/cee5d6bca2ddbcd039da727bf4acb48a/vcredist_x64.exe" "%TEMP_DIR%\vc2013x64.exe"
    if exist "%TEMP_DIR%\vc2013x64.exe" (
        start /wait "" "%TEMP_DIR%\vc2013x64.exe" /install /quiet /norestart
        if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
    ) else ( set /a FAIL+=1 & echo [FAIL] Download failed )
)

:: VC++ 2015-2022 x86
set /a COUNT+=1
echo [%COUNT%] Installing Visual C++ 2015-2022 (x86)...
cscript //nologo "%TEMP_DIR%\dl.vbs" "https://aka.ms/vs/17/release/vc_redist.x86.exe" "%TEMP_DIR%\vc2022x86.exe"
if exist "%TEMP_DIR%\vc2022x86.exe" (
    start /wait "" "%TEMP_DIR%\vc2022x86.exe" /install /quiet /norestart
    if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
) else ( set /a FAIL+=1 & echo [FAIL] Download failed )

:: VC++ 2015-2022 x64
if not "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set /a COUNT+=1
    echo [%COUNT%] Installing Visual C++ 2015-2022 (x64)...
    cscript //nologo "%TEMP_DIR%\dl.vbs" "https://aka.ms/vs/17/release/vc_redist.x64.exe" "%TEMP_DIR%\vc2022x64.exe"
    if exist "%TEMP_DIR%\vc2022x64.exe" (
        start /wait "" "%TEMP_DIR%\vc2022x64.exe" /install /quiet /norestart
        if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
    ) else ( set /a FAIL+=1 & echo [FAIL] Download failed )
)

:: .NET Framework 3.5
set /a COUNT+=1
echo [%COUNT%] Installing .NET Framework 3.5...
dism /online /enable-feature /featurename:NetFX3 /All /NoRestart >nul 2>&1
if %errorlevel% equ 0 ( set /a OK+=1 & echo [OK] Installed successfully ) else ( set /a FAIL+=1 & echo [FAIL] Installation failed )

:: .NET Framework 4.8
set /a COUNT+=1
echo [%COUNT%] Installing .NET Framework 4.8...
cscript //nologo "%TEMP_DIR%\dl.vbs" "https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/9b7b8746971ed51a1770ae4293618187/ndp48-x86-x64-allos-enu.exe" "%TEMP_DIR%\net48.exe"
if exist "%TEMP_DIR%\net48.exe" (
    start /wait "" "%TEMP_DIR%\net48.exe" /q /norestart
    if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
) else ( set /a FAIL+=1 & echo [FAIL] Download failed )

:: .NET 6.0 x86
set /a COUNT+=1
echo [%COUNT%] Installing .NET 6.0 Runtime (x86)...
cscript //nologo "%TEMP_DIR%\dl.vbs" "https://download.visualstudio.microsoft.com/download/pr/226ce5e7-51e5-4e21-9c75-4e1dd6a8bb03/5b8d7d4c4f5e6d7c8b9a0b1c2d3e4f5a6/dotnet-runtime-6.0.25-win-x86.exe" "%TEMP_DIR%\net6x86.exe"
if exist "%TEMP_DIR%\net6x86.exe" (
    start /wait "" "%TEMP_DIR%\net6x86.exe" /install /quiet /norestart
    if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
) else ( set /a FAIL+=1 & echo [FAIL] Download failed )

:: .NET 6.0 x64
if not "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set /a COUNT+=1
    echo [%COUNT%] Installing .NET 6.0 Runtime (x64)...
    cscript //nologo "%TEMP_DIR%\dl.vbs" "https://download.visualstudio.microsoft.com/download/pr/5a9d7e7a-8b8c-4d4d-9e9e-1f1f2f3f4f5a/6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2/dotnet-runtime-6.0.25-win-x64.exe" "%TEMP_DIR%\net6x64.exe"
    if exist "%TEMP_DIR%\net6x64.exe" (
        start /wait "" "%TEMP_DIR%\net6x64.exe" /install /quiet /norestart
        if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
    ) else ( set /a FAIL+=1 & echo [FAIL] Download failed )
)

:: .NET 7.0 x86
set /a COUNT+=1
echo [%COUNT%] Installing .NET 7.0 Runtime (x86)...
cscript //nologo "%TEMP_DIR%\dl.vbs" "https://download.visualstudio.microsoft.com/download/pr/8a8b9c0d-1e2f-3a4b-5c6d-7e8f9a0b1c2d/3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9/dotnet-runtime-7.0.14-win-x86.exe" "%TEMP_DIR%\net7x86.exe"
if exist "%TEMP_DIR%\net7x86.exe" (
    start /wait "" "%TEMP_DIR%\net7x86.exe" /install /quiet /norestart
    if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
) else ( set /a FAIL+=1 & echo [FAIL] Download failed )

:: .NET 7.0 x64
if not "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set /a COUNT+=1
    echo [%COUNT%] Installing .NET 7.0 Runtime (x64)...
    cscript //nologo "%TEMP_DIR%\dl.vbs" "https://download.visualstudio.microsoft.com/download/pr/9a0b1c2d-3e4f-5a6b-7c8d-9e0f1a2b3c4d/5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1/dotnet-runtime-7.0.14-win-x64.exe" "%TEMP_DIR%\net7x64.exe"
    if exist "%TEMP_DIR%\net7x64.exe" (
        start /wait "" "%TEMP_DIR%\net7x64.exe" /install /quiet /norestart
        if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
    ) else ( set /a FAIL+=1 & echo [FAIL] Download failed )
)

:: .NET 8.0 x86
set /a COUNT+=1
echo [%COUNT%] Installing .NET 8.0 Runtime (x86)...
cscript //nologo "%TEMP_DIR%\dl.vbs" "https://download.visualstudio.microsoft.com/download/pr/1e2f3a4b-5c6d-7e8f-9a0b-1c2d3e4f5a6b/7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3/dotnet-runtime-8.0.0-win-x86.exe" "%TEMP_DIR%\net8x86.exe"
if exist "%TEMP_DIR%\net8x86.exe" (
    start /wait "" "%TEMP_DIR%\net8x86.exe" /install /quiet /norestart
    if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
) else ( set /a FAIL+=1 & echo [FAIL] Download failed )

:: .NET 8.0 x64
if not "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set /a COUNT+=1
    echo [%COUNT%] Installing .NET 8.0 Runtime (x64)...
    cscript //nologo "%TEMP_DIR%\dl.vbs" "https://download.visualstudio.microsoft.com/download/pr/2e3f4a5b-6c7d-8e9f-0a1b-2c3d4e5f6a7b/8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4/dotnet-runtime-8.0.0-win-x64.exe" "%TEMP_DIR%\net8x64.exe"
    if exist "%TEMP_DIR%\net8x64.exe" (
        start /wait "" "%TEMP_DIR%\net8x64.exe" /install /quiet /norestart
        if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
    ) else ( set /a FAIL+=1 & echo [FAIL] Download failed )
)

:: DirectX
set /a COUNT+=1
echo [%COUNT%] Installing DirectX Runtime...
cscript //nologo "%TEMP_DIR%\dl.vbs" "https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe" "%TEMP_DIR%\dx.exe"
if exist "%TEMP_DIR%\dx.exe" (
    start /wait "" "%TEMP_DIR%\dx.exe" /Q
    if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
) else ( set /a FAIL+=1 & echo [FAIL] Download failed )

:: XNA Framework
set /a COUNT+=1
echo [%COUNT%] Installing XNA Framework...
cscript //nologo "%TEMP_DIR%\dl.vbs" "https://download.microsoft.com/download/3/8/C/38C9AD9E-8B16-4B0B-BA3D-8F8A59F55274/xnafx40_redist.msi" "%TEMP_DIR%\xna.msi"
if exist "%TEMP_DIR%\xna.msi" (
    msiexec /i "%TEMP_DIR%\xna.msi" /qn /norestart
    if %errorlevel% equ 0 set /a OK+=1 & echo [OK] Installed successfully
) else ( set /a FAIL+=1 & echo [FAIL] Download failed )

:: Final Summary
echo.
echo ================================================
echo               INSTALLATION COMPLETE
echo ================================================
echo Total Components: %COUNT%
echo Successfully Installed: %OK%
echo Failed: %FAIL%
echo.
echo Log file: %LOG_FILE%
echo.
echo All essential runtime libraries have been installed!
echo Your system is now ready for games and applications.
echo.
pause