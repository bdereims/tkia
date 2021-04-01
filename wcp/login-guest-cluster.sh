#!/bin/bash
#bdereims@vmware.com

# Args: <Cluster_Namespace> <Cluster_Name>

. ../env

export KUBECTL_VSPHERE_PASSWORD=${PASSWORD}

[ "$1" == "" -o "$2" == "" ] && printf "\nIt needs to provide <Cluster_Namespace> and <Cluster_Name>.\n\n" && exit 1

echo ${TANZU_PASSWORD}
kubectl vsphere login --insecure-skip-tls-verify --server ${SUPERVISOR}  --vsphere-username ${TANZU_USER} --tanzu-kubernetes-cluster-name ${2} --tanzu-kubernetes-cluster-namespace ${1} 
