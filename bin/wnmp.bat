@echo off
set utf8=65001
chcp %utf8%


set basedir=D:\_wnmp
set nginxdir=nginx
set phpdir=php\php-5.6.30
set mysqldir=mariadb
set phppath=%basedir%\%phpdir%
set nginxpath=%basedir%\%nginxdir%
set mysqlpath=%basedir%\%mysqldir%

set phpbin=%basedir%\bin\RunHiddenConsole.exe %phppath%\php-cgi.exe
set nginxstartbin=%basedir%\bin\RunHiddenConsole.exe %nginxpath%\nginx.exe -p %nginxpath% -c %nginxpath%\conf\nginx.conf
set mysqlstartbin=%basedir%\bin\RunHiddenConsole.exe %mysqlpath%\bin\mysqld.exe --defaults-file=%mysqlpath%\my.ini --standalone

set phpprocess=10
set phpport=9001
set /a port=%phpport%+%phpprocess%-1

cls
title Wnmp Control Panel
color 0A

:menu
echo.
echo ========================================================================
echo                   请选择要进行的操作，然后按回车
echo ========================================================================
echo.
echo    1. 启动 Wnmp 服务  
echo.
echo    2. 停止 Wnmp 服务  
echo.
echo    3. 重启 Wnmp 服务  
echo.
echo    4. 重启 Nginx 服务  
echo.
echo    5. 重启 PHP 服务  
echo.
echo    6. 重启 Mysql 服务  
echo.
echo    7. 关闭 Nginx 服务  
echo.
echo    8. 关闭 PHP 服务  
echo.
echo    9. 关闭 Mysql 服务  
echo.
echo    M. Mysql 命令行  
echo.
echo    T. Nginx 配置 Test  
echo.
echo    R. Nginx 配置 Reload  
echo.
echo    S. 检查状态
echo.
echo    O. 打开 Wnmp 目录
echo.
echo    Q. 退出  
echo.
echo.

:cho
set choice=
set /p choice=请选择:
IF NOT \"%choice%\"==\"\" SET choice=%choice:~0,1%
if /i \"%choice%\"==\"1\" goto startWnmp
if /i \"%choice%\"==\"2\" goto stopWnmp
if /i \"%choice%\"==\"3\" goto restartWnmp
if /i \"%choice%\"==\"4\" goto restartNginx
if /i \"%choice%\"==\"5\" goto restartPHP
if /i \"%choice%\"==\"6\" goto restartMysql
if /i \"%choice%\"==\"7\" goto stopNginx
if /i \"%choice%\"==\"8\" goto stopPHP
if /i \"%choice%\"==\"9\" goto stopMysql
if /i \"%choice%\"==\"M\" goto mysqlCmd
if /i \"%choice%\"==\"T\" goto nginxTest
if /i \"%choice%\"==\"R\" goto nginxReload
if /i \"%choice%\"==\"S\" goto status
if /i \"%choice%\"==\"o\" goto wnmpDir
if /i \"%choice%\"==\"Q\" goto endd
echo 选择无效，请重新输入
echo.

goto cho

:startWnmp
cls
echo ================================== Starting Wnmp ==================================
echo.
echo ... Starting PHP ...
echo upstream php_processes {>%nginxpath%\conf\php_processes.conf

for /l %%i in (%phpport%, 1, %port%) do (
	set /p="."<nul
	%phpbin% -b 127.0.0.1:%%i -c %phppath%\php.ini
	echo 	server 127.0.0.1:%%i max_fails=0 fail_timeout=3s  weight=1;>>%nginxpath%\conf\php_processes.conf
)

echo }>>%nginxpath%\conf\php_processes.conf
echo.
echo ... Starting Nginx ...
%nginxstartbin%
echo.
echo ... Starting Mysql ...
%mysqlstartbin%
echo.
goto menu

:stopWnmp
cls
echo ================================== Stopping Wnm ==================================
echo.
echo ... Stopping nginx...
taskkill /F /IM nginx.exe > nul
echo.
echo ... Stopping PHP ...
taskkill /F /IM php-cgi.exe > nul
echo.
echo ... Stopping Mysql ...
taskkill /F /IM mysqld.exe > nul
echo.
goto menu

:restartWnmp
cls
echo ================================== Restarting Wnmp ==================================
echo.
echo ... Stopping Nginx ...
taskkill /F /IM nginx.exe > nul
echo.
echo ... Stopping PHP ...
taskkill /F /IM php-cgi.exe > nul
echo.
echo ... Stopping Mysql ...
taskkill /F /IM mysqld.exe > nul
echo.
echo ... Starting PHP ...
echo upstream php_processes {>%nginxpath%\conf\php_processes.conf
for /l %%i in (%phpport%, 1, %port%) do (
	set /p="."<nul
	%phpbin% -b 127.0.0.1:%%i -c %phppath%\php.ini
	echo 	server 127.0.0.1:%%i weight=1;>>%nginxpath%\conf\php_processes.conf
)
echo }>>%nginxpath%\conf\php_processes.conf
echo.
echo ... Starting Nginx ...
%nginxstartbin%
echo.
echo ... Starting Mysql ...
%mysqlstartbin%
echo.
goto menu

:restartNginx
cls
echo ================================== Restarting Nginx ==================================
echo.
echo ... Stopping Nginx ...
taskkill /F /IM nginx.exe > nul
echo.
echo ... Starting Nginx ...
%nginxstartbin%
echo.
goto menu

:restartPHP
cls
echo ================================== Restarting PHP ==================================
echo.
echo ... Stopping PHP ...
taskkill /F /IM php-cgi.exe > nul
echo.
echo ... Starting PHP ...
echo upstream php_processes {>%nginxpath%\conf\php_processes.conf
for /l %%i in (%phpport%, 1, %port%) do (
	set /p="."<nul
	%phpbin% -b 127.0.0.1:%%i -c %phppath%\php.ini
	echo 	server 127.0.0.1:%%i weight=1;>>%nginxpath%\conf\php_processes.conf
)
echo }>>%nginxpath%\conf\php_processes.conf
echo.
goto menu

:restartMysql
cls
echo ================================== Restarting Mysql ==================================
echo.
echo ... Stopping Mysql ...
taskkill /F /IM mysqld.exe > nul
echo.
echo ... Starting Mysql ...
%mysqlstartbin%
echo.
goto menu

:nginxTest
cls
echo ================================== Nginx config test ==================================
echo.
%nginxpath%\nginx.exe -p %nginxpath% -c %nginxpath%\conf\nginx.conf -t
echo.
goto menu

:nginxReload
cls
echo ================================== Nginx config reload ==================================
echo.
%nginxpath%\nginx.exe -p %nginxpath% -c %nginxpath%\conf\nginx.conf -s reload
echo.
goto menu

:stopNginx
cls
echo ================================== Stopping Nginx ==================================
echo.
echo ... Stopping Nginx ...
taskkill /F /IM nginx.exe > nul
echo.
goto menu 

:stopPHP
cls
echo ================================== Stopping PHP ==================================
echo.
echo ... Stopping PHP ...
taskkill /F /IM php-cgi.exe > nul
echo.
goto menu

:stopMysql
cls
echo ================================== Stopping Mysql ==================================
echo.
echo ... Stopping Mysql ...
taskkill /F /IM mysqld.exe > nul
echo.
goto menu

:status
cls
echo ================================== Wnmp Status =====================================
echo.
echo ........................... Nginx ..........................................................
tasklist |findstr nginx.exe
echo.
echo ........................... PHP ..........................................................
tasklist |findstr php-cgi.exe
echo.
echo ........................... Mysql ..........................................................
tasklist |findstr mysqld.exe
echo.
goto menu

:wnmpDir
cls
echo ================================== Open Wnmp Directory =====================================
echo.
explorer /n,/root,%basedir%
goto menu

:mysqlCmd
cls
start %mysqlpath%\bin\mysql.exe -u root -p
echo.
goto menu

:endd
exit





