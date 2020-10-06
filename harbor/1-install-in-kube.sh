#!/bin/bash
#bdereims@vmware.com

. ./env

# Needs Helm v3
# Retrieve ca.crt from Harbor UI -> under project -> registry certificat
# Or launch next script

helm repo add harbor https://helm.goharbor.io
kubectl create ns harbor

helm install harbor harbor/harbor \
--set expose.type=loadBalancer \
--set expose.tls.auto.commonName=harbor.${DOMAIN} \
--set externalURL=https://harbor.${DOMAIN} \
--set harborAdminPassword=${PASSWORD} \
-n harbor

