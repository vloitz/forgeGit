@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

cd /d "%~dp0"

echo.
echo   ============================================
echo    Subir - Push a GitHub
echo   ============================================
echo.

if not exist ".git" (
    echo   [X] No hay repositorio Git. Ejecuta: init.cmd
    call :shell_if_double_click
    exit /b 1
)

git diff --cached --quiet
set "STAGED=!ERRORLEVEL!"
git diff --quiet
set "UNSTAGED=!ERRORLEVEL!"

if !STAGED! NEQ 0 goto :has_changes
if !UNSTAGED! NEQ 0 goto :has_changes
goto :check_remote

:has_changes
echo   Hay cambios sin commitear.
echo.
set "SAVE="
set /p "SAVE=  Guardar cambios primero? [S/n]: "
if /i "!SAVE!"=="n" goto :check_remote
echo.
set "SKIP_HISTORIAL=1"
set "NO_PAUSE=1"
call "guardar.cmd"
set "SKIP_HISTORIAL="
set "NO_PAUSE="
echo.

:check_remote
git remote get-url origin >nul 2>nul
if errorlevel 1 (
    echo   [X] No hay remote 'origin' configurado.
    echo.
    echo   Para vincular tu repo a GitHub:
    echo.
    echo     git remote add origin https://github.com/TU-USUARIO/TU-REPO.git
    echo.
    call :shell_if_double_click
    exit /b 1
)

echo   Subiendo a GitHub...
echo.

git push -u origin main
set "RC=!ERRORLEVEL!"

echo.
if !RC! EQU 0 (
    echo   [OK] Push completado
) else (
    echo   [ERROR] Push fallo con codigo !RC!
)
echo.

set "NO_PAUSE=1"
call "%~dp0historial.cmd"
set "NO_PAUSE="

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