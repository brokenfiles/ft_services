#!/bin/bash

# *
# * FTPS USER : user
# * FTPS PASS : pass
# *

IP_ADDRESS=$(cat /tmp/mnk_ip)

# génération de la clé et ajout de ses permissions
openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem -subj "/C=FR/ST=France/L=Paris/O=42/OU=llaurent/CN=ft_services"
chmod 777 /etc/ssl/private/pure-ftpd.pem

adduser -D "$FTPS_USER"
# on défini le mot de passe du ftps_user
echo "$FTPS_USER:$FTPS_PASSWORD" | chpasswd

/usr/sbin/pure-ftpd -j -Y 2 -p 21000:21000 -P "$IP_ADDRESS"