#!/bin/bash
#bdereims@vmware.com

. ./env

mysql -u ${USERNAME} -p${PASSWORD} <<EOF
use ${DATABASE};
delete from web where name !='vmware-vmc-tanzu-is-fantastic';
EOF
