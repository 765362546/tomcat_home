@echo off
setlocal 
echo "���tomcat��־�ͻ���"
set CUR_DIR=%~dp0
for /d %%i in (*tomcat*) do (
ECHO ���� %CUR_DIR%%%i
del /q %CUR_DIR%%%i\logs\*
rd /s/q %CUR_DIR%%%i\work\Catalina\localhost\
del /q %CUR_DIR%%%i\conf\Catalina\localhost\*
)
