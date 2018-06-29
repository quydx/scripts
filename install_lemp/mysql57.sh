wget http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
yum localinstall mysql57-community-release-el7-7.noarch.rpm
yum install mysql-community-server
systemctl enable msqld
systemctl start mysqld
tail /var/log/mysqld.log
mysql_secure_installation