@echo off
set "TARGET_DIR=%AppData%\RoGold Ultimate\extensions\rogold-ultimate\styles"
set "MAIN_JS=%AppData%\RoGold Ultimate\extensions\rogold-ultimate\src\main.js"

echo ===========================================
echo         Rgu-Pen Uninstaller
echo ===========================================
echo.

echo Deleting CSS files...
del /f /q "%TARGET_DIR%\rgu-pen.css" 2>nul
del /f /q "%TARGET_DIR%\rgu-pen-floating.css" 2>nul
del /f /q "%TARGET_DIR%\rgu-pen-dark.css" 2>nul
del /f /q "%TARGET_DIR%\rgu-pen-light.css" 2>nul
del /f /q "%TARGET_DIR%\rgu-pen-avatar-effect.css" 2>nul

if exist "%MAIN_JS%.bak" (
    echo Restoring main.js from backup...
    move /y "%MAIN_JS%.bak" "%MAIN_JS%" >nul
) else (
    echo [!] No backup found. Skipping main.js restoration.
)

echo.
echo ===========================================
echo Uninstall Complete!
echo ===========================================
echo.

pause
exit