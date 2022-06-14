#!/bin/bash

URL=$(kubectl -n ${USER} get svc -o json | jq '.items[] | select(.metadata.name=="nginx-service") | .status.loadBalancer.ingress[].ip' | sed "s/\"//g")

while true
do
	wget -q -O- http://${URL}/list.php
done
