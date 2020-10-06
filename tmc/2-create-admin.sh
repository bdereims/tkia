#!/bin/bash
#bdereims@gmail.com

kubectl create -n kube-system serviceaccount admin
kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --user=admin --group=system:serviceaccounts

export SECRET_NAME=$( kubectl -n kube-system get serviceaccount admin  -o json | jq -Mr '.secrets[].name' )
export TOKEN=$( kubectl -n kube-system get secrets ${SECRET_NAME} -o json | jq -Mr '.data.token' | base64 -D )
export MASTER_URL=$( kubectl config view --raw -o json | jq -Mr '.clusters[].cluster.server' )

echo "---"
echo "URL: ${MASTER_URL}"
echo ""
echo "Taken: ${TOKEN}"
echo ""

exit 0
