@echo off
setlocal 
echo "清除tomcat日志和缓存"
set CUR_DIR=%~dp0
for /d %%i in (*tomcat*) do (
ECHO 清理 %CUR_DIR%%%i
del /q %CUR_DIR%%%i\logs\*
rd /s/q %CUR_DIR%%%i\work\Catalina\localhost\
del /q %CUR_DIR%%%i\conf\Catalina\localhost\*
)
