#!/bin/bash
set -e
wget http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
yum localinstall mysql57-community-release-el7-7.noarch.rpm
yum install mysql-community-server -y
systemctl enable mysqld
systemctl start mysqld
mysql_secure_installation