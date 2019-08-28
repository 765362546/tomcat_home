@echo off
setlocal 
set CUR_DIR=%~dp0
cd %CUR_DIR%\nginx
nginx -t 
rem pause
start " " nginx.exe