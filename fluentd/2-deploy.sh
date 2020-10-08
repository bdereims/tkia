#!/bin/bash
#bdereims@vmware.com

. ./env

REGISTRY=harbor.${DOMAIN}

kubectl apply -f fluentd-configmap.yaml -n kube-system
kubectl apply -f fluentd-cluster-role.yaml
kubectl apply -f fluentd-daemonset.yaml
