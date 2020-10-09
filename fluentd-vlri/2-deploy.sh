#!/bin/bash
#bdereims@vmware.com

. ./env

kubectl_apply() {
eval "cat <<EOF
$(<$1)
EOF" | kubectl apply -f -
}

kubectl_apply vrli.yaml 

watch -n1 kubectl -n kube-system get pods
