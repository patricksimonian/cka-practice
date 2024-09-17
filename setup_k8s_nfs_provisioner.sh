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




helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm repo update

helm install nfs-client nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --set "nfs.server=$NFS_HOST" \
  --set "nfs.path=$NFS_PATH"
