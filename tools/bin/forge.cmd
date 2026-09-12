@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

REM --- Detectar FORGE_HOME desde tools/bin/ ---
for %%I in ("%~dp0..\..") do set "FORGE_HOME=%%~fI"

REM --- Directorio actual = proyecto destino ---
set "TARGET=%CD%"

REM --- Verificar que estamos fuera del propio kit ---
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

REM --- Copiar archivos core ---
if not exist "%TARGET%\lib" mkdir "%TARGET%\lib"
if not exist "%TARGET%\templates" mkdir "%TARGET%\templates"

copy /Y "%FORGE_HOME%\init.cmd"   "%TARGET%\" >nul
copy /Y "%FORGE_HOME%\config.cmd" "%TARGET%\" >nul
copy /Y "%FORGE_HOME%\lib\*.cmd"  "%TARGET%\lib\" >nul
copy /Y "%FORGE_HOME%\templates\*.tpl" "%TARGET%\templates\" >nul

echo   Archivos copiados desde forgeGit.
echo.

REM --- Ejecutar init ---
cd /d "%TARGET%"
call "%TARGET%\init.cmd"

endlocal
exit /b 0