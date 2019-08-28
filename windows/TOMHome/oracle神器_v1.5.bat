@echo off
set local=%~dp0%
cd /d %local%
rem �����գ�ymd  ���£�ym
set yyyy=%date:~0,4%
set mm=%date:~5,2%
set dd=%date:~8,2%
set ymd=%yyyy%%mm%%dd%
set ym=%yyyy%%mm%
rem ʱ���룺hm
for /f "tokens=1,2,3,4 delims=: " %%a in ('time /t') do (set hm=%%a%%b)
echo ��ǰʵ����
lsnrctl status|findstr /I ready
echo.

:Menu
rem �˵�
echo.
echo *******************************************************
echo                  ��ӭʹ��Oracle_Tool
echo.
echo          1������TIMS�û�          2��EXP��������   
echo.                                       
echo          3��IMP��������           4�������Զ�����������
echo. 
echo          5��EXPDP��������         6��IMPDP��������
echo.
echo *******************************************************

set /p choice=���������ѡ��

if "%choice%"=="1" goto createuser
if "%choice%"=="2" goto expdb
if "%choice%"=="3" goto impdb
if "%choice%"=="4" goto genexpcode
if "%choice%"=="5" goto expdpdb
if "%choice%"=="6" goto impdpdb

echo.
echo ѡ�����������ѡ�񣡣���
goto :Menu
:expdb
set /p expuser=Ҫ���ݵ��û���
set /p exppw=�û����룺
set /p exptnsname=Oracle Net��������
set /p expdir=�����ļ����·�����磺c:\backup����
if not exist %expdir% mkdir %expdir%
set begintime=%time%
exp %expuser%/%exppw%@%exptnsname% owner=%expuser% file=%expdir%\\%expuser%_%ymd%%hm%_exp.dmp log=%expdir%\\%expuser%_%ymd%%hm%_exp.log buffer=204800000 
rem ��¼��ʼ�ͽ���ʱ�䵽��־��
echo ���ݿ�ʼʱ�䣺%begintime% >>%expdir%\\%expuser%_%ymd%%hm%_exp.log
echo.
echo ���ݽ���ʱ�䣺%time% >>%expdir%\\%expuser%_%ymd%%hm%_exp.log
echo ���ݵ��ļ�Ϊ: %expdir%%expuser%_%ymd%%hm%_exp.dmp
echo.
set /p choice2=���ݽ������˳���1��or �ص����˵���2��?��
if %choice2%==1 goto exit
goto :Menu

:impdb
set /p touser=Ҫ������û���
set /p touserpw=�û����룺
rem set /p fromuser=ԭ�û�����
set /p imptnsname=Oracle Net��������
set /p impfile=�����ļ�ȫ·�����磺c:\backup\tims.dmp����
set begintime=%time%
rem imp %touser%/%touserpw%@%imptnsname% fromuser=%fromuser% touser=%touser% file=%impfile% log=%local%\%touser%_%ymd%%hm%_imp.log buffer=20480000 commit=y
imp %touser%/%touserpw%@%imptnsname% full=y ignore=y file=%impfile% log=%local%\%touser%_%ymd%%hm%_imp.log buffer=20480000 commit=y
rem ��¼��ʼ�ͽ���ʱ�䵽��־��
echo ���뿪ʼʱ�䣺%begintime% >>%local%\%touser%_%ymd%%hm%_imp.log
echo.
echo �������ʱ�䣺%time% >>%local%\%touser%_%ymd%%hm%_imp.log
set /p choice3=����������˳���1��or �ص����˵���2��?��
if %choice3%==1 goto exit
goto :Menu

:createuser

set /p catnsname=Oracle Net��������
set /p username=�������û�����
set /p userpw=�������û����룺


echo create user %username% identified by %userpw% ; >create.sql
echo grant dba,connect to %username%; >>create.sql
echo quit; >>create.sql


sqlplus /@%catnsname% as sysdba  @%local%\create.sql

echo �û��Ѵ������û�����%username% ���룺%userpw% 
echo.
del /s /q create.sql
set /p choice1=�˳�(1) or �ص����˵�(2)��:
if %choice1%==1 goto exit
goto :Menu

:genexpcode
rem �Զ����ɱ���������
cd /d %local%
echo @echo off^&setlocal enabledelayedexpansion  >oracle_backup.bat
echo set local=%%~dp0%% >>oracle_backup.bat
echo cd /d %%local%% >>oracle_backup.bat
echo rem �����գ�ymd  ���£�ym >>oracle_backup.bat
echo for /f "tokens=1,2,3,4 delims=/ " %%%%a in ('date /t') do (set ymd=%%%%a%%%%b%%%%c>>oracle_backup.bat
echo set ym=%%%%a%%%%b>>oracle_backup.bat
echo ) >>oracle_backup.bat
echo rem ʱ���룺hm >>oracle_backup.bat
echo for /f "tokens=1,2,3,4 delims=: " %%%%a in ('time /t') do (set hm=%%%%a%%%%b) >>oracle_backup.bat


echo set yyyy=%%date:~0,4%%>>oracle_backup.bat
echo set mm=%%date:~5,2%%>>oracle_backup.bat
echo set dd=%%date:~8,2%%>>oracle_backup.bat
echo if %%mm:~0,1%%== 0 set mm=%%mm:~1,1%%>>oracle_backup.bat
echo if %%dd:~0,1%%== 0 set dd=%%dd:~1,1%%>>oracle_backup.bat
echo set /a od=!dd!-15 >>oracle_backup.bat
echo if !od! LEQ 0 call :dd0 >>oracle_backup.bat
echo if !mm! LEQ 0 call :mm0 >>oracle_backup.bat
echo rem set yyyymmdd=!yyyy!��!mm!��!od!��  >>oracle_backup.bat

echo if !mm! LSS 10 set mm=0!mm!>>oracle_backup.bat
echo if !od! LSS 10 set od=0!od!>>oracle_backup.bat
echo set needdel=!yyyy!!mm!!od!>>oracle_backup.bat

set /p expuser=Ҫ���ݵ��û���
set /p exppw=�û����룺
set /p exptnsname=Oracle Net��������
set /p expdir=�����ļ����·�����磺c:\backup����
echo if not exist %expdir% mkdir %expdir% >>oracle_backup.bat
echo cd /d %expdir% >>oracle_backup.bat
echo if not exist %%ymd%% mkdir %%ymd%% >>oracle_backup.bat
echo cd %%ymd%% >>oracle_backup.bat

echo set begintime=%%time%% >>oracle_backup.bat
echo exp %expuser%/%exppw%@%exptnsname% owner=%expuser% file=%expuser%_%%ymd%%%%hm%%_exp.dmp log=%expuser%_%%ymd%%%%hm%%_exp.log buffer=204800000 >>oracle_backup.bat
echo rem ��¼��ʼ�ͽ���ʱ�䵽��־�� >>oracle_backup.bat
echo echo ���ݿ�ʼʱ�䣺%%begintime%% ^>^>%expuser%_%%ymd%%%%hm%%_exp.log >>oracle_backup.bat
echo echo. >>oracle_backup.bat
echo echo ���ݽ���ʱ�䣺%%time%% ^>^>%expuser%_%%ymd%%%%hm%%_exp.log >>oracle_backup.bat

echo cd  /d %expdir% >>oracle_backup.bat

echo if exist %%needdel%% rd /s /q %%needdel%% >>oracle_backup.bat



echo :dd0 >>oracle_backup.bat
echo set /a mm=!mm!-1 >>oracle_backup.bat
echo if %%mm%%==0 set mm=12 >>oracle_backup.bat
echo for %%%%a in (1 3 5 7 8 10 12)do set %%%%add=31 >>oracle_backup.bat
echo set /a pddd=!yyyy!*10/4 >>oracle_backup.bat
echo set pd2d=!pddd:~-1,1! >>oracle_backup.bat
echo set 2dd=28 >>oracle_backup.bat
echo if !pd2d!==0 set 2dd=29 >>oracle_backup.bat
echo for %%%%b in (4 6 9 11)do set %%%%bdd=30 >>oracle_backup.bat
echo set /a od=!%%mm%%dd!+(!od!)>>oracle_backup.bat
echo if !od! LEQ 0 call :dd0 >>oracle_backup.bat
echo goto :eof >>oracle_backup.bat
echo :mm0  >>oracle_backup.bat
echo set /a yyyy=!yyyy!-1  >>oracle_backup.bat
echo set mm=12 ^&^& set od=31  >>oracle_backup.bat
echo goto :eof >>oracle_backup.bat

echo �����������ɣ�����%local%\oracle_backup.bat
goto :Menu

:expdpdb
rem expdp��������
set /p expdpuser=Ҫ���ݵ����ݿ��û�����
set /p expdpuserpw=Ҫ���ݵ����ݿ��û����룺
set /p sid=��ǰ���ݿ�ʵ������SID����
set /p expdppath=�����ļ����·����
set /p target_db_version=Ŀ�����ݿ�汾��Դ���ݿ�汾����Ŀ�����ݿ�汾���䣬�����ֱ�ӻس�����
set expdir=expdir%random%

if not exist %expdppath%  mkdir %expdppath%
echo create directory %expdir% as '%expdppath%';>expdpscript.sql
echo grant read,write on directory %expdir% to %expdpuser%;>>expdpscript.sql
echo exit;>>expdpscript.sql
echo drop directory %expdir%;>dropdirectory.sql
echo exit;>>dropdirectory.sql

sqlplus /@%sid% as sysdba @expdpscript.sql

set sql1=expdp %expdpuser%/%expdpuserpw%@%sid% dumpfile=expdp_%expdpuser%_%hm%.dmp logfile=expdp_%expdpuser%_%hm%.log directory=%expdir% exclude=statistics parallel=2
set sql2=expdp %expdpuser%/%expdpuserpw%@%sid% dumpfile=expdp_%expdpuser%_%hm%.dmp logfile=expdp_%expdpuser%_%hm%.log directory=%expdir% exclude=statistics version=%target_db_version% parallel=2
if  not defined target_db_version ( %sql1% ) else %sql2%

sqlplus /@%sid% as sysdba @dropdirectory.sql
echo.
del /s /q expdpscript.sql
del /s /q dropdirectory.sql
set /p choice1=�˳�(1) or �ص����˵�(2)��:
if %choice1%==1 goto exit
goto :Menu

:impdpdb
rem impdp��������

set /p impdpuser=������û�����
set /p impdpuserpw=������û����룺
set /p expdpuser=ԭ�����û�����
set /p sid=��ǰ���ݿ�ʵ������SID����
set /p impdppath=�����ļ�·������ȷ���ļ��У���
set /p dbfile=�����ļ�����
set /p db_version=��ǰ���ݿ�汾������ʱû�������ֱ�ӻس�����
set impdir=impdir%random%
echo create  directory %impdir% as '%impdppath%';>impdpscript.sql
echo grant read,write on directory %impdir% to %impdpuser%;>>impdpscript.sql
echo exit;>>impdpscript.sql
echo drop directory %impdir%;>dropdirectory.sql
echo exit;>>dropdirectory.sql
sqlplus /@%sid% as sysdba @impdpscript.sql

if not defined db_version ( impdp %impdpuser%/%impdpuserpw%@%sid% dumpfile=%dbfile% logfile=impdp_%dbfile%.log directory=%impdir% parallel=3 remap_schema=%expdpuser%:%impdpuser% ) else ( impdp %impdpuser%/%impdpuserpw% dumpfile=%dbfile% logfile=impdp_%dbfile%.log directory=%impdir% parallel=3 remap_schema=%expdpuser%:%impdpuser% version=%db_version% )
sqlplus /@%sid% as sysdba @dropdirectory.sql
echo.
del /s /q impdpscript.sql
del /s /q dropdirectory.sql
set /p choice1=�˳�(1) or �ص����˵�(2)��:
if %choice1%==1 goto exit
goto :Menu




