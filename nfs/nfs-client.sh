#!/bin/bash
set -e 

yum install nfs-utils -y

mkdir -p /mnt/nfs/gitlabdata

mount -t nfs 172.28.48.4:/var/gitlabdata /mnt/nfs/gitlabdata

