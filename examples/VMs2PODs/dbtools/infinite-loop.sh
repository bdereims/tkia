#!/bin/bash
#bdereims@gmail.com

#. ./env

DB=web.txt
DATABASE="nginx"
PASSWORD='VMware1!'

cp /dev/null $DB 

echo "generating..."

while true; do
	I=$(expr ${I} + 1)
	for LINE in {1..1}
	do
		NAME=$( ./petname.sh )
		DATE=$( date +%c )
		UUID=$( cat /proc/sys/kernel/random/uuid )
		printf "${LINE}-${UUID}-${NAME}\t${DATE}\n" > ${DB} 
		cat ${DB}
	done

	echo "loading..."

	mysqlimport -u ${USERNAME} -p${PASSWORD} --local ${DATABASE} ${DB} 

	sleep 5 

	if [ ${I} -gt 21 ]; then
		/root/clean.sh
		I=0
	fi
done

rm ${DB}
