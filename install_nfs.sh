#!/bin/bash
# Installs and configures an nfs volume on a target server
VG_NAME=$1
SIZE=$2
LV_NAME=$3

if [ -z "$VG_NAME" ]; then
    echo "Volume Group not provided"
    echo "here are the following Volume Groups available"
    sudo vgs
    exit 0
fi
if [ -z "$LV_NAME" ]; then
    LV_NAME=nfs
fi

if [ -z "$SIZE" ]; then
    SIZE="1g"
fi


# Check if the logical volume exists
if sudo lvdisplay "/dev/$VG_NAME/$LV_NAME" > /dev/null 2>&1; then
    echo "Logical volume $LV_NAME exists."
else
    echo "Logical volume $LV_NAME does not exist."
    echo "Creating..."
    echo "Logical Volume"
    sudo lvcreate -n "$LV_NAME" -L "$SIZE" "$VG_NAME"
    echo "Making filesystem at /dev/$VG_NAME/$LV_NAME"
    sudo mkfs.xfs "/dev/$VG_NAME/$LV_NAME"
fi
FSTAB_ENTRY="/dev/$VG_NAME/$LV_NAME   /media/$LV_NAME xfs defaults 0 0"
FSTAB_PATH=/etc/fstab
if ! sudo grep -qF "$FSTAB_ENTRY" "$FSTAB_PATH"; then 
  echo "Creating fstab entry"
  echo "#k8s mount point" | sudo tee -a "$FSTAB_PATH"
  echo "$FSTAB_ENTRY" | sudo tee -a "$FSTAB_PATH"
else
  echo "fstab entry already exists"
fi

sudo mkdir -p "/media/$LV_NAME"
echo "mounting /media/$LV_NAME"
sudo mount "/media/$LV_NAME"

df -hT "/media/$LV_NAME"

sudo apt install nfs-kernel-server -y



ENTRY="/media/$LV_NAME		192.168.1.0/24(rw,sync,no_subtree_check)"

# File to check
EXPORTS_FILE="/etc/exports"

# Check if the entry exists in the file
if ! grep -qF "$ENTRY" "$EXPORTS_FILE"; then
    echo "$ENTRY" | sudo tee -a "$EXPORTS_FILE"
    echo "Entry added to $EXPORTS_FILE"
else
    echo "Entry already exists in $EXPORTS_FILE"
fi

sudo systemctl enable --now nfs-server
sudo systemctl restart nfs-server
sudo chown -R nobody:nogroup "/media/$LV_NAME"
