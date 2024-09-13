#!/bin/sh

## First you need to get etcd info
echo "Running ETCD BACKUP"
echo "creating a temp configmap of etcd cert files. They require reader permissions for the account that is creating the configmap"

kubectl create configmap etcd-certs-temp \
  --from-file=ca.crt=/etc/kubernetes/pki/etcd/ca.crt \
  --from-file=etcd.crt=/etc/kubernetes/pki/etcd/server.crt \
  --from-file=etcd.key=/etc/kubernetes/pki/etcd/server.key

TIMESTAMP=$(date +%F)
TIMEOUT=$1

if [ -z "$TIMEOUT" ];then
    printf "Setting Timeout to 30s to wait for pod to be completed by default\n This can be adjusted by running ./backup_etcd.sh 250s \n"
    TIMEOUT=30s
fi

## use etcdctl
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: etcd-backup-$TIMESTAMP
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
          etcdctl snapshot save /backup/etcd_backup_$TIMESTAMP.db \
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
echo "waiting for pod to be complete"
kubectl logs "etcd-backup-$TIMESTAMP" -f
# kubectl wait --for=condition=complete "pod/etcd-backup-$TIMESTAMP" --timeout=$TIMEOUT

echo "======RESULTS====="
kubectl delete configmap/etcd-certs-temp

echo "Backup Completed, you may delete the pod by running kubectl delete pod/etcd-backup-$TIMESTAMP"
