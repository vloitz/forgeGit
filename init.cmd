@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

REM ============================================================
REM   forge-git / init.cmd
REM   Entry point - orchestrates the bootstrap flow
REM   Version: 1.2.0
REM
REM   Modules:
REM     config.cmd          Configuration
REM     lib/ui.cmd          UI helpers
REM     lib/git-ops.cmd     Git operations
REM     lib/templates.cmd   File writers
REM ============================================================

cd /d "%~dp0"
cls

set "ROOT=%~dp0"
set "LIB=%ROOT%lib"

REM --- Load configuration ---
call "%ROOT%config.cmd"

REM --- Detect project name ---
for %%a in ("%CD%") do set "PROJECT_NAME=%%~nxa"

REM --- Show banner ---
call "%LIB%\ui.cmd" banner

REM ============================================================
REM   STEP 1 - Node.js
REM ============================================================
where node >nul 2>nul
if errorlevel 1 (
    echo   [1/9] Node.js                          MISSING
    echo         Descargalo desde: https://nodejs.org/
    goto :abort
)
for /f "tokens=*" %%v in ('node --version 2^>nul') do set "NODE_VER=%%v"
call "%LIB%\ui.cmd" step 1/9 "Node.js !NODE_VER!" "OK"

REM ============================================================
REM   STEP 2 - Git
REM ============================================================
where git >nul 2>nul
if errorlevel 1 (
    echo   [2/9] Git                              MISSING
    echo         Descargalo desde: https://git-scm.com/download/win
    goto :abort
)
for /f "tokens=*" %%v in ('git --version 2^>nul') do set "GIT_VER=%%v"
call "%LIB%\ui.cmd" step 2/9 "!GIT_VER!" "OK"

REM ============================================================
REM   STEP 3 - Init repo
REM ============================================================
call "%LIB%\git-ops.cmd" init
if errorlevel 1 (
    REM 1 = creado OK, 0 = ya existia - ambos OK
)

REM ============================================================
REM   STEP 4 - Branch main
REM ============================================================
call "%LIB%\git-ops.cmd" branch_main

REM ============================================================
REM   STEP 5 - .gitignore
REM ============================================================
if exist ".gitignore" (
    call "%LIB%\ui.cmd" step 5/9 ".gitignore" "YA EXISTE"
) else (
    call "%LIB%\templates.cmd" write_gitignore
    call "%LIB%\ui.cmd" step 5/9 ".gitignore universal" "CREADO"
)

REM ============================================================
REM   STEP 6 - README.md
REM ============================================================
if exist "README.md" (
    call "%LIB%\ui.cmd" step 6/9 "README.md" "YA EXISTE"
) else (
    call "%LIB%\templates.cmd" write_readme
    call "%LIB%\ui.cmd" step 6/9 "README.md adaptativo" "CREADO"
)

REM ============================================================
REM   STEP 7 - Commit
REM ============================================================
call "%LIB%\git-ops.cmd" has_changes
if errorlevel 1 (
    set "USER_MSG="
    set /p "USER_MSG=  Mensaje del commit [Enter = default]: "
    if "!USER_MSG!"=="" set "USER_MSG=%COMMIT_MESSAGE%"
    call "%LIB%\git-ops.cmd" commit "!USER_MSG!"
    call "%LIB%\ui.cmd" step 7/9 "Commit: !USER_MSG!" "CREADO"
) else (
    call "%LIB%\ui.cmd" step 7/9 "Sin cambios para commit" "SKIP"
)

REM ============================================================
REM   STEP 8 - Tag
REM ============================================================
call "%LIB%\git-ops.cmd" tag
if errorlevel 1 (
    call "%LIB%\ui.cmd" step 8/9 "Tag %TAG_INITIAL%" "CREADO"
) else (
    call "%LIB%\ui.cmd" step 8/9 "Tag %TAG_INITIAL%" "YA EXISTE"
)

REM ============================================================
REM   STEP 9 - subir.cmd
REM ============================================================
if exist "subir.cmd" (
    call "%LIB%\ui.cmd" step 9/9 "subir.cmd" "YA EXISTE"
) else (
    call "%LIB%\templates.cmd" write_subir
    call "%LIB%\ui.cmd" step 9/9 "subir.cmd universal" "CREADO"
)

REM ============================================================
REM   DONE
REM ============================================================
call "%LIB%\ui.cmd" done

REM --- Pausar solo si se lanzo con doble clic ---
call :pause_if_double_click

endlocal
exit /b 0

:abort
call "%LIB%\ui.cmd" abort
call :pause_if_double_click
endlocal
exit /b 1

REM ============================================================
REM   :pause_if_double_click
REM   Pauses only if the script was launched by double-click
REM   (i.e. %cmdcmdline% contains the script name)
REM ============================================================
:pause_if_double_click
echo %cmdcmdline% | find /i "%~nx0" >nul
if not errorlevel 1 (
    echo   Presiona cualquier tecla para cerrar...
    pause >nul
)
goto :eof