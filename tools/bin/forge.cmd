@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

REM --- FORGE_HOME desde tools/bin/ ---
for %%I in ("%~dp0..\..") do set "FORGE_HOME=%%~fI"
set "TARGET=%CD%"

REM --- Subcomandos ---
if /i "%~1"=="update"  goto :update
if /i "%~1"=="help"    goto :help
if /i "%~1"=="--help"  goto :help
if /i "%~1"=="-h"      goto :help

REM --- Default: install ---
goto :install

REM ============================================================
REM   HELP
REM ============================================================
:help
echo.
echo   ============================================
echo    forgeGit - Ayuda
echo   ============================================
echo.
echo   USO:
echo     forge               Instala forgeGit en la carpeta actual
echo     forge update        Actualiza templates/core del kit
echo     forge help          Esta ayuda
echo.
echo   QUE HACE:
echo     - Copia init.cmd, config.cmd, lib/, templates/
echo     - Ejecuta init.cmd automaticamente
echo     - Deja el proyecto con 7 helpers listos
echo.
goto :end

REM ============================================================
REM   INSTALL
REM ============================================================
:install
if /i "%TARGET%"=="%FORGE_HOME%" (
    echo.
    echo   [!] Estas dentro del kit forgeGit.
    echo   [!] Ve a un proyecto nuevo y ejecuta: forge
    echo.
    exit /b 1
)

echo.
echo   ============================================
echo    forgeGit - Instalando en:
echo    %TARGET%
echo   ============================================
echo.

REM --- Safety: detectar instalacion previa ---
if exist "%TARGET%\init.cmd" (
    echo   [!] Ya existe init.cmd en este proyecto.
    echo   [!] Puede ser de un forgeGit anterior.
    echo.
    set "CONFIRM="
    set /p "CONFIRM=  Sobrescribir? [S/n]: "
    if /i "!CONFIRM!"=="n" (
        echo   Cancelado.
        exit /b 0
    )
    echo.
)

if not exist "%TARGET%\lib" mkdir "%TARGET%\lib"
if not exist "%TARGET%\templates" mkdir "%TARGET%\templates"

copy /Y "%FORGE_HOME%\init.cmd"   "%TARGET%\" >nul
copy /Y "%FORGE_HOME%\config.cmd" "%TARGET%\" >nul
copy /Y "%FORGE_HOME%\lib\*.cmd"  "%TARGET%\lib\" >nul
copy /Y "%FORGE_HOME%\templates\*.tpl" "%TARGET%\templates\" >nul

echo   Archivos copiados desde forgeGit.
echo.

cd /d "%TARGET%"
call "%TARGET%\init.cmd"

goto :end

REM ============================================================
REM   UPDATE
REM ============================================================
:update
if /i "%TARGET%"=="%FORGE_HOME%" (
    echo.
    echo   [!] Estas dentro del kit forgeGit.
    echo   [!] No hay nada que actualizar aqui.
    echo.
    exit /b 1
)

if not exist "%TARGET%\init.cmd" (
    echo.
    echo   [X] Este proyecto no tiene forgeGit instalado.
    echo       Ejecuta primero: forge
    echo.
    exit /b 1
)

echo.
echo   ============================================
echo    forgeGit - Actualizando
echo    %TARGET%
echo   ============================================
echo.

echo   Actualizando core (init.cmd, config.cmd)...
copy /Y "%FORGE_HOME%\init.cmd"   "%TARGET%\" >nul
copy /Y "%FORGE_HOME%\config.cmd" "%TARGET%\" >nul

echo   Actualizando lib/...
if not exist "%TARGET%\lib" mkdir "%TARGET%\lib"
robocopy "%FORGE_HOME%\lib" "%TARGET%\lib" /E /NFL /NDL /NJH /NJS /NC /NS /NP >nul

echo   Actualizando templates/...
if not exist "%TARGET%\templates" mkdir "%TARGET%\templates"
robocopy "%FORGE_HOME%\templates" "%TARGET%\templates" /E /NFL /NDL /NJH /NJS /NC /NS /NP >nul

echo.
echo   [OK] Actualizado.
echo.
echo   Nota: los helpers (guardar, subir, etc.) NO se
echo         regeneran automaticamente.
echo.
echo   Para regenerarlos:
echo     init.cmd --force
echo.

goto :end

:end
endlocal
exit /b 0