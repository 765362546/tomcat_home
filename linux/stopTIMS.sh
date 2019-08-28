#!/bin/bash
echo "停止TIMS..."
CUR_DIR=$PWD

# 清除系统自带的JAVA环境变量
export -n JAVA_HOME
export JRE_HOME=$CUR_DIR/jre7_linux
export CATALINA_HOME=$CUR_DIR/apache-tomcat-7.0.0


chk_status(){
pn=`ps -ef|grep java|grep $CUR_DIR|grep -v "grep" |wc -l`
[ $pn -ge 1 ] && return 0 || return 1
}



chk_status
if [ $? -eq 0 ];then
   PID=`ps -ef|grep java |grep $CATALINA_HOME|awk '{print $2}'` && \
   kill -9 $PID &> /dev/null && echo "停止TIMS完毕" || echo "停止TIMS失败"
else
   echo "TIMS没有运行"
fi
