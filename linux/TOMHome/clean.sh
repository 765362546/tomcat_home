#!/bin/bash
echo "清除tomcat日志和缓存"
CUR_DIR=$PWD
TOM_HOME=$CUR_DIR/apache-tomcat-7.0.0
#echo $TOM_HOME
cd $TOM_HOME && \
rm -rfv logs/*  && \
rm -rfv work/Catalina/localhost/* && \
rm -rfv conf/Catalina/localhost/*
