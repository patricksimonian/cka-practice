#!/bin/bash
user=k8stest
pass='Password12!@'
sudo useradd -m -d /home/$user $user
sudo echo "$user:$pass" | chpasswd
usermod -aG sudo $user

su -l k8stest
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config