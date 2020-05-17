#!/bin/bash

IP_ADDRESS=$(cat /tmp/mnk_ip)

openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=llaurent/CN=ft_services"
chmod 777 /etc/ssl/private/pure-ftpd.pem

adduser -D "$FTPS_USER"
echo "$FTPS_USER:$FTPS_PASSWORD" | chpasswd

/usr/sbin/pure-ftpd -j -Y 2 -p 21000:21000 -P "$IP_ADDRESS"