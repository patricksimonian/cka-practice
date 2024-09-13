#!/bin/bash
workers=$(cat << EOF
192.168.1.123
EOF
)

PASSWORD=$1
for worker in $workers
do
  sshpass -p $PASSWORD scp /home/patrick/.kube/config patrick@$worker:/home/patrick/.kube/config
done 