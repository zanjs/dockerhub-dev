############################################################
# 创建开发环境的dockerfile
# Based on Centos 6
############################################################
# Set the base image to centos6.8
FROM centos:6.8

# File Author / Maintainer
MAINTAINER zhangce zhangce5413@gmail.com

##################### 常用基础软件 START #####################
RUN yum install -y net-tools vsftpd vim wget crontabs gcc make openssh-server git && \
 yum clean all
##################### 常用基础软件 END #####################

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
 yum clean all
###################### mysql END #####################

################## openresty start ######################
### 安装依赖
RUN yum -y install readline-devel pcre-devel openssl-devel && cd /usr/src && \
### 安装软件
 wget https://openresty.org/download/openresty-1.11.2.3.tar.gz && tar -xzvf openresty-1.11.2.3.tar.gz && \
 cd openresty-1.11.2.3 && ./configure && make && make install && ln -s /usr/local/openresty/nginx/conf /etc/nginx && \
 mkdir /etc/nginx/vhosts && \
 yum clean all && rm -rf ../openresty-1.11.2.3.tar.gz
###添加配置
COPY conf/nginx/* /etc/nginx/
COPY conf/nginx/vhosts/* /etc/nginx/vhosts/
##################### openresty END #####################


###################### php7 START #####################
RUN cd /usr/src && \
 ###安装php7
 yum -y install libxml2-devel curl-devel libpng-devel gd-devel autoconf xz zlib-devel&& \
 wget http://cn2.php.net/get/php-7.1.2.tar.xz/from/this/mirror && \
 mv mirror php-7.1.2.tar.xz && xz -d php-7.1.2.tar.xz && tar xvf php-7.1.2.tar && \
 cd php-7.1.2 && \
 ./configure --prefix=/usr/local/php --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-gd --with-jpeg-dir=/usr/lib64/ --with-iconv --with-openssl --with-curl --enable-pcntl --with-zlib --enable-bcmath --enable-json --enable-fpm --enable-mbstring --enable-soap --enable-opcache && \
 make -j4 && make install && yum clean all

RUN echo -e 'export PATH=/usr/local/php/bin:usr/local/php/sbin:$PATH' >> ~/.bashrc && \
 ln -s /usr/local/php/bin/php /usr/bin/php && \
 ### yaf
 source ~/.bashrc && \
 cd /usr/src && \
 wget http://pecl.php.net/get/yaf-3.0.4.tgz && tar zxvf yaf-3.0.4.tgz && \
 cd yaf-3.0.4 && phpize && ./configure && make -j4 && make install && \

 ### yac
 cd /usr/src && \
 wget http://pecl.php.net/get/yac-2.0.1.tgz && tar zxvf yac-2.0.1.tgz && \
 cd yac-2.0.1 && phpize && ./configure && make -j4 && make install && \

 ### redis
 cd /usr/src && \
 wget http://pecl.php.net/get/redis-3.1.1.tgz && tar zxvf redis-3.1.1.tgz && \
 cd redis-3.1.1 && phpize && ./configure && make && make install && \

 ### phpunit
 cd /usr/src && \
 wget https://phar.phpunit.de/phpunit-6.1.phar && \
 cp phpunit-6.1.phar /usr/local/bin/phpunit && \
 chmod +x /usr/local/bin/phpunit && \

 ### clean
 cd /usr/src && rm -rf *.tgz && rm -rf *.xz

### 创建日志文件夹  改变日志文件夹
RUN mkdir -p /data1/logs && chmod 777 /data1/logs

COPY conf/php/php.ini /usr/local/php/lib/
COPY conf/php/php-fpm.conf /usr/local/php/etc/
COPY conf/php/www.conf /usr/local/php/etc/php-fpm.d/
###################### php7 END #####################

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]