#!/bin/sh

## First you need to get etcd info
kubectl describe -n kube-system pod etcd-ckacp01 | grep file 

echo "creating a temp configmap of those files"

kubectl create configmap etcd-certs-temp \
  --from-file=ca.crt=/etc/kubernetes/pki/etcd/ca.crt \
  --from-file=etcd.crt=/etc/kubernetes/pki/etcd/server.crt \
  --from-file=etcd.key=/etc/kubernetes/pki/etcd/server.key


## use etcdctl
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: etcd-backup
spec:
  restartPolicy: Never   
  securityContext:
    runAsUser: 0
  containers:
    - name: etcd-backup
      image: bitnami/etcd:latest
      volumeMounts:
        - name: backup-storage
          mountPath: /backup
        - name: etcd-certs
          mountPath: /etc/etcd
      command:
        - /bin/sh
        - -c
        - |
          etcdctl snapshot save /backup/etcd_backup_$(date +%F).db \
            --endpoints=https://192.168.1.237:2379 \
            --cacert=/etc/etcd/ca.crt \
            --cert=/etc/etcd/etcd.crt \
            --key=/etc/etcd/etcd.key
  volumes:
    - name: backup-storage
      emptyDir: {}
    - name: etcd-certs
      configMap:
        name: etcd-certs-temp

EOF


# TO DO
# check if pod is complete
# output log info
# delete configmap
