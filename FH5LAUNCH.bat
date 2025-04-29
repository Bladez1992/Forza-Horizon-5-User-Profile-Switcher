@echo off
setlocal

:: Ensure the script is running as Administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Get the directory where this script is located
set "script_dir=%~dp0"
set "script_dir=%script_dir:~0,-1%"  :: Remove trailing backslash

:: Detect the Windows drive dynamically and clean formatting
for /f "tokens=2 delims==" %%A in ('wmic os get SystemDrive /value') do set "win_drive=%%A"
set "win_drive=%win_drive: =%"  :: Trim spaces

echo Detected Windows Drive: %win_drive%

:: Define paths relative to the script directory (Only applicable if using the CODEX or Online-Fix cracks, remove the source_file and destination_file lines here if using the Microsoft Store or Steam versions of the game)
set "username=%USERNAME%"
set "source_file=%script_dir%\Profiles\%username%.ini"
set "destination_file=%script_dir%\steam_emu.ini"
set "game_exe=%script_dir%\ForzaHorizon5.exe"
set "game_dir=%script_dir%"

:: Define symbolic link 1 (Save Game Data Location - only replace the destination_folder path)
set "destination_folder_1=%win_drive%\Users\Public\Documents\Steam\CODEX"
set "source_base_1=%script_dir%\Profiles\Saves\%username%\1551360"
set "symbolic_link_1=1551360"
set "symbolic_link_path_1=%destination_folder_1%\%symbolic_link_1%"

:: Define symbolic link 2 (Configuration Files Location - only replace the destination_folder path)
set "destination_folder_2=%win_drive%\Users\%username%\AppData\Local\ForzaHorizon5"
set "source_base_2=%script_dir%\Profiles\Saves\%username%\Appdata\Local\ForzaHorizon5"

:: Ensure source file exists before replacing
if exist "%source_file%" (
    copy /y "%source_file%" "%destination_file%"
    echo File replaced successfully.
) else (
    echo ERROR: Source file does not exist.
    pause
    exit /b
)

:: Ensure both source folders exist (create if missing)
if not exist "%source_base_1%" (
    echo Source folder 1 does not exist. Creating...
    mkdir "%source_base_1%"
    if errorlevel 1 (
        echo ERROR: Failed to create source folder 1.
        pause
        exit /b
    )
)
if not exist "%source_base_2%" (
    echo Source folder 2 does not exist. Creating...
    mkdir "%source_base_2%"
    if errorlevel 1 (
        echo ERROR: Failed to create source folder 2.
        pause
        exit /b
    )
)

:: Remove existing symbolic links if present
if exist "%symbolic_link_path_1%" (
    rmdir /s /q "%symbolic_link_path_1%"
    echo Existing symbolic link 1 removed.
)
if exist "%destination_folder_2%" (
    rmdir /s /q "%destination_folder_2%"
    echo Existing symbolic link 2 removed.
)

:: Create symbolic link 1
echo Creating symbolic link 1: "%symbolic_link_path_1%" -> "%source_base_1%"
mklink /D "%symbolic_link_path_1%" "%source_base_1%"
if %errorLevel% neq 0 (
    echo ERROR: Failed to create symbolic link 1.
    pause
    exit /b
)
echo Symbolic link 1 created successfully.

:: Create symbolic link 2
echo Creating symbolic link 2: "%destination_folder_2%" -> "%source_base_2%"
mklink /D "%destination_folder_2%" "%source_base_2%"
if %errorLevel% neq 0 (
    echo ERROR: Failed to create symbolic link 2.
    pause
    exit /b
)
echo Symbolic link 2 created successfully.

:: Ensure the links are fully registered before launching the game - you may need to increase the timeout value here if you have a slower PC
timeout /t 5 /nobreak

:: Change to game directory and launch the game
cd /d "%game_dir%"
start "" "%game_exe%"

:: Wait for the game to close
echo Waiting for ForzaHorizon5.exe to close...
:waitLoop
timeout /t 5 /nobreak >nul
wmic process where "name='ForzaHorizon5.exe'" get ProcessId 2>nul | findstr [0-9] >nul
if not errorlevel 1 goto waitLoop

:: Wait before deleting symbolic links
timeout /t 5 /nobreak

:: Remove symbolic links after the game closes
if exist "%symbolic_link_path_1%" (
    rmdir /s /q "%symbolic_link_path_1%"
    echo Symbolic link 1 removed.
)
if exist "%destination_folder_2%" (
    rmdir /s /q "%destination_folder_2%"
    echo Symbolic link 2 removed.
)

endlocal
exit /b
