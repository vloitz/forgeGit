@echo off
REM ============================================================
REM   forge-git / lib/templates.cmd
REM   Copies templates from templates/ to project root
REM ============================================================

if "%~1"=="write_gitignore" goto :write_gitignore
if "%~1"=="write_readme"    goto :write_readme
if "%~1"=="write_guardar"   goto :write_guardar
if "%~1"=="write_subir"     goto :write_subir
if "%~1"=="write_respaldar" goto :write_respaldar
if "%~1"=="write_historial" goto :write_historial
goto :eof

:write_gitignore
call :copy_template "gitignore.tpl" ".gitignore"
goto :eof

:write_guardar
call :copy_template "guardar.cmd.tpl" "guardar.cmd"
goto :eof

:write_subir
call :copy_template "subir.cmd.tpl" "subir.cmd"
goto :eof

:write_respaldar
call :copy_template "respaldar.cmd.tpl" "respaldar.cmd"
goto :eof

:write_historial
call :copy_template "historial.cmd.tpl" "historial.cmd"
goto :eof

:write_readme
call :apply_template "readme.md.tpl" "README.md"
goto :eof

REM ============================================================
REM   :copy_template
REM   Copies templates/<file> to project root/<dest>
REM ============================================================
:copy_template
set "SRC=%~dp0..\templates\%~1"
set "DST=%~dp0..\%~2"
if not exist "%SRC%" (
    echo   [X] Template no encontrado: %SRC%
    exit /b 1
)
copy /Y "%SRC%" "%DST%" >nul
exit /b 0

REM ============================================================
REM   :apply_template
REM   Copies with {{PLACEHOLDER}} substitution
REM ============================================================
:apply_template
set "SRC=%~dp0..\templates\%~1"
set "DST=%~dp0..\%~2"
if not exist "%SRC%" (
    echo   [X] Template no encontrado: %SRC%
    exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$c = Get-Content -Raw -LiteralPath '%SRC%';" ^
  "$c = $c.Replace('{{PROJECT_NAME}}', '%PROJECT_NAME%');" ^
  "$c = $c.Replace('{{FG_VERSION}}', '%FG_VERSION%');" ^
  "[System.IO.File]::WriteAllText('%DST%', $c, [System.Text.UTF8Encoding]::new($false))"
exit /b 0