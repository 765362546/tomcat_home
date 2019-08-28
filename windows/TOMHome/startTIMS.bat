@echo off
setlocal
rem 清空默认的环境变量，防止产生干扰
set PATH=
SET JAVA_HOME=
SET JRE_HOME=
set CATALINA_HOME=
set CATALINA_BASE=

set CUR_DIR=%~dp0
set JAVA_HOME=%CUR_DIR%\jdk
rem set JRE_HOME=%CUR_DIR%\jre
set CATALINA_HOME=%CUR_DIR%\apache-tomcat-xx

set TITLE=%CATALINA_HOME%
 
rem 0 测试环境  1 开发环境     配置为1时，下面的JVM参数会生效，注意根据实际情况修改这些参数
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
