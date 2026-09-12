@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>nul

cd /d "%~dp0"

echo.
echo   ============================================
echo    Pack - Distribucion limpia
echo   ============================================
echo.
echo   Empaqueta solo los archivos necesarios para
echo   que otros usuarios usen forgeGit.
echo.
echo   Excluye: .git, .vscode, versiones, audits,
echo            y todos los helpers generados.
echo.

REM --- ROOT = un nivel arriba de tools/ (forgeGit/) ---
set "ROOT=%~dp0.."
set "OUT=%~dp0..\..\forgeGit-dist"

REM --- Limpiar destino previo ---
if exist "%OUT%" (
    echo   Limpiando distribucion anterior...
    rmdir /s /q "%OUT%"
)

mkdir "%OUT%"
mkdir "%OUT%\lib"
mkdir "%OUT%\templates"

echo   Copiando archivos core...
copy /Y "%ROOT%\init.cmd"   "%OUT%\" >nul
copy /Y "%ROOT%\config.cmd" "%OUT%\" >nul

echo   Copiando modulos internos...
copy /Y "%ROOT%\lib\ui.cmd"        "%OUT%\lib\" >nul
copy /Y "%ROOT%\lib\git-ops.cmd"   "%OUT%\lib\" >nul
copy /Y "%ROOT%\lib\templates.cmd" "%OUT%\lib\" >nul

echo   Copiando templates...
for %%F in ("%ROOT%\templates\*.tpl") do (
    copy /Y "%%F" "%OUT%\templates\" >nul
)

echo.
echo   ============================================
echo    Distribucion creada:
echo    %OUT%\
echo   ============================================
echo.
echo   Contenido:
echo.
dir /b /s "%OUT%"
echo.

endlocal
exit /b 0