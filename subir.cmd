@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

cd /d "%~dp0"

echo.
echo   ============================================
echo    Subir - Push a GitHub
echo   ============================================
echo.

REM --- 1. Verificar repo ---
if not exist ".git" (
    echo   [X] No hay repositorio Git.
    echo       Ejecuta primero: init.cmd
    echo.
    call :pause_if_double_click
    exit /b 1
)

REM --- 2. Verificar cambios pendientes ---
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
if /i "!SAVE!"=="n" (
    echo   Continuando sin guardar...
    echo.
    goto :check_remote
)
echo.
call "guardar.cmd"
echo.

REM --- 3. Verificar remote ---
:check_remote
git remote get-url origin >nul 2>nul
if errorlevel 1 (
    echo   [X] No hay remote 'origin' configurado.
    echo.
    echo   Para vincular tu repo a GitHub, ejecuta:
    echo.
    echo     git remote add origin https://github.com/TU-USUARIO/TU-REPO.git
    echo.
    echo   O si prefieres SSH:
    echo.
    echo     git remote add origin git@github.com:TU-USUARIO/TU-REPO.git
    echo.
    echo   Cancela este comando y vincula manualmente.
    echo.
    call :pause_if_double_click
    exit /b 1
)

REM --- 4. Push ---
echo   Subiendo a GitHub...
echo.

git push -u origin main
set "RC=!ERRORLEVEL!"

echo.
if !RC! EQU 0 (
    echo   ============================================
    echo    Push completado correctamente
    echo   ============================================
) else (
    echo   ============================================
    echo    [ERROR] Push fallo con codigo !RC!
    echo   ============================================
    echo.
    echo   Causas comunes:
    echo     - Sin conexion a internet
    echo     - Sin permisos en el repo remoto
    echo     - Necesitas hacer 'git pull' primero
)
echo.

call :pause_if_double_click
endlocal
exit /b 0

REM ============================================================
REM   :pause_if_double_click
REM ============================================================
:pause_if_double_click
echo %cmdcmdline% | find /i "%~nx0" >nul
if not errorlevel 1 (
    echo   Presiona cualquier tecla para cerrar...
    pause >nul
)
goto :eof