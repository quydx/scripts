#!/bin/bash
set -e
USER=root
echo $USER
list_host=("192.168.158.48 192.168.158.64")
# list_host="10.0.0.7 10.0.0.8 10.0.0.9"
for host in ${list_host[*]};do
  echo "'$host'"
  scp /etc/kubernetes/pki/ca.crt "${USER}"@$host:/etc/kubernetes/pki
  scp /etc/kubernetes/pki/ca.key "${USER}"@$host:/etc/kubernetes/pki
  scp /etc/kubernetes/pki/sa.key "${USER}"@$host:/etc/kubernetes/pki
  scp /etc/kubernetes/pki/sa.pub "${USER}"@$host:/etc/kubernetes/pki
  scp /etc/kubernetes/pki/front-proxy-ca.crt "${USER}"@$host:/etc/kubernetes/pki
  scp /etc/kubernetes/pki/front-proxy-ca.key "${USER}"@$host:/etc/kubernetes/pki
done
