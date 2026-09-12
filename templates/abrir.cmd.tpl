@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

cd /d "%~dp0"

REM --- Verifica VS Code CLI ---
where code >nul 2>nul
if errorlevel 1 (
    echo   [X] VS Code CLI no esta en el PATH.
    echo.
    echo   Instala:
    echo     1. Abre VS Code
    echo     2. Ctrl+Shift+P
    echo     3. "Shell Command: Install 'code' command in PATH"
    echo.
    call :shell_if_double_click
    exit /b 1
)

REM --- Argumentos opcionales (por si quieres pasar archivos) ---
if "%~1"=="" (
    code .
) else (
    code %*
)

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