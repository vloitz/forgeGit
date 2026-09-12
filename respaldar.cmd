@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

cd /d "%~dp0"

for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HHmmss"') do set "TS=%%i"

echo.
echo   ============================================
echo    Respaldar - Snapshot del proyecto
echo   ============================================
echo.

set "INPUT="
set /p "INPUT=  Nombre del snapshot [Enter = noDefined]: "
if "!INPUT!"=="" set "INPUT=noDefined"

set "BASENAME=!TS!_!INPUT!"
set "DEST=versiones\!BASENAME!"

if not exist "versiones" mkdir "versiones"
if not exist "!DEST!" mkdir "!DEST!"

echo   Copiando archivos...
robocopy "." "!DEST!" /E /XD .git versiones old_versions backup backups node_modules __pycache__ venv .venv env dist build out cache .cache .parcel-cache .vite .vscode .idea /XF *.log *.tmp *.bak *.orig Thumbs.db .DS_Store /NFL /NDL /NJH /NJS /NC /NS /NP >nul
set "RC=!ERRORLEVEL!"

echo.
echo   ============================================
echo    Snapshot creado:
echo    versiones\!BASENAME!\
echo   ============================================
echo.

if !RC! GEQ 8 (
    echo   [WARN] Robocopy termino con codigo !RC!
    echo.
)

echo   Contenido:
dir /b "!DEST!"
echo.

call :pause_if_double_click
endlocal
exit /b 0

:pause_if_double_click
echo %cmdcmdline% | find /i "%~nx0" >nul
if not errorlevel 1 (
    echo   Presiona cualquier tecla para cerrar...
    pause >nul
)
goto :eof
