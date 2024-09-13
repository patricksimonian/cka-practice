#!/bin/bash
# shuts down the kubelet
worker=$(hostname)


sudo swapoff -a

sudo modprobe overlay
sudo modprobe br_netfilter

## 
sudo systemctl start crio
sudo systemctl start kubelet
kubectl uncordon $worker
