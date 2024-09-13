#!/bin/bash
# shuts down the kubelet
worker=$(hostname)


kubectl cordon $worker
kubectl drain $worker --ignore-daemonsets --delete-emptydir-data


## 
sudo systemctl stop kubelet
sudo systemctl stop crio
sudo shutdown now