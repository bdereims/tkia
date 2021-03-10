#!/bin/bash
#bdereims@vmware.com

# $1 : namespace
# $2 : sc name

#kubectl -n ${1} patch storageclass ${2} -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
kubectl patch storageclass ${2} -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
