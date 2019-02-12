#!/bin/bash

set -e
echo "[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg" >> /etc/yum.repos.d/kubernetes.repo



sysctl net.bridge.bridge-nf-call-ip6tables=1
sysctl net.bridge.bridge-nf-call-iptables=1
sysctl net.ipv4.ip_forward=1
sysctl -p
sysctl --system


echo k8s-master01 192.168.158.216 >> /etc/hosts
echo k8s-master02 192.168.158.217 >> /etc/hosts
echo k8s-master03 192.168.158.218 >> /etc/hosts
echo k8slb 192.168.158.99 >> /etc/hosts

kubeadm config images pull --kubernetes-version=v1.11.1

docker pull quay.io/calico/typha:v0.7.4
docker pull quay.io/calico/node:v3.1.3
docker pull quay.io/calico/cni:v3.1.3

docker pull gcr.io/google_containers/metrics-server-amd64:v0.2.1

docker pull gcr.io/google_containers/kubernetes-dashboard-amd64:v1.8.3

docker pull k8s.gcr.io/heapster-amd64:v1.5.4
docker pull k8s.gcr.io/heapster-influxdb-amd64:v1.5.2
docker pull k8s.gcr.io/heapster-grafana-amd64:v5.0.4

docker pull nginx:latest

docker pull prom/prometheus:v2.3.1

docker pull traefik:v1.6.3

docker pull docker.io/jaegertracing/all-in-one:1.5
docker pull docker.io/prom/prometheus:v2.3.1
docker pull docker.io/prom/statsd-exporter:v0.6.0
docker pull gcr.io/istio-release/citadel:1.0.0
docker pull gcr.io/istio-release/galley:1.0.0
docker pull gcr.io/istio-release/grafana:1.0.0
docker pull gcr.io/istio-release/mixer:1.0.0
docker pull gcr.io/istio-release/pilot:1.0.0
docker pull gcr.io/istio-release/proxy_init:1.0.0
docker pull gcr.io/istio-release/proxyv2:1.0.0
docker pull gcr.io/istio-release/servicegraph:1.0.0
docker pull gcr.io/istio-release/sidecar_injector:1.0.0
docker pull quay.io/coreos/hyperkube:v1.7.6_coreos.0

swapoff -a
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config



yum install -y docker-compose-1.9.0-5.el7.noarch
yum install -y docker-ce-17.12.0.ce-0.2.rc2.el7.centos.x86_64
systemctl enable docker && systemctl start docker

yum install -y kubelet-1.11.1-0.x86_64 kubeadm-1.11.1-0.x86_64 kubectl-1.11.1-0.x86_64
systemctl enable kubelet && systemctl start kubelet


#yum install -y keepalived
#systemctl enable keepalived && systemctl restart keepalived


#touch /etc/sysconfig/network-scripts/fcfg-lo:1
# echo "DEVICE=lo:1
# IPADDR=192.168.158.99
# NETMASK=255.255.255.255
# ONBOOT=yes" >> /etc/sysconfig/network-scripts/fcfg-lo:1
















