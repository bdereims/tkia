#!/bin/bash
#bdereims@vmware.com

# Delete Namspace specified as $1
# Need a kubectl proxy in background task

kubectl get ns ${1} -o json | \
  jq '.spec.finalizers=[]' | \
  curl -X PUT http://localhost:8001/api/v1/namespaces/${1}/finalize -H "Content-Type: application/json" --data @-

