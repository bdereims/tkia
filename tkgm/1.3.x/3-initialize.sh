#!/bin/bash
#bdereims@vmware.com

. ../../env

rm -fr ~/.tanzu/tkg/bom
export TKG_BOM_CUSTOM_IMAGE_TAG="v1.3.1-patch1"
echo "VSPHERE_INSECURE: true" > ~/.tanzu/tkg/cluster-config.yaml

IP=$( ip a show dev ens192 | grep inet | sed -e "s/^.*inet //" -e "s/\/.*$//" )

### Add subnets for TKG-Portgroup and Frontend
#export no_proxy=vcsa.${DOMAIN},tkgm.${DOMAIN},172.17.20.100,${IP}
export no_proxy=172.17.20.0/24,10.30.0.0/24
echo "no_proxy for: ${no_proxy}"

#tanzu management-cluster create --ui --bind ${IP}:8080 --browser none -v 9
tanzu management-cluster create --file cluster-config.yaml -v 9
