#!/bin/bash
echo "[influxdb]
name = InfluxData Repository - RHEL $releasever
baseurl = https://repos.influxdata.com/rhel/$releasever/$basearch/stable
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdb.key" >> /etc/yum.repos.d/influxdata.repo

sudo yum install influxdb -y 
sudo systemctl start influxdb
influx -execute 'CREATE USER "vega" WITH PASSWORD '"'"'Vega123312##'"'"' WITH ALL PRIVILEGES'
influx -execute 'show users'
sed -i "/#auth-enabled/c\auth-enabled = true" /etc/influxdb/influxdb.conf
sudo systemctl restart influxdb
sudo yum install telegraf
cp /etc/telegraf/telegraf.conf /etc/telegraf/telegraf.conf.bak
sed -i "/username/c\username = \"vega\"" /etc/telegraf/telegraf.conf
sed -i "/password/c\password = \"Vega123312##\"" /etc/telegraf/telegraf.conf
sudo systemctl start telegraf
influx -username 'vega' -password 'Vega123312##' -execute 'show databases'
sudo yum install kapacitor
cp /etc/kapacitor/kapacitor.conf /etc/kapacitor/kapacitor.conf.bak
sed -i "/username/c\username = \"vega\"" /etc/kapacitor/kapacitor.conf
sed -i "/password/c\password = \"Vega123312##\"" /etc/kapacitor/kapacitor.conf
sudo systemctl daemon-reload
sudo systemctl start kapacitor
wget https://dl.influxdata.com/chronograf/releases/chronograf-1.2.0~beta3.x86_64.rpm
sudo yum localinstall chronograf-1.2.0~beta3.x86_64.rpm
sudo systemctl start chronograf
