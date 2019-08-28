@echo off  
rem nginx������� 
color 8b   
TITLE Nginx �������
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
echo ��ǰNginxĿ¼Ϊ%cd%
echo.
ECHO Nginx �����б�   
echo ++++++++++++++++++++++++++++
tasklist|findstr /i "nginx.exe" 
if ERRORLEVEL 1 (echo nginx���̲�����) 
echo ++++++++++++++++++++++++++++ 
echo.
echo.

echo       ѡ��
echo -----------------------------
echo [1] ����Nginx
echo [2] �ر�Nginx
echo [3] ����Nginx 
echo [4^|q] �� �� 
echo -----------------------------
ECHO.   
  
ECHO.������ѡ����Ŀ�����:  
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
    ECHO.�ر�Nginx......   
    taskkill /F /IM nginx.exe > nul  && ECHO Nginx stop successful!  || ECHO Nginx stop failed!  & pause & goto menu
 
:startNginx  
    ECHO.   
    ECHO.����Nginx......    
    IF EXIST "nginx.exe" (  
        start "" nginx.exe  && ECHO Nginx started successful!  || ECHO Nginx started failed!  & pause & goto menu
    )  
  