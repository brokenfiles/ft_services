#!/bin/bash

printf 'Waiting for mysql'
until mysql
do
	echo "."
	sleep 1
done
printf '\n'

MINIKUBE_IP=$(cat /tmp/mnk_ip)

cat << EOF > instructions.sql
USE wordpress;
UPDATE wp_options SET option_value = 'http://$MINIKUBE_IP:5050' WHERE option_id BETWEEN 1 AND 2;

use mysql;
CREATE USER 'wp_admin'@'%';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_admin'@'%' WITH GRANT OPTION;
SET PASSWORD FOR 'wp_admin'@'%' = PASSWORD('pass');
FLUSH PRIVILEGES;
EOF

#check: SELECT option_value FROM wp_options WHERE option_id BETWEEN 1 AND 2;

MYSQL="mysql -u root"
$MYSQL -e 'CREATE DATABASE wordpress;'
$MYSQL wordpress < /tmp/wordpress.sql
$MYSQL < instructions.sql

rm -f instructions.sql