#!/bin/bash
#bdereims@vmware.com

kubectl create ns octant
kubectl -n octant create configmap octant-config --from-file ~/.kube/config
kubectl -n octant apply -f octant.yaml
