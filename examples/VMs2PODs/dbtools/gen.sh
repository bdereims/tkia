#!/bin/bash
#bdereims@gmail.com

. ./env

DB=web.txt

cp /dev/null $DB 

echo "generating..."

for LINE in {1..100}
do
	NAME=$( ./petname.sh )
	DATE=$( date +%c )
	UUID=$( cat /proc/sys/kernel/random/uuid )
	printf "${LINE}-${UUID}-${NAME}\t${DATE}\n" >> ${DB} 
done

echo "loading..."

mysqlimport -u ${USERNAME} -p${PASSWORD} --local ${DATABASE} ${DB} 

rm ${DB}
