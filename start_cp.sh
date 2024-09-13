#!/bin/bash
# starts up the kubelet
cp_name=$(hostname)
worker=ckacw01
sudo swapoff -a

sudo modprobe overlay
sudo modprobe br_netfilter

## 
sudo systemctl start crio
sudo systemctl start kubelet

kubectl uncordon $cp_name
# worker 1
kubectl uncordon $worker