#!/bin/bash
# 初始化数据结构
mysql -h127.0.0.1 -uroot -pRoot1.pwd -e "source /usr/local/apache-tomcat-8.5.16/webapps/ROOT/WEB-INF/classes/database/initialize.sql;"

# 修改rap数据库配置
sed -i 's/jdbc.password=/jdbc.password =Root1.pwd/g' /usr/local/apache-tomcat-8.5.16/webapps/ROOT/WEB-INF/classes/config.properties

# 重启tomcat
/usr/local/apache-tomcat-8.5.16/bin/shutdown.sh
/usr/local/apache-tomcat-8.5.16/bin/startup.sh