FROM wordpress:php7.4-fpm-alpine

RUN apk update && \
	apk add nginx mysql-client

COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint-target /tmp/entrypoint-target
COPY wordpress.tar.gz /var/www/localhost/htdocs
COPY wordpress.sql /wordpress.sql

ENTRYPOINT sh /tmp/entrypoint-target