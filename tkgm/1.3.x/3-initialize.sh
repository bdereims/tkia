#!/bin/bash
#bdereims@vmware.com

. ../../env

rm -fr ~/.tanzu ~/.kube-tkg
docker ps -aq | xargs docker kill 
docker ps -aq | xargs docker rm
mkdir -p ~/.tanzu/tkg

export TKG_BOM_CUSTOM_IMAGE_TAG="v1.3.1-patch1"
export DEPLOY_TKG_ON_VSPHERE7="true"
#export TKG_CUSTOM_IMAGE_REPOSITORY=""
echo "VSPHERE_INSECURE: true" > ~/.tanzu/tkg/cluster-config.yaml

IP=$( ip a show dev ens192 | grep inet | sed -e "s/^.*inet //" -e "s/\/.*$//" )

### Add subnets for TKG-Portgroup and Frontend
export no_proxy=192.168.0.0/16,172.16.0.0/12,10.0.0.0/8,*.${DOMAIN}
echo "no_proxy for: ${no_proxy}"

### If you prefer to setup trough ui
#tanzu management-cluster create --ui --bind ${IP}:8080 --browser none -v 9

tanzu management-cluster create --file cluster-config.yaml -v 9

### for user auth
#export TANZU_CLI_PINNIPED_AUTH_LOGIN_SKIP_BROWSER=true
#tanzu management-cluster kubeconfig get --export-file /tmp/tkgm_kubeconfig
#kubectl get pods -A --kubeconfig /tmp/tkgm_kubeconfig
