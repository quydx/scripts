#!/bin/bash

set -e 

{
yum install gcc kernel-headers kernel-devel -y 
yum install keepalived -y

} &>/dev/null

mv /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.ori
# cp keepalived_timor.conf /etc/keepalived/keepalived.conf

systemctl enable keepalived
# systemctl start keepalived

#allow kernel binding non-local IP into the hosts and apply the changes
echo "net.ipv4.ip_nonlocal_bind = 1
net.ipv4.conf.eth0.arp_ignore = 1
net.ipv4.conf.eth0.arp_announce = 2
net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p