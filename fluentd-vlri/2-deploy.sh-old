#!/bin/bash
#bdereims@vmware.com

. ./env

kubectl_apply() {
eval "cat <<EOF
$(<$1)
EOF" | kubectl apply -f -
}

kubectl_apply fluentd-configmap.yaml
kubectl apply -f fluentd-cluster-role.yaml
kubectl_apply fluentd-daemonset.yaml

watch -n1 kubectl -n kube-system get pods
