@echo off
setlocal
set CUR_DIR=%~dp0
echo %CUR_DIR%
rem 通过杀进程的方式关闭tomcat，虽然用tomcat下的shutdown.bat更温和，但是有的时候会关不掉
rem 通过tasklist筛选出包含当前目录的进程的pid，当目录太长时，有可能取不到，因为tasklist里只显示一部分，可以手动修改下面的命令，直到能匹配上当前的java进程
tasklist /v |findstr /i %CUR_DIR% |findstr /i java.exe > closetomcat.txt
for /f "tokens=2 delims= " %%i in (closetomcat.txt) do (tskill  %%i)
del /s /q closetomcat.txt
exit
