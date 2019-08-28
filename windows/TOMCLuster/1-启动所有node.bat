@echo off
setlocal 
set CUR_DIR=%~dp0
set JRE_HOME=%CUR_DIR%\jre_win
set CATALINA_HOME=%CUR_DIR%\tomcat
set JAVA_OPTS=%JAVA_OPTS% -server -Xms1g -Xmx1g -Xss1m -XX:MaxDirectMemorySize=2g
set JAVA_OPTS=%JAVA_OPTS% -XX:PermSize=256m -XX:MaxPermSize=512m
set JAVA_OPTS=%JAVA_OPTS% -XX:+AggressiveOpts -XX:+UseBiasedLocking 
set JAVA_OPTS=%JAVA_OPTS% -XX:+DisableExplicitGC -XX:MaxTenuringThreshold=31 
set JAVA_OPTS=%JAVA_OPTS% -XX:+UseConcMarkSweepGC -XX:+UseParNewGC  
set JAVA_OPTS=%JAVA_OPTS% -XX:+CMSParallelRemarkEnabled -XX:+UseCMSCompactAtFullCollection 
set JAVA_OPTS=%JAVA_OPTS% -XX:LargePageSizeInBytes=256m  -XX:+UseFastAccessorMethods 
set JAVA_OPTS=%JAVA_OPTS% -XX:+UseCMSInitiatingOccupancyOnly -Djava.awt.headless=true
rem pause
for /d %%i in (node*) do (
set CATALINA_BASE=%CUR_DIR%\%%i
echo start %%i
call %CATALINA_HOME%\bin\startup.bat
rem pause
)