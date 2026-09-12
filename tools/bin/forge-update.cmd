@echo off
setlocal
chcp 65001 >nul 2>nul

call "%~dp0forge.cmd" update
endlocal
exit /b 0