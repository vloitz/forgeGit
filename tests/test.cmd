@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

echo.
echo   ============================================
echo    forgeGit - Tests
echo   ============================================
echo.

set "FORGE_HOME=%~dp0.."
set "TEMP_DIR=%TEMP%\forge_test_%RANDOM%%RANDOM%"
set "PASS=0"
set "FAIL=0"

echo   [SETUP] Creando: %TEMP_DIR%
mkdir "%TEMP_DIR%" 2>nul
cd /d "%TEMP_DIR%"

REM ============================================================
REM   TEST 1: forge instala correctamente
REM ============================================================
echo.
echo   [TEST 1] Ejecutando forge...
call "%FORGE_HOME%\tools\bin\forge.cmd" < nul >nul 2>nul

REM Check archivos core
if exist "init.cmd" (
    echo     [OK] init.cmd creado
    set /a PASS+=1
) else (
    echo     [X] init.cmd NO creado
    set /a FAIL+=1
)

if exist "config.cmd" (
    echo     [OK] config.cmd creado
    set /a PASS+=1
) else (
    echo     [X] config.cmd NO creado
    set /a FAIL+=1
)

REM Check 7 helpers
for %%F in (guardar subir snapshots historial abrir auditar) do (
    if exist "%%F.cmd" (
        echo     [OK] %%F.cmd creado
        set /a PASS+=1
    ) else (
        echo     [X] %%F.cmd NO creado
        set /a FAIL+=1
    )
)

REM Check carpetas
if exist "lib\ui.cmd" (
    echo     [OK] lib\ui.cmd presente
    set /a PASS+=1
) else (
    echo     [X] lib\ui.cmd NO presente
    set /a FAIL+=1
)

if exist "templates\abrir.cmd.tpl" (
    echo     [OK] templates\abrir.cmd.tpl presente
    set /a PASS+=1
) else (
    echo     [X] templates\abrir.cmd.tpl NO presente
    set /a FAIL+=1
)

REM Check git
if exist ".git" (
    echo     [OK] repositorio git inicializado
    set /a PASS+=1
) else (
    echo     [X] repositorio git NO inicializado
    set /a FAIL+=1
)

REM Check tag
git tag -l 2>nul | findstr "v1.0.0" >nul
if not errorlevel 1 (
    echo     [OK] tag v1.0.0 creado
    set /a PASS+=1
) else (
    echo     [X] tag v1.0.0 NO creado
    set /a FAIL+=1
)

REM ============================================================
REM   TEST 2: forge update no rompe nada
REM ============================================================
echo.
echo   [TEST 2] Ejecutando forge update...
call "%FORGE_HOME%\tools\bin\forge.cmd" update < nul >nul 2>nul

if exist "init.cmd" (
    echo     [OK] init.cmd sigue presente
    set /a PASS+=1
) else (
    echo     [X] init.cmd desaparecio
    set /a FAIL+=1
)

REM ============================================================
REM   TEST 3: forge detecta instalacion previa
REM ============================================================
echo.
echo   [TEST 3] Ejecutando forge de nuevo (sin confirmar)...
echo n | call "%FORGE_HOME%\tools\bin\forge.cmd" >nul 2>nul

if exist "init.cmd" (
    echo     [OK] init.cmd intacto tras cancelacion
    set /a PASS+=1
) else (
    echo     [X] init.cmd se corrompio
    set /a FAIL+=1
)

REM ============================================================
REM   CLEANUP
REM ============================================================
echo.
echo   [CLEANUP] Borrando %TEMP_DIR%
cd /d "%TEMP%"
rmdir /s /q "%TEMP_DIR%" 2>nul

REM ============================================================
REM   RESULTADO
REM ============================================================
echo.
echo   ============================================
echo    Resultado
echo   ============================================
echo.
echo    PASS: !PASS!
echo    FAIL: !FAIL!
echo.

if !FAIL! GTR 0 (
    echo   ============================================
    echo    [X] TESTS FALLARON
    echo   ============================================
    echo.
    pause
    exit /b 1
)

echo   ============================================
echo    [OK] TODOS LOS TESTS PASARON
echo   ============================================
echo.
pause
exit /b 0