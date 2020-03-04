FROM alpine

RUN apk update && \
	apk add nginx mysql-client

COPY wordpress.tar.gz /var/www/html/wordpress.tar.gz
COPY nginx.conf /etc/nginx/nginx.conf
COPY wordpress.sql /wordpress-dump.sql
COPY entrypoint /entrypoint

ENTRYPOINT sh /entrypoint
