@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

echo.
echo   ============================================
echo    forgeGit - Tests v1.5.10
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
if exist "forge.cmd" (
    echo     [OK] forge.cmd creado
    set /a PASS+=1
) else (
    echo     [X] forge.cmd NO creado
    set /a FAIL+=1
)

if exist ".forge\init.cmd" (
    echo     [OK] .forge\init.cmd presente
    set /a PASS+=1
) else (
    echo     [X] .forge\init.cmd NO presente
    set /a FAIL+=1
)

if exist ".forge\config.cmd" (
    echo     [OK] .forge\config.cmd presente
    set /a PASS+=1
) else (
    echo     [X] .forge\config.cmd NO presente
    set /a FAIL+=1
)

REM Check 7 helpers
for %%F in (save push snapshots historial abrir auditar serve) do (
    if exist ".forge\commands\%%F.cmd" (
        echo     [OK] .forge\commands\%%F.cmd creado
        set /a PASS+=1
    ) else (
        echo     [X] .forge\commands\%%F.cmd NO creado
        set /a FAIL+=1
    )
)

REM Check carpetas
if exist ".forge\lib\ui.cmd" (
    echo     [OK] .forge\lib\ui.cmd presente
    set /a PASS+=1
) else (
    echo     [X] .forge\lib\ui.cmd NO presente
    set /a FAIL+=1
)

if exist ".forge\templates\abrir.cmd.tpl" (
    echo     [OK] .forge\templates\abrir.cmd.tpl presente
    set /a PASS+=1
) else (
    echo     [X] .forge\templates\abrir.cmd.tpl NO presente
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

if exist "forge.cmd" (
    echo     [OK] forge.cmd sigue presente
    set /a PASS+=1
) else (
    echo     [X] forge.cmd desaparecio
    set /a FAIL+=1
)

if exist ".forge\init.cmd" (
    echo     [OK] .forge\init.cmd sigue presente
    set /a PASS+=1
) else (
    echo     [X] .forge\init.cmd desaparecio
    set /a FAIL+=1
)

REM ============================================================
REM   TEST 3: omitido (delegacion interactiva no automatizable)
REM ============================================================
echo.
echo   [TEST 3] Omitido (test manual requerido)

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