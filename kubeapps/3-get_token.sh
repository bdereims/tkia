#!/bin/bash
#bdereims@vmware.com

kubectl -n kubeapps get secret $(kubectl -n kubeapps get serviceaccount kubeapps-operator -o jsonpath='{range .secrets[*]}{.name}{"\n"}{end}' | grep kubeapps-operator-token) -o jsonpath='{.data.token}' -o go-template='{{.data.token | base64decode}}' && echo
