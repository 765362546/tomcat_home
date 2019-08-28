@echo off
@echo off
setlocal
set CUR_DIR=%~dp0
echo %CUR_DIR%
tasklist /v |findstr /i %CUR_DIR% |findstr /i java.exe > closetomcat.txt
for /f "tokens=2 delims= " %%i in (closetomcat.txt) do (tskill  %%i)
del /s /q closetomcat.txt
exit