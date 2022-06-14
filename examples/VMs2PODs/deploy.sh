#!/bin/bash -e
#bdereims@vmware.com

. ./env

EXIST=$(kubectl get namespaces -o json | jq -r ".items[] | select(.metadata.name==\"${NAMESPACE}\") | .metadata.name")
if [ "X${EXIST}" != "X" ]; then
	kubectl delete namespace ${NAMESPACE}
fi

kubectl create namespace ${NAMESPACE}

YAMLS="secret.yaml front-end.yaml netpolicy.yaml"

for FILE in ${YAMLS} ; do
	echo "--- Applying ${FILE}"
	./kubectl_apply.sh ${FILE}
done

exit 0
