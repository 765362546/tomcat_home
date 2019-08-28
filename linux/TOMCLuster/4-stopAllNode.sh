#!/bin/bash
export CUR_DIR=${PWD}
export JRE_HOME=${CUR_DIR}/jre_linux
export CATALINA_HOME=${CUR_DIR}/tomcat
export JAVA_OPTS="-server -Xms128m -Xmx256m"

if [ $# -ne 1 ];then
	jpid=$(ps -ef|grep java|grep "$CATALINA_HOME"|grep -v 'grep' |awk '{print $2}')
	#echo $jpid
	for i in  $jpid
	do
		kill $i
	done
	sleep 2
	num=$(ps -ef|grep java|grep "$CATALINA_HOME"|grep -v 'grep' |wc -l)
	[ $num -eq 0 ] && echo "All node is stoped"

else
	export CATALINA_BASE="${CUR_DIR}/$1"
	jpid=$(ps -ef|grep java|grep "$CATALINA_BASE"|grep -v 'grep' |awk '{print $2}')
	[  $jpid ] && kill $jpid && echo "$1 is stoped!" || echo "$1 is not run!"
fi


