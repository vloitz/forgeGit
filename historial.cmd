@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

cd /d "%~dp0"

echo.
echo   ============================================
echo    Historial de versiones
echo   ============================================
echo.

if exist ".git" (
    echo   [ COMMITS - ultimos 20 ]
    echo.
    echo   FECHA                HASH       MENSAJE
    echo   ----------------------------------------------------------------
    git log --date=format:"%%Y-%%m-%%d %%H:%%M:%%S" --pretty=format:"  %%ad  %%h  %%s" -20
    echo.
    echo.
) else (
    echo   [ COMMITS ] Sin repositorio Git
    echo.
)

echo   [ TAGS ]
echo.
if exist ".git" git tag -l
echo.
echo.

echo   [ SNAPSHOTS ]
echo.
if exist "versiones" dir /b /o-n "versiones"
echo.
echo.

echo   ============================================
echo.

call :pause_if_double_click
endlocal
exit /b 0

:pause_if_double_click
if "%NO_PAUSE%"=="1" goto :eof
echo %cmdcmdline% | find /i "%~nx0" >nul
if not errorlevel 1 (
    echo   Presiona cualquier tecla para cerrar...
    pause >nul
)
goto :eof