#!/bin/bash
set -e
#!/bin/bash
set -e
wget http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
yum localinstall mysql57-community-release-el7-7.noarch.rpm -y
yum install mysql-community-server -y
systemctl enable mysqld
systemctl start mysqld
cat /var/log/mysqld.log | grep pass
get_pri_ip () {
  ip=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | tail -n1)
}

sed -i "s/^\(bind-address\s*=\s*\).*$/\1$1/" /etc/my.cnf
echo "server-id = 1" >> 
