@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

cd /d "%~dp0"

echo.
echo   ============================================
echo    forgeGit - Restaurar PATH
echo   ============================================
echo.

if not exist "backups" (
    echo   [X] No hay carpeta backups\
    pause
    exit /b 1
)

echo   Backups disponibles:
echo.
set "IDX=0"
for /f "delims=" %%F in ('dir /b /o-n "backups\PATH_backup_*.txt" 2^>nul') do (
    echo     [!IDX!] %%F
    set "BK_!IDX!=%%F"
    set /a IDX+=1
)

if !IDX! EQU 0 (
    echo   (vacio)
    pause
    exit /b 1
)

echo.
set "SEL="
set /p "SEL=  Numero a restaurar [0-!IDX!-1]: "
if "!SEL!"=="" (
    echo   Cancelado.
    pause
    exit /b 0
)

set "TARGET=!BK_%SEL%!"
if "!TARGET!"=="" (
    echo   [X] Numero invalido.
    pause
    exit /b 1
)

echo.
echo   Restaurando: !TARGET!
echo.
set "CONFIRM="
set /p "CONFIRM=  Escribe SI para confirmar: "
if /i not "!CONFIRM!"=="SI" (
    echo   Cancelado.
    pause
    exit /b 0
)

powershell -NoProfile -Command ^
    "$content = [System.IO.File]::ReadAllText('backups\!TARGET!');" ^
    "[Environment]::SetEnvironmentVariable('Path', $content, 'User');" ^
    "Write-Host '  [OK] PATH restaurado.';"

echo.
echo   Cierra la terminal para aplicar los cambios.
echo.
pause
endlocal
exit /b 0