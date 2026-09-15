@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

cd /d "%~dp0"
cls

set "ROOT=%~dp0"

REM --- Detectar donde esta lib/ y templates/ ---
if exist ".forge\lib\ui.cmd" (
    set "LIB=%ROOT%.forge\lib"
    set "TPL=%ROOT%.forge\templates"
    set "CMDS=%ROOT%.forge\commands"
) else (
    set "LIB=%ROOT%lib"
    set "TPL=%ROOT%templates"
    set "CMDS=%ROOT%.forge\commands"
)

REM --- Force mode ---
set "FORCE=0"
if /i "%~1"=="--force" set "FORCE=1"
if /i "%~1"=="force"   set "FORCE=1"
if /i "%~1"=="-f"      set "FORCE=1"

call "%ROOT%config.cmd"

for %%a in ("%CD%") do set "PROJECT_NAME=%%~nxa"

call "%LIB%\ui.cmd" banner

REM --- STEP 1/16: Node.js ---
where node >nul 2>nul
if errorlevel 1 (
    echo   [1/16] Node.js                          MISSING
    echo          Descargalo desde: https://nodejs.org/
    goto :abort
)
for /f "tokens=*" %%v in ('node --version 2^>nul') do set "NODE_VER=%%v"
call "%LIB%\ui.cmd" step 1/16 "Node.js !NODE_VER!" "OK"

REM --- STEP 2/16: Git ---
where git >nul 2>nul
if errorlevel 1 (
    echo   [2/16] Git                              MISSING
    echo          Descargalo desde: https://git-scm.com/download/win
    goto :abort
)
for /f "tokens=*" %%v in ('git --version 2^>nul') do set "GIT_VER=%%v"
call "%LIB%\ui.cmd" step 2/16 "!GIT_VER!" "OK"

REM --- STEP 3/16: Init repo ---
call "%LIB%\git-ops.cmd" init

REM --- STEP 4/16: Branch main ---
call "%LIB%\git-ops.cmd" branch_main

REM --- STEP 5/16: Crear estructura .forge/ ---
if exist ".forge\commands" goto :step5_ok
mkdir ".forge" 2>nul
mkdir ".forge\commands" 2>nul
mkdir ".forge\lib" 2>nul
mkdir ".forge\templates" 2>nul
call "%LIB%\ui.cmd" step 5/16 "Estructura .forge/" "CREADO"
goto :step6
:step5_ok
call "%LIB%\ui.cmd" step 5/16 "Estructura .forge/" "YA EXISTE"

:step6
REM --- STEP 6/16: .gitignore ---
if exist ".gitignore" goto :step6_ok
call "%LIB%\templates.cmd" write_gitignore
call "%LIB%\ui.cmd" step 6/16 ".gitignore universal" "CREADO"
goto :step7
:step6_ok
call "%LIB%\ui.cmd" step 6/16 ".gitignore" "YA EXISTE"

:step7
REM --- STEP 7/16: README.md ---
if exist "README.md" goto :step7_ok
call "%LIB%\templates.cmd" write_readme
call "%LIB%\ui.cmd" step 7/16 "README.md adaptativo" "CREADO"
goto :step8
:step7_ok
call "%LIB%\ui.cmd" step 7/16 "README.md" "YA EXISTE"

:step8
REM --- STEP 8/16: forge.cmd ---
if exist "forge.cmd" goto :step8_ok
call "%LIB%\templates.cmd" write_forge
call "%LIB%\ui.cmd" step 8/16 "forge.cmd menu" "CREADO"
goto :step9
:step8_ok
call "%LIB%\ui.cmd" step 8/16 "forge.cmd" "YA EXISTE"

:step9
REM --- STEP 9/16: save.cmd ---
if exist ".forge\commands\save.cmd" goto :step9_ok
call "%LIB%\templates.cmd" write_save
call "%LIB%\ui.cmd" step 9/16 "save.cmd" "CREADO"
goto :step10
:step9_ok
call "%LIB%\ui.cmd" step 9/16 "save.cmd" "YA EXISTE"

:step10
REM --- STEP 10/16: push.cmd ---
if exist ".forge\commands\push.cmd" goto :step10_ok
call "%LIB%\templates.cmd" write_push
call "%LIB%\ui.cmd" step 10/16 "push.cmd" "CREADO"
goto :step11
:step10_ok
call "%LIB%\ui.cmd" step 10/16 "push.cmd" "YA EXISTE"

:step11
REM --- STEP 11/16: snapshots.cmd ---
if exist ".forge\commands\snapshots.cmd" goto :step11_ok
call "%LIB%\templates.cmd" write_snapshots
call "%LIB%\ui.cmd" step 11/16 "snapshots.cmd" "CREADO"
goto :step12
:step11_ok
call "%LIB%\ui.cmd" step 11/16 "snapshots.cmd" "YA EXISTE"

:step12
REM --- STEP 12/16: historial.cmd ---
if exist ".forge\commands\historial.cmd" goto :step12_ok
call "%LIB%\templates.cmd" write_historial
call "%LIB%\ui.cmd" step 12/16 "historial.cmd" "CREADO"
goto :step13
:step12_ok
call "%LIB%\ui.cmd" step 12/16 "historial.cmd" "YA EXISTE"

:step13
REM --- STEP 13/16: abrir.cmd ---
if exist ".forge\commands\abrir.cmd" goto :step13_ok
call "%LIB%\templates.cmd" write_abrir
call "%LIB%\ui.cmd" step 13/16 "abrir.cmd" "CREADO"
goto :step14
:step13_ok
call "%LIB%\ui.cmd" step 13/16 "abrir.cmd" "YA EXISTE"

:step14
REM --- STEP 14/16: auditar.cmd ---
if exist ".forge\commands\auditar.cmd" goto :step14_ok
call "%LIB%\templates.cmd" write_auditar
call "%LIB%\ui.cmd" step 14/16 "auditar.cmd" "CREADO"
goto :step15
:step14_ok
call "%LIB%\ui.cmd" step 14/16 "auditar.cmd" "YA EXISTE"

:step15
REM --- STEP 15/16: Commit ---
call "%LIB%\git-ops.cmd" has_changes
if errorlevel 1 (
    set "USER_MSG="
    set /p "USER_MSG=  Mensaje del commit [Enter = default]: "
    if "!USER_MSG!"=="" set "USER_MSG=%COMMIT_MESSAGE%"
    call "%LIB%\git-ops.cmd" commit "!USER_MSG!"
    call "%LIB%\ui.cmd" step 15/16 "Commit: !USER_MSG!" "CREADO"
) else (
    call "%LIB%\ui.cmd" step 15/16 "Sin cambios para commit" "SKIP"
)

REM --- STEP 16/16: Tag ---
call "%LIB%\git-ops.cmd" tag
if errorlevel 1 (
    call "%LIB%\ui.cmd" step 16/16 "Tag %TAG_INITIAL%" "CREADO"
) else (
    call "%LIB%\ui.cmd" step 16/16 "Tag %TAG_INITIAL%" "YA EXISTE"
)

call "%LIB%\ui.cmd" done
call :shell_if_double_click
endlocal
exit /b 0

:abort
call "%LIB%\ui.cmd" abort
call :shell_if_double_click
endlocal
exit /b 1

:shell_if_double_click
if "%NO_PAUSE%"=="1" goto :eof
echo %cmdcmdline% | find /i "%~nx0" >nul
if errorlevel 1 goto :eof
echo.
echo   Sesion interactiva abierta. Escribe 'exit' para cerrar.
echo.
cmd /k
goto :eof