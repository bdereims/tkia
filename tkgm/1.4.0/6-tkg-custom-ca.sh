#!/bin/bash
#bdereims@vmware.com

#copy a custom ca cert into custo ytt yaml repo in order pull image from a self signed harbor
#copy harbor's ca cert ca.crt to tkg-custom-ca.pem
#create a new cluster, it will be ready to pull images

. ../../env

cp tkg-custom-ca.yaml ~/.config/tanzu/tkg/providers/ytt/03_customizations/tkg-custom-ca.yaml 
cp tkg-custom-ca.pem ~/.config/tanzu/tkg/providers/ytt/03_customizations/tkg-custom-ca.pem 
