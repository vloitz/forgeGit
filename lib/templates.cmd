@echo off
REM ============================================================
REM   forge-git / lib/templates.cmd
REM   File writers - .gitignore, README.md, subir.cmd
REM
REM   Usage:
REM     call "templates.cmd" write_gitignore
REM     call "templates.cmd" write_readme
REM     call "templates.cmd" write_subir
REM ============================================================

if "%~1"=="write_gitignore" goto :write_gitignore
if "%~1"=="write_readme"    goto :write_readme
if "%~1"=="write_subir"     goto :write_subir
goto :eof

REM ============================================================
REM   write_gitignore - universal
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
REM   write_readme - adaptive (detects stack)
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
    echo ## Uso
    echo.
    echo ```
    echo subir.cmd    Crear backup con nombre
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
REM   write_subir - universal backup script
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
    echo for /f %%%%i in ^('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HHmmss"'^) do set "TS=%%%%i"
    echo.
    echo echo.
    echo echo   ============================================
    echo echo    Subir - Backup del proyecto
    echo echo   ============================================
    echo echo.
    echo.
    echo set "INPUT="
    echo set /p "INPUT=  Nombre de la mejora [Enter = noDefined]: "
    echo if "!INPUT!"=="" set "INPUT=noDefined"
    echo.
    echo set "BASENAME=!TS!_!INPUT!"
    echo set "DEST=versiones\!BASENAME!"
    echo.
    echo if not exist "versiones" mkdir "versiones"
    echo if not exist "!DEST!" mkdir "!DEST!"
    echo.
    echo echo   Copiando archivos...
    echo robocopy "." "!DEST!" /E /XD %EXCLUDE_DIRS% /XF %EXCLUDE_FILES% /NFL /NDL /NJH /NJS /NC /NS /NP ^>nul
    echo set "RC=%%ERRORLEVEL%%"
    echo.
    echo echo.
    echo echo   ============================================
    echo echo    Backup creado:
    echo echo    versiones\!BASENAME!\
    echo echo   ============================================
    echo echo.
    echo if %%RC%% GEQ 8 (
    echo     echo   [WARN] Robocopy termino con codigo %%RC%%
    echo     echo.
    echo )
    echo.
    echo echo   Contenido:
    echo dir /b "!DEST!"
    echo echo.
    echo pause
    echo endlocal
)
endlocal
goto :eof