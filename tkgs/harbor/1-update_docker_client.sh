#!/bin/bash
#bdereims@vmware.com

. ./env

sudo mkdir -p /etc/docker/certs.d/${HARBOR}
sudo curl -o /etc/docker/certs.d/${HARBOR}/ca.crt --insecure https://${HARBOR}/api/systeminfo/getcert

sudo systemctl restart docker

docker pull nginx
docker tag nginx ${HARBOR}/${NAMESPACE}/nginx:latest

printf "${PASSWORD}" | docker login ${HARBOR} -u ${USER} --password-stdin

docker push ${HARBOR}/${NAMESPACE}/nginx:latest
