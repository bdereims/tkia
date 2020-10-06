#!/bin/bash
#bdereims@vmware.com

. ./env

sudo mkdir -p  /etc/docker/certs.d/harbor.${DOMAIN}
sudo curl -sk https://harbor.${DOMAIN}/api/v2.0/systeminfo/getcert -o /etc/docker/certs.d/harbor.${DOMAIN}/ca.crt

sudo systemctl restart docker

echo ${PASSWORD} | docker login -u admin --password-stdin harbor.${DOMAIN}
