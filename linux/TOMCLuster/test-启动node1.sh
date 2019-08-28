#!/bin/bash
export CUR_DIR=${PWD}
export JRE_HOME=${CUR_DIR}/jre_linux
export CATALINA_HOME=${CUR_DIR}/tomcat
export JAVA_OPTS="-server -Xms128m -Xmx256m"

echo $#
if [ $# -ne 1 ];then
	export CATALINA_BASE="${CUR_DIR}/node1"
else
	export CATALINA_BASE="${CUR_DIR}/$1"
fi


#${CATALINA_HOME}/bin/startup.sh
${CATALINA_HOME}/bin/catalina.sh run
