#!/bin/bash
#bdereims@vmware.com

. ../../env

pushd
cd ~
mkdir tanzu
cd tanzu
tar xvf ${BITS}/${TKGM_CLI_BUNDLE}.tar
sudo install cli/core/${TKG_RELEASE}/tanzu-core-linux_amd64 /usr/bin/tanzu
tanzu plugin clean
tanzu plugin install --local cli all
