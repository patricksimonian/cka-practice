#!/bin/bash

NFS_HOST=$1
NFS_PATH=$2


if [ -z "$NFS_HOST" ]; then 
    echo "$NFS_HOST does not exist try ./setup_k8s_nfs_provisioner.sh <HOST> <NFS_PATH>"
    exit 1
fi

if [ -z "$NFS_PATH" ]; then 
    echo "$NFS_PATH does not exist try ./setup_k8s_nfs_provisioner.sh <HOST> <NFS_PATH>"
    exit 1
fi

sudo apt install nfs-common -y

MOUNT_PATH=/mnt/nfs
sudo mkdir -p $MOUNT_PATH
sudo mount "$NFS_HOST:$NFS_PATH" $MOUNT_PATH
