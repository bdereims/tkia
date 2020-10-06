#!/bin/bash
#bdereims@gmail.com

kubectl create serviceaccount api-service-account
kubectl apply -f clusterRole.yaml

export USER_UID=$( kubectl get sa api-service-account -o json | jq -Mr '.metadata.uid' )
export SECRET_NAME=$( kubectl get serviceaccount api-service-account  -o json | jq -Mr '.secrets[].name' )
export TOKEN=$( kubectl get secrets ${SECRET_NAME} -o json | jq -Mr '.data.token' | base64 -D )

echo "---"
echo "User UID: ${USER_UID}"
echo "Secret name: ${SECRET_NAME}"
echo "Taken: ${TOKEN}"

export CLUSTER_NAME=$( kubectl config view --raw -o json | jq -Mr '.clusters[].name' )
export MASTER_URL=$( kubectl config view --raw -o json | jq -Mr '.clusters[].cluster.server' )
export CERT_AUTH_DATA=$( kubectl config view --raw -o json | jq -Mr '.clusters[0].cluster."certificate-authority-data"' )

echo "---"
echo "Cluster name:${CLUSTER_NAME}"
echo "URL: ${MASTER_URL}"
echo "Certificate authority: ${CERT_AUTH_DATA}"

echo "---"
echo "Generating k8s config file..."
eval "echo \"$(cat config-template)\"" > config
echo "Done!"
echo "---"
cat config
