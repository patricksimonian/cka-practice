#!/bin/bash
set -o pipefail
UPGRADE_VERSION=$1
PASSWORD=$2
if [ -z "$UPGRADE_VERSION" ]; then
  echo "PANIC!! UPGRADE_VERSION not set as positional param 1. Try something like 1.28.3-00"
  exit 1
fi 

workers=(
ckacw01
)

for worker in "${workers[@]}"
do
kubectl drain "$worker" --ignore-daemonsets

sshpass -p $PASSWORD ssh "patrick@$worker" << EOF

sudo apt-mark unhold kubelet kubectl
sudo apt-get update 
sudo apt-get install -y kubelet=$UPGRADE_VERSION kubectl=$UPGRADE_VERSION
sudo apt-mark hold kubelet kubectl
sudo systemctl daemon-reload
EOF
done