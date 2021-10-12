#!/bin/bash -e
#bdereims@vmware.com

. ../../env

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

install_nsx_alb_controller() {
	govc import.spec ${ALB_CONTROLLER_OVA_FILE} > ${TEMP}

	cat ${TEMP} | jq '.IPAllocationPolicy="fixedPolicy"' > ${TEMP}-tmp
	cp ${TEMP}-tmp ${TEMP} ; rm ${TEMP}-tmp

	VMIP=$( echo ${ALB_CONTROLLER_IP} | cut -f 4 -d '.' )
	VMIP=$( expr ${VMIP} + ${1} - 1 )
	ALB_CONTROLLER_IP="${SUBNET}.${VMIP}"

	replace_json ${TEMP} "PropertyMapping" "Key" "avi.mgmt-ip.CONTROLLER" "Value" "${ALB_CONTROLLER_IP}"
	replace_json ${TEMP} "PropertyMapping" "Key" "avi.mgmt-mask.CONTROLLER" "Value" "${ALB_CONTROLLER_MASK}"
	replace_json ${TEMP} "PropertyMapping" "Key" "avi.default-gw.CONTROLLER" "Value" "${ALB_CONTROLLER_GW}"
	replace_json ${TEMP} "PropertyMapping" "Key" "avi.sysadmin-public-key.CONTROLLER" "Value" "$(cat ~/.ssh/id_rsa.pub)"
	replace_json ${TEMP} "PropertyMapping" "Key" "avi.hostname.CONTROLLER" "Value" "${ALB_CONTROLLER_NAME}-${1}"
	
	replace_json ${TEMP} "NetworkMapping" "Name" "Management" "Network" "${ALB_CONTROLLER_NETWORK}"

	govc import.ova -options=${TEMP} -name="${ALB_CONTROLLER_NAME}-${1}" ${ALB_CONTROLLER_OVA_FILE}
	govc vm.power -on ${ALB_CONTROLLER_NAME}-${1} 

	rm ${TEMP}
}


#install_nsx_alb_controller 1 
#install_nsx_alb_controller 2
install_nsx_alb_controller 3 
