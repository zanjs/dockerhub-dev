############################################################
# 带ssh的centos
# Based on Centos 6.8
#
############################################################
# Set the base image to centos6.8
FROM centos:6.8

# File Author / Maintainer
MAINTAINER lvyalin lvyalin.yl@gmail.com

##################### 常用基础软件 START #####################
RUN yum install -y vsftpd vim wget crontabs gcc make openssh-server git unzip && \
 service sshd start && echo "root:Root1.pwd" | chpasswd &&  yum clean all
##################### 常用基础软件 END #####################

##################### 安装java-1.8.0-openjdk-headless #########
RUN yum install -y java-1.8.0-openjdk && \
 yum install -y java-1.8.0-openjdk-devel.x86_64
##################### 安装java-1.8.0-openjdk-headless end #####

###################### redis START #####################
COPY conf/redis/redis /etc/init.d/redis
COPY conf/redis/redis.conf /etc/redis.conf
RUN chmod +x /etc/init.d/redis && cd /usr/src && \
 wget http://download.redis.io/releases/redis-3.2.9.tar.gz && tar xzf redis-3.2.9.tar.gz && cd redis-3.2.9 && make && \
 cp src/redis-server /usr/sbin/redis-server && cp src/redis-cli /usr/sbin/redis-cli && \
 rm -rf /usr/src/redis-3.2.9.tar.gz
###################### redis END #####################

###################### mysql START #####################
RUN rpm -Uvh https://dev.mysql.com/get/mysql57-community-release-el6-9.noarch.rpm && \
 yum -y install mysql-community-server && \
 service mysqld start && \
 defaultmysqlpwd=`grep 'A temporary password' /var/log/mysqld.log | awk -F"root@localhost: " '{ print $2}' ` && \
 /usr/bin/mysql -uroot -p${defaultmysqlpwd} --connect-expired-password -e "SET PASSWORD = PASSWORD('Root1.pwd');grant all privileges on *.* to root@'%' identified by 'Root1.pwd';" && \
 yum clean all
###################### mysql END #####################

###################### tomcat START ############################
RUN wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-8/v8.5.16/bin/apache-tomcat-8.5.16.tar.gz && tar xzf apache-tomcat-8.5.16.tar.gz && \
mv ./apache-tomcat-8.5.16 /usr/local/apache-tomcat-8.5.16 && \
rm -f /apache-tomcat-8.5.16.tar.gz
###################### tomcat END #################################

###################### RAP deploy START ############################
COPY conf/rap/init.sh /root/init.sh
RUN wget http://rapapi.org/release/RAP-0.14.16-SNAPSHOT.war && \
mv RAP-0.14.16-SNAPSHOT.war /usr/local/apache-tomcat-8.5.16/webapps/ROOT.war && \
rm -rf /usr/local/apache-tomcat-8.5.16/webapps/ROOT && \
chmod +x /root/init.sh
###################### RAP deploy END ############################

COPY rc.local /etc/rc.local
RUN chmod +x /etc/rc.local
CMD ["/etc/rc.local"]
