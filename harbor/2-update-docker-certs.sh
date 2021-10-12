#!/bin/bash
#bdereims@vmware.com

. ../env

openssl s_client -showcerts -connect  harbor.${DOMAIN}:443 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ~/harbor-ca.crt

sudo mkdir -p  /etc/docker/certs.d/harbor.${DOMAIN}
#sudo curl -sk https://harbor.${DOMAIN}/api/v2.0/systeminfo/getcert -o /etc/docker/certs.d/harbor.${DOMAIN}/ca.crt
#scp root@harbor.${DOMAIN}:ca.crt /etc/docker/certs.d/harbor.${DOMAIN}/ca.crt
sudo cp ~/harbor-ca.crt /etc/docker/certs.d/harbor.${DOMAIN}/ca.crt

sudo systemctl restart docker

echo ${PASSWORD} | docker login -u admin --password-stdin harbor.${DOMAIN}
