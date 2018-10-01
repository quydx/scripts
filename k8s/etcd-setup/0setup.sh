#!/bin/bash

set -e
echo "[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg" >> /etc/yum.repos.d/kubernetes.repo

yum install kubectl-1.11.1-0 kubelet-1.11.1-0 kubeadm-1.11.1-0

sysctl net.bridge.bridge-nf-call-ip6tables=1
sysctl net.bridge.bridge-nf-call-iptables=1
sysctl net.ipv4.ip_forward = 1
sysctl -p

echo k8s01 192.168.158.216 >> /etc/hosts
echo k8s02 192.168.158.217 >> /etc/hosts
echo k8s03 192.168.158.218 >> /etc/hosts
echo k8slb 192.168.158.218 >> /etc/hosts

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

sysctl --system









