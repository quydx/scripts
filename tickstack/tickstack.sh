#!/bin/bash

echo "[influxdb]
name = InfluxData Repository - RHEL \$releasever
baseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdb.key" >> /etc/yum.repos.d/influxdata.repo

sudo yum install influxdb -y 
sudo systemctl start influxdb
influx -execute 'CREATE USER "$1" WITH PASSWORD '"'"'$2'"'"' WITH ALL PRIVILEGES'
influx -execute 'show users'
sed -i "/#auth-enabled/c\auth-enabled = true" /etc/influxdb/influxdb.conf
sudo systemctl restart influxdb
sudo yum install telegraf -y
cp /etc/telegraf/telegraf.conf /etc/telegraf/telegraf.conf.bak
cp telegraf.conf /etc/telegraf/telegraf.conf
sudo systemctl start telegraf
influx -username '$1' -password '$2' -execute 'show databases'
sudo yum install kapacitor -y
cp /etc/kapacitor/kapacitor.conf /etc/kapacitor/kapacitor.conf.bak
cp kapacitor.conf /etc/kapacitor/kapacitor.conf
# sed -i "/username/c\username = \"<user>\"" /etc/kapacitor/kapacitor.conf
# sed -i "/password/c\password = \"<passwd>\"" /etc/kapacitor/kapacitor.conf
sudo systemctl daemon-reload
sudo systemctl start kapacitor
wget https://dl.influxdata.com/chronograf/releases/chronograf-1.5.0.1.x86_64.rpm
sudo yum localinstall chronograf-1.2.0~beta3.x86_64.rpm
sudo systemctl start chronograf
