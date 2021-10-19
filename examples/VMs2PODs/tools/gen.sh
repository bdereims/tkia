#!/bin/bash
#bdereims@gmail.com

. ./env

DB=nginx.txt

cp /dev/null $DB 

echo "generating..."

for LINE in {1..1000}
do
	NAME=$( ./petname.sh )
	DATE=$( date +%c )
	UUID=$( cat /proc/sys/kernel/random/uuid )
	printf "${LINE}-${UUID}-${NAME}\t${DATE}\n" >> ${DB} 
done

echo "loading..."

mysqlimport -h ${HOST} -u root -pVMware1! --local nginx ${DB} 
