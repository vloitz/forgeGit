@echo off
REM ============================================================
REM   forge-git / lib/templates.cmd
REM   File writers
REM
REM   Usage:
REM     call "templates.cmd" write_gitignore
REM     call "templates.cmd" write_readme
REM     call "templates.cmd" write_guardar
REM     call "templates.cmd" write_subir
REM     call "templates.cmd" write_respaldar
REM     call "templates.cmd" write_historial
REM ============================================================

if "%~1"=="write_gitignore" goto :write_gitignore
if "%~1"=="write_readme"    goto :write_readme
if "%~1"=="write_guardar"   goto :write_guardar
if "%~1"=="write_subir"     goto :write_subir
if "%~1"=="write_respaldar" goto :write_respaldar
if "%~1"=="write_historial" goto :write_historial
goto :eof

REM ============================================================
REM   write_gitignore
REM ============================================================
:write_gitignore
> .gitignore (
    echo # ==== Sistema operativo ====
    echo Thumbs.db
    echo ehthumbs.db
    echo Desktop.ini
    echo $RECYCLE.BIN/
    echo *.lnk
    echo .DS_Store
    echo.
    echo # ==== Editor / IDE ====
    echo .vscode/
    echo .idea/
    echo *.swp
    echo *.swo
    echo *~
    echo.
    echo # ==== Node.js ====
    echo node_modules/
    echo npm-debug.log*
    echo yarn-debug.log*
    echo yarn-error.log*
    echo pnpm-debug.log*
    echo package-lock.json
    echo yarn.lock
    echo pnpm-lock.yaml
    echo.
    echo # ==== Python ====
    echo __pycache__/
    echo *.py[cod]
    echo .Python
    echo venv/
    echo .venv/
    echo env/
    echo .env
    echo.
    echo # ==== Rust ====
    echo target/
    echo Cargo.lock
    echo.
    echo # ==== Go ====
    echo *.test
    echo *.out
    echo.
    echo # ==== Build / dist ====
    echo dist/
    echo build/
    echo out/
    echo .cache/
    echo .parcel-cache/
    echo .vite/
    echo.
    echo # ==== Modelos / cache IA ====
    echo *.onnx
    echo *.bin
    echo *.wasm
    echo *.pb
    echo models/
    echo cache/
    echo .huggingface/
    echo.
    echo # ==== Backups manuales ====
    echo versiones/
    echo old_versions/
    echo backup/
    echo backups/
    echo.
    echo # ==== Temporales ====
    echo *.log
    echo *.tmp
    echo *.bak
    echo *.orig
    echo.
    echo # ==== Capturas ====
    echo screenshots/
    echo capturas/
    echo test-output/
)
goto :eof

REM ============================================================
REM   write_readme
REM ============================================================
:write_readme
set "STACK_WRITTEN="

> README.md (
    echo # %PROJECT_NAME%
    echo.
    echo Proyecto inicializado con `init.cmd`.
    echo.
)

call :try_stack "package.json"      "Node.js"
call :try_stack "requirements.txt"  "Python"
call :try_stack "Cargo.toml"        "Rust"
call :try_stack "go.mod"            "Go"
call :try_stack "composer.json"     "PHP"
call :try_stack "pom.xml"           "Java / Maven"
call :try_stack "build.gradle"      "Java / Gradle"
call :try_stack "Gemfile"           "Ruby"

>> README.md (
    echo ## Estructura
    echo.
)

for /d %%d in (*) do (
    if /I not "%%d"==".git" if /I not "%%d"=="versiones" if /I not "%%d"=="node_modules" if /I not "%%d"=="__pycache__" if /I not "%%d"=="venv" (
        >> README.md echo - `%%d/`
    )
)

>> README.md (
    echo.
    echo ## Comandos
    echo.
    echo ```
    echo guardar.cmd     Commit de cambios en Git
    echo subir.cmd       Push a GitHub
    echo respaldar.cmd   Snapshot completo en versiones/
    echo historial.cmd   Ver commits, tags y snapshots
    echo ```
    echo.
    echo ---
    echo.
    echo Generado por forge-git v%FG_VERSION%
)
goto :eof

:try_stack
if not exist "%~1" goto :eof
if "!STACK_WRITTEN!"=="" (
    >> README.md (
        echo ## Stack detectado
        echo.
    )
    set "STACK_WRITTEN=1"
)
>> README.md echo - %~2
goto :eof

REM ============================================================
REM   write_guardar - commit local
REM ============================================================
:write_guardar
setlocal DisableDelayedExpansion
> guardar.cmd (
    echo @echo off
    echo setlocal EnableDelayedExpansion
    echo chcp 65001 ^>nul 2^>nul
    echo.
    echo cd /d "%%~dp0"
    echo.
    echo if not exist ".git" ^(
    echo     echo   [X] No hay repositorio Git. Ejecuta: init.cmd
    echo     exit /b 1
    echo ^)
    echo.
    echo git add -A ^>nul 2^>nul
    echo git diff --cached --quiet
    echo if not errorlevel 1 ^(
    echo     echo   Sin cambios para guardar.
    echo     exit /b 0
    echo ^)
    echo.
    echo echo.
    echo echo   Archivos a guardar:
    echo git diff --cached --name-only
    echo echo.
    echo.
    echo set "MSG="
    echo set /p "MSG=  Mensaje del commit: "
    echo if "!MSG!"=="" ^(
    echo     echo   Abortado.
    echo     exit /b 0
    echo ^)
    echo.
    echo git commit -q -m "!MSG!"
    echo echo.
    echo echo   [OK] Commit: !MSG!
    echo echo.
    echo.
    echo endlocal
    echo exit /b 0
)
endlocal
goto :eof

REM ============================================================
REM   write_subir - push a GitHub
REM ============================================================
:write_subir
setlocal DisableDelayedExpansion
> subir.cmd (
    echo @echo off
    echo setlocal EnableDelayedExpansion
    echo chcp 65001 ^>nul 2^>nul
    echo.
    echo cd /d "%%~dp0"
    echo.
    echo echo.
    echo echo   ============================================
    echo echo    Subir - Push a GitHub
    echo echo   ============================================
    echo echo.
    echo.
    echo if not exist ".git" ^(
    echo     echo   [X] No hay repositorio Git. Ejecuta: init.cmd
    echo     call :pause_if_double_click
    echo     exit /b 1
    echo ^)
    echo.
    echo git diff --cached --quiet
    echo set "STAGED=!ERRORLEVEL!"
    echo git diff --quiet
    echo set "UNSTAGED=!ERRORLEVEL!"
    echo.
    echo if !STAGED! NEQ 0 goto :has_changes
    echo if !UNSTAGED! NEQ 0 goto :has_changes
    echo goto :check_remote
    echo.
    echo :has_changes
    echo echo   Hay cambios sin commitear.
    echo echo.
    echo set "SAVE="
    echo set /p "SAVE=  Guardar cambios primero? [S/n]: "
    echo if /i "!SAVE!"=="n" goto :check_remote
    echo echo.
    echo call "guardar.cmd"
    echo echo.
    echo.
    echo :check_remote
    echo git remote get-url origin ^>nul 2^>nul
    echo if errorlevel 1 ^(
    echo     echo   [X] No hay remote 'origin' configurado.
    echo     echo.
    echo     echo   Para vincular tu repo a GitHub:
    echo     echo.
    echo     echo     git remote add origin https://github.com/TU-USUARIO/TU-REPO.git
    echo     echo.
    echo     call :pause_if_double_click
    echo     exit /b 1
    echo ^)
    echo.
    echo echo   Subiendo a GitHub...
    echo echo.
    echo.
    echo git push -u origin main
    echo set "RC=!ERRORLEVEL!"
    echo.
    echo echo.
    echo if !RC! EQU 0 ^(
    echo     echo   [OK] Push completado
    echo ^) else ^(
    echo     echo   [ERROR] Push fallo con codigo !RC!
    echo ^)
    echo echo.
    echo.
    echo call :pause_if_double_click
    echo endlocal
    echo exit /b 0
    echo.
    echo :pause_if_double_click
    echo echo %%cmdcmdline%% ^| find /i "%%~nx0" ^>nul
    echo if not errorlevel 1 ^(
    echo     echo   Presiona cualquier tecla para cerrar...
    echo     pause ^>nul
    echo ^)
    echo goto :eof
)
endlocal
goto :eof

REM ============================================================
REM   write_respaldar - snapshot en versiones/
REM ============================================================
:write_respaldar
setlocal DisableDelayedExpansion
> respaldar.cmd (
    echo @echo off
    echo setlocal EnableDelayedExpansion
    echo chcp 65001 ^>nul 2^>nul
    echo.
    echo cd /d "%%~dp0"
    echo.
    echo for /f %%%%i in ^('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HHmmss"'^) do set "TS=%%%%i"
    echo.
    echo echo.
    echo echo   ============================================
    echo echo    Respaldar - Snapshot del proyecto
    echo echo   ============================================
    echo echo.
    echo.
    echo set "INPUT="
    echo set /p "INPUT=  Nombre del snapshot [Enter = noDefined]: "
    echo if "!INPUT!"=="" set "INPUT=noDefined"
    echo.
    echo set "BASENAME=!TS!_!INPUT!"
    echo set "DEST=versiones\!BASENAME!"
    echo.
    echo if not exist "versiones" mkdir "versiones"
    echo if not exist "!DEST!" mkdir "!DEST!"
    echo.
    echo echo   Copiando archivos...
    echo robocopy "." "!DEST!" /E /XD .git versiones old_versions backup backups node_modules __pycache__ venv .venv env dist build out cache .cache .parcel-cache .vite .vscode .idea /XF *.log *.tmp *.bak *.orig Thumbs.db .DS_Store /NFL /NDL /NJH /NJS /NC /NS /NP ^>nul
    echo set "RC=!ERRORLEVEL!"
    echo.
    echo echo.
    echo echo   ============================================
    echo echo    Snapshot creado:
    echo echo    versiones\!BASENAME!\
    echo echo   ============================================
    echo echo.
    echo.
    echo if !RC! GEQ 8 ^(
    echo     echo   [WARN] Robocopy termino con codigo !RC!
    echo     echo.
    echo ^)
    echo.
    echo echo   Contenido:
    echo dir /b "!DEST!"
    echo echo.
    echo.
    echo call :pause_if_double_click
    echo endlocal
    echo exit /b 0
    echo.
    echo :pause_if_double_click
    echo echo %%cmdcmdline%% ^| find /i "%%~nx0" ^>nul
    echo if not errorlevel 1 ^(
    echo     echo   Presiona cualquier tecla para cerrar...
    echo     pause ^>nul
    echo ^)
    echo goto :eof
)
endlocal
goto :eof

REM ============================================================
REM   write_historial - ver commits, tags, snapshots
REM ============================================================
:write_historial
setlocal DisableDelayedExpansion
> historial.cmd (
    echo @echo off
    echo setlocal EnableDelayedExpansion
    echo chcp 65001 ^>nul 2^>nul
    echo.
    echo cd /d "%%~dp0"
    echo.
    echo echo.
    echo echo   ============================================
    echo echo    Historial de versiones
    echo echo   ============================================
    echo echo.
    echo.
    echo if exist ".git" ^(
    echo     echo   [ COMMITS ]
    echo     echo.
    echo     git log --oneline --decorate --graph --all
    echo     echo.
    echo ^) else ^(
    echo     echo   [ COMMITS ] Sin repositorio Git
    echo     echo.
    echo ^)
    echo.
    echo echo   [ TAGS ]
    echo echo.
    echo if exist ".git" ^(
    echo     git tag -l
    echo ^) else ^(
    echo     echo   [vacio]
    echo ^)
    echo echo.
    echo.
    echo echo   [ SNAPSHOTS ]
    echo echo.
    echo if exist "versiones" ^(
    echo     dir /b /o-n "versiones"
    echo ^) else ^(
    echo     echo   [vacio]
    echo ^)
    echo echo.
    echo.
    echo echo   ============================================
    echo echo.
    echo.
    echo call :pause_if_double_click
    echo endlocal
    echo exit /b 0
    echo.
    echo :pause_if_double_click
    echo echo %%cmdcmdline%% ^| find /i "%%~nx0" ^>nul
    echo if not errorlevel 1 ^(
    echo     echo   Presiona cualquier tecla para cerrar...
    echo     pause ^>nul
    echo ^)
    echo goto :eof
)
endlocal
goto :eof