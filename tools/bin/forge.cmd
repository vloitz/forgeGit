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
if /i "%~1"=="version" goto :version
if /i "%~1"=="--version" goto :version

goto :install

:version
powershell -NoProfile -Command "(Get-Content -LiteralPath '%FORGE_HOME%\.forge\config.cmd' | Select-String 'FG_VERSION=').ToString().Split('=')[1].Trim('\"', ' ')"
exit /b 0

:help
echo.
echo   ============================================
echo    forgeGit - Ayuda
echo   ============================================
echo.
echo   USO:
echo     forge               Instala forgeGit en la carpeta actual
echo     forge update        Actualiza .forge/ del kit
echo     forge version       Muestra la version
echo     forge help          Esta ayuda
echo.
echo   QUE HACE:
echo     - Copia forge.cmd a la raiz
echo     - Copia .forge/ completa (init, config, lib, templates, commands)
echo     - Ejecuta .forge\init.cmd automaticamente
echo.
goto :end

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
if exist "%TARGET%\.forge\init.cmd" (
    echo   [!] Ya existe .forge\init.cmd en este proyecto.
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

REM --- Copiar forge.cmd a la raiz ---
copy /Y "%FORGE_HOME%\forge.cmd" "%TARGET%\forge.cmd" >nul

REM --- Copiar .forge/ completa ---
if not exist "%TARGET%\.forge" mkdir "%TARGET%\.forge"
robocopy "%FORGE_HOME%\.forge" "%TARGET%\.forge" /E /NFL /NDL /NJH /NJS /NC /NS /NP >nul

REM --- Limpiar helpers pre-generados (instalacion limpia) ---
if exist "%TARGET%\.forge\commands\*.cmd" (
    del /Q "%TARGET%\.forge\commands\*.cmd" >nul 2>nul
)

echo   Archivos copiados desde forgeGit.
echo.

cd /d "%TARGET%"
call "%TARGET%\.forge\init.cmd"

goto :end

:update
if /i "%TARGET%"=="%FORGE_HOME%" (
    echo.
    echo   [!] Estas dentro del kit forgeGit.
    echo   [!] No hay nada que actualizar aqui.
    echo.
    exit /b 1
)

if not exist "%TARGET%\.forge\init.cmd" (
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

echo   Actualizando forge.cmd...
copy /Y "%FORGE_HOME%\forge.cmd" "%TARGET%\forge.cmd" >nul

echo   Actualizando .forge/...
robocopy "%FORGE_HOME%\.forge" "%TARGET%\.forge" /E /NFL /NDL /NJH /NJS /NC /NS /NP >nul

echo.
echo   [OK] Actualizado.
echo.
echo   Nota: los helpers (.forge\commands\) NO se
echo         regeneran automaticamente.
echo.
echo   Para regenerarlos:
echo     forge init --force
echo.

goto :end

:end
endlocal
exit /b 0