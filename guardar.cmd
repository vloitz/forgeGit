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
git diff --cached --name-only
echo.

set "MSG="
set /p "MSG=  Mensaje del commit: "
if "!MSG!"=="" (
    echo   Abortado.
    exit /b 0
)

git commit -q -m "!MSG!"
echo.
echo   [OK] Commit: !MSG!
echo.

endlocal
exit /b 0
