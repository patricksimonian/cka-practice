#!/bin/bash
# Run this script from your control plane node and target the worker node you want to join the cluster
# ARG 1 is the target worker node name or ip address
# ARG 2 is the password for the worker

JOIN_COMMAND=$(kubeadm token create --print-join-command)

TARGET_WORKER=$1
PASSWORD=$2

sshpass -p "$PASSWORD" ssh "patrick@$TARGET_WORKER" << EOF
# SWAP off must always run when system restarts
sudo swapoff -a

sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
$JOIN_COMMAND
EOF
