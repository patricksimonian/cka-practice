#!/bin/bash
# SWAP off must always run when system restarts
sudo swapoff -a

sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

IP=$1
TOKEN=$2
DISCOVERY_TOKEN_CA_CERT_HASH=$3

kubeadm join $IP:6443 --token $TOKEN \
        --discovery-token-ca-cert-hash $DISCOVERY_TOKEN_CA_CERT_HASH
