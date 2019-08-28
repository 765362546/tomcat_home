@echo off
setlocal 
set CUR_DIR=%~dp0
set JRE_HOME=%CUR_DIR%\jre_win
set CATALINA_HOME=%CUR_DIR%\tomcat
set JAVA_OPTS=%JAVA_OPTS% -server -Xms256m -Xmx256m
rem pause
for /d %%i in (node*) do (
set CATALINA_BASE=%CUR_DIR%\%%i
echo stop %%i
call %CATALINA_HOME%\bin\shutdown.bat
rem  pause
)