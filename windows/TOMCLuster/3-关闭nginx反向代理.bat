@echo off
setlocal 
set CUR_DIR=%~dp0
cd %CUR_DIR%\nginx
nginx.exe -s stop