#!/bin/bash
#bdereims@vmware.com

CPODROUTER=$( ip route | grep default | sed -e "s/^.*via //" -e "s/ dev.*$//" )
export http_proxy=http://${CPODROUTER}:3128
export https_proxy=https://${CPODROUTER}:3128
