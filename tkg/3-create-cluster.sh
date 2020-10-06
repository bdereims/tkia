#!/bin/bash
#bdereims@vmware.com

. ./password
. ./env

NAME=prodcluster
PLAN=prod
KUBE=v1.18.2+vmware.1
CTLPLANE=3
WORKER=1

export NAMESERVER="172.23.3.1"
export DOMAIN="cpod-vs67u3.az-rbx.cloud-garage.net"

tkg create cluster ${NAME} --plan ${PLAN} --kubernetes-version ${KUBE} --controlplane-machine-count ${CTLPLANE}  --worker-machine-count ${WORKER}
