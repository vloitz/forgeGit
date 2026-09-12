@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

cd /d "%~dp0"

if not exist ".git" (
    echo   [X] No hay repositorio Git. Ejecuta: init.cmd
    exit /b 1
)

git add -A >nul 2>nul
git diff --cached --quiet
if not errorlevel 1 (
    echo   Sin cambios para guardar.
    exit /b 0
)

echo.
echo   Archivos a guardar:
git diff --cached --name-only | findstr /n "^"
echo.

set "MSG="
set /p "MSG=  Mensaje del commit [Enter = Sin definir]: "
if "!MSG!"=="" set "MSG=Sin definir"

git commit -q -m "!MSG!"
echo.
echo   [OK] Commit: !MSG!
echo.

if "%SKIP_HISTORIAL%"=="1" goto :skip_hist
set "NO_PAUSE=1"
call "%~dp0historial.cmd"
set "NO_PAUSE="
:skip_hist

call :shell_if_double_click
endlocal
exit /b 0

:shell_if_double_click
if "%NO_PAUSE%"=="1" goto :eof
echo %cmdcmdline% | find /i "%~nx0" >nul
if errorlevel 1 goto :eof
echo.
echo   Sesion interactiva abierta. Escribe 'exit' para cerrar.
echo.
cmd /k
goto :eof