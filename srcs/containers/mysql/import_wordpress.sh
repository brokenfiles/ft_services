#!/bin/bash

# on attend que le mysql soit up pour lancer les opérations
printf 'Waiting for mysql'
until mysql
do
	echo "."
	sleep 1
done
printf '\n'

MINIKUBE_IP=$(cat /tmp/mnk_ip)

# on envoie les lignes jusqu'au EOF dans instructions.sql
cat << EOF > instructions.sql
USE wordpress;
UPDATE wp_options SET option_value = 'http://$MINIKUBE_IP:5050' WHERE option_id BETWEEN 1 AND 2;

USE mysql;
CREATE USER 'wp_admin'@'%';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_admin'@'%' WITH GRANT OPTION;
SET PASSWORD FOR 'wp_admin'@'%' = PASSWORD('pass');
FLUSH PRIVILEGES;
EOF

#check: SELECT option_value FROM wp_options WHERE option_id BETWEEN 1 AND 2;

# on injecte la base de données dans mysql
MYSQL="mysql -u root"
$MYSQL -e 'CREATE DATABASE wordpress;'
$MYSQL wordpress < /tmp/wordpress.sql

# on envoie les instructions précédemment sauvegardées dans mysql
$MYSQL < instructions.sql

rm -f instructions.sql