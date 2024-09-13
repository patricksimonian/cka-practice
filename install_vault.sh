#!/bin/bash
cd "$HOME" || return

mkdir -p helm/vault

cd helm/vault || return

helm repo add hashicorp https://helm.releases.hashicorp.com

helm install vault hashicorp/vault --set='ui.enabled=true' --set='ui.serviceType=LoadBalancer' --namespace vault --create-namespace

# wait for vault to be ready

kubectl wait --for=condition=ready pod/vault-0 -n vault --timeout=60s