#!/bin/bash
export CUR_DIR=${PWD}
NGX_HOME=${CUR_DIR}/nginx
cd ${NGX_HOME}
pn=$(ps -ef|grep "nginx"|grep -v "grep"|wc -l)
#echo $pn
if [ $pn -ne 0 ];then
	echo "Nginx is running!"
	ps -ef|grep "nginx"|grep -v "grep"
	netstat -tnlp|grep nginx
else
	./nginx -t &> /dev/null
	[ $? -eq 0 ] && ./nginx && echo "Nginx is started!"|| echo "Nginx conf check error!"
	ps -ef|grep "nginx"|grep -v "grep"
	netstat -tnlp|grep nginx
fi
