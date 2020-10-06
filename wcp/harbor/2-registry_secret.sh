#!/bin/bash
#bdereims@vmware.com

. ./env

kubectl -n ${NAMESPACE} create secret docker-registry regsecret --docker-server=https://${HARBOR} --docker-username=${USER} --docker-password="${PASSWORD}" --docker-email=${USER}
