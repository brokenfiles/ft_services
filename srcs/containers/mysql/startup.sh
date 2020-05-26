#!/bin/bash

# on lance le script en asynchrone
nohup sh /tmp/import_wordpress.sh > /dev/null 2>&1 &

# on enlève le skip networking pour faire en sorte que mysql écoute les requêtes externes
sed -i 's/skip-networking/#skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf
# on setup mysql avec comme directory /var/lib/mysql
/usr/bin/mysql_install_db --user=mysql --datadir="/var/lib/mysql"
# on lance mysql avec le mysql_safe
/usr/bin/mysqld_safe --datadir="/var/lib/mysql"
