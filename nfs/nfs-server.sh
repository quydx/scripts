#!/bin/bash
set -e 

yum install nfs-utils -y

mkdir /var/gitlabdata
chmod -R 755 /var/gitlabdata
chown nfsnobody:nfsnobody /var/gitlabdata

systemctl enable rpcbind
systemctl enable nfs-server
systemctl enable nfs-lock
systemctl enable nfs-idmap
systemctl start rpcbind
systemctl start nfs-server
systemctl start nfs-lock
systemctl start nfs-idmap

echo "" > /etc/exports
echo "/var/gitlabdata    172.28.48.10(rw,sync,no_root_squash,no_all_squash)" >> /etc/exports
systemctl restart nfs-server
