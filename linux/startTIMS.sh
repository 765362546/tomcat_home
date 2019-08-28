#!/bin/bash
#
echo "启动TIMS"
CUR_DIR=$PWD

# 清除系统自带的JAVA环境变量
export -n JAVA_HOME
export JRE_HOME=$CUR_DIR/jre7_linux
export CATALINA_HOME=$CUR_DIR/apache-tomcat-7.0.0
# DEV 0 测试环境  1 生产环境
DEV=0

# 生产环境的jvm参数，请根据硬件配置进行修改
MY_OPTS="-Xms1g -Xmx1g -Xss1m -XX:MaxDirectMemorySize=1g"
MY_OPTS="$MY_OPTS -XX:PermSize=256m -XX:MaxPermSize=512m"
MY_OPTS="$MY_OPTS -XX:+AggressiveOpts -XX:+UseBiasedLocking "
MY_OPTS="$MY_OPTS -XX:+DisableExplicitGC -XX:MaxTenuringThreshold=31" 
MY_OPTS="$MY_OPTS -XX:+UseConcMarkSweepGC -XX:+UseParNewGC"  
MY_OPTS="$MY_OPTS -XX:+CMSParallelRemarkEnabled -XX:+UseCMSCompactAtFullCollection" 
MY_OPTS="$MY_OPTS -XX:LargePageSizeInBytes=256m  -XX:+UseFastAccessorMethods" 
MY_OPTS="$MY_OPTS -XX:+UseCMSInitiatingOccupancyOnly -Djava.awt.headless=true"


if [ $DEV -eq 0 ];then
    echo -e "当前运行模式为测试模式 \n" && \
    echo "如果想切换为生产模式，请修改此脚本中的DEV变量以及相关jvm参数"
else
    echo -e "当前运行模式为生产模式 \n" && \
    echo "如果想切换为测试模式，请修改此脚本中的DEV变量"
    export JAVA_OPTS="$MY_OPTS"
fi


chk_status(){
pn=`ps -ef|grep java|grep $CUR_DIR|grep -v "grep" |wc -l`
[ $pn -ge 1 ] && return 0 || return 1
}

chk_status
if [ $? -eq 1 ];then
  cd $CATALINA_HOME/bin && \
  ./startup.sh && chk_status && \
  echo "启动TIMS完毕" || echo "启动TIMS失败"
else
  echo "TIMS正在运行中..."
fi
