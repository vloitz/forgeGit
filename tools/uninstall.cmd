@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

cd /d "%~dp0"

echo.
echo   ============================================
echo    forgeGit - Desinstalación (MODO SEGURO)
echo   ============================================
echo.

for %%I in ("%~dp0..") do set "FORGE_HOME=%%~fI"
set "BIN=%FORGE_HOME%\tools\bin"

REM --- Backup ---
if not exist "backups" mkdir "backups"
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HHmmss"') do set "TS=%%i"
set "BACKUP=%CD%\backups\PATH_backup_%TS%.txt"

echo   [1/2] Backup del PATH actual...
powershell -NoProfile -Command ^
    "$old = [Environment]::GetEnvironmentVariable('Path', 'User');" ^
    "if ($null -eq $old) { $old = '' };" ^
    "[System.IO.File]::WriteAllText('%BACKUP%', $old, [System.Text.UTF8Encoding]::new($false));" ^
    "Write-Host '  [OK] Backup: %BACKUP%';"
echo.

echo   [2/2] Quitando forgeGit del PATH...
powershell -NoProfile -Command ^
    "$old = [Environment]::GetEnvironmentVariable('Path', 'User');" ^
    "if ($null -eq $old) { $old = '' };" ^
    "$parts = $old -split ';' | Where-Object { $_ -ne '%BIN%' -and $_ -ne '' };" ^
    "$new = $parts -join ';';" ^
    "$oldCount = ($old -split ';' | Where-Object { $_ -ne '' }).Count;" ^
    "$newCount = ($new -split ';' | Where-Object { $_ -ne '' }).Count;" ^
    "if ($newCount -eq ($oldCount - 1)) {" ^
    "    setx PATH $new >nul;" ^
    "    Write-Host '  [OK] Removido.';" ^
    "} elseif ($newCount -eq $oldCount) {" ^
    "    Write-Host '  [!] No estaba en el PATH.';" ^
    "} else {" ^
    "    Write-Host '  [X] Validacion fallo. Sin cambios.';" ^
    "    exit 1;" ^
    "}"

echo.
echo   Backup guardado en: %BACKUP%
echo.
echo   Cierra la terminal para aplicar.
echo.
pause
endlocal
exit /b 0