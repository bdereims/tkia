#!/bin/bash
#bdereims@vmware.com

. ../env

# Needs Helm v3
# Retrieve ca.crt from Harbor UI -> under project -> registry certificat
# Or launch next script

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

kubectl create namespace harbor

helm install harbor bitnami/harbor \
--set expose.type=loadBalancer \
--set expose.tls.auto.commonName=harbor.${DOMAIN} \
--set externalURL=https://harbor.${DOMAIN} \
--set harborAdminPassword=${PASSWORD} \
--set service.tls.commonName=harbor.${DOMAIN} \
-n harbor

export SERVICE_IP=$(kubectl get svc --namespace harbor harbor --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
export PASSWORD=$(kubectl get secret --namespace harbor harbor-core-envvars -o jsonpath="{.data.HARBOR_ADMIN_PASSWORD}" | base64 --decode)

echo "@${SERVICE_IP}: ${PASSWORD}"
