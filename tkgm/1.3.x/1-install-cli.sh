#!/bin/bash
#bdereims@vmware.com

. ../../env

TKGM_CLI_BUNDLE="tanzu-cli-bundle-v1.3.1-linux-amd64.tar"

pushd
cd ~
mkdir tanzu
cd tanzu
tar xvf ${BITS}/${TKGM_CLI_BUNDLE}
sudo install cli/core/v1.3.1/tanzu-core-linux_amd64 /usr/bin/tanzu
tanzu plugin clean
tanzu plugin install --local cli all
