@echo off
set "TARGET_DIR=%AppData%\RoGold Ultimate\extensions\rogold-ultimate\styles"
set "SOURCE_DIR=Core_Files"
set "MAIN_JS=%AppData%\RoGold Ultimate\extensions\rogold-ultimate\src\main.js"

echo ===========================================
echo         Rgu-Pen Installer
echo ===========================================

if exist "%MAIN_JS%.bak" (
    echo.
    echo [!] ALERT: Rgu-Pen appears to be already installed.
    set /p redo="Do you want to overwrite your current settings? (y/n): "
    if /i not "%redo%"=="y" exit
    
    echo Resetting to original state before applying new settings...
    copy /y "%MAIN_JS%.bak" "%MAIN_JS%" >nul
) else (
    echo Creating a backup of the original main.js...
    copy /y "%MAIN_JS%" "%MAIN_JS%.bak" >nul
)

if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"
xcopy /y "%SOURCE_DIR%\*.css" "%TARGET_DIR%\" >nul

(
echo ^(function^(^) {
echo     if ^(document.getElementById^('rgu-pen-override'^)^) return;
echo     var link = document.createElement^('link'^);
echo     link.id = 'rgu-pen-override';
echo     link.rel = 'stylesheet';
echo     link.type = 'text/css';
echo     link.href = chrome.runtime.getURL^('styles/rgu-pen.css'^);
echo     ^(document.head ^|^| document.documentElement^).appendChild^(link^);
echo }^)^(^);
) > "%temp%\temp_prefix.js"


echo.
set /p float_choice="Do you want to enable Floating sidebar, topbar, and extras? (y/n): "
if /i "%float_choice%"=="y" goto :AddFloating
:SkipFloating

echo.
echo Choose your theme base:
echo [D] Dark Mode
echo [L] Light Mode
echo [N] No extra theme
set /p theme_choice="Selection (D/L/N): "

if /i "%theme_choice%"=="d" (
    set "THEME_FILE=rgu-pen-dark.css"
    set "THEME_ID=rgu-pen-dark"
    goto :AddTheme
)
if /i "%theme_choice%"=="l" (
    set "THEME_FILE=rgu-pen-light.css"
    set "THEME_ID=rgu-pen-light"
    goto :AddTheme
)
:SkipTheme

echo.
echo Enter a Hex Color (e.g. #ff0000) to enable custom avatar effects.
set /p hex_color="Hex Code (or press Enter to skip): "
if not "%hex_color%"=="" goto :AddAvatar
:SkipAvatar

type "%temp%\temp_prefix.js" > "%temp%\new_main.js"
echo. >> "%temp%\new_main.js"
type "%MAIN_JS%" >> "%temp%\new_main.js"

move /y "%temp%\new_main.js" "%MAIN_JS%" >nul
del "%temp%\temp_prefix.js"

echo.
echo ===========================================
echo Installation Complete!
echo ===========================================
pause
exit


:AddFloating
(
echo.
echo ^(function^(^) {
echo     if ^(document.getElementById^('rgu-pen-floating'^)^) return;
echo     var link = document.createElement^('link'^);
echo     link.id = 'rgu-pen-floating';
echo     link.rel = 'stylesheet';
echo     link.type = 'text/css';
echo     link.href = chrome.runtime.getURL^('styles/rgu-pen-floating.css'^);
echo     ^(document.head ^|^| document.documentElement^).appendChild^(link^);
echo }^)^(^);
) >> "%temp%\temp_prefix.js"
goto :SkipFloating

:AddTheme
(
echo.
echo ^(function^(^) {
echo     if ^(document.getElementById^('%THEME_ID%'^)^) return;
echo     var link = document.createElement^('link'^);
echo     link.id = '%THEME_ID%';
echo     link.rel = 'stylesheet';
echo     link.type = 'text/css';
echo     link.href = chrome.runtime.getURL^('styles/%THEME_FILE%'^);
echo     ^(document.head ^|^| document.documentElement^).appendChild^(link^);
echo }^)^(^);
) >> "%temp%\temp_prefix.js"
goto :SkipTheme

:AddAvatar
(
echo.
echo ^(function^(^) {
echo     if ^(document.getElementById^('rgu-pen-avatar'^)^) return;
echo     var link = document.createElement^('link'^);
echo     link.id = 'rgu-pen-avatar';
echo     link.rel = 'stylesheet';
echo     link.type = 'text/css';
echo     link.href = chrome.runtime.getURL^('styles/rgu-pen-avatar-effect.css'^);
echo     ^(document.head ^|^| document.documentElement^).appendChild^(link^);
echo.
echo     var style = document.createElement^('style'^);
echo     style.id = 'rgu-pen-custom-color';
echo     style.innerHTML = ':root {--avatarEffectColor: %hex_color% !important; }';
echo     ^(document.head ^|^| document.documentElement^).appendChild^(style^);
echo }^)^(^);
) >> "%temp%\temp_prefix.js"
goto :SkipAvatar