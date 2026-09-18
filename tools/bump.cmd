@echo off
setlocal
chcp 65001 >nul 2>nul

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0bump.ps1" %*
exit /b %ERRORLEVEL%