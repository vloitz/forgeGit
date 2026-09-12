@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

cd /d "%~dp0"
cls

set "ROOT=%~dp0"
set "LIB=%ROOT%lib"

REM --- Force mode: init.cmd --force  o  init.cmd force ---
set "FORCE=0"
if /i "%~1"=="--force" set "FORCE=1"
if /i "%~1"=="force"   set "FORCE=1"
if /i "%~1"=="-f"      set "FORCE=1"

call "%ROOT%config.cmd"

for %%a in ("%CD%") do set "PROJECT_NAME=%%~nxa"

call "%LIB%\ui.cmd" banner

REM --- STEP 1/12: Node.js ---
where node >nul 2>nul
if errorlevel 1 (
    echo   [1/12] Node.js                          MISSING
    echo          Descargalo desde: https://nodejs.org/
    goto :abort
)
for /f "tokens=*" %%v in ('node --version 2^>nul') do set "NODE_VER=%%v"
call "%LIB%\ui.cmd" step 1/12 "Node.js !NODE_VER!" "OK"

REM --- STEP 2/12: Git ---
where git >nul 2>nul
if errorlevel 1 (
    echo   [2/12] Git                              MISSING
    echo          Descargalo desde: https://git-scm.com/download/win
    goto :abort
)
for /f "tokens=*" %%v in ('git --version 2^>nul') do set "GIT_VER=%%v"
call "%LIB%\ui.cmd" step 2/12 "!GIT_VER!" "OK"

REM --- STEP 3/12: Init repo ---
call "%LIB%\git-ops.cmd" init

REM --- STEP 4/12: Branch main ---
call "%LIB%\git-ops.cmd" branch_main

REM --- STEP 5/12: .gitignore ---
if exist ".gitignore" (
    if "%FORCE%"=="1" (
        call "%LIB%\templates.cmd" write_gitignore
        call "%LIB%\ui.cmd" step 5/12 ".gitignore universal" "FORZADO"
    ) else (
        call "%LIB%\ui.cmd" step 5/12 ".gitignore" "YA EXISTE"
    )
) else (
    call "%LIB%\templates.cmd" write_gitignore
    call "%LIB%\ui.cmd" step 5/12 ".gitignore universal" "CREADO"
)

REM --- STEP 6/12: README.md ---
if exist "README.md" (
    if "%FORCE%"=="1" (
        call "%LIB%\templates.cmd" write_readme
        call "%LIB%\ui.cmd" step 6/12 "README.md adaptativo" "FORZADO"
    ) else (
        call "%LIB%\ui.cmd" step 6/12 "README.md" "YA EXISTE"
    )
) else (
    call "%LIB%\templates.cmd" write_readme
    call "%LIB%\ui.cmd" step 6/12 "README.md adaptativo" "CREADO"
)

REM --- STEP 7/12: guardar.cmd ---
if exist "guardar.cmd" (
    if "%FORCE%"=="1" (
        call "%LIB%\templates.cmd" write_guardar
        call "%LIB%\ui.cmd" step 7/12 "guardar.cmd" "FORZADO"
    ) else (
        call "%LIB%\ui.cmd" step 7/12 "guardar.cmd" "YA EXISTE"
    )
) else (
    call "%LIB%\templates.cmd" write_guardar
    call "%LIB%\ui.cmd" step 7/12 "guardar.cmd" "CREADO"
)

REM --- STEP 8/12: subir.cmd ---
if exist "subir.cmd" (
    if "%FORCE%"=="1" (
        call "%LIB%\templates.cmd" write_subir
        call "%LIB%\ui.cmd" step 8/12 "subir.cmd" "FORZADO"
    ) else (
        call "%LIB%\ui.cmd" step 8/12 "subir.cmd" "YA EXISTE"
    )
) else (
    call "%LIB%\templates.cmd" write_subir
    call "%LIB%\ui.cmd" step 8/12 "subir.cmd" "CREADO"
)

REM --- STEP 9/12: respaldar.cmd ---
if exist "respaldar.cmd" (
    if "%FORCE%"=="1" (
        call "%LIB%\templates.cmd" write_respaldar
        call "%LIB%\ui.cmd" step 9/12 "respaldar.cmd" "FORZADO"
    ) else (
        call "%LIB%\ui.cmd" step 9/12 "respaldar.cmd" "YA EXISTE"
    )
) else (
    call "%LIB%\templates.cmd" write_respaldar
    call "%LIB%\ui.cmd" step 9/12 "respaldar.cmd" "CREADO"
)

REM --- STEP 10/12: historial.cmd ---
if exist "historial.cmd" (
    if "%FORCE%"=="1" (
        call "%LIB%\templates.cmd" write_historial
        call "%LIB%\ui.cmd" step 10/12 "historial.cmd" "FORZADO"
    ) else (
        call "%LIB%\ui.cmd" step 10/12 "historial.cmd" "YA EXISTE"
    )
) else (
    call "%LIB%\templates.cmd" write_historial
    call "%LIB%\ui.cmd" step 10/12 "historial.cmd" "CREADO"
)

REM --- STEP 11/12: Commit ---
call "%LIB%\git-ops.cmd" has_changes
if errorlevel 1 (
    set "USER_MSG="
    set /p "USER_MSG=  Mensaje del commit [Enter = default]: "
    if "!USER_MSG!"=="" set "USER_MSG=%COMMIT_MESSAGE%"
    call "%LIB%\git-ops.cmd" commit "!USER_MSG!"
    call "%LIB%\ui.cmd" step 11/12 "Commit: !USER_MSG!" "CREADO"
) else (
    call "%LIB%\ui.cmd" step 11/12 "Sin cambios para commit" "SKIP"
)

REM --- STEP 12/12: Tag ---
call "%LIB%\git-ops.cmd" tag
if errorlevel 1 (
    call "%LIB%\ui.cmd" step 12/12 "Tag %TAG_INITIAL%" "CREADO"
) else (
    call "%LIB%\ui.cmd" step 12/12 "Tag %TAG_INITIAL%" "YA EXISTE"
)

call "%LIB%\ui.cmd" done

call :pause_if_double_click
endlocal
exit /b 0

:abort
call "%LIB%\ui.cmd" abort
call :pause_if_double_click
endlocal
exit /b 1

:pause_if_double_click
echo %cmdcmdline% | find /i "%~nx0" >nul
if not errorlevel 1 (
    echo   Presiona cualquier tecla para cerrar...
    pause >nul
)
goto :eof