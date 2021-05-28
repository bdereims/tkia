#!/bin/bash
#bdereims@vmware.com

. ../env

export KUBECTL_VSPHERE_PASSWORD=${PASSWORD}

echo ${TANZU_PASSWORD}
kubectl vsphere login --insecure-skip-tls-verify --server ${SUPERVISOR} --vsphere-username ${TANZU_USER}
