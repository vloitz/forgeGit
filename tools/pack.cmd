@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

cd /d "%~dp0"

echo.
echo   ============================================
echo    Pack - Distribucion limpia (v1.5.11)
echo   ============================================
echo.

set "ROOT=%~dp0.."
set "DIST=%~dp0..\..\forgeGit-dist"
set "OUT=%DIST%\forgeGit"

REM --- Limpiar destino previo ---
if exist "%DIST%" rmdir /s /q "%DIST%"

mkdir "%OUT%"
mkdir "%OUT%\.forge"
mkdir "%OUT%\.forge\lib"
mkdir "%OUT%\.forge\templates"
mkdir "%OUT%\.forge\commands"
mkdir "%OUT%\tools"
mkdir "%OUT%\tools\bin"
mkdir "%OUT%\tests"

echo   Copiando archivos core...
copy /Y "%ROOT%\forge.cmd"   "%OUT%\" >nul
copy /Y "%ROOT%\README.md"   "%OUT%\" >nul
copy /Y "%ROOT%\MANUAL.md"   "%OUT%\" >nul
copy /Y "%ROOT%\WORKFLOW.md" "%OUT%\" >nul

echo   Copiando .forge/...
copy /Y "%ROOT%\.forge\init.cmd"        "%OUT%\.forge\" >nul
copy /Y "%ROOT%\.forge\config.cmd"      "%OUT%\.forge\" >nul
copy /Y "%ROOT%\.forge\serve-static.js" "%OUT%\.forge\" >nul

echo   Copiando .forge/lib/...
copy /Y "%ROOT%\.forge\lib\*.cmd" "%OUT%\.forge\lib\" >nul

echo   Copiando .forge/templates/...
copy /Y "%ROOT%\.forge\templates\*.tpl" "%OUT%\.forge\templates\" >nul
copy /Y "%ROOT%\.forge\templates\serve-static.js" "%OUT%\.forge\templates\" >nul

echo   Copiando tools/...
copy /Y "%ROOT%\tools\*.cmd" "%OUT%\tools\" >nul
copy /Y "%ROOT%\tools\bin\*.cmd" "%OUT%\tools\bin\" >nul

echo   Copiando tests/...
copy /Y "%ROOT%\tests\*.cmd" "%OUT%\tests\" >nul

echo.
echo   ============================================
echo    Distribucion creada en:
echo    %OUT%
echo   ============================================
echo.
echo   Contenido:
echo.
dir /b /s "%OUT%"
echo.

endlocal
exit /b 0