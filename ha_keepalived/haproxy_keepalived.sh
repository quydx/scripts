#!/bin/bash
set -e 
yum install haproxy -y
cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg_orig

os=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
echo "$os"

echo "net.ipv4.ip_nonlocal_bind=1" >> /etc/sysctl.conf
sysctl -p

systemctl enable haproxy
systemctl start haproxy