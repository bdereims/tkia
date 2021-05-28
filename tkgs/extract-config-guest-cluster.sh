#!/bin/bash
#bdereims@vmware.com

# Args: <Cluster_Namespace> <Cluster_Name>

. ../env

[ "$1" == "" -o "$2" == "" ] && printf "\nIt needs to provide <Cluster_Namespace> and <Cluster_Name>.\n\n" && exit 1

kubectl -n ${1} get secret ${2}-kubeconfig -o json | jq -r .data.value | base64 -d > ~/${1}-${2}.config && printf "\nConfig File: ~/${1}-${2}.config\n\n"
