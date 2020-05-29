#!/bin/bash

echo "$SSH_USER:$SSH_PASSWORD" | chpasswd
printf "Hello, correcteur !\nLes permissions de cet utilisateur sont limités à ce dossier et au dossier /html\n\n" > /etc/motd

/usr/sbin/sshd
nginx -g "daemon off;"