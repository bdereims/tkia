#!/bin/bash
#bdereims@vmware.com
#
# $1: namespace
# $2: service to patch

kubectl patch svc ${2} -n ${1} -p '{"spec": {"type": "LoadBalancer"}}'
