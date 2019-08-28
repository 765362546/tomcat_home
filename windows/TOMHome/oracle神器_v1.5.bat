@echo off
set local=%~dp0%
cd /d %local%
rem 年月日：ymd  年月：ym
set yyyy=%date:~0,4%
set mm=%date:~5,2%
set dd=%date:~8,2%
set ymd=%yyyy%%mm%%dd%
set ym=%yyyy%%mm%
rem 时分秒：hm
for /f "tokens=1,2,3,4 delims=: " %%a in ('time /t') do (set hm=%%a%%b)
echo 当前实例名
lsnrctl status|findstr /I ready
echo.

:Menu
rem 菜单
echo.
echo *******************************************************
echo                  欢迎使用Oracle_Tool
echo.
echo          1、创建TIMS用户          2、EXP备份数据   
echo.                                       
echo          3、IMP导入数据           4、生成自动备份批处理
echo. 
echo          5、EXPDP备份数据         6、IMPDP导入数据
echo.
echo *******************************************************

set /p choice=请输入你的选择：

if "%choice%"=="1" goto createuser
if "%choice%"=="2" goto expdb
if "%choice%"=="3" goto impdb
if "%choice%"=="4" goto genexpcode
if "%choice%"=="5" goto expdpdb
if "%choice%"=="6" goto impdpdb

echo.
echo 选择错误，请重新选择！！！
goto :Menu
:expdb
set /p expuser=要备份的用户：
set /p exppw=用户密码：
set /p exptnsname=Oracle Net服务名：
set /p expdir=备份文件存放路径（如：c:\backup）：
if not exist %expdir% mkdir %expdir%
set begintime=%time%
exp %expuser%/%exppw%@%exptnsname% owner=%expuser% file=%expdir%\\%expuser%_%ymd%%hm%_exp.dmp log=%expdir%\\%expuser%_%ymd%%hm%_exp.log buffer=204800000 
rem 记录开始和结束时间到日志中
echo 备份开始时间：%begintime% >>%expdir%\\%expuser%_%ymd%%hm%_exp.log
echo.
echo 备份结束时间：%time% >>%expdir%\\%expuser%_%ymd%%hm%_exp.log
echo 备份的文件为: %expdir%%expuser%_%ymd%%hm%_exp.dmp
echo.
set /p choice2=备份结束，退出（1）or 回到主菜单（2）?：
if %choice2%==1 goto exit
goto :Menu

:impdb
set /p touser=要导入的用户：
set /p touserpw=用户密码：
rem set /p fromuser=原用户名：
set /p imptnsname=Oracle Net服务名：
set /p impfile=备份文件全路径（如：c:\backup\tims.dmp）：
set begintime=%time%
rem imp %touser%/%touserpw%@%imptnsname% fromuser=%fromuser% touser=%touser% file=%impfile% log=%local%\%touser%_%ymd%%hm%_imp.log buffer=20480000 commit=y
imp %touser%/%touserpw%@%imptnsname% full=y ignore=y file=%impfile% log=%local%\%touser%_%ymd%%hm%_imp.log buffer=20480000 commit=y
rem 记录开始和结束时间到日志中
echo 导入开始时间：%begintime% >>%local%\%touser%_%ymd%%hm%_imp.log
echo.
echo 导入结束时间：%time% >>%local%\%touser%_%ymd%%hm%_imp.log
set /p choice3=导入结束，退出（1）or 回到主菜单（2）?：
if %choice3%==1 goto exit
goto :Menu

:createuser

set /p catnsname=Oracle Net服务名：
set /p username=创建的用户名：
set /p userpw=创建的用户密码：


echo create user %username% identified by %userpw% ; >create.sql
echo grant dba,connect to %username%; >>create.sql
echo quit; >>create.sql


sqlplus /@%catnsname% as sysdba  @%local%\create.sql

echo 用户已创建，用户名：%username% 密码：%userpw% 
echo.
del /s /q create.sql
set /p choice1=退出(1) or 回到主菜单(2)？:
if %choice1%==1 goto exit
goto :Menu

:genexpcode
rem 自动生成备份批处理
cd /d %local%
echo @echo off^&setlocal enabledelayedexpansion  >oracle_backup.bat
echo set local=%%~dp0%% >>oracle_backup.bat
echo cd /d %%local%% >>oracle_backup.bat
echo rem 年月日：ymd  年月：ym >>oracle_backup.bat
echo for /f "tokens=1,2,3,4 delims=/ " %%%%a in ('date /t') do (set ymd=%%%%a%%%%b%%%%c>>oracle_backup.bat
echo set ym=%%%%a%%%%b>>oracle_backup.bat
echo ) >>oracle_backup.bat
echo rem 时分秒：hm >>oracle_backup.bat
echo for /f "tokens=1,2,3,4 delims=: " %%%%a in ('time /t') do (set hm=%%%%a%%%%b) >>oracle_backup.bat


echo set yyyy=%%date:~0,4%%>>oracle_backup.bat
echo set mm=%%date:~5,2%%>>oracle_backup.bat
echo set dd=%%date:~8,2%%>>oracle_backup.bat
echo if %%mm:~0,1%%== 0 set mm=%%mm:~1,1%%>>oracle_backup.bat
echo if %%dd:~0,1%%== 0 set dd=%%dd:~1,1%%>>oracle_backup.bat
echo set /a od=!dd!-15 >>oracle_backup.bat
echo if !od! LEQ 0 call :dd0 >>oracle_backup.bat
echo if !mm! LEQ 0 call :mm0 >>oracle_backup.bat
echo rem set yyyymmdd=!yyyy!年!mm!月!od!日  >>oracle_backup.bat

echo if !mm! LSS 10 set mm=0!mm!>>oracle_backup.bat
echo if !od! LSS 10 set od=0!od!>>oracle_backup.bat
echo set needdel=!yyyy!!mm!!od!>>oracle_backup.bat

set /p expuser=要备份的用户：
set /p exppw=用户密码：
set /p exptnsname=Oracle Net服务名：
set /p expdir=备份文件存放路径（如：c:\backup）：
echo if not exist %expdir% mkdir %expdir% >>oracle_backup.bat
echo cd /d %expdir% >>oracle_backup.bat
echo if not exist %%ymd%% mkdir %%ymd%% >>oracle_backup.bat
echo cd %%ymd%% >>oracle_backup.bat

echo set begintime=%%time%% >>oracle_backup.bat
echo exp %expuser%/%exppw%@%exptnsname% owner=%expuser% file=%expuser%_%%ymd%%%%hm%%_exp.dmp log=%expuser%_%%ymd%%%%hm%%_exp.log buffer=204800000 >>oracle_backup.bat
echo rem 记录开始和结束时间到日志中 >>oracle_backup.bat
echo echo 备份开始时间：%%begintime%% ^>^>%expuser%_%%ymd%%%%hm%%_exp.log >>oracle_backup.bat
echo echo. >>oracle_backup.bat
echo echo 备份结束时间：%%time%% ^>^>%expuser%_%%ymd%%%%hm%%_exp.log >>oracle_backup.bat

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

echo 批处理已生成，见：%local%\oracle_backup.bat
goto :Menu

:expdpdb
rem expdp备份数据
set /p expdpuser=要备份的数据库用户名：
set /p expdpuserpw=要备份的数据库用户密码：
set /p sid=当前数据库实例名（SID）：
set /p expdppath=备份文件存放路径：
set /p target_db_version=目标数据库版本（源数据库版本高于目标数据库版本必输，否则可直接回车）：
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
set /p choice1=退出(1) or 回到主菜单(2)？:
if %choice1%==1 goto exit
goto :Menu

:impdpdb
rem impdp导入数据

set /p impdpuser=导入的用户名：
set /p impdpuserpw=导入的用户密码：
set /p expdpuser=原导出用户名：
set /p sid=当前数据库实例名（SID）：
set /p impdppath=备份文件路径（精确到文件夹）：
set /p dbfile=备份文件名：
set /p db_version=当前数据库版本（备份时没有输则可直接回车）：
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
set /p choice1=退出(1) or 回到主菜单(2)？:
if %choice1%==1 goto exit
goto :Menu




