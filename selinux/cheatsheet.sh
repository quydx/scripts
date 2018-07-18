#!/bin/bash

## check selinux status 
sestatus 

## disable selinux temporarily

echo 0 > /selinux/enforce
setenforce 0
setenforce Permissive

## disable selinux forever 

## vim /etc/sysconfig/selinux
##SELINUX=enforcing
##SELINUX=disabled