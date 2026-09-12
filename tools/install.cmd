@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

cd /d "%~dp0"

echo.
echo   ============================================
echo    forgeGit - Instalación (MODO SEGURO)
echo   ============================================
echo.

for %%I in ("%~dp0..") do set "FORGE_HOME=%%~fI"
set "BIN=%FORGE_HOME%\tools\bin"

REM --- Verificar bin\forge.cmd ---
if not exist "%BIN%\forge.cmd" (
    echo   [X] No se encontro: %BIN%\forge.cmd
    pause
    exit /b 1
)

REM --- 1. Backup del PATH ---
if not exist "backups" mkdir "backups"
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HHmmss"') do set "TS=%%i"
set "BACKUP=%CD%\backups\PATH_backup_%TS%.txt"

echo   [1/6] Backup del PATH de usuario...
powershell -NoProfile -Command ^
    "$old = [Environment]::GetEnvironmentVariable('Path', 'User');" ^
    "if ($null -eq $old) { $old = '' };" ^
    "[System.IO.File]::WriteAllText('%BACKUP%', $old, [System.Text.UTF8Encoding]::new($false));" ^
    "Write-Host '  [OK] Backup guardado.';" ^
    "Write-Host ('  Tamano: ' + $old.Length + ' caracteres');"
echo.

REM --- 2. Verificar que no este ya ---
powershell -NoProfile -Command ^
    "$old = [Environment]::GetEnvironmentVariable('Path', 'User');" ^
    "if ($null -eq $old) { $old = '' };" ^
    "if ($old -like '*%BIN%*') { exit 0 } else { exit 1 }"

if not errorlevel 1 (
    echo   [2/6] Ya estaba instalado. Nada que hacer.
    pause
    exit /b 0
)
echo   [2/6] No estaba en el PATH. Continuando...
echo.

REM --- 3. Preview de los cambios ---
echo   [3/6] Vista previa del cambio:
echo.
echo     PATH actual:
powershell -NoProfile -Command ^
    "$old = [Environment]::GetEnvironmentVariable('Path', 'User');" ^
    "if ($null -eq $old) { $old = '' };" ^
    "$parts = $old -split ';' | Where-Object { $_ -ne '' };" ^
    "Write-Host ('    ' + $parts.Count + ' entradas');"
echo.
echo     Se agregara:
echo       %BIN%
echo.
set "CONFIRM="
set /p "CONFIRM=  Continuar? [S/n]: "
if /i "!CONFIRM!"=="n" (
    echo   Cancelado.
    pause
    exit /b 0
)
echo.

REM --- 4. Aplicar cambio con API (sin setx - sin limite 1024) ---
echo   [4/6] Aplicando cambio...
powershell -NoProfile -Command ^
    "$old = [Environment]::GetEnvironmentVariable('Path', 'User');" ^
    "if ($null -eq $old) { $old = '' };" ^
    "$new = if ($old -eq '') { '%BIN%' } else { $old + ';%BIN%' };" ^
    "$oldCount = ($old -split ';' | Where-Object { $_ -ne '' }).Count;" ^
    "$newCount = ($new -split ';' | Where-Object { $_ -ne '' }).Count;" ^
    "if ($newCount -ne ($oldCount + 1)) {" ^
    "    Write-Host '  [X] Validacion fallo (count no cambio).';" ^
    "    exit 1;" ^
    "}" ^
    "[Environment]::SetEnvironmentVariable('Path', $new, 'User');" ^
    "Write-Host '  [OK] PATH actualizado.';"

if errorlevel 1 (
    echo   [X] Fallo. Restaurando backup...
    powershell -NoProfile -Command ^
        "$content = [System.IO.File]::ReadAllText('%BACKUP%');" ^
        "[Environment]::SetEnvironmentVariable('Path', $content, 'User');" ^
        "Write-Host '  [OK] Restaurado.';"
    pause
    exit /b 1
)
echo.

REM --- 5. Verificar el cambio ---
echo   [5/6] Verificando...
timeout /t 1 /nobreak >nul
powershell -NoProfile -Command ^
    "$new = [Environment]::GetEnvironmentVariable('Path', 'User');" ^
    "if ($new -like '*%BIN%*') {" ^
    "    Write-Host '  [OK] forgeGit esta en el PATH.';" ^
    "} else {" ^
    "    Write-Host '  [X] No aparece. Restaurando...';" ^
    "    $content = [System.IO.File]::ReadAllText('%BACKUP%');" ^
    "    [Environment]::SetEnvironmentVariable('Path', $content, 'User');" ^
    "    Write-Host '  [OK] Restaurado.';" ^
    "    exit 1;" ^
    "}"

if errorlevel 1 (
    pause
    exit /b 1
)
echo.

REM --- 6. Instrucciones ---
echo   [6/6] Instalacion completada
echo.
echo   ============================================
echo    Instalación exitosa
echo   ============================================
echo.
echo   Cierra esta ventana y abre una NUEVA terminal.
echo.
echo   Uso:
echo     cd C:\MiProyecto
echo     forge
echo.
echo   Restaurar PATH anterior:
echo     tools\restore.cmd
echo.
echo   Backup: %BACKUP%
echo.

pause
endlocal
exit /b 0