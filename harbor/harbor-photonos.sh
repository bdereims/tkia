#!/bin/bash
#bdereims@vmware.com

### Install Harbor in PhotonOS

# $1: Domain
# $2: IP for SAN

### Check prerequisites 
uname -a | grep photon 2>&1 > /dev/null
if [ $? -ge 1 ]; then
	echo "Only for PhotonOS."
	exit 1
fi

[ "$1" == "" ] && echo "usage: $0 <Domain>" && exit 1

### Set variables
HOSTNAME="harbor"
DOMAIN="${1}"
IP=$( ip a show dev eth0 | grep "inet " | sed -e "s/^.*inet //" -e "s/\/.*$//" )
SUBJET="/C=FR/ST=Paris/L=Paris/O=cloud-garage/OU=services/CN=${HOSTNAME}.${DOMAIN}"

echo "${HOSTNAME}" > /etc/hostname
hostname ${HOSTNAME} 

### Let's go

tdnf -y install tar

echo "=== Install docker-compose"

curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "=== Generate cert"

openssl genrsa -out ca.key 4096

openssl req -x509 -new -nodes -sha512 -days 3650 \
-subj "${SUBJET}" \
-key ca.key \
-out ca.crt

openssl genrsa -out ${HOSTNAME}.${DOMAIN}.key 4096

openssl req -sha512 -new \
-subj "${SUBJET}" \
-key ${HOSTNAME}.${DOMAIN}.key \
-out ${HOSTNAME}.${DOMAIN}.csr

cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=${HOSTNAME}.${DOMAIN}
DNS.2=${IP}
EOF

openssl x509 -req -sha512 -days 3650 \
-extfile v3.ext \
-CA ca.crt -CAkey ca.key -CAcreateserial \
-in ${HOSTNAME}.${DOMAIN}.csr \
-out ${HOSTNAME}.${DOMAIN}.crt

mkdir -p /data/cert

cp ${HOSTNAME}.${DOMAIN}.crt /data/cert/
cp ${HOSTNAME}.${DOMAIN}.key /data/cert/

openssl x509 -inform PEM -in ${HOSTNAME}.${DOMAIN}.crt -out ${HOSTNAME}.${DOMAIN}.cert

mkdir -p /etc/docker/certs.d/${HOSTNAME}.${DOMAIN}

cp ${HOSTNAME}.${DOMAIN}.cert /etc/docker/certs.d/${HOSTNAME}.${DOMAIN}/
cp ${HOSTNAME}.${DOMAIN}.key /etc/docker/certs.d/${HOSTNAME}.${DOMAIN}/
cp ca.crt /etc/docker/certs.d/${HOSTNAME}.${DOMAIN}/

### Modify Docker daemon config because 172.17/16 often already allocated 
cat > /etc/docker/daemon.json <<-EOF
{
  "bip": "172.31.0.1/16"
}
EOF

cat > /lib/systemd/system/docker.service <<-EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
BindsTo=containerd.service
After=network-online.target containerd.service
Wants=network-online.target
Requires=docker.socket

[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutSec=0
RestartSec=2
Restart=always
Environment="HTTP_PROXY=${http_proxy}"
Environment="HTTPS_PROXY=${https_proxy}"
Environment="NO_PROXY=127.0.0.1"

# Note that StartLimit* options were moved from "Service" to "Unit" in systemd 229.
# Both the old, and new location are accepted by systemd 229 and up, so using the old location
# to make them work for either version of systemd.
StartLimitBurst=3

# Note that StartLimitInterval was renamed to StartLimitIntervalSec in systemd 230.
# Both the old, and new name are accepted by systemd 230 and up, so using the old name to make
# this option work for either version of systemd.
StartLimitInterval=60s

# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity

# Comment TasksMax if your systemd version does not support it.
# Only systemd 226 and above support this option.
TasksMax=infinity

# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes

# kill only the docker process, not all processes in the cgroup
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl restart docker

curl -L https://github.com/goharbor/harbor/releases/download/v2.2.2/harbor-online-installer-v2.2.2.tgz -o harbor.tgz
tar xvzf harbor.tgz
cd harbor
cp harbor.yml.tmpl harbor.yml
sed -i -e "s/reg.mydomain.com/${HOSTNAME}.${DOMAIN}/" harbor.yml
sed -i -e "s#/your/certificate/path#/data/cert/${HOSTNAME}.${DOMAIN}.crt#" harbor.yml
sed -i -e "s#/your/private/key/path#/data/cert/${HOSTNAME}.${DOMAIN}.key#" harbor.yml
sed -i -e "s/Harbor12345/VMware1!/" harbor.yml

./prepare --with-notary --with-trivy --with-chartmuseum

docker-compose up -d

echo " "
echo "Harbor: https://${HOSTNAME}.${DOMAIN}"
echo "CA: ~/${HOSTNAME}.${DOMAIN}.crt"
