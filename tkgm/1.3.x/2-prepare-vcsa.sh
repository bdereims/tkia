#!/bin/bash
#bdereims@vmware.com

. ../../env

import_ova() {
	OVA_NAME=${1}
	OVA_FILE=${BITS}/${1}.ova

	govc import.spec ${OVA_FILE} | jq '.Name="'${OVA_NAME}'"' | jq '.NetworkMapping [0].Network="'"${GOVC_NETWORK}"'"' > ${OVA_NAME}.json
	cat ${OVA_NAME}.json
	govc import.ova -options=${OVA_NAME}.json ${OVA_FILE}
	govc object.mv /${GOVC_DATACENTER}/vm/${OVA_NAME} /${GOVC_DATACENTER}/vm/${TKG_DIR}
	rm ${OVA_NAME}.json

	#govc snapshot.create -vm ${OVA_NAME} root
	govc vm.markastemplate ${OVA_NAME}
}

echo "=== Create TKG VM folder"
govc folder.create /${GOVC_DATACENTER}/vm/${TKG_DIR}

echo "=== Import OVAs as templates"
import_ova photon-3-kube-v1.20.5-vmware.2-tkg.1-3176963957469777230
