#!/bin/bash
#bdereims@vmware.com

if [ "${1}" == "no" ]; then
	unset http_proxy
	unset https_proxy
	unset no_proxy
else
	CPODROUTER=$( ip route | grep default | sed -e "s/^.*via //" -e "s/ dev.*$//" )
	export http_proxy=http://${CPODROUTER}:3128
	export https_proxy=http://${CPODROUTER}:3128
fi
