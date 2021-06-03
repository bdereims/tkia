#!/bin/bash
#bdereims@vmware.com

kubectl_apply() {
eval "cat <<EOF
$(<$1)
EOF" | kubectl apply -f -
}

### StorageClass
STORAGE_CLASS="TKG Storage Policy"
kubectl_apply storge-class.yaml

### Type LoadBalancer
NAMESPACE=metallb-system
kubectl create namespace ${NAMESPACE} 
kubectl -n ${NAMESPACE} create secret generic memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl -n ${NAMESPACE} apply -f metallb-configmap.yaml 
kubectl -n ${NAMESPACE} apply -f https://raw.githubusercontent.com/google/metallb/v0.9.2/manifests/metallb.yaml

### Ingress Congtroller
kubectl apply -f https://projectcontour.io/quickstart/contour.yaml

### Metrics Server

