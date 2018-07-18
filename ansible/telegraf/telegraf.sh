#!/bin/bash
set -e
echo "[influxdb]
name = InfluxData Repository - RHEL \$releasever
baseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdb.key" >> /etc/yum.repos.d/influxdata.repo

sudo yum install telegraf -y 
mv /etc/telegraf/telegraf.conf /etc/telegraf/telegraf.conf.ori
cp -r conf/* /etc/telegraf/conf.d/ 
cp telegraf.conf /etc/telegraf/
sudo systemctl enabled telegraf
sudo systemctl start telegraf