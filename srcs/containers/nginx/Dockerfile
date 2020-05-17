FROM alpine:latest

RUN apk update && \
	apk add nginx openssl openssh && \
	mkdir -p /var/run/nginx && \
	rm -rf /var/cache/apk/*

RUN adduser -D -g 'admin' admin && \
	mkdir /html && \
	chown -R admin:admin /var/lib/nginx && \
	chown -R admin:admin /html

# SSL
RUN mkdir /etc/nginx/ssl && \
	openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/www.pem -keyout /etc/nginx/ssl/www.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=llaurent/CN=ft_services"

RUN rm /etc/nginx/nginx.conf

COPY nginx.conf /etc/nginx/nginx.conf
COPY id_rsa_key_ssh /etc/ssh/ssh_host_rsa_key
COPY sshd_config /etc/ssh/
COPY startup.sh /tmp/startup.sh

RUN chmod 600 /etc/ssh/ssh_host_rsa_key

ENTRYPOINT sh /tmp/startup.sh

EXPOSE 30002 443 80 22
