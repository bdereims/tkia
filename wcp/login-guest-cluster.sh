#!/bin/bash
#bdereims@vmware.com

# Args: <Cluster_Namespace> <Cluster_Name>

. ../env

kubectl vsphere login --insecure-skip-tls-verify --server ${SUPERVISOR}  --vsphere-username ${TANZU_USER} --tanzu-kubernetes-cluster-name ${2} --tanzu-kubernetes-cluster-namespace ${1} 
