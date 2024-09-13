#!/bin/bash

UPGRADE_VERSION=$1

if [ -z "$UPGRADE_VERSION" ]; then
  echo "PANIC!! UPGRADE_VERSION not set as positional param 1. Try something like 1.28.3-00"
  exit 1
fi 

echo "unholding kubeadm"
sudo apt-mark unhold kubeadm && apt-get update && apt-get install -y kubeadm="$UPGRADE_VERSION"
apt-mark hold kubeadm

kubeadm version

echo "performing upgrade"

sudo kubeadm upgrade apply "v${UPGRADE_VERSION}"