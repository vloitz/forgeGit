@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

cd /d "%~dp0"

echo.
echo   ============================================
echo    Release - Empaquetar y comprimir (v1.5.11)
echo   ============================================
echo.

REM --- 1. Pack ---
call "%~dp0pack.cmd"

REM --- 2. Leer version desde .forge/config.cmd ---
call "%~dp0..\.forge\config.cmd"
set "ZIP=%~dp0..\..\forgeGit-v%FG_VERSION%.zip"

REM --- 3. Comprimir ---
echo   Comprimiendo v%FG_VERSION%...
if exist "%ZIP%" del "%ZIP%" >nul 2>nul

cd /d "%~dp0..\..\forgeGit-dist"
powershell -NoProfile -Command "Compress-Archive -Path 'forgeGit' -DestinationPath '%ZIP%' -Force"

if not exist "%ZIP%" (
    echo   [X] Fallo al comprimir
    pause
    exit /b 1
)

for %%f in ("%ZIP%") do set "SIZE=%%~zf"

echo.
echo   ============================================
echo    Release listo:
echo    %ZIP%
echo    Tamano: !SIZE! bytes
echo   ============================================
echo.
echo   Siguiente:
echo     1. Se abre GitHub Releases en tu navegador
echo     2. Tag: v%FG_VERSION%
echo     3. Attach: forgeGit-v%FG_VERSION%.zip
echo     4. Publish
echo.

REM --- 4. Abrir navegador ---
start "" "https://github.com/vloitz/forgeGit/releases/new"

endlocal
exit /b 0