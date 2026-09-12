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

REM --- STEP 1/14: Node.js ---
where node >nul 2>nul
if errorlevel 1 (
    echo   [1/14] Node.js                          MISSING
    echo          Descargalo desde: https://nodejs.org/
    goto :abort
)
for /f "tokens=*" %%v in ('node --version 2^>nul') do set "NODE_VER=%%v"
call "%LIB%\ui.cmd" step 1/14 "Node.js !NODE_VER!" "OK"

REM --- STEP 2/14: Git ---
where git >nul 2>nul
if errorlevel 1 (
    echo   [2/14] Git                              MISSING
    echo          Descargalo desde: https://git-scm.com/download/win
    goto :abort
)
for /f "tokens=*" %%v in ('git --version 2^>nul') do set "GIT_VER=%%v"
call "%LIB%\ui.cmd" step 2/14 "!GIT_VER!" "OK"

REM --- STEP 3/14: Init repo ---
call "%LIB%\git-ops.cmd" init

REM --- STEP 4/14: Branch main ---
call "%LIB%\git-ops.cmd" branch_main

REM --- STEP 5/14: .gitignore ---
if exist ".gitignore" (
    if "%FORCE%"=="1" (
        call "%LIB%\templates.cmd" write_gitignore
        call "%LIB%\ui.cmd" step 5/14 ".gitignore universal" "FORZADO"
    ) else (
        call "%LIB%\ui.cmd" step 5/14 ".gitignore" "YA EXISTE"
    )
) else (
    call "%LIB%\templates.cmd" write_gitignore
    call "%LIB%\ui.cmd" step 5/14 ".gitignore universal" "CREADO"
)

REM --- STEP 6/14: README.md ---
if exist "README.md" (
    if "%FORCE%"=="1" (
        call "%LIB%\templates.cmd" write_readme
        call "%LIB%\ui.cmd" step 6/14 "README.md adaptativo" "FORZADO"
    ) else (
        call "%LIB%\ui.cmd" step 6/14 "README.md" "YA EXISTE"
    )
) else (
    call "%LIB%\templates.cmd" write_readme
    call "%LIB%\ui.cmd" step 6/14 "README.md adaptativo" "CREADO"
)

REM --- STEP 7/14: guardar.cmd ---
if exist "guardar.cmd" (
    if "%FORCE%"=="1" (
        call "%LIB%\templates.cmd" write_guardar
        call "%LIB%\ui.cmd" step 7/14 "guardar.cmd" "FORZADO"
    ) else (
        call "%LIB%\ui.cmd" step 7/14 "guardar.cmd" "YA EXISTE"
    )
) else (
    call "%LIB%\templates.cmd" write_guardar
    call "%LIB%\ui.cmd" step 7/14 "guardar.cmd" "CREADO"
)

REM --- STEP 8/14: subir.cmd ---
if exist "subir.cmd" (
    if "%FORCE%"=="1" (
        call "%LIB%\templates.cmd" write_subir
        call "%LIB%\ui.cmd" step 8/14 "subir.cmd" "FORZADO"
    ) else (
        call "%LIB%\ui.cmd" step 8/14 "subir.cmd" "YA EXISTE"
    )
) else (
    call "%LIB%\templates.cmd" write_subir
    call "%LIB%\ui.cmd" step 8/14 "subir.cmd" "CREADO"
)

REM --- STEP 9/14: snapshots.cmd ---
if exist "snapshots.cmd" (
    if "%FORCE%"=="1" (
        call "%LIB%\templates.cmd" write_snapshots
        call "%LIB%\ui.cmd" step 9/14 "snapshots.cmd" "FORZADO"
    ) else (
        call "%LIB%\ui.cmd" step 9/14 "snapshots.cmd" "YA EXISTE"
    )
) else (
    call "%LIB%\templates.cmd" write_snapshots
    call "%LIB%\ui.cmd" step 9/14 "snapshots.cmd" "CREADO"
)

REM --- STEP 10/14: historial.cmd ---
if exist "historial.cmd" (
    if "%FORCE%"=="1" (
        call "%LIB%\templates.cmd" write_historial
        call "%LIB%\ui.cmd" step 10/14 "historial.cmd" "FORZADO"
    ) else (
        call "%LIB%\ui.cmd" step 10/14 "historial.cmd" "YA EXISTE"
    )
) else (
    call "%LIB%\templates.cmd" write_historial
    call "%LIB%\ui.cmd" step 10/14 "historial.cmd" "CREADO"
)

REM --- STEP 11/14: abrir.cmd ---
if exist "abrir.cmd" (
    if "%FORCE%"=="1" (
        call "%LIB%\templates.cmd" write_abrir
        call "%LIB%\ui.cmd" step 11/14 "abrir.cmd" "FORZADO"
    ) else (
        call "%LIB%\ui.cmd" step 11/14 "abrir.cmd" "YA EXISTE"
    )
) else (
    call "%LIB%\templates.cmd" write_abrir
    call "%LIB%\ui.cmd" step 11/14 "abrir.cmd" "CREADO"
)

REM --- STEP 12/14: auditar.cmd ---
if exist "auditar.cmd" (
    if "%FORCE%"=="1" (
        call "%LIB%\templates.cmd" write_auditar
        call "%LIB%\ui.cmd" step 12/14 "auditar.cmd" "FORZADO"
    ) else (
        call "%LIB%\ui.cmd" step 12/14 "auditar.cmd" "YA EXISTE"
    )
) else (
    call "%LIB%\templates.cmd" write_auditar
    call "%LIB%\ui.cmd" step 12/14 "auditar.cmd" "CREADO"
)

REM --- STEP 13/14: Commit ---
call "%LIB%\git-ops.cmd" has_changes
if errorlevel 1 (
    set "USER_MSG="
    set /p "USER_MSG=  Mensaje del commit [Enter = default]: "
    if "!USER_MSG!"=="" set "USER_MSG=%COMMIT_MESSAGE%"
    call "%LIB%\git-ops.cmd" commit "!USER_MSG!"
    call "%LIB%\ui.cmd" step 13/14 "Commit: !USER_MSG!" "CREADO"
) else (
    call "%LIB%\ui.cmd" step 13/14 "Sin cambios para commit" "SKIP"
)

REM --- STEP 14/14: Tag ---
call "%LIB%\git-ops.cmd" tag
if errorlevel 1 (
    call "%LIB%\ui.cmd" step 14/14 "Tag %TAG_INITIAL%" "CREADO"
) else (
    call "%LIB%\ui.cmd" step 14/14 "Tag %TAG_INITIAL%" "YA EXISTE"
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