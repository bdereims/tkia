#!/bin/bash
#bdereims@vmware.com

. ./env

mysql -u ${USERNAME} -p${PASSWORD} <<EOF
use ${DATABASE};
select * from web;
EOF
