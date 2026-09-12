@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

cd /d "%~dp0"

REM --- Timestamp portable ---
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HHmmss"') do set "TS=%%i"

REM --- Banner ---
echo.
echo   ============================================
echo    Subir - Backup del proyecto
echo   ============================================
echo.

REM --- Pedir nombre ---
set "INPUT="
set /p "INPUT=  Nombre de la mejora [Enter = noDefined]: "
if "!INPUT!"=="" set "INPUT=noDefined"

REM --- Componer nombre ---
set "BASENAME=!TS!_!INPUT!"
set "DEST=versiones\!BASENAME!"

REM --- Crear carpeta destino ---
if not exist "versiones" mkdir "versiones"
if not exist "!DEST!" mkdir "!DEST!"

REM --- Copiar todo excepto exclusiones ---
echo   Copiando archivos...
robocopy "." "!DEST!" /E /XD .git versiones old_versions backup backups node_modules __pycache__ venv .venv env dist build out cache .cache .parcel-cache .vite .vscode .idea /XF *.log *.tmp *.bak *.orig Thumbs.db .DS_Store /NFL /NDL /NJH /NJS /NC /NS /NP >nul
set "RC=%ERRORLEVEL%"

REM --- Reportar ---
echo.
echo   ============================================
echo    Backup creado:
echo    versiones\!BASENAME!\
echo   ============================================
echo.
if %RC% GEQ 8 (
    echo   [WARN] Robocopy termino con codigo %RC%
    echo.
ECHO está desactivado.
