#!/bin/bash

export CUR_DIR=${PWD}
export JRE_HOME=${CUR_DIR}/jre_linux
export CATALINA_HOME=${CUR_DIR}/tomcat
export JAVA_OPTS="-server -Xms128m -Xmx128m -Xss1m -XX:MaxDirectMemorySize=256m"
#export JAVA_OPTS=${JAVA_OPTS}:" -XX:PermSize=128m  -XX:MaxPermSize=128m "
#export JAVA_OPTS=${JAVA_OPTS}:"-XX:+AggressiveOpts -XX:+UseBiasedLocking"
#export JAVA_OPTS=${JAVA_OPTS}:"-XX:+DisableExplicitGC -XX:MaxTenuringThreshold=31"
#export JAVA_OPTS=${JAVA_OPTS}:"-XX:+UseConcMarkSweepGC -XX:+UseParNewGC"
#export JAVA_OPTS=${JAVA_OPTS}:"-XX:+CMSParallelRemarkEnabled -XX:+UseCMSCompactAtFullCollection"
#export JAVA_OPTS=${JAVA_OPTS}:"-XX:LargePageSizeInBytes=256m  -XX:+UseFastAccessorMethods"
#export JAVA_OPTS=${JAVA_OPTS}:"-XX:+UseCMSInitiatingOccupancyOnly -Djava.awt.headless=true"

chk_status(){
	pn=`ps -ef|grep java|grep "$CATALINA_BASE"|grep -v "grep" |wc -l`
	[ $pn -ge 1 ] && return 0 || return 1
}

for i in $(ls -d  node*)
do 
	export CATALINA_BASE=${CUR_DIR}/$i
	chk_status
	if [ $? -eq 1 ];then
		echo "start $i"
  		${CATALINA_HOME}/bin/startup.sh
	else
		echo "$i is running!"
	fi

done
