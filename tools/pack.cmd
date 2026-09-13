@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

cd /d "%~dp0"

echo.
echo   ============================================
echo    Pack - Distribucion limpia
echo   ============================================
echo.

set "ROOT=%~dp0.."
set "DIST=%~dp0..\..\forgeGit-dist"
set "OUT=%DIST%\forgeGit"

REM --- Limpiar destino previo ---
if exist "%DIST%" rmdir /s /q "%DIST%"

mkdir "%OUT%"
mkdir "%OUT%\lib"
mkdir "%OUT%\templates"
mkdir "%OUT%\tools"
mkdir "%OUT%\tools\bin"
mkdir "%OUT%\tests"

echo   Copiando archivos core...
copy /Y "%ROOT%\init.cmd"   "%OUT%\" >nul
copy /Y "%ROOT%\config.cmd" "%OUT%\" >nul
copy /Y "%ROOT%\README.md"  "%OUT%\" >nul

echo   Copiando modulos internos...
copy /Y "%ROOT%\lib\*.cmd" "%OUT%\lib\" >nul

echo   Copiando templates...
copy /Y "%ROOT%\templates\*.tpl" "%OUT%\templates\" >nul

echo   Copiando tools...
copy /Y "%ROOT%\tools\*.cmd" "%OUT%\tools\" >nul
copy /Y "%ROOT%\tools\bin\*.cmd" "%OUT%\tools\bin\" >nul

echo   Copiando tests...
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