@echo off
REM ============================================================
REM   forge-git / lib/ui.cmd
REM   UI helpers - banner and status messages
REM
REM   Usage:
REM     call "ui.cmd" banner
REM     call "ui.cmd" step 1/12 "Node.js v20" "OK"
REM     call "ui.cmd" done
REM     call "ui.cmd" abort
REM ============================================================

if "%~1"=="banner" goto :banner
if "%~1"=="step"   goto :step
if "%~1"=="done"   goto :done
if "%~1"=="abort"  goto :abort
goto :eof

:banner
echo.
echo   ############################################
echo   #  forge-git v%FG_VERSION%                        #
echo   #  Bootstrap universal de proyecto         #
echo   ############################################
echo.
echo   Proyecto: %PROJECT_NAME%
echo   Ruta:     %CD%
echo.
goto :eof

:step
REM %2 = step id (1/12), %3 = label, %4 = status
echo   [%~2] %~3    %~4
goto :eof

:done
echo.
echo   ############################################
echo   #  Bootstrap completado                     #
echo   ############################################
echo.
echo   Comandos disponibles:
echo.
echo     Esenciales:
echo       init.cmd        Bootstrap
echo       abrir.cmd       Abrir en VS Code
echo.
echo     Trabajo diario:
echo       guardar.cmd     Commit de cambios
echo       subir.cmd       Push a GitHub
echo       historial.cmd   Ver commits recientes
echo.
echo     Ocasionales:
echo       snapshots.cmd   Crear/restaurar copias
echo       auditar.cmd     Generar reporte diff
echo.
goto :eof

:abort
echo.
echo   Bootstrap abortado. Instala los requisitos y vuelve a intentar.
pause
goto :eof