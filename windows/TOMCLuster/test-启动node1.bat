@echo off
setlocal 
set CUR_DIR=%~dp0
set JRE_HOME=%CUR_DIR%\jre_win
set CATALINA_HOME=%CUR_DIR%\tomcat
set JAVA_OPTS=%JAVA_OPTS% -server -Xms256m -Xmx256m


set CATALINA_BASE=%CUR_DIR%\node1


call %CATALINA_HOME%\bin\startup.bat
rem pause