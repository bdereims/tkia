#!/bin/bash
#bdereims@vmware.com

. ./env

REGISTRY=harbor.${DOMAIN}

git clone https://github.com/vmware/fluent-plugin-vmware-loginsight
cd fluent-plugin-vmware-loginsight/examples
docker build --no-cache --file fluentd-vrli-plugin-photon-tdnf.dockerfile . --tag ${REGISTRY}/library/vrli:latest
rm -fr fluent-plugin-vmware-loginsight

echo 4{REGISTRY_PASSWORD} | docker login ${REGISTRY}
docker push  ${REGISTRY}/library/vrli:1
