#!/bin/bash
#bdereims@vmware.com

. ./env

kubectl -n ${NAMESPACE} create deployment nginx --image=${HARBOR}/${NAMESPACE}/nginx:latest
kubectl -n ${NAMESPACE} patch deployment nginx -p '{"spec": {"template": {"spec": {"imagePullSecrets": [ {"name": "regsecret" } ] }}}}'
kubectl -n ${NAMESPACE} expose deployment nginx --port=80 --type=LoadBalancer
