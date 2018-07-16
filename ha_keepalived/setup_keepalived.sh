#!/bin/bash

set -e 

{
yum install gcc kernel-headers kernel-devel -y 
yum install keepalived -y
} &>/dev/null

mv /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.ori
cp keepalived_timor.conf /etc/keepalived/keepalived.conf