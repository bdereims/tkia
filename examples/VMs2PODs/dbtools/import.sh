#!/bin/bash
#bdereims@vmware.com

. ./env

mysql -h ${TARGET} -u ${USERNAME} -p${PASSWORD} <<EOF
CREATE DATABASE ${DATABASE};
EOF

mysql -h ${TARGET} -u ${USERNAME} -p${PASSWORD} < dump.sql
