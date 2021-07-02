#!/bin/bash -e
#bdereims@vmware.com

. ./env

#EXIST=$(kubectl get namespaces -o json | jq -r ".items[] | select(.metadata.name==\"${NAMESPACE}\") | .metadata.name")
#if [ "X${EXIST}" != "X" ]; then
#	kubectl delete namespace ${NAMESPACE}
#fi

#kubectl create namespace ${NAMESPACE}

#YAMLS="secret.yaml back-end.yaml front-end.yaml"
YAMLS="secret.yaml front-end.yaml"

for FILE in ${YAMLS} ; do
	echo "--- Applying ${FILE}"
	./kubectl_apply.sh ${FILE}
done

#./kubectl_apply.sh secret.yaml 
#./kubectl_apply.sh back-end.yaml
#./kubectl_apply.sh front-end.yaml

exit 0
