#!/bin/bash
set -e
wget http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
yum localinstall mysql57-community-release-el7-7.noarch.rpm -y
yum install mysql-community-server -y
systemctl enable mysqld
systemctl start mysqld
cat /var/log/mysqld.log | grep pass
# mysql_secure_installation

