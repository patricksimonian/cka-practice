#!/bin/bash
# shuts down the kubelet
cp_name=$(hostname)


kubectl cordon $cp_name
kubectl drain $cp_name --ignore-daemonsets --delete-emptydir-data


## 
sudo systemctl stop kubelet
sudo systemctl stop crio
sudo systemctl stop etcd
sudo shutdown now