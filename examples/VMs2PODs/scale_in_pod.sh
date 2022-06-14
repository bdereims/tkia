#!/bin/bash

. ./env

URL=$(kubectl -n ${NAMESPACE} get svc -o json | jq '.items[] | select(.metadata.name=="nginx-service") | .status.loadBalancer.ingress[].ip' | sed "s/\"//g")

kubectl -n ${NAMESPACE} run -ti --rm load-generator --image=busybox -- /bin/sh -c "while true; do wget -q -O- http://${URL}/list.php; done"
