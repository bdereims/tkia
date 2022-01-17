#!/bin/bash
#bdereims@vmware.com

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
kubectl create namespace kubeapps
helm install kubeapps --namespace kubeapps bitnami/kubeapps

kubectl -n kubeapps create serviceaccount kubeapps-operator
kubectl create clusterrolebinding kubeapps-operator --clusterrole=cluster-admin --serviceaccount=kubeapps:kubeapps-operator
