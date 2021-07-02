#!/bin/sh

#sed -i "s/###SERVER###/${HOSTNAME}/" /var/www/html/grease-monkey/index.html
sed -i "s/###SERVER###/${HOSTNAME}/" /var/www/html/index.html

nginx -g 'daemon off;'
