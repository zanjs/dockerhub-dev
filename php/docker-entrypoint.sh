#!/bin/bash
service sshd start
echo "root:Root1.pwd" | chpasswd

# 判断是否为第一次启动mysql服务，如果是并修改mysql root密码，如果不是则只启动mysql
if [ ! -d "/var/lib/mysql/mysql" ]; then
    service mysqld start
    defaultmysqlpwd=`grep 'A temporary password' /var/log/mysqld.log | awk -F"root@localhost: " '{ print $2}' `
    /usr/bin/mysql -uroot -p${defaultmysqlpwd} --connect-expired-password -e "SET PASSWORD = PASSWORD('Root1.pwd');grant all privileges on *.* to root@'%' identified by 'Root1.pwd';"
else
    service mysqld start
fi

/etc/init.d/redis start
/usr/local/php/sbin/php-fpm
/usr/local/openresty/nginx/sbin/nginx

exec "/bin/bash"