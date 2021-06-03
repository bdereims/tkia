#!/bin/bash -e
#bdereims@vmware.com

. ./env

TEMP=/tmp/$$

replace_json() {
	# ${1} : Source File
	# ${2} : Nested Item 
	# ${3} : Key to find 
	# ${4} : Value of Key 
	# ${5} : Key to update 
	# ${6} : Update Key 
	
	cat ${1} | \
	jq '(.'"${2}"'[] | select (.'"${3}"' == "'"${4}"'") | .'"${5}"') = "'"${6}"'"' > ${1}-tmp

	cp ${1}-tmp ${1} ; rm ${1}-tmp
}

install_nsx_manager() {
	govc import.spec ${NSX_MANAGER_OVA_FILE} > ${TEMP}

	cat ${TEMP} | jq '.IPAllocationPolicy="fixedPolicy"' > ${TEMP}-tmp
	cp ${TEMP}-tmp ${TEMP} ; rm ${TEMP}-tmp

	replace_json ${TEMP} "PropertyMapping" "Key" "nsx_passwd_0" "Value" "${NSX_COMMON_PASSWORD}"
	replace_json ${TEMP} "PropertyMapping" "Key" "nsx_cli_passwd_0" "Value" "${NSX_COMMON_PASSWORD}"
	replace_json ${TEMP} "PropertyMapping" "Key" "nsx_cli_audit_passwd_0" "Value" "${NSX_COMMON_PASSWORD}"
	replace_json ${TEMP} "PropertyMapping" "Key" "nsx_cli_username" "Value" "admin"
	replace_json ${TEMP} "PropertyMapping" "Key" "nsx_cli_audit_username" "Value" "audit"
	#replace_json ${TEMP} "PropertyMapping" "Key" "extraPara" "Value" ""
	replace_json ${TEMP} "PropertyMapping" "Key" "nsx_hostname" "Value" "${NSX_COMMON_HOSTNAME}"
	replace_json ${TEMP} "PropertyMapping" "Key" "nsx_role" "Value" "NSX Manager"
	replace_json ${TEMP} "PropertyMapping" "Key" "nsx_site_name" "Value" "${VCENTER_DATACENTER}"
	replace_json ${TEMP} "PropertyMapping" "Key" "nsx_gateway_0" "Value" "${NSX_COMMON_GATEWAY}"
	replace_json ${TEMP} "PropertyMapping" "Key" "nsx_ip_0" "Value" "${NSX_MANAGER_IP}"
	replace_json ${TEMP} "PropertyMapping" "Key" "nsx_netmask_0" "Value" "${NSX_COMMON_NETMASK}"
	replace_json ${TEMP} "PropertyMapping" "Key" "nsx_dns1_0" "Value" "${NSX_COMMON_DNS}"
	replace_json ${TEMP} "PropertyMapping" "Key" "nsx_domain_0" "Value" "${NSX_COMMON_DOMAIN}"
	replace_json ${TEMP} "PropertyMapping" "Key" "nsx_ntp_0" "Value" "${NSX_COMMON_NTP}"
	replace_json ${TEMP} "PropertyMapping" "Key" "nsx_isSSHEnabled" "Value" "True"
	replace_json ${TEMP} "PropertyMapping" "Key" "nsx_allowSSHRootLogin" "Value" "True"

	replace_json ${TEMP} "NetworkMapping" "Name" "Network 1" "Network" "${NSX_HOST_COMMON_NETWORK0}"

	govc import.ova -options=${TEMP} -name="${NSX_MANAGER_NAME}-1" ${NSX_MANAGER_OVA_FILE}
	govc vm.power -on ${NSX_MANAGER_NAME}-1 

	rm ${TEMP}
}

install_nsx_edge() {
        govc import.spec ${NSX_EDGE_OVA_FILE} > ${TEMP}

        cat ${TEMP} | jq '.IPAllocationPolicy="fixedPolicy"' > ${TEMP}-tmp
        cp ${TEMP}-tmp ${TEMP} ; rm ${TEMP}-tmp

        replace_json ${TEMP} "PropertyMapping" "Key" "nsx_passwd_0" "Value" "${NSX_COMMON_PASSWORD}"
        replace_json ${TEMP} "PropertyMapping" "Key" "nsx_cli_passwd_0" "Value" "${NSX_COMMON_PASSWORD}"
        replace_json ${TEMP} "PropertyMapping" "Key" "nsx_cli_audit_passwd_0" "Value" "${NSX_COMMON_PASSWORD}"
        replace_json ${TEMP} "PropertyMapping" "Key" "nsx_cli_username" "Value" "admin"
        replace_json ${TEMP} "PropertyMapping" "Key" "nsx_cli_audit_username" "Value" "audit"
        replace_json ${TEMP} "PropertyMapping" "Key" "nsx_hostname" "Value" "edge-1"
        replace_json ${TEMP} "PropertyMapping" "Key" "nsx_site_name" "Value" "${VCENTER_DATACENTER}"
        replace_json ${TEMP} "PropertyMapping" "Key" "nsx_gateway_0" "Value" "${NSX_COMMON_GATEWAY}"
        replace_json ${TEMP} "PropertyMapping" "Key" "nsx_ip_0" "Value" "${NSX_EDGE_IP}"
        replace_json ${TEMP} "PropertyMapping" "Key" "nsx_netmask_0" "Value" "${NSX_COMMON_NETMASK}"
        replace_json ${TEMP} "PropertyMapping" "Key" "nsx_dns1_0" "Value" "${NSX_COMMON_DNS}"
        replace_json ${TEMP} "PropertyMapping" "Key" "nsx_domain_0" "Value" "${NSX_COMMON_DOMAIN}"
        replace_json ${TEMP} "PropertyMapping" "Key" "nsx_ntp_0" "Value" "${NSX_COMMON_NTP}"
        replace_json ${TEMP} "PropertyMapping" "Key" "nsx_isSSHEnabled" "Value" "True"
        replace_json ${TEMP} "PropertyMapping" "Key" "nsx_allowSSHRootLogin" "Value" "True"

        replace_json ${TEMP} "NetworkMapping" "Name" "Network 0" "Network" "${NSX_HOST_COMMON_NETWORK0}"
        replace_json ${TEMP} "NetworkMapping" "Name" "Network 1" "Network" "${NSX_HOST_COMMON_NETWORK0}"
        replace_json ${TEMP} "NetworkMapping" "Name" "Network 2" "Network" "${NSX_HOST_COMMON_NETWORK0}"
        replace_json ${TEMP} "NetworkMapping" "Name" "Network 3" "Network" "${NSX_HOST_COMMON_NETWORK0}"

        govc import.ova -options=${TEMP} -name="${NSX_EDGE_NAME}-1" ${NSX_EDGE_OVA_FILE}
	govc vm.power -on ${NSX_EDGE_NAME}-1 

	rm ${TEMP}
}

#install_nsx_manager
install_nsx_edge

printf "\n\n###\n### Wait until complet startup of Manager & Edge...\n###\n### Add license ASAP before to go to the next step.\n###\n\n"
