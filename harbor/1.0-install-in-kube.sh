#!/bin/bash
#bdereims@vmware.com

. ./env

# Needs Helm v3
# Retrieve ca.crt from Harbor UI -> under project -> registry certificat
# Or launch next script

helm repo add harbor https://helm.goharbor.io
kubectl create ns harbor

helm install harbor harbor/harbor -f values.yaml -n harbor

#kubectl -n harbor get secret harbor-core -o json | jq ".data.\"tls.crt\"" -r | base64 -d > ~/harbor-ca.crt
#openssl s_client -showcerts -connect  harbor.${DOMAIN}:443 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ~/harbor-ca.crt
