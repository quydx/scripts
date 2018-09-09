#!/bin/bash
set -e
wget http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
yum localinstall mysql57-community-release-el7-7.noarch.rpm -y
yum install mysql-community-server -y
systemctl enable mysqld
systemctl start mysqld
cat /var/log/mysqld.log | grep 

cp /etc/my.cnf /etc/my.cnf.bak
cp ./my.cnf /etc/my.cnf

systemctl restart mysqld

get_pri_ip () {
  ip=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | tail -n1)
}


check_exist (){
  echo "#1 is '$1'"
  echo "#2 is '$2'"
  if grep -qe $1 $2; then
	  if grep -qe "^#$1" $2; then
	    echo "0"
	  else
	    echo "1"
	  fi
  else
	  echo "false"
  fi
}

replace_conf () {
  # $1 and $2 is param and value of param
  # $3 is file
  exist=$(check_exist "$1" $3)
  if [[ "$exist" = "false" ]];then
    echo "$1 = $2" >> $3
  elif [[ "$exist" = "1" ]];then
    sed -i "s/^\($1\s*=\s*\).*$/\1$2/" $3
  elif [[ "$exist" = "0" ]];then
    # change val 
    sed -i "s/^\($1\s*=\s*\).*$/\1$2/" $3
    #uncomment the line
    sed -i "/^#.* $1 /s/^#//" $3
  fi
}


