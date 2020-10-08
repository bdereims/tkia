#!/bin/bash
#bdereims@vmware.com

. ./env

git clone https://github.com/vmware/fluent-plugin-vmware-loginsight
cd fluent-plugin-vmware-loginsight/examples
cp -r ../lib/fluent/plugin plugins 
docker build --no-cache --file fluentd-vrli-plugin-debian.dockerfile . --tag ${REGISTRY}/library/log-collector:latest
cd ../..
rm -fr fluent-plugin-vmware-loginsight

echo ${REGISTRY_PASSWORD} | docker login ${REGISTRY}
docker push ${REGISTRY}/library/log-collector:latest
