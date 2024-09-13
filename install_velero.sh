#!/bin/bash

VERSION=$1

cd $HOME

if [ -z "$VERSION" ]; then
  echo "PANIC! Version was not included as positional argument 1"
  exit 2
fi 

curl -fSL -o velero-$VERSION-linux-amd64.tar.gz https://github.com/vmware-tanzu/velero/releases/download/$VERSION/velero-$VERSION-linux-amd64.tar.gz

echo "untarring velero-$VERSION-linux-amd64.tar.gz"

tar -xvf velero-$VERSION-linux-amd64.tar.gz

echo "done"

ls 