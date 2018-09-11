#!/bin/bash
set -e 
sudo yum check-update
if [ ! -x /usr/bin/curl ]; then
  sudo yum install curl -y
fi
curl -fsSL https://get.docker.com/ | sh
sudo systemctl start docker
sudo systemctl enable docker


sudo yum install epel-release -y
sudo yum install -y python-pip
sudo pip install docker-compose
