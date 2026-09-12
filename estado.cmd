@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

cd /d "%~dp0"

if not exist ".git" (
    echo   [X] No hay repositorio Git. Ejecuta: init.cmd
    exit /b 1
)

echo.
echo   ============================================
echo    Diff - Auditar cambios
echo   ============================================
echo.

REM --- 1. Cuantos commits ---
set "LIMIT=10"
set "INPUT="
set /p "INPUT=  Cuantos commits hacia atras? [Enter=10, T=todos]: "
if /i "!INPUT!"=="T" (
    set "LIMIT=9999"
) else if not "!INPUT!"=="" (
    set "LIMIT=!INPUT!"
)

REM --- 2. Log a temp file ---
set "TMPLOG=%TEMP%\forge_git_log.txt"
git log -n !LIMIT! --date=format:"%%Y-%%m-%%d %%H:%%M:%%S" --pretty=format:"%%h %%ad %%s" > "!TMPLOG!" 2>nul

REM --- 3. Mostrar con indices ---
echo.
echo   IDX   FECHA                HASH       MENSAJE
echo   ----------------------------------------------------------------

set "IDX=0"
for /f "delims=" %%L in ('type "!TMPLOG!"') do (
    set "LINE=%%L"
    set "HASH=!LINE:~0,7!"
    set "DATETIME=!LINE:~8,19!"
    set "MSG=!LINE:~28!"
    set "H_!IDX!=!HASH!"
    echo   [!IDX!] !DATETIME!  !HASH!  !MSG!
    set /a IDX=IDX+1
)
del "!TMPLOG!" >nul 2>nul

if !IDX! EQU 0 (
    echo   [X] No hay commits.
    exit /b 1
)

echo.
echo   Total: !IDX! commits  ^(0 = mas reciente^)
echo.

REM --- 4. Pedir rango ---
set "RANGE="
set /p "RANGE=  Rango (ej: 0,3 o 0-3) [Enter=cancelar]: "
if "!RANGE!"=="" (
    echo   Cancelado.
    goto :end
)

set "A="
set "B="
for /f "tokens=1,2 delims=,-" %%a in ("!RANGE!") do (
    set "A=%%a"
    if not "%%b"=="" set "B=%%b"
)
if "!A!"=="" (
    echo   [X] Rango invalido.
    goto :end
)
if "!B!"=="" set "B=!A!"

REM --- 5. Resolver hashes ---
set "HA=!H_%A%!"
set "HB=!H_%B%!"
if "!HA!"=="" (
    echo   [X] Indice !A! no existe.
    goto :end
)
if "!HB!"=="" (
    echo   [X] Indice !B! no existe.
    goto :end
)

REM --- 6. Orden cronologico (mas antiguo primero) ---
set "OLD_IDX=!A!"
set "NEW_IDX=!B!"
if !A! LSS !B! (
    set "OLD_IDX=!B!"
    set "NEW_IDX=!A!"
)
set "H_OLD=!H_%OLD_IDX%!"
set "H_NEW=!H_%NEW_IDX%!"

echo.
echo   Comparando:
echo     [mas antiguo]  !H_OLD!  ^(idx !OLD_IDX!^)
echo     [mas reciente] !H_NEW!  ^(idx !NEW_IDX!^)
echo.

REM --- 7. Reporte ---
set "REPORT=audit_diff_!OLD_IDX!_!NEW_IDX!.txt"
(
    echo # Reporte de auditoria
    echo.
    echo # Generado: %DATE% %TIME%
    echo # Proyecto: %CD%
    echo # Rango:    [!OLD_IDX!] !H_OLD!  -^>  [!NEW_IDX!] !H_NEW!
    echo.
    echo # ============================================================
    echo # COMMITS EN EL RANGO
    echo # ============================================================
    echo.
    git log !H_OLD!^..!H_NEW! --date=format:"%%Y-%%m-%%d %%H:%%M:%%S" --pretty=format:"  %%ad  %%h  %%s"
    echo.
    echo.
    echo # ============================================================
    echo # DIFF COMPLETO
    echo # ============================================================
    echo.
    git diff !H_OLD! !H_NEW!
    echo.
    echo.
    echo # ============================================================
    echo # ESTADO ACTUAL (sin commitear)
    echo # ============================================================
    echo.
    git status --short
) > "!REPORT!" 2>&1

echo   [OK] Reporte: !REPORT!
for %%f in ("!REPORT!") do echo        Tamano: %%~zf bytes
echo.

:end
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