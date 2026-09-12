@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

cd /d "%~dp0"

echo.
echo   ============================================
echo    Guardar - Commit en Git
echo   ============================================
echo.

REM --- Verificar repo ---
if not exist ".git" (
    echo   [X] No hay repositorio Git.
    echo       Ejecuta primero: init.cmd
    echo.
    call :pause_if_double_click
    exit /b 1
)

REM --- Verificar cambios ---
git add -A >nul 2>nul
git diff --cached --quiet
if not errorlevel 1 (
    echo   Sin cambios para guardar.
    echo.
    call :pause_if_double_click
    exit /b 0
)

REM --- Mostrar resumen ---
echo   Archivos a guardar:
echo.
git diff --cached --name-only | findstr /n "^" | findstr "^[0-9]*:"
echo.

REM --- Pedir mensaje ---
set "MSG="
set /p "MSG=  Mensaje del commit: "
if "!MSG!"=="" (
    echo   Mensaje vacio. Abortado.
    echo.
    call :pause_if_double_click
    exit /b 0
)

REM --- Commit ---
git commit -q -m "!MSG!"

echo.
echo   ============================================
echo    Commit guardado:
echo    !MSG!
echo   ============================================
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