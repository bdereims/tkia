#!/bin/bash
#bdereims@vmware.com

. ./env

docker build . --tag ${REGISTRY}/${PROJECT}/${IMAGE_NAME}:${IMAGE_RELEASE}

echo ${REGISTRY_PASSWORD} | docker login ${REGISTRY}
docker push ${REGISTRY}/${PROJECT}/${IMAGE_NAME}:${IMAGE_RELEASE}
