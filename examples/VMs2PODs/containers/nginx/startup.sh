#!/bin/sh

#sed -i "s/###SERVER###/${HOSTNAME}/" /var/www/html/cpod-tzuu2/index.html
sed -i "s/###SERVER###/${HOSTNAME}/" /var/www/html/index.html

nginx -g 'daemon off;'
