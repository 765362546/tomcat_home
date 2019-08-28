@echo off
setlocal
set CUR_DIR=%~dp0
set JRE_HOME=%CUR_DIR%\jre7_win
set CATALINA_HOME=%CUR_DIR%\apache-tomcat-7.0.0
set TITLE=%CATALINA_HOME%
 
rem 0 测试环境  1 开发环境 
set dev=0

REM 设置生产环境java运行参数，请根据实际运行环境设置
REM 设置jvm内存大小，Xmx、Xms设置为同一个值，Xss不需要修改，MaxDirectMemorySize根据实际内存设置。
set MY_OPTS=-Xms1g -Xmx1g -Xss1m -XX:MaxDirectMemorySize=1g
set MY_OPTS=%MY_OPTS% -XX:PermSize=128m -XX:MaxPermSize=256m
REM 其他 
set MY_OPTS=%MY_OPTS% -XX:+AggressiveOpts -XX:+UseBiasedLocking 
set MY_OPTS=%MY_OPTS% -XX:MaxTenuringThreshold=31 
set MY_OPTS=%MY_OPTS% -XX:+UseConcMarkSweepGC -XX:+UseParNewGC  
set MY_OPTS=%MY_OPTS% -XX:+CMSParallelRemarkEnabled -XX:+UseCMSCompactAtFullCollection 
set MY_OPTS=%MY_OPTS% -XX:+UseFastAccessorMethods 
set MY_OPTS=%MY_OPTS% -XX:+UseCMSInitiatingOccupancyOnly -Djava.awt.headless=true

if "%dev%"=="1" set JAVA_OPTS=%MY_OPTS%

call %CATALINA_HOME%\bin\startup.bat
exit