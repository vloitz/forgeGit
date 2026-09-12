@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

REM ============================================================
REM   forge-git / init.cmd
REM   Universal idempotent project bootstrap
REM
REM   Version: 1.1.0
REM   Usage:   init.cmd
REM
REM   What it does:
REM     1. Verifies Node.js
REM     2. Verifies Git
REM     3. Initializes git repository (if not present)
REM     4. Sets main as primary branch
REM     5. Creates universal .gitignore (if not present)
REM     6. Creates adaptive README.md (if not present)
REM     7. Creates initial commit (if changes exist)
REM     8. Creates tag v1.0.0 (if not present)
REM     9. Creates universal subir.cmd (if not present)
REM
REM   Safe to run multiple times. Idempotent.
REM ============================================================

REM ---------------- CONFIG ----------------
set "FG_VERSION=1.1.0"
set "TAG_INITIAL=v1.0.0"
set "TAG_MESSAGE=Primera version estable"
set "BRANCH_MAIN=main"
set "COMMIT_MESSAGE=chore: initial commit"
REM ----------------------------------------

cd /d "%~dp0"
cls

set "PROJECT_NAME=%CD%"
for %%a in ("%CD%") do set "PROJECT_NAME=%%~nxa"

echo.
echo   ############################################
echo   #  forge-git v!FG_VERSION!                      #
echo   #  Bootstrap universal de proyecto         #
echo   ############################################
echo.
echo   Proyecto: !PROJECT_NAME!
echo   Ruta:     %CD%
echo.

REM --- [1/9] Node.js ---
where node >nul 2>nul
if errorlevel 1 (
    echo   [X] Node.js no encontrado.
    echo       Descargalo desde: https://nodejs.org/
    goto :abort
)
for /f "tokens=*" %%v in ('node --version 2^>nul') do set "NODE_VER=%%v"
echo   [1/9] Node.js !NODE_VER!                  OK

REM --- [2/9] Git ---
where git >nul 2>nul
if errorlevel 1 (
    echo   [X] Git no encontrado.
    echo       Descargalo desde: https://git-scm.com/download/win
    goto :abort
)
for /f "tokens=*" %%v in ('git --version 2^>nul') do set "GIT_VER=%%v"
echo   [2/9] !GIT_VER!           OK

REM --- [3/9] Git init ---
if exist ".git" (
    echo   [3/9] Repositorio Git                    YA EXISTE
) else (
    git init -q
    if errorlevel 1 (
        echo   [X] Fallo al inicializar Git
        goto :abort
    )
    echo   [3/9] Repositorio Git                    CREADO
)

REM --- [4/9] Rama main ---
git branch -M !BRANCH_MAIN! >nul 2>nul
echo   [4/9] Rama principal: !BRANCH_MAIN!            OK

REM --- [5/9] .gitignore ---
if exist ".gitignore" (
    echo   [5/9] .gitignore                         YA EXISTE
) else (
    call :write_gitignore
    echo   [5/9] .gitignore universal               CREADO
)

REM --- [6/9] README.md ---
if exist "README.md" (
    echo   [6/9] README.md                          YA EXISTE
) else (
    call :write_readme
    echo   [6/9] README.md adaptativo               CREADO
)

REM --- [7/9] Commit inicial ---
git add -A >nul 2>nul
git diff --cached --quiet
if errorlevel 1 (
    git commit -q -m "!COMMIT_MESSAGE!"
    echo   [7/9] Commit inicial                     CREADO
) else (
    echo   [7/9] Sin cambios para commit            SKIP
)

REM --- [8/9] Tag v1.0.0 ---
git rev-parse !TAG_INITIAL! >nul 2>nul
if errorlevel 1 (
    git rev-parse HEAD >nul 2>nul
    if not errorlevel 1 (
        git tag -a !TAG_INITIAL! -m "!TAG_MESSAGE!" 2>nul
        echo   [8/9] Tag !TAG_INITIAL!                     CREADO
    ) else (
        echo   [8/9] Sin commits para tag             SKIP
    )
) else (
    echo   [8/9] Tag !TAG_INITIAL!                     YA EXISTE
)

REM --- [9/9] subir.cmd ---
if exist "subir.cmd" (
    echo   [9/9] subir.cmd                          YA EXISTE
) else (
    call :write_subir
    echo   [9/9] subir.cmd universal                CREADO
)

echo.
echo   ############################################
echo   #  Bootstrap completado                     #
echo   ############################################
echo.
echo   Siguiente:
echo     subir.cmd   Crear backup del proyecto
echo.
endlocal
exit /b 0

:abort
echo.
echo   Bootstrap abortado. Instala los requisitos y vuelve a intentar.
pause
endlocal
exit /b 1

REM ============================================================
REM   :write_gitignore
REM   Universal .gitignore cubriendo todos los stacks comunes
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
    echo .sublime-project
    echo .sublime-workspace
    echo.
    echo # ==== Node.js ====
    echo node_modules/
    echo npm-debug.log*
    echo yarn-debug.log*
    echo yarn-error.log*
    echo pnpm-debug.log*
    echo .npm
    echo .yarn/
    echo .pnp.*
    echo package-lock.json
    echo yarn.lock
    echo pnpm-lock.yaml
    echo.
    echo # ==== Python ====
    echo __pycache__/
    echo *.py[cod]
    echo *$py.class
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
REM   :write_readme
REM   README adaptativo segun archivos presentes en el proyecto
REM ============================================================
:write_readme
set "STACK_WRITTEN="

> README.md (
    echo # !PROJECT_NAME!
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

for %%f in (*.*) do (
    if /I not "%%f"=="init.cmd" if /I not "%%f"=="subir.cmd" (
        >> README.md echo - `%%f`
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
    echo Generado por forge-git v!FG_VERSION!
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
REM   :write_subir
REM   subir.cmd universal con robocopy
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
    echo REM --- Timestamp portable ---
    echo for /f %%%%i in ^('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HHmmss"'^) do set "TS=%%%%i"
    echo.
    echo REM --- Banner ---
    echo echo.
    echo echo   ============================================
    echo echo    Subir - Backup del proyecto
    echo echo   ============================================
    echo echo.
    echo.
    echo REM --- Pedir nombre ---
    echo set "INPUT="
    echo set /p "INPUT=  Nombre de la mejora [Enter = noDefined]: "
    echo if "!INPUT!"=="" set "INPUT=noDefined"
    echo.
    echo REM --- Componer nombre ---
    echo set "BASENAME=!TS!_!INPUT!"
    echo set "DEST=versiones\!BASENAME!"
    echo.
    echo REM --- Crear carpeta destino ---
    echo if not exist "versiones" mkdir "versiones"
    echo if not exist "!DEST!" mkdir "!DEST!"
    echo.
    echo REM --- Copiar todo excepto exclusiones ---
    echo echo   Copiando archivos...
    echo robocopy "." "!DEST!" /E /XD .git versiones old_versions backup backups node_modules __pycache__ venv .venv env dist build out cache .cache .parcel-cache .vite .vscode .idea /XF *.log *.tmp *.bak *.orig Thumbs.db .DS_Store /NFL /NDL /NJH /NJS /NC /NS /NP ^>nul
    echo set "RC=%%ERRORLEVEL%%"
    echo.
    echo REM --- Reportar ---
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
    echo REM --- Contenido del backup ---
    echo echo   Contenido:
    echo dir /b "!DEST!"
    echo echo.
    echo pause
    echo endlocal
)
endlocal
goto :eof