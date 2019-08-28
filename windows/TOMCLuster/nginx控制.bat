@echo off  
rem nginx管理程序 
color 8b   
TITLE Nginx 管理程序
setlocal enableextensions
cd /d %~dp0  
for /d %%d in (*) do (
 if exist %%d\nginx.exe   SET NGINX_DIR=%%d 
)   
if "%NGINX_DIR%"=="" echo Nginx does not exist. & pause & exit
cd %NGINX_DIR% 
:MENU
CLS
ECHO.
echo 当前Nginx目录为%cd%
echo.
ECHO Nginx 进程列表   
echo ++++++++++++++++++++++++++++
tasklist|findstr /i "nginx.exe" 
if ERRORLEVEL 1 (echo nginx进程不存在) 
echo ++++++++++++++++++++++++++++ 
echo.
echo.

echo       选项
echo -----------------------------
echo [1] 启动Nginx
echo [2] 关闭Nginx
echo [3] 重启Nginx 
echo [4^|q] 退 出 
echo -----------------------------
ECHO.   
  
ECHO.请输入选择项目的序号:  
set /p ID=  
    IF "%id%"=="1" GOTO start   
    IF "%id%"=="2" GOTO stop   
    IF "%id%"=="3" GOTO restart   
    IF "%id%"=="4" EXIT 
	IF "%id%"=="q" EXIT 
	IF not "%id%"=="q" goto menu
PAUSE   
  
:start   
    call :startNginx  
    GOTO MENU  
  
:stop   
    call :shutdownNginx  
    GOTO MENU  
  
:restart   
    call :shutdownNginx  
    call :startNginx  
    GOTO MENU  
  
:shutdownNginx  
    ECHO.   
    ECHO.关闭Nginx......   
    taskkill /F /IM nginx.exe > nul  && ECHO Nginx stop successful!  || ECHO Nginx stop failed!  & pause & goto menu
 
:startNginx  
    ECHO.   
    ECHO.启动Nginx......    
    IF EXIST "nginx.exe" (  
        start "" nginx.exe  && ECHO Nginx started successful!  || ECHO Nginx started failed!  & pause & goto menu
    )  
  