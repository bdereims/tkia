#!/bin/bash
#bdereims@vmware.com

###

DOMAIN="cpod-services.az-fkd.cloud-garage.net"
SUBJET="/C=FR/ST=Paris/L=Paris/O=cloud-garage/OU=services/CN=${DOMAIN}"

###
echo "=== Pre-requisite : docker engine and a clean /etc/systemd/scripts/iptable without DROP"
echo " "

echo "=== Install docker-compose"

sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "=== Generate cert"

openssl genrsa -out ca.key 4096

openssl req -x509 -new -nodes -sha512 -days 3650 \
-subj "${SUBJET}" \
-key ca.key \
-out ca.crt

openssl genrsa -out ${DOMAIN}.key 4096

openssl req -sha512 -new \
-subj "${SUBJET}" \
-key ${DOMAIN}.key \
-out ${DOMAIN}.csr

cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=${DOMAIN}
DNS.2=harbor
EOF

openssl x509 -req -sha512 -days 3650 \
-extfile v3.ext \
-CA ca.crt -CAkey ca.key -CAcreateserial \
-in ${DOMAIN}.csr \
-out ${DOMAIN}.crt

mkdir -p /data/cert

cp ${DOMAIN}.crt /data/cert/
cp ${DOMAIN}.key /data/cert/

openssl x509 -inform PEM -in ${DOMAIN}.crt -out ${DOMAIN}.cert

mkdir -p /etc/docker/certs.d/${DOMAIN}

cp ${DOMAIN}.cert /etc/docker/certs.d/${DOMAIN}/
cp ${DOMAIN}.key /etc/docker/certs.d/${DOMAIN}/
cp ca.crt /etc/docker/certs.d/${DOMAIN}/

cat > /etc/docker/daemon.json <<-EOF
{
  "bip": "172.31.0.1/16"
}
EOF

systemctl restart docker

wget https://github.com/goharbor/harbor/releases/download/v2.1.1/harbor-online-installer-v2.1.1.tgz

echo ""
echo "=== Copy and edit harbor.yaml and execute in harbor dir :  ./prepare --with-trivy --with-clair"
echo "=== And execute : docker-compose up -d"
