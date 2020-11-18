#!/bin/bash
#bdereims@vmware.com

. ../env

echo ${TANZU_PASSWORD}
kubectl vsphere login --insecure-skip-tls-verify --server ${SUPERVISOR} --vsphere-username ${TANZU_USER}
