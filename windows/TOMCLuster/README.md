nginx+tomcat集群
通过nginx对tomcat各个节点做方向代理

目录结构
TOMCluster
  - 文件夹：
  - jdk或jre
  - tomcat 只需包含bin lib  #CATALIAN_HOME
  - nginx 
  - node1 包含conf logs temp webapps work # 通过CATALINA_BASE变量，分别指向这些节点
  - node2
  - nodeN
  - 脚本：
  - tomcat 所有节点启停脚本
  - nginx 启停脚本
  - tomcat 单个节点启动脚本，用于调试
  - 初始化可执行权限的脚本
