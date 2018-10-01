#!/bin/bash

USER=root
echo $USER
HOST_LIST=("192.168.158.48" "192.168.158.64")
for host in ${HOST_LIST[*]};do
  echo $host
  scp -r /tmp/$host/* ${USER}@$host:
  ssh ${USER}@$host mv /root/pki /etc/kubernetes/
  ssh ${USER}@$host chown -R root:root /etc/kubernetes/pki
done
