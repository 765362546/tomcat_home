#!/bin/bash
find ./ -name "*.sh" -exec chmod +x {} \;
chmod +x tomcat/bin/*.sh
chmod +x jre_linux/bin/*
chmod +x nginx/nginx

