#!/bin/bash
set -e
function hasFile {
  if [ -f "$1" ];then
    echo "true"
  else
    echo "false"
  fi
}
influx_repo_file="/etc/yum.repos.d/influxdata.repo"
repo_existed=$(hasFile $influx_repo_file)
if [ "$repo_existed" == "true" ];then
  touch $influx_repo_file
fi
echo "[influxdb]
name = InfluxData Repository - RHEL \$releasever
baseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdb.key" > /etc/yum.repos.d/influxdata.repo

sudo yum install telegraf -y
if [ -f /etc/telegraf/telegraf.conf ];then
  mv /etc/telegraf/telegraf.conf /etc/telegraf/telegraf.conf.ori
fi
if [ -d /etc/telegraf/telegraf.d/ ];then
  cp -r ~/conf/* /etc/telegraf/telegraf.d/
fi
cp ~/telegraf.conf /etc/telegraf/
sudo systemctl enable telegraf
sudo systemctl start telegraf