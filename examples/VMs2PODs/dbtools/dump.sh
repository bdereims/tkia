#!/bin/bash
#bdereims@vmware.com

. ./env

mysqldump -u ${USERNAME} -p${PASSWORD}  ${DATABASE} > dump.sql
