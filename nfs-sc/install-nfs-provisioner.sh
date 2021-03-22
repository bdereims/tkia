#!/bin/bash
#bdereims@vmware.com

NFS_SERVER=$1
NFS_SHARE=$2
NFS_PROVIONER=nfs-provisioner

helm repo add ckotzbauer https://ckotzbauer.github.io/helm-charts
helm repo update

kubectl create ns ${NFS_PROVIONER}
helm install ${NFS_PROVIONER} -n ${NFS_PROVIONER} --set nfs.server=${NFS_SERVER} --set nfs.path=${NFS_SHARE} ckotzbauer/nfs-client-provisioner
