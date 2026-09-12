@echo off
REM ============================================================
REM   forge-git / lib/git-ops.cmd
REM   Git operations
REM
REM   Usage:
REM     call "git-ops.cmd" init           - init repo
REM     call "git-ops.cmd" branch_main    - rename branch to main
REM     call "git-ops.cmd" has_changes    - check for pending changes
REM     call "git-ops.cmd" commit "msg"   - commit with message
REM     call "git-ops.cmd" tag            - create tag
REM
REM   Return codes:
REM     0 = nothing to do (already exists / no changes)
REM     1 = action performed
REM ============================================================

if "%~1"=="init"        goto :init
if "%~1"=="branch_main" goto :branch_main
if "%~1"=="has_changes" goto :has_changes
if "%~1"=="commit"      goto :commit
if "%~1"=="tag"         goto :tag
goto :eof

:init
if exist ".git" (
    call "%~dp0ui.cmd" step 3/12 "Repositorio Git" "YA EXISTE"
    exit /b 0
)
git init -q
if errorlevel 1 (
    call "%~dp0ui.cmd" step 3/12 "Repositorio Git" "ERROR"
    exit /b 1
)
call "%~dp0ui.cmd" step 3/12 "Repositorio Git" "CREADO"
exit /b 1

:branch_main
git branch -M %BRANCH_MAIN% >nul 2>nul
call "%~dp0ui.cmd" step 4/12 "Rama principal: %BRANCH_MAIN%" "OK"
exit /b 0

:has_changes
git add -A >nul 2>nul
git diff --cached --quiet
if errorlevel 1 (
    exit /b 1
) else (
    exit /b 0
)

:commit
REM %~2 = mensaje opcional
set "MSG=%~2"
if "!MSG!"=="" set "MSG=%COMMIT_MESSAGE%"
git commit -q -m "!MSG!"
exit /b 1

:tag
git rev-parse %TAG_INITIAL% >nul 2>nul
if not errorlevel 1 (
    exit /b 0
)
git rev-parse HEAD >nul 2>nul
if errorlevel 1 (
    exit /b 0
)
git tag -a %TAG_INITIAL% -m "%TAG_MESSAGE%" 2>nul
exit /b 1